Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o9JNf8L8256733 for <xfs@oss.sgi.com>; Tue, 19 Oct 2010 18:41:09 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C502F1E7E923
	for <xfs@oss.sgi.com>; Tue, 19 Oct 2010 16:42:20 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail16.adl2.internode.on.net
	[150.101.137.101]) by cuda.sgi.com with ESMTP id
	7SD8Epb7tJ1dPmJd for <xfs@oss.sgi.com>;
	Tue, 19 Oct 2010 16:42:20 -0700 (PDT)
Date: Wed, 20 Oct 2010 10:42:17 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: avoid mbox file fragmentation
Message-ID: <20101019234217.GD12506@dastard>
References: <4CBE2403.8070108@hardwarefreak.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4CBE2403.8070108@hardwarefreak.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: xfs@oss.sgi.com

On Tue, Oct 19, 2010 at 06:04:35PM -0500, Stan Hoeppner wrote:
> In an effort to maximize mbox performance and minimize fragmentation I'm
> using these mount options in fstab.  This is on a Debian Lenny box but
> with vanilla 2.6.34.1 rolled from kernel.org source (Lenny ships with
> 2.6.26).  xfsprogs is 2.9.8.
....
> I've recently run xfs_fsr thus the low 7% figure.  Every couple of weeks
> the fragmentation reaches ~30%.  I save a lot of list mail, dozens to
> hundreds per day for each of about 7 foss mailing lists.  As I say, in
> just a couple of weeks, these mbox files become fragmented, on the order
> of a dozen to a few dozen extents per mbox file.  With so much free
> space available on this filesystem, why aren't/weren't these files being
> spread out with sufficient space between them to prevent fragmentation?

I've explained how allocsize works, and that speculative allocation
gets truncated away whenteh file is closed. Hence is the application
is doing:

	open()
	seek(EOF)
	write()
	close()

allocsize does not help you because the specualtive prealloc done in
write() is truncated away in close().

What you want is _physical_ preallocation, not speculative
preallocation. i.e. look up XFS_IOC_RESVSP or FIEMAP so your
application does _permanent_ preallocate past EOF. Alteratively, the
filesystem will avoid the truncation on close() is the file has the
APPEND attribute set and the application is writing via O_APPEND...

The filesystem cannot do everything for you. Sometimes the
application has to help....

Cheers,

Dave.
> (Dave or someone has suggested on list that with newer kernels the
> defaults for these two (and other) mount options do not match those
> suggested in the man pages.  I requested a feature some time ago that
> would actually put these default values in /proc files to eliminate any
> doubt as to what the actual defaults being used are.  I don't recall if
> anything came of this.

/proc/mounts displays some default options.

> I've seen many an OP get "scolded" on list for
> manually specifying values that were apparently equal to the "default"
> values as stated by the responding dev.  This problem would never exist
> if the documentation was complete and consistent.

As I say to _everyone_ who complains about this: Patches
to correct documentation issues are greatly appreciated. You don't
need to be a coding export to send a patch correcting a man page....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
