Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 6DB6429DFB
	for <xfs@oss.sgi.com>; Sun, 22 Sep 2013 23:13:46 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 1B810AC004
	for <xfs@oss.sgi.com>; Sun, 22 Sep 2013 21:13:42 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	CsRLCTNoi92tmxLn for <xfs@oss.sgi.com>;
	Sun, 22 Sep 2013 21:13:41 -0700 (PDT)
Date: Mon, 23 Sep 2013 14:13:35 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC PATCH] xfsprogs: add hex offset for superblock structure
Message-ID: <20130923041335.GU9901@dastard>
References: <1379907255.3246.4.camel@ThinkPad-T5421>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1379907255.3246.4.camel@ThinkPad-T5421>
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
To: Li Zhong <zhong@linux.vnet.ibm.com>
Cc: Chandra Seetharaman <sekharan@us.ibm.com>, xfsprogs <xfs@oss.sgi.com>

On Mon, Sep 23, 2013 at 11:34:15AM +0800, Li Zhong wrote:
> It would be a little bit easier if somebody uses something like hexdump 
> to check the superblock of one device.

NACK. If you want this information, use pahole.

Cheers,

Dave.

$ pahole fs/xfs/xfs_sb.o |grep -A 61 "struct xfs_dsb"
struct xfs_dsb {
        __be32                     sb_magicnum;          /*     0     4 */
        __be32                     sb_blocksize;         /*     4     4 */
        __be64                     sb_dblocks;           /*     8     8 */
        __be64                     sb_rblocks;           /*    16     8 */
        __be64                     sb_rextents;          /*    24     8 */
        uuid_t                     sb_uuid;              /*    32    16 */
        __be64                     sb_logstart;          /*    48     8 */
        __be64                     sb_rootino;           /*    56     8 */
        /* --- cacheline 1 boundary (64 bytes) --- */
        __be64                     sb_rbmino;            /*    64     8 */
        __be64                     sb_rsumino;           /*    72     8 */
        __be32                     sb_rextsize;          /*    80     4 */
        __be32                     sb_agblocks;          /*    84     4 */
        __be32                     sb_agcount;           /*    88     4 */
        __be32                     sb_rbmblocks;         /*    92     4 */
        __be32                     sb_logblocks;         /*    96     4 */
        __be16                     sb_versionnum;        /*   100     2 */
        __be16                     sb_sectsize;          /*   102     2 */
        __be16                     sb_inodesize;         /*   104     2 */
        __be16                     sb_inopblock;         /*   106     2 */
        char                       sb_fname[12];         /*   108    12 */
        __u8                       sb_blocklog;          /*   120     1 */
        __u8                       sb_sectlog;           /*   121     1 */
        __u8                       sb_inodelog;          /*   122     1 */
        __u8                       sb_inopblog;          /*   123     1 */
        __u8                       sb_agblklog;          /*   124     1 */
        __u8                       sb_rextslog;          /*   125     1 */
        __u8                       sb_inprogress;        /*   126     1 */
        __u8                       sb_imax_pct;          /*   127     1 */
        /* --- cacheline 2 boundary (128 bytes) --- */
        __be64                     sb_icount;            /*   128     8 */
        __be64                     sb_ifree;             /*   136     8 */
        __be64                     sb_fdblocks;          /*   144     8 */
        __be64                     sb_frextents;         /*   152     8 */
        __be64                     sb_uquotino;          /*   160     8 */
        __be64                     sb_gquotino;          /*   168     8 */
        __be16                     sb_qflags;            /*   176     2 */
        __u8                       sb_flags;             /*   178     1 */
        __u8                       sb_shared_vn;         /*   179     1 */
        __be32                     sb_inoalignmt;        /*   180     4 */
        __be32                     sb_unit;              /*   184     4 */
        __be32                     sb_width;             /*   188     4 */
        /* --- cacheline 3 boundary (192 bytes) --- */
        __u8                       sb_dirblklog;         /*   192     1 */
        __u8                       sb_logsectlog;        /*   193     1 */
        __be16                     sb_logsectsize;       /*   194     2 */
        __be32                     sb_logsunit;          /*   196     4 */
        __be32                     sb_features2;         /*   200     4 */
        __be32                     sb_bad_features2;     /*   204     4 */
        __be32                     sb_features_compat;   /*   208     4 */
        __be32                     sb_features_ro_compat; /*   212     4 */
        __be32                     sb_features_incompat; /*   216     4 */
        __be32                     sb_features_log_incompat; /*   220     4 */
        __le32                     sb_crc;               /*   224     4 */
        __be32                     sb_pad;               /*   228     4 */
        __be64                     sb_pquotino;          /*   232     8 */
        __be64                     sb_lsn;               /*   240     8 */

        /* size: 248, cachelines: 4, members: 54 */
        /* last cacheline: 56 bytes */
};
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
