Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C7D4729DF5
	for <xfs@oss.sgi.com>; Sat, 12 Dec 2015 06:26:15 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 53F97AC001
	for <xfs@oss.sgi.com>; Sat, 12 Dec 2015 04:26:12 -0800 (PST)
Received: from mail.lichtvoll.de (mondschein.lichtvoll.de [194.150.191.11]) by
	cuda.sgi.com with ESMTP id r8GmAGVaOp344D62 for
	<xfs@oss.sgi.com>; Sat, 12 Dec 2015 04:26:08 -0800 (PST)
From: Martin Steigerwald <martin@lichtvoll.de>
Subject: Re: XFS and nobarrier with SSDs
Date: Sat, 12 Dec 2015 13:26:06 +0100
Message-ID: <3496214.YTSKClH6pV@merkaba>
In-Reply-To: <E127700EFE58FD45BD6298EAC813FA42020D8173@TIGER2010.xortex.local>
References: <E127700EFE58FD45BD6298EAC813FA42020D8173@TIGER2010.xortex.local>
MIME-Version: 1.0
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Georg =?ISO-8859-1?Q?Sch=F6nberger?= <g.schoenberger@xortex.com>

Am Samstag, 12. Dezember 2015, 10:24:25 CET schrieb Georg Sch=F6nberger:
> Hi folks!

Hi Georg.

> We are using a lot of SSDs in our Ceph clusters with XFS. Our SSDs have
> Power Loss Protection via capacitors, so is it safe in all cases to run X=
FS
> with nobarrier on them? Or is there indeed a need for a specific I/O
> scheduler?

I do think that using nobarrier would be safe with those SSDs as long as th=
ere =

is no other caching happening on the hardware side, for example inside the =

controller that talks to the SSDs.

I always thought barrier/nobarrier acts independently of the I/O scheduler =

thing, but I can understand the thought from the bug report you linked to =

below. As for I/O schedulers, with recent kernels and block multiqueue I se=
e =

it being set to "none".

> I have found a recent discussion on the Ceph mailing list, anyone from XFS
> that can help us?
> =

> *http://www.spinics.net/lists/ceph-users/msg22053.html

Also see:

http://xfs.org/index.php/
XFS_FAQ#Q._Should_barriers_be_enabled_with_storage_which_has_a_persistent_w=
rite_cache.
3F

> *https://bugzilla.redhat.com/show_bug.cgi?id=3D1104380

Interesting. Never thought of that one.

So would it be safe to interrupt the flow of data towards the SSD at any po=
int =

if time with reordering I/O schedulers in place? And how about blk-mq which =

has mutiple software queus?

I like to think that they are still independent of the barrier thing and th=
e =

last bug comment by Eric, where he quoted from Jeff, supports this:

> Eric Sandeen 2014-06-24 10:32:06 EDT
> =

> As Jeff Moyer says:
> > The file system will manually order dependent I/O.
> > What I mean by that is the file system will send down any I/O for the
> > transaction log, wait for that to complete, issue a barrier (which will
> > be a noop in the case of a battery-backed write cache), and then send
> > down the commit block along with another barrier.  As such, you cannot
> > have the I/O scheduler reorder the commit block and the log entry with
> > which it is associated.=00

Ciao,
-- =

Martin
_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
