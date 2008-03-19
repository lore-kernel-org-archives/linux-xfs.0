Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 18 Mar 2008 22:11:38 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m2J5BP13018153
	for <xfs@oss.sgi.com>; Tue, 18 Mar 2008 22:11:28 -0700
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E7D96FCD5DA
	for <xfs@oss.sgi.com>; Tue, 18 Mar 2008 22:11:57 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id Wws6nLuDwpz8nvl5 for <xfs@oss.sgi.com>; Tue, 18 Mar 2008 22:11:57 -0700 (PDT)
Message-ID: <47E0A07D.5090803@sandeen.net>
Date: Wed, 19 Mar 2008 00:11:25 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] fix dir2 shortform structures on ARM old ABI
References: <b1b17e290803181631x60a3e921l836b115c3b026773@mail.gmail.com> <47E085F3.8030908@sandeen.net>
In-Reply-To: <47E085F3.8030908@sandeen.net>
Content-Type: multipart/mixed;
 boundary="------------090103080105010103000905"
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Andre Draszik <xfs@andred.net>
Cc: xfs@oss.sgi.com

This is a multi-part message in MIME format.
--------------090103080105010103000905
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Eric Sandeen wrote:

> I've helpfully provided structure layouts for the structures you mention
> in the attached files, for your diffing pleasure.  I think you'll find
> that it's not exactly as you described.

Ah hell the arm structs I attached were for oldabi.  It's what I get for
saving this fun work for late at night ;)

Attached are eabi structs; still only xfs_dir2_data_entry, xfs_dinode
and xfs_log_item seem to be affected by end-of-struct padding, of the
structures you mention.  And xfs_log_item isn't a disk structure...

which brings me back to, what specific failures do you see as a result
of end-of-struct padding on these structs?

-Eric

--------------090103080105010103000905
Content-Type: text/plain; x-mac-type="0"; x-mac-creator="0";
 name="arm-eabi.structs"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="arm-eabi.structs"

struct xfs_dir2_data_entry {
	__be64                     inumber;              /*     0     8 */
	__u8                       namelen;              /*     8     1 */
	__u8                       name[1];              /*     9     1 */
	__be16                     tag;                  /*    10     2 */

	/* size: 16, cachelines: 1 */
	/* padding: 4 */
	/* last cacheline: 16 bytes */
};
struct xfs_dinode {
	xfs_dinode_core_t          di_core;              /*     0    96 */
	/* --- cacheline 1 boundary (64 bytes) was 32 bytes ago --- */
	__be32                     di_next_unlinked;     /*    96     4 */
	union {
		xfs_bmdr_block_t   di_bmbt;              /*           4 */
		xfs_bmbt_rec_32_t  di_bmx[1];            /*          16 */
		xfs_dir2_sf_t      di_dir2sf;            /*          22 */
		char               di_c[1];              /*           1 */
		__be32             di_dev;               /*           4 */
		uuid_t             di_muuid;             /*          16 */
		char               di_symlink[1];        /*           1 */
	} di_u;                                          /*   100    24 */
	union {
		xfs_bmdr_block_t   di_abmbt;             /*           4 */
		xfs_bmbt_rec_32_t  di_abmx[1];           /*          16 */
		xfs_attr_shortform_t di_attrsf;          /*           8 */
	} di_a;                                          /*   124    16 */
	/* --- cacheline 2 boundary (128 bytes) was 12 bytes ago --- */

