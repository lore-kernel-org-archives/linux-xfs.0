Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0AMASBw100561 for <xfs@oss.sgi.com>; Tue, 10 Jan 2012 16:10:28 -0600
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	ApTijHskfxF8AGi9 for <xfs@oss.sgi.com>;
	Tue, 10 Jan 2012 14:10:26 -0800 (PST)
Date: Wed, 11 Jan 2012 09:10:24 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Empty dir can't be removed ... because it's not empty?
Message-ID: <20120110221024.GC24410@dastard>
References: <201201102126.35268.rafagriman@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <201201102126.35268.rafagriman@gmail.com>
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
To: Rafa =?iso-8859-1?Q?Grim=E1n?= <rafagriman@gmail.com>
Cc: xfs-oss <xfs@oss.sgi.com>

On Tue, Jan 10, 2012 at 09:26:35PM +0100, Rafa Grim=E1n wrote:
> Hi all :)
> =

> My /home is on an XFS partition all to it's own. The other day the lights=
 went =

> out and when I rebooted, there's an empty directory that can't be erased.=
 This =

> directory is a subdirectory in ~/.kde4/

Is your system using barriers (i.e. mounting with nobarrier option,
or hardware that doesn't support FUA)? Directory corruption like
this on power failure is a classic sign of a voltile drive cache
being lost on power failure.

The output of dmesg from a system boot will tell us what hardware
you have...

> The funny thing about this is that I can rename the directory, but I can'=
t =

> delete it:
> =

> [root@mine albumcovers]# ls
> .  ..  cache
> =

> [root@mine albumcovers]# ls -lah cache/
> total 0
> drwx------ 1 rafa users  6 Jan 10 02:23 .
> drwx------ 3 rafa users 18 Jan 10 02:23 ..
            ^^^

It's link count is 3, meaning that it thinks that there is an entry
in the directory. You need to run xfs_repair to fix it (and whatever
else is broken).

Cheers,

Dave.
-- =

Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
