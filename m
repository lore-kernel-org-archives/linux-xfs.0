Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pBF5ndfp249628 for <xfs@oss.sgi.com>; Wed, 14 Dec 2011 23:49:40 -0600
Received: from ipmail05.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C0F911571FB4
	for <xfs@oss.sgi.com>; Wed, 14 Dec 2011 21:49:37 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	L9CVCKmDXJW2ZQ00 for <xfs@oss.sgi.com>;
	Wed, 14 Dec 2011 21:49:37 -0800 (PST)
Date: Thu, 15 Dec 2011 16:49:34 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: trim performance on xfs (also reply to: Online TRIM/discard
	performance impact)
Message-ID: <20111215054934.GP3179@dastard>
References: <CA+mMEgf+k6focwqB8_pZoCMF8=e=_czrrRe-6R8i4bNP614g2Q@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CA+mMEgf+k6focwqB8_pZoCMF8=e=_czrrRe-6R8i4bNP614g2Q@mail.gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Andrei Purdea <andrei@purdea.ro>
Cc: xfs@oss.sgi.com

On Thu, Dec 15, 2011 at 04:14:28AM +0200, Andrei Purdea wrote:
> I also recently met with an issue that has been described in a
> previous email(http://oss.sgi.com/archives/xfs/2011-11/msg00108.html).
> I have an OCZ Agility 3 (also a SandForce 2281 controller),and a
> Corsair Performance Pro (non-SandForce controller,with good
> non-compressible data speeds)
> Removing a linux-3.2-rc5 tree took more then 6 minutes with online
> discard,and ext4 was very speedy (less then a second), but only on the
> SandForce controller!!For the Corsair performance was good on both
> filesystems.
> So I decided to debug what is happening.I also noticed that fstrim was
> slower on the OCZ(30-40 seconds, vs. 3 seconds on the Corsair)So I had
> a hunch that the performance difference comes from the number
> ofsectors that are discarded in a single TRIM command.
> So i compiled a kernel where I inserted a printk into
> blkdev_issue_discard(),to see how many sectors each call asks for.

XFS has a trace point so will issue an event for every discard it
issues. You can look at this without needing to add printk()s to the
code....

> Results:
> Total number of sectors discarded:=A0 =A0ext4: 1032864 =A0 XFS: 1043112
> (about the same)Number of calls to blkdev_issue_discard():=A0 =A0ext4: 24
>  =A0 =A0 =A0 =A0 =A0XFS: 39395Average number of sectors discarded per cal=
l:
> ext4: 43036 (21 MiB) =A0 XFS: 26.48 =A0(13.2 KiB)

XFS is doing fine grained discards, just like mount option is asking
for, but the block layer does not allow async dispatch/completion of
discard requests so they are issued serially.  Hence the speed of
online discard is a purely a function of number * duration.

Fixing this properly is two fold - allowing async discard dispatch,
and then change XFS to use a 2-pass dispatch/wait-for-completion
model. This also assumes that the block layer can sort/merge separate
discard requests to reduce the number of requests sent to the
device, which I don't think it can do right now and would also need
fixing.

We could probably add sorting before dispatching at the XFS layer,
but sorting/merging IO requests is really a function of the block
layer, not the filesystem...

> I made some TRIM performance measurements (see image on
> http://purdea.ro/projects/trim_perf/)with a small tool i wrote.
> (warning, destructive to data)
> It looks like the OCZ needs a really high amount of time to
> executeeven the smallest TRIM command.
> I made a small post about this here: http://purdea.ro/projects/trim_perf/
> Can this be fixed in XFS?
> I am curious, do all SandForce controllers exhibit this slow TRIM issue?

The slowness of individual TRIM commands cannot be fixed in XFS -
it' aproperty of the SSD. And no, it's not unique to Sandforce
controllers - there are other types of controllers that have
similiar (or worse) TRIM behaviour.  Indeed, there have been
occurences of SSDs being bricked by being sent too many TRIM
commands too often/quickly...

This is one of the reasons why our current recommendation is to not
use online discard, but use background discard (FITRIM) to
periodically issue discards on the free space in the filesystem. It
does not happen in a filesystem performance fast-path, can be
configured with a minimum size to trim, and usually requires much
fewer TRIM commands to be sent to the device so is generally safer.

Cheers,

Dave.
-- =

Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
