Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id E84A67F62
	for <xfs@oss.sgi.com>; Tue,  9 Jul 2013 15:00:25 -0500 (CDT)
Date: Tue, 9 Jul 2013 15:00:25 -0500
From: Ben Myers <bpm@sgi.com>
Subject: XFS queue for 3.11-rc1
Message-ID: <20130709200025.GT32736@sgi.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@redhat.com>, Dave Chinner <david@fromorbit.com>, Jeff Liu <jeff.liu@oracle.com>, Chandra Seetharaman <sekharan@us.ibm.com>, Carlos Maiolino <cmaiolino@redhat.com>
Cc: xfs@oss.sgi.com

Hi,

Here is what I currently have left on the queue for 3.11-rc1:

Eric:
- xfs: use XFS_BMAP_BMDR_SPACE vs. XFS_BROOT_SIZE_ADJ

Dave:
- [PATCH 01/15] xfs: update mount options documentation
- [PATCH 13/15] xfs: remove local fork format handling from xfs_bmapi_write()
- [PATCH 14/15] xfs: dquot log reservations are too small

Chandra:
- [PATCH v10 08/11] xfs: Add pquota fields where gquota is used.
- [PATCH v10 09/11] xfs: Start using pquotaino from the superblock.
- [PATCH v10 10/11] quota: Add proper versioning support to fs_quota_stat
- [PATCH v10 11/11] xfs: Use new qs_pquota field in fs_quota_stat for Q_XGETQSTAT

Jeff:
- [PATCH] xfs: clean up unused codes at xfs_bulkstat()

Carlos:
- [PATCH] xfs: fix sgid inheritance for subdirectories inheriting default acls [V3]

Some of these are ready to go and some still need review.  Maybe we can
still get them in.  If I'm missing any please give a shout.  I'd like to do
another pull request on Thursday or Friday.

Thanks,
	Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
