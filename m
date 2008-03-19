Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 18 Mar 2008 20:17:55 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m2J3HiFK010314
	for <xfs@oss.sgi.com>; Tue, 18 Mar 2008 20:17:47 -0700
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BCD8FFCC725
	for <xfs@oss.sgi.com>; Tue, 18 Mar 2008 20:18:14 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id YDu3GaEcGgn8R2cX for <xfs@oss.sgi.com>; Tue, 18 Mar 2008 20:18:14 -0700 (PDT)
Message-ID: <47E085F3.8030908@sandeen.net>
Date: Tue, 18 Mar 2008 22:18:11 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] fix dir2 shortform structures on ARM old ABI
References: <b1b17e290803181631x60a3e921l836b115c3b026773@mail.gmail.com>
In-Reply-To: <b1b17e290803181631x60a3e921l836b115c3b026773@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------000308010300090300070805"
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Andre Draszik <xfs@andred.net>
Cc: xfs@oss.sgi.com

This is a multi-part message in MIME format.
--------------000308010300090300070805
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Andre Draszik wrote:
> Hi,
> 
> (I just subscribed, so I can't reply correctly :-(
> 
> In fact,, the last two evenings I spent making XFS work on arm eabi,
> where things are much better than with the old API, but still XFS
> won't work out of the box.

How so?

> So, Eric, if you go for the #if defined(__arm__) &&
> !defined(__ARM_EABI__) approach, arm eabi will still be broken.

Details, please.

> EABI basically behaves like other 'normal' arches/abis, but sometimes
> structures get padded to have a size of a multiple of 8, i.e. padding
> is added at the end of the struct, which as far as I can see for now
> affects 5 structs: xfs_dir2_data_entry_t, xfs_dinode_t, xfs_sb_t,
> xfs_dsb_t, and xfs_log_item_t

I did pretty exhaustive testing on new abi and saw no failures that were
clearly unique to arm, although full qa gets enough failures that I
wouldn't swear to it.  What testing did you do, and what failures did
you see?  And what work did you need to do to "make XFS work" on eabi?

I've helpfully provided structure layouts for the structures you mention
in the attached files, for your diffing pleasure.  I think you'll find
that it's not exactly as you described.

xfs_dinode_t has no extra padding at the end, though xfs_dir2_sf, a
member of one of its unions, does (though other union members are larger
though, so the struct offsets are not changed.)

There is one other cosmetic difference just because my arm tree doesn't
have Jeff's ail_entry list change.  The rest of the structures seem to
be identical.

If you have structure differences that lead to demonstrable failures,
then by all means, provide the details.

> I must say, I like Jeff's approach of explicitly telling gcc about
> alignment much better :-) It makes it a) much easier to find structs
> that are in fact representations of on-disk data and thus might need
> tweaking, and b) as somebody already said you fix such problems once
> and forever.
> E.g. for me as an absolute outsider, it was quite time consuming
> finding out which structs are actually on-disk.

At some point here I'm just going to go quietly insane.

Yes, _annotating_ things as __ondisk is great, and I have no problems
with that, although it'd be nice if something actually made use of the
annotation.  But don't confuse that with telling gcc to actually treat
each of these structures differently, which is great if done properly,
and requires a huge amount of diligence.

If you guys can take this exercise to the point where you've convinced
the sgi guys that the benefits outweigh the risks, then more power to
you.  In the meantime, I hope my targeted, safe fix for a demonstrable
problem which has gone begging for 5 years or so doesn't get lost in the
noise.

-Eric

> 
> That said, Jeff, you mentioned that your changes don't work yet
> completely - could this be because (at least from the comments) struct
> xfs_sb needs to match struct xfs_dsb and you only change xfs_dsb?
> 
> 
> Cheers,
> Andre'
> 
> 


--------------000308010300090300070805
Content-Type: text/plain; x-mac-type="0"; x-mac-creator="0";
 name="arm.structs"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="arm.structs"

struct xfs_dir2_data_entry {
	__be64                     inumber;              /*     0     8 */
	__u8                       namelen;              /*     8     1 */
	__u8                       name[1];              /*     9     1 */
	__be16                     tag;                  /*    10     2 */

	/* size: 12, cachelines: 1 */
	/* last cacheline: 12 bytes */
};
struct xfs_dinode {
	xfs_dinode_core_t          di_core;              /*     0    96 */
	/* --- cacheline 1 boundary (64 bytes) was 32 bytes ago --- */
	__be32                     di_next_unlinked;     /*    96     4 */
	union {
		xfs_bmdr_block_t   di_bmbt;              /*           4 */
		xfs_bmbt_rec_32_t  di_bmx[1];            /*          16 */
		xfs_dir2_sf_t      di_dir2sf;            /*          24 */
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

	/* size: 140, cachelines: 3 */
	/* last cacheline: 12 bytes */
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

	/* size: 44, cachelines: 1 */
	/* last cacheline: 44 bytes */
};

--------------000308010300090300070805
Content-Type: text/plain; x-mac-type="0"; x-mac-creator="0";
 name="x86.structs"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x86.structs"

struct xfs_dir2_data_entry {
	__be64                     inumber;              /*     0     8 */
	__u8                       namelen;              /*     8     1 */
	__u8                       name[1];              /*     9     1 */
	__be16                     tag;                  /*    10     2 */

	/* size: 12, cachelines: 1 */
	/* last cacheline: 12 bytes */
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

	/* size: 140, cachelines: 3 */
	/* last cacheline: 12 bytes */
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
	struct list_head           li_ail;               /*     0     8 */
	xfs_lsn_t                  li_lsn;               /*     8     8 */
	struct xfs_log_item_desc * li_desc;              /*    16     4 */
	struct xfs_mount *         li_mountp;            /*    20     4 */
	uint                       li_type;              /*    24     4 */
	uint                       li_flags;             /*    28     4 */
	struct xfs_log_item *      li_bio_list;          /*    32     4 */
	void                       (*li_cb)(struct xfs_buf *, struct xfs_log_item *); /*    36     4 */
	struct xfs_item_ops *      li_ops;               /*    40     4 */

	/* size: 44, cachelines: 1 */
	/* last cacheline: 44 bytes */
};

--------------000308010300090300070805--
