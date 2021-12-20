Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B189C433EF
	for <linux-xfs@archiver.kernel.org>; Mon, 20 Dec 2021 15:28:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238751AbhLTP2i (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 20 Dec 2021 10:28:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237536AbhLTP2S (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 Dec 2021 10:28:18 -0500
Received: from mail-qv1-xf36.google.com (mail-qv1-xf36.google.com [IPv6:2607:f8b0:4864:20::f36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5A46C0A8909
        for <linux-xfs@vger.kernel.org>; Mon, 20 Dec 2021 07:14:17 -0800 (PST)
Received: by mail-qv1-xf36.google.com with SMTP id kc16so9624073qvb.3
        for <linux-xfs@vger.kernel.org>; Mon, 20 Dec 2021 07:14:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=nFO1+m9tyRLeYeJh4dXhAkA+80d7YSD/2i3phE24ZMI=;
        b=UQyTAekU6YKQrIRLhe+DB3/cNJ0QGGu/Wae6jyJfG69MslvRoAsfyjqMRIjF7AZj3O
         U/l7p8sRZX1N59DncgtIM8Gi8bcZhxFwgKjkJsol8WQQGfULtp+qKf8BO/sRwWdCJcmd
         WiLMwHdDM9BJcR+Ub2Q7Gh534DWFcZKoYo7yscFtgeaLeu7D+QpUSQxkd7XQLZvMf5td
         ALC5O3frJ2CoeN7rg5Rg1mlNswJV0rXXIXBt4NhWvlTRgpuwfew/cTJi0y+Q2lLrEQTq
         lgfnvr6nrkplcb9cWTQpUwolxGvkuhTFyeRagicopoNqmMZTOYCEMCmh7bbEUaOcecS/
         FUQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=nFO1+m9tyRLeYeJh4dXhAkA+80d7YSD/2i3phE24ZMI=;
        b=QkW55R6m2deiCJylsLwFqSyaBLwLL9EFO9SKc0tILBtnRcERKIPVImgbhOjfeR5ykY
         OpTO3ymvVisPEla428dkC5YrRl888nOq5xcz4S7RpBN7ocaZwyBR1PEzSz/2Huy4tbJ7
         CfrLLhp+lXrqA9J9969AP8fVFSswL5uZlSS/8+xuceSZv5KpC4fmOIv1kuj1NV3CCTBs
         eYf4CCECCPcvgvzlTIC8Gv0Dezc9yzzvIobtpzyGb63NBsC4UU2R/yCZgybV0PoCmFHm
         /RNiX6Nm1QPp8wZWg1zNWoJfDlSD8xxMuRuMLSEjwGwIfRib4P8OR51/Su/2Thscg7wJ
         J+Hw==
X-Gm-Message-State: AOAM532cvtZbrxD69S8EDpX5lWIZNJm1SaHLqdQpQ1GwgfDxLJsnMv1l
        sCIzdenJDiqrpumKhzqn9A==
X-Google-Smtp-Source: ABdhPJyrvEhVdB4lpipdKZvNTST7pfckCj+Lp6lJS5trtMPUMLk+VXHUsZG+SVei5n0FsdKUjHTJ8A==
X-Received: by 2002:a05:6214:508d:: with SMTP id kk13mr7597475qvb.43.1640013256965;
        Mon, 20 Dec 2021 07:14:16 -0800 (PST)
Received: from gabell (209-6-122-159.s2973.c3-0.arl-cbr1.sbo-arl.ma.cable.rcncustomer.com. [209.6.122.159])
        by smtp.gmail.com with ESMTPSA id t15sm15569472qta.45.2021.12.20.07.14.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Dec 2021 07:14:16 -0800 (PST)
Date:   Mon, 20 Dec 2021 10:14:14 -0500
From:   Masayoshi Mizuma <msys.mizuma@gmail.com>
To:     Gao Xiang <hsiangkao@redhat.com>
Cc:     linux-xfs@vger.kernel.org, Eric Sandeen <sandeen@sandeen.net>,
        Donald Douwsma <ddouwsma@redhat.com>
Subject: Re: [RFC PATCH v2] xfsrestore: fix rootdir due to xfsdump bulkstat
 misuse
Message-ID: <YcCdxvyYbNHREvDW@gabell>
References: <20201113125127.966243-1-hsiangkao@redhat.com>
 <20201116080723.1486270-1-hsiangkao@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201116080723.1486270-1-hsiangkao@redhat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Nov 16, 2020 at 04:07:23PM +0800, Gao Xiang wrote:
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
> 
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

Hello,
This patch looks good to me. The option should be useful as
the workaround of the xfsdump bulkstat issue.

How about if we add the help of the option?
Something like this:

diff --git a/common/main.c b/common/main.c
index cb2caf7..9f98226 100644
--- a/common/main.c
+++ b/common/main.c
@@ -988,6 +988,7 @@ usage(void)
 	ULO(_("(contents only)"),			GETOPT_TOC);
 	ULO(_("<verbosity {silent, verbose, trace}>"),	GETOPT_VERBOSITY);
 	ULO(_("(use small tree window)"),		GETOPT_SMALLWINDOW);
+	ULO(_("(try to fix rootdir due to xfsdump issue)"),GETOPT_FIXROOTDIR);
 	ULO(_("(don't restore extended file attributes)"), GETOPT_NOEXTATTR);
 	ULO(_("(restore root dir owner/permissions)"),	GETOPT_ROOTPERM);
 	ULO(_("(restore DMAPI event settings)"),	GETOPT_SETDM);
diff --git a/man/man8/xfsrestore.8 b/man/man8/xfsrestore.8
index 60e4309..5e58434 100644
--- a/man/man8/xfsrestore.8
+++ b/man/man8/xfsrestore.8
@@ -240,6 +240,10 @@ but does not create or modify any files or directories.
 It may be desirable to set the verbosity level to \f3silent\f1
 when using this option.
 .TP 5
+.B \-x
+This option may be useful to fix an issue which the files are restored
+to orphanage directory because of xfsdump (v3.1.7 - v3.1.9) problem.
+.TP 5
 \f3\-v\f1 \f2verbosity\f1
 .\" set inter-paragraph distance to 0
 .PD 0
---

Thanks!
Masa

> ---
> changes since RFC v1:
>  - fix non-dir fake rootino cases since tree_begindir()
>    won't be triggered for these non-dir, and we could do
>    that in tree_addent() instead (fault injection verified);
> 
>  - fix fake rootino case with gen = 0 as well, for more
>    details, see the inlined comment in link_hardh()
>    (fault injection verified as well).
> 
> Anyway, all of this behaves like a workaround and I have
> no idea how to deal it more gracefully.
> 
>  restore/content.c |  7 +++++
>  restore/getopt.h  |  4 +--
>  restore/tree.c    | 70 ++++++++++++++++++++++++++++++++++++++++++++---
>  restore/tree.h    |  2 ++
>  4 files changed, 77 insertions(+), 6 deletions(-)
> 
> diff --git a/restore/content.c b/restore/content.c
> index 6b22965..e807a83 100644
> --- a/restore/content.c
> +++ b/restore/content.c
> @@ -865,6 +865,7 @@ static int quotafilecheck(char *type, char *dstdir, char *quotafile);
>  
>  bool_t content_media_change_needed;
>  bool_t restore_rootdir_permissions;
> +bool_t need_fixrootdir;
>  char *media_change_alert_program = NULL;
>  size_t perssz;
>  
> @@ -964,6 +965,7 @@ content_init(int argc, char *argv[], size64_t vmsz)
>  	stsz = 0;
>  	interpr = BOOL_FALSE;
>  	restore_rootdir_permissions = BOOL_FALSE;
> +	need_fixrootdir = BOOL_FALSE;
>  	optind = 1;
>  	opterr = 0;
>  	while ((c = getopt(argc, argv, GETOPT_CMDSTRING)) != EOF) {
> @@ -1189,6 +1191,9 @@ content_init(int argc, char *argv[], size64_t vmsz)
>  		case GETOPT_FMT2COMPAT:
>  			tranp->t_truncategenpr = BOOL_TRUE;
>  			break;
> +		case GETOPT_FIXROOTDIR:
> +			need_fixrootdir = BOOL_TRUE;
> +			break;
>  		}
>  	}
>  
> @@ -3140,6 +3145,8 @@ applydirdump(drive_t *drivep,
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
> index 0670318..918fa01 100644
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
> @@ -265,6 +264,7 @@ extern void usage(void);
>  extern size_t pgsz;
>  extern size_t pgmask;
>  extern bool_t restore_rootdir_permissions;
> +extern bool_t need_fixrootdir;
>  
>  /* forward declarations of locally defined static functions ******************/
>  
> @@ -331,10 +331,45 @@ static tran_t *tranp = 0;
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
> +
> +		mlog(MLOG_NORMAL, _("fix root # to %llu (bind mount?)\n"),
> +		     rootino);
> +	}
> +}
> +
>  /* ARGSUSED */
>  bool_t
>  tree_init(char *hkdir,
> @@ -754,7 +789,8 @@ tree_begindir(filehdr_t *fhdrp, dah_t *dahp)
>  	/* lookup head of hardlink list
>  	 */
>  	hardh = link_hardh(ino, gen);
> -	assert(ino != persp->p_rootino || hardh == persp->p_rooth);
> +	if (need_fixrootdir == BOOL_FALSE)
> +		assert(ino != persp->p_rootino || hardh == persp->p_rooth);
>  
>  	/* already present
>  	 */
> @@ -823,7 +859,6 @@ tree_begindir(filehdr_t *fhdrp, dah_t *dahp)
>  		adopt(persp->p_orphh, hardh, NRH_NULL);
>  		*dahp = dah;
>  	}
> -
>  	return hardh;
>  }
>  
> @@ -968,6 +1003,7 @@ tree_addent(nh_t parh, xfs_ino_t ino, gen_t gen, char *name, size_t namelen)
>  				}
>  			} else {
>  				assert(hardp->n_nrh != NRH_NULL);
> +
>  				namebuflen
>  				=
>  				namreg_get(hardp->n_nrh,
> @@ -1118,6 +1154,13 @@ tree_addent(nh_t parh, xfs_ino_t ino, gen_t gen, char *name, size_t namelen)
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
> @@ -3841,7 +3884,26 @@ selsubtree_recurse_down(nh_t nh, bool_t sensepr)
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
> index 4f9ffe8..5d0c346 100644
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
> 2.18.4
> 
