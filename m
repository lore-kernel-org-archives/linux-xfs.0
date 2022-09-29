Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F0C5C433FE
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Sep 2022 18:17:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234417AbiI2SRY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 29 Sep 2022 14:17:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235182AbiI2SRX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Sep 2022 14:17:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56C951F5A30
        for <linux-xfs@vger.kernel.org>; Thu, 29 Sep 2022 11:17:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E9F7C62127
        for <linux-xfs@vger.kernel.org>; Thu, 29 Sep 2022 18:17:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C3F4C433C1;
        Thu, 29 Sep 2022 18:17:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664475441;
        bh=fONu4FS2iQlmOkFNECNiDZ6JcZYFTasNFzMy3ftkVvg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KesuZBIrvUwXkRdPsDt6fJfMgASHDSrvMJN5dxNs+/xYCHaOSimY91/C3ufUTKzm8
         lTifc/8GZsjvBvxOs7Z0RflElK+nT78/qRN630BI+VNdnWgIpL87KhUi3x5a2CqzIj
         JLD/r2HmmCz4RHZ+jNKghPlYTcn9KI0+tqM6T/aGLN7O7Zt+YEY0Rm3kHA7g956i9z
         lN19+Mi18yf/8AxzWT2kUjg0Vh4fsFc8fa/dDxdKJG5xqixUFtF0WaX6T3pDf6quDt
         mDnJNZ2X73WY19sBWiGzrBklmOfTAScOsfrOMZP3nq58hMAQt9blQGQAfZYAn78aGF
         JRyGUU3Rpwr9A==
Date:   Thu, 29 Sep 2022 11:17:20 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Hironori Shiina <shiina.hironori@gmail.com>
Cc:     linux-xfs@vger.kernel.org, Gao Xiang <hsiangkao@redhat.com>,
        Donald Douwsma <ddouwsma@redhat.com>,
        Hironori Shiina <shiina.hironori@fujitsu.com>
Subject: Re: [RFC PATCH V3] xfsrestore: fix rootdir due to xfsdump bulkstat
 misuse
Message-ID: <YzXhMJmbEsEueRKy@magnolia>
References: <20201116080723.1486270-1-hsiangkao@redhat.com>
 <20220928191052.410437-1-shiina.hironori@fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220928191052.410437-1-shiina.hironori@fujitsu.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Sep 28, 2022 at 03:10:52PM -0400, Hironori Shiina wrote:
