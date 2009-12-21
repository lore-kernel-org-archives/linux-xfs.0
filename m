Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nBLBljHm035086 for <xfs@oss.sgi.com>; Mon, 21 Dec 2009 05:47:45 -0600
Message-ID: <4B2F6153.8010609@gmail.com>
Date: Mon, 21 Dec 2009 19:51:47 +0800
From: Liuwenyi <qingshenlwy@gmail.com>
MIME-Version: 1.0
Subject: [PATCHv2 00/12]posix_acl: Add the check items
Reply-To: qingshenlwy@gmail.com
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
To: chris.mason@oracle.com, viro@zeniv.linux.org.uk, joel.becker@oracle.com, cjb@laptop.org, jmorris@namei.org, serue@us.ibm.com, hch@lst.de, akpm@linux-foundation.org, adilger@sun.com, jack@suse.cz, tytso@mit.edu, dwmw2@infradead.org, swhiteho@redhat.com, bfields@fieldses.org, neilb@suse.de, ffilzlnx@us.ibm.com, bharrosh@panasas.com, mfasheh@suse.com, tiger.yang@oracle.com, jeffm@suse.com, aelder@sgi.com, sandeen@sandeen.net, xfs-masters@oss.sgi.com, xfs@oss.sgi.com, reiserfs-devel@vger.kernel.org, ocfs2-devel@oss.oracle.com, linux-nfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, cluster-devel@redhat.com, linux-mtd@lists.infradead.org, strongzgy@gmail.com, onlyflyer@gmail.com

Hi all:
This patch is moving the acl check(Null pointer and PTR_ERR) into
fs/posix_acl.c.

Thanks for Matthew Wilcox's sguuestion.

---
Signed-off-by: Liuwenyi <qingshenlwy@gmail.com>
Cc: Chris Mason <chris.mason@oracle.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Joel Becker <joel.becker@oracle.com>
Cc: Chris Ball <cjb@laptop.org>
Cc: James Morris <jmorris@namei.org>
Cc: Serge Hallyn <serue@us.ibm.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Andreas Dilger <adilger@sun.com>
Cc: Jan Kara <jack@suse.cz>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Steven Whitehouse <swhiteho@redhat.com>
Cc: J. Bruce Fields <bfields@fieldses.org>
Cc: Neil Brown <neilb@suse.de>
Cc: Frank Filz <ffilzlnx@us.ibm.com>
Cc: Boaz Harrosh <bharrosh@panasas.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Tiger Yang <tiger.yang@oracle.com>
Cc: Jeff Mahoney <jeffm@suse.com>
Cc: Alex Elder <aelder@sgi.com>
Cc: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-masters@oss.sgi.com
Cc: xfs@oss.sgi.com
Cc: reiserfs-devel@vger.kernel.org
Cc: ocfs2-devel@oss.oracle.com
Cc: linux-nfs@vger.kernel.org
Cc: linux-ext4@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: cluster-devel@redhat.com
Cc: linux-mtd@lists.infradead.org

-- 
Best Regards,
Liuwenyi

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
