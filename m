Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o7F23KUw169347 for <xfs@oss.sgi.com>; Sat, 14 Aug 2010 21:03:21 -0500
Received: from Ishtar.sc.tlinx.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 55EC24ADB42
	for <xfs@oss.sgi.com>; Sat, 14 Aug 2010 19:03:46 -0700 (PDT)
Received: from Ishtar.sc.tlinx.org (ishtar.tlinx.org [173.164.175.65]) by
	cuda.sgi.com with ESMTP id pNJDvsbUXY83kxtV for
	<xfs@oss.sgi.com>; Sat, 14 Aug 2010 19:03:46 -0700 (PDT)
Message-ID: <4C674AE8.7030107@tlinx.org>
Date: Sat, 14 Aug 2010 19:03:20 -0700
From: Linda Walsh <xfs@tlinx.org>
MIME-Version: 1.0
Subject: Re: xfs.fsck change that is unhelpful
References: <4C670101.8050901@tlinx.org> <20100815005240.GH10429@dastard>
In-Reply-To: <20100815005240.GH10429@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs-oss <xfs@oss.sgi.com>



Dave Chinner wrote:
> On Sat, Aug 14, 2010 at 01:48:01PM -0700, Linda A. Walsh wrote:
>> Some time ago, when I upgraded a system, I ran into problems when
>> it hit a file system that was offline.  It wasn't a critical
>> partition, so it normally wouldn't have been an issue, but somewhere
>> along the line
>> someone mangled fsck.xfs.
> 
> fsck.xfs is behaving identically to e2fsck when presented with an
> invalid block device - it exits with an error of 8, which is defined
> as "operational error" in the e2fsck man page.
---
	That may be fine for the ext2 fs, but I am asserting that in actual
practice, with xfs, it does more harm than good.



> That sounds like a problem with the distro init scripts or you've
> stuffed up your /etc/fstab config (i.e. fs_passno is wrong). Indeed,
> setting fs_passno = 0 will cause the filesysetm fsck to be skipped
> completely on boot, regardless of the fs type...
---
	Yes, you are right.  They are setup to be check in the order
I would want them mounted.  But I don't see the benefit to being
compliant with a checking mechanism for a file system that is
actually needs fsck.

	It was long a *feature* of xfs, that xfs.fsck, was a noop.

	I don't see that making it fail in ways fsck does for a file
system that *needs* fsck, is productive.  Sure, it may be dotting i's
and crossing t's, but in reality, is that a standard xfs should be
living down to?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
