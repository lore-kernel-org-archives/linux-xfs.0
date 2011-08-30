Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7UCBGFi135158 for <xfs@oss.sgi.com>; Tue, 30 Aug 2011 07:11:18 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DD932125BD3
	for <xfs@oss.sgi.com>; Tue, 30 Aug 2011 05:11:13 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	ueYbhJn8VJQ7VAPe for <xfs@oss.sgi.com>;
	Tue, 30 Aug 2011 05:11:13 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1QyN9s-00068Q-86
	for xfs@oss.sgi.com; Tue, 30 Aug 2011 12:11:12 +0000
Date: Tue, 30 Aug 2011 08:11:12 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: RFC: merging the quota source files
Message-ID: <20110830121112.GA19509@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
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
To: xfs@oss.sgi.com

Hi,

I've started a bit work on the quota code, and the split between the
implementation files is rather annoying.  I'd suggest we merge at least
xfs_dquot.c and xfs_qm.c into a single file, as there is no visible
split.  Given how small and useless xfs_qm_bhv.c is I'd throw it in.

As a second pass I'd also like to kill xfs_qm_syscalls.c and merge
it into the new xfs_qm.c/xfs_dquot.c for the low-level helpers, and
xfs_quotaops.c for high-level code that deals directly with the Linux
interface.

Does this a) sound good to others, and b) does anyone have a preference
for the name of the new quota implementation file?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
