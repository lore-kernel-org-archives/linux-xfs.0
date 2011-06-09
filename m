Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p59DmG0Y177915 for <xfs@oss.sgi.com>; Thu, 9 Jun 2011 08:48:17 -0500
Received: from pyre.virge.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A47554AF537
	for <xfs@oss.sgi.com>; Thu,  9 Jun 2011 06:48:13 -0700 (PDT)
Received: from pyre.virge.net (24-246-28-70.cable.teksavvy.com [24.246.28.70])
	by cuda.sgi.com with ESMTP id P5ORrIcltB14HgC5 for
	<xfs@oss.sgi.com>; Thu, 09 Jun 2011 06:48:13 -0700 (PDT)
Date: Thu, 9 Jun 2011 09:48:11 -0400
From: Norbert Veber <nveber@pyre.virge.net>
Subject: Re: Small files perform much faster on newly formatted fs?
Message-ID: <20110609134811.GI28625@pyre.virge.net>
References: <20110607163742.GH28625@pyre.virge.net> <201106080911.11286@zmi.at>
	<20110608122638.GQ28625@pyre.virge.net>
	<20110609012907.GR32466@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110609012907.GR32466@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Michael Monnerie <michael.monnerie@is.it-management.at>, xfs@oss.sgi.com

On Thu, Jun 09, 2011 at 11:29:07AM +1000, Dave Chinner wrote:
> Those mount options are ignored if the filesystem doesn't have the
> superblock feature bit set for aligned allocations. A filesystem
> with 0/0 for sunit/swidth does not have the superblock bit set....

Oh man!  I thought I saw some improvement with iometer benchmarks before
and after the mount options, but I dont see any significant difference
while timing the untar and rm -rf I've been doing.

All the documentation I came across including the man page and XFS faq
entry imply that the mount options can be used to perform alignment..

"XFS allows to optimize for a given RAID stripe unit (stripe size) and
stripe width (number of data disks) via mount options."
http://xfs.org/index.php/XFS_FAQ#Q:_How_to_calculate_the_correct_sunit.2Cswidth_values_for_optimal_performance

"While the stripe unit and stripe width cannot be changed after an XFS
file system has been created, they can be overridden at mount time with
the sunit/swidth options, similar to ones used by mkfs.xfs."
https://raid.wiki.kernel.org/index.php/RAID_setup#XFS

In these kinds of cases maybe there should be an error logged instead of
just silently ignoring them?

Is there any way to change the superblock?  Eg. soething like the ext*
command:

tune2fs -E stride=n,stripe-width=m /dev/xxx

Thanks,

Norbert

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