	/* size: 144, cachelines: 3 */
	/* padding: 4 */
	/* last cacheline: 16 bytes */
};
struct xfs_sb {
	__uint32_t                 sb_magicnum;          /*     0     4 */
	__uint32_t                 sb_blocksize;         /*     4     4 */
	xfs_drfsbno_t              sb_dblocks;           /*     8     8 */
	xfs_drfsbno_t              sb_rblocks;           /*    16     8 */
	xfs_drtbno_t               sb_rextents;          /*    24     8 */
	uuid_t                     sb_uuid;              /*    32    16 */
	xfs_dfsbno_t               sb_logstart;          /*    48     8 */
	xfs_ino_t                  sb_rootino;           /*    56     8 */
	/* --- cacheline 1 boundary (64 bytes) --- */
	xfs_ino_t                  sb_rbmino;            /*    64     8 */
	xfs_ino_t                  sb_rsumino;           /*    72     8 */
	xfs_agblock_t              sb_rextsize;          /*    80     4 */
	xfs_agblock_t              sb_agblocks;          /*    84     4 */
	xfs_agnumber_t             sb_agcount;           /*    88     4 */
	xfs_extlen_t               sb_rbmblocks;         /*    92     4 */
	xfs_extlen_t               sb_logblocks;         /*    96     4 */
	__uint16_t                 sb_versionnum;        /*   100     2 */
	__uint16_t                 sb_sectsize;          /*   102     2 */
	__uint16_t                 sb_inodesize;         /*   104     2 */
	__uint16_t                 sb_inopblock;         /*   106     2 */
	char                       sb_fname[12];         /*   108    12 */
	__uint8_t                  sb_blocklog;          /*   120     1 */
	__uint8_t                  sb_sectlog;           /*   121     1 */
	__uint8_t                  sb_inodelog;          /*   122     1 */
	__uint8_t                  sb_inopblog;          /*   123     1 */
	__uint8_t                  sb_agblklog;          /*   124     1 */
	__uint8_t                  sb_rextslog;          /*   125     1 */
	__uint8_t                  sb_inprogress;        /*   126     1 */
	__uint8_t                  sb_imax_pct;          /*   127     1 */
	/* --- cacheline 2 boundary (128 bytes) --- */
	__uint64_t                 sb_icount;            /*   128     8 */
	__uint64_t                 sb_ifree;             /*   136     8 */
	__uint64_t                 sb_fdblocks;          /*   144     8 */
	__uint64_t                 sb_frextents;         /*   152     8 */
	xfs_ino_t                  sb_uquotino;          /*   160     8 */
	xfs_ino_t                  sb_gquotino;          /*   168     8 */
	__uint16_t                 sb_qflags;            /*   176     2 */
	__uint8_t                  sb_flags;             /*   178     1 */
	__uint8_t                  sb_shared_vn;         /*   179     1 */
	xfs_extlen_t               sb_inoalignmt;        /*   180     4 */
	__uint32_t                 sb_unit;              /*   184     4 */
	__uint32_t                 sb_width;             /*   188     4 */
	/* --- cacheline 3 boundary (192 bytes) --- */
	__uint8_t                  sb_dirblklog;         /*   192     1 */
	__uint8_t                  sb_logsectlog;        /*   193     1 */
	__uint16_t                 sb_logsectsize;       /*   194     2 */
	__uint32_t                 sb_logsunit;          /*   196     4 */
	__uint32_t                 sb_features2;         /*   200     4 */
	__uint32_t                 sb_bad_features2;     /*   204     4 */

	/* size: 208, cachelines: 4 */
	/* last cacheline: 16 bytes */
};
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

	/* size: 208, cachelines: 4 */
	/* last cacheline: 16 bytes */
};
struct xfs_log_item {
	xfs_ail_entry_t            li_ail;               /*     0     8 */
	xfs_lsn_t                  li_lsn;               /*     8     8 */
	struct xfs_log_item_desc * li_desc;              /*    16     4 */
	struct xfs_mount *         li_mountp;            /*    20     4 */
	uint                       li_type;              /*    24     4 */
	uint                       li_flags;             /*    28     4 */
	struct xfs_log_item *      li_bio_list;          /*    32     4 */
	void                       (*li_cb)(struct xfs_buf *, struct xfs_log_item *); /*    36     4 */
	struct xfs_item_ops *      li_ops;               /*    40     4 */

	/* size: 48, cachelines: 1 */
	/* padding: 4 */
	/* last cacheline: 48 bytes */
};

--------------090103080105010103000905--
