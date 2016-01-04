Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E98057F37
	for <xfs@oss.sgi.com>; Sun,  3 Jan 2016 23:55:02 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B843E304032
	for <xfs@oss.sgi.com>; Sun,  3 Jan 2016 21:55:02 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	GTeZtjwCCR1bXnBZ for <xfs@oss.sgi.com>;
	Sun, 03 Jan 2016 21:54:58 -0800 (PST)
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/3] fs: FS_IOC_FS[GS]ETXATTR promotion
Date: Mon,  4 Jan 2016 16:54:49 +1100
Message-Id: <1451886892-15548-1-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: linux-fsdevel@vger.kernel.org, ext4@vger.kernel.org

Hi folks,

As I mentioned on -fsdevel this morning, the XFS_IOC_FS[SG]SETXATTR
API promotion patch for ext4 project quota really needs to be split
up into two patches: one for the API promotion and the other for
the ext4 implementation of the API.

This short series has the isolated API promotion patch, as well as a
followup cleanup patch in XFS to get rid of the XFS definitions from
the kernel code completely, followed by the first conflicting patch
I had against the ext4-all-in-one patch for a per-inode DAX
enablement flag.

I've pushed these patches out to the following branch:

git://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs.git xfs-setxattr-promotion

And I'll update them and merge them into the for-next branch
according to feedback and review.

Cheers,

Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