> From: Gao Xiang <hsiangkao@redhat.com>
> 
> If rootino is wrong and misspecified to a subdir inode #,
> the following assertion could be triggered:
>   assert(ino != persp->p_rootino || hardh == persp->p_rooth);
> 
> This patch adds a '-x' option (another awkward thing is that
> the codebase doesn't support long options) to address
> problamatic images by searching for the real dir, the reason
> that I don't enable it by default is that I'm not very confident
> with the xfsrestore codebase and xfsdump bulkstat issue will
> also be fixed immediately as well, so this function might be
> optional and only useful for pre-exist corrupted dumps.

As far as fixing xfsdump -- wasn't XFS_BULK_IREQ_SPECIAL_ROOT supposed
to solve that problem by enabling dump to discover it it's really been
passed the fs root directory?

--D

> In details, my understanding of the original logic is
>  1) xfsrestore will create a rootdir node_t (p_rooth);
>  2) it will build the tree hierarchy from inomap and adopt
>     the parent if needed (so inodes whose parent ino hasn't
>     detected will be in the orphan dir, p_orphh);
>  3) during this period, if ino == rootino and
>     hardh != persp->p_rooth (IOWs, another node_t with
>     the same ino # is created), that'd be definitely wrong.
> 
> So the proposal fix is that
>  - considering the xfsdump root ino # is a subdir inode, it'll
>    trigger ino == rootino && hardh != persp->p_rooth condition;
>  - so we log this node_t as persp->p_rooth rather than the
>    initial rootdir node_t created in 1);
>  - we also know that this node is actually a subdir, and after
>    the whole inomap is scanned (IOWs, the tree is built),
>    the real root dir will have the orphan dir parent p_orphh;
>  - therefore, we walk up by the parent until some node_t has
>    the p_orphh, so that's it.
> 
> Cc: Donald Douwsma <ddouwsma@redhat.com>
> Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
> Signed-off-by: Hironori Shiina <shiina.hironori@fujitsu.com>
> ---
> 
> changes since RFC v2:
>  - re-adopt the orphanage dir to the fixed root for creating a
>    correct path of the orphanage dir.
> 
>  - add description of the new '-x' option to the man page.
> 
> changes since RFC v1:
>  - fix non-dir fake rootino cases since tree_begindir()
>    won't be triggered for these non-dir, and we could do
>    that in tree_addent() instead (fault injection verified);
> 
>  - fix fake rootino case with gen = 0 as well, for more
>    details, see the inlined comment in link_hardh()
>    (fault injection verified as well).
> 
>  common/main.c         |  1 +
>  man/man8/xfsrestore.8 | 14 +++++++++
>  restore/content.c     |  7 +++++
>  restore/getopt.h      |  4 +--
>  restore/tree.c        | 72 ++++++++++++++++++++++++++++++++++++++++---
>  restore/tree.h        |  2 ++
>  6 files changed, 94 insertions(+), 6 deletions(-)
> 
> diff --git a/common/main.c b/common/main.c
> index 1db07d4..6141ffb 100644
> --- a/common/main.c
> +++ b/common/main.c
> @@ -988,6 +988,7 @@ usage(void)
>  	ULO(_("(contents only)"),			GETOPT_TOC);
>  	ULO(_("<verbosity {silent, verbose, trace}>"),	GETOPT_VERBOSITY);
>  	ULO(_("(use small tree window)"),		GETOPT_SMALLWINDOW);
> +	ULO(_("(try to fix rootdir due to xfsdump issue)"),GETOPT_FIXROOTDIR);
>  	ULO(_("(don't restore extended file attributes)"), GETOPT_NOEXTATTR);
>  	ULO(_("(restore root dir owner/permissions)"),	GETOPT_ROOTPERM);
>  	ULO(_("(restore DMAPI event settings)"),	GETOPT_SETDM);
> diff --git a/man/man8/xfsrestore.8 b/man/man8/xfsrestore.8
> index 60e4309..df7dde0 100644
> --- a/man/man8/xfsrestore.8
> +++ b/man/man8/xfsrestore.8
> @@ -240,6 +240,20 @@ but does not create or modify any files or directories.
>  It may be desirable to set the verbosity level to \f3silent\f1
>  when using this option.
>  .TP 5
> +.B \-x
> +This option may be useful to fix an issue which the files are restored
> +to orphanage directory because of xfsdump (v3.1.7 - v3.1.9) problem.
> +A normal dump cannot be restored with this option. This option works
> +only for a corrupted dump.
> +If a dump is created by problematic xfsdump (v3.1.7 - v3.1.9), you
> +should see the contents of the dump with \f3\-t\f1 option before
> +restoring. Then, if a file is placed to the orphanage directory, you need to
> +use this \f3\-x\f1 option to restore the dump. Otherwise, you can restore
> +the dump without this option.
> +
> +In the cumulative mode, this option is required only for a base (level 0)
> +dump. You no longer need this option for level 1+ dumps.
> +.TP 5
>  \f3\-v\f1 \f2verbosity\f1
>  .\" set inter-paragraph distance to 0
>  .PD 0
> diff --git a/restore/content.c b/restore/content.c
> index b19bb90..fdf26dd 100644
> --- a/restore/content.c
> +++ b/restore/content.c
> @@ -861,6 +861,7 @@ static int quotafilecheck(char *type, char *dstdir, char *quotafile);
>  
>  bool_t content_media_change_needed;
>  bool_t restore_rootdir_permissions;
> +bool_t need_fixrootdir;
>  char *media_change_alert_program = NULL;
>  size_t perssz;
>  
> @@ -958,6 +959,7 @@ content_init(int argc, char *argv[], size64_t vmsz)
>  	stsz = 0;
>  	interpr = BOOL_FALSE;
>  	restore_rootdir_permissions = BOOL_FALSE;
> +	need_fixrootdir = BOOL_FALSE;
>  	optind = 1;
>  	opterr = 0;
>  	while ((c = getopt(argc, argv, GETOPT_CMDSTRING)) != EOF) {
> @@ -1186,6 +1188,9 @@ content_init(int argc, char *argv[], size64_t vmsz)
>  		case GETOPT_FMT2COMPAT:
>  			tranp->t_truncategenpr = BOOL_TRUE;
>  			break;
> +		case GETOPT_FIXROOTDIR:
> +			need_fixrootdir = BOOL_TRUE;
> +			break;
>  		}
>  	}
>  
> @@ -3129,6 +3134,8 @@ applydirdump(drive_t *drivep,
>  			return rv;
>  		}
>  
> +		if (need_fixrootdir)
> +			tree_fixroot();
>  		persp->s.dirdonepr = BOOL_TRUE;
>  	}
>  
> diff --git a/restore/getopt.h b/restore/getopt.h
> index b5bc004..b0c0c7d 100644
> --- a/restore/getopt.h
> +++ b/restore/getopt.h
> @@ -26,7 +26,7 @@
>   * purpose is to contain that command string.
>   */
>  
> -#define GETOPT_CMDSTRING	"a:b:c:def:himn:op:qrs:tv:wABCDEFG:H:I:JKL:M:NO:PQRS:TUVWX:Y:"
> +#define GETOPT_CMDSTRING	"a:b:c:def:himn:op:qrs:tv:wxABCDEFG:H:I:JKL:M:NO:PQRS:TUVWX:Y:"
>  
>  #define GETOPT_WORKSPACE	'a'	/* workspace dir (content.c) */
>  #define GETOPT_BLOCKSIZE        'b'     /* blocksize for rmt */
> @@ -51,7 +51,7 @@
>  /*				'u' */
>  #define	GETOPT_VERBOSITY	'v'	/* verbosity level (0 to 4) */
>  #define	GETOPT_SMALLWINDOW	'w'	/* use a small window for dir entries */
> -/*				'x' */
> +#define GETOPT_FIXROOTDIR	'x'	/* try to fix rootdir due to bulkstat misuse */
>  /*				'y' */
>  /*				'z' */
>  #define	GETOPT_NOEXTATTR	'A'	/* do not restore ext. file attr. */
> diff --git a/restore/tree.c b/restore/tree.c
> index 5429b74..bfa07fe 100644
> --- a/restore/tree.c
> +++ b/restore/tree.c
> @@ -15,7 +15,6 @@
>   * along with this program; if not, write the Free Software Foundation,
>   * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>   */
> -
>  #include <stdio.h>
>  #include <unistd.h>
>  #include <stdlib.h>
> @@ -262,6 +261,7 @@ extern void usage(void);
>  extern size_t pgsz;
>  extern size_t pgmask;
>  extern bool_t restore_rootdir_permissions;
> +extern bool_t need_fixrootdir;
>  
>  /* forward declarations of locally defined static functions ******************/
>  
> @@ -328,10 +328,47 @@ static tran_t *tranp = 0;
>  static char *persname = PERS_NAME;
>  static char *orphname = ORPH_NAME;
>  static xfs_ino_t orphino = ORPH_INO;
> +static nh_t orig_rooth = NH_NULL;
>  
>  
>  /* definition of locally defined global functions ****************************/
>  
> +void
> +tree_fixroot(void)
> +{
> +	nh_t		rooth = persp->p_rooth;
> +	xfs_ino_t 	rootino;
> +
> +	while (1) {
> +		nh_t	parh;
> +		node_t *rootp = Node_map(rooth);
> +
> +		rootino = rootp->n_ino;
> +		parh = rootp->n_parh;
> +		Node_unmap(rooth, &rootp);
> +
> +		if (parh == rooth ||
> +		/*
> +		 * since all new node (including non-parent)
> +		 * would be adopted into orphh
> +		 */
> +		    parh == persp->p_orphh ||
> +		    parh == NH_NULL)
> +			break;
> +		rooth = parh;
> +	}
> +
> +	if (rooth != persp->p_rooth) {
> +		persp->p_rooth = rooth;
> +		persp->p_rootino = rootino;
> +		disown(rooth);
> +		adopt(persp->p_rooth, persp->p_orphh, NH_NULL);
> +
> +		mlog(MLOG_NORMAL, _("fix root # to %llu (bind mount?)\n"),
> +		     rootino);
> +	}
> +}
> +
>  /* ARGSUSED */
>  bool_t
>  tree_init(char *hkdir,
> @@ -746,7 +783,8 @@ tree_begindir(filehdr_t *fhdrp, dah_t *dahp)
>  	/* lookup head of hardlink list
>  	 */
>  	hardh = link_hardh(ino, gen);
> -	assert(ino != persp->p_rootino || hardh == persp->p_rooth);
> +	if (need_fixrootdir == BOOL_FALSE)
> +		assert(ino != persp->p_rootino || hardh == persp->p_rooth);
>  
>  	/* already present
>  	 */
> @@ -815,7 +853,6 @@ tree_begindir(filehdr_t *fhdrp, dah_t *dahp)
>  		adopt(persp->p_orphh, hardh, NRH_NULL);
>  		*dahp = dah;
>  	}
> -
>  	return hardh;
>  }
>  
> @@ -960,6 +997,7 @@ tree_addent(nh_t parh, xfs_ino_t ino, gen_t gen, char *name, size_t namelen)
>  				}
>  			} else {
>  				assert(hardp->n_nrh != NRH_NULL);
> +
>  				namebuflen
>  				=
>  				namreg_get(hardp->n_nrh,
> @@ -1110,6 +1148,13 @@ tree_addent(nh_t parh, xfs_ino_t ino, gen_t gen, char *name, size_t namelen)
>  		      ino,
>  		      gen);
>  	}
> +	/* found the fake rootino from subdir, need fix p_rooth. */
> +	if (need_fixrootdir == BOOL_TRUE &&
> +	    persp->p_rootino == ino && hardh != persp->p_rooth) {
> +		mlog(MLOG_NORMAL,
> +		     _("found fake rootino #%llu, will fix.\n"), ino);
> +		persp->p_rooth = hardh;
> +	}
>  	return RV_OK;
>  }
>  
> @@ -3808,7 +3853,26 @@ selsubtree_recurse_down(nh_t nh, bool_t sensepr)
>  static nh_t
>  link_hardh(xfs_ino_t ino, gen_t gen)
>  {
> -	return hash_find(ino, gen);
> +	nh_t tmp = hash_find(ino, gen);
> +
> +	/*
> +	 * XXX (another workaround): the simply way is that don't reuse node_t
> +	 * with gen = 0 created in tree_init(). Otherwise, it could cause
> +	 * xfsrestore: tree.c:1003: tree_addent: Assertion
> +	 * `hardp->n_nrh != NRH_NULL' failed.
> +	 * and that node_t is a dir node but the fake rootino could be a non-dir
> +	 * plus reusing it could cause potential loop in tree hierarchy.
> +	 */
> +	if (need_fixrootdir == BOOL_TRUE &&
> +	    ino == persp->p_rootino && gen == 0 &&
> +	    orig_rooth == NH_NULL) {
> +		mlog(MLOG_NORMAL,
> +_("link out fake rootino %llu with gen=0 created in tree_init()\n"), ino);
> +		link_out(tmp);
> +		orig_rooth = tmp;
> +		return NH_NULL;
> +	}
> +	return tmp;
>  }
>  
>  /* returns following node in hard link list
> diff --git a/restore/tree.h b/restore/tree.h
> index bf66e3d..f5bd4ff 100644
> --- a/restore/tree.h
> +++ b/restore/tree.h
> @@ -18,6 +18,8 @@
>  #ifndef TREE_H
>  #define TREE_H
>  
> +void tree_fixroot(void);
> +
>  /* tree_init - creates a new tree abstraction.
>   */
>  extern bool_t tree_init(char *hkdir,
> -- 
> 2.37.3
> 
