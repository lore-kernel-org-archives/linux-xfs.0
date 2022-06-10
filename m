Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A045C43334
	for <linux-xfs@archiver.kernel.org>; Fri, 10 Jun 2022 23:05:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343938AbiFJXFZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 10 Jun 2022 19:05:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348656AbiFJXFX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 10 Jun 2022 19:05:23 -0400
Received: from mail-qv1-xf29.google.com (mail-qv1-xf29.google.com [IPv6:2607:f8b0:4864:20::f29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0EF811463
        for <linux-xfs@vger.kernel.org>; Fri, 10 Jun 2022 16:05:20 -0700 (PDT)
Received: by mail-qv1-xf29.google.com with SMTP id l1so607255qvh.1
        for <linux-xfs@vger.kernel.org>; Fri, 10 Jun 2022 16:05:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=1l6/STObwpusTSDxzxobq9F4ZjYYB8ZnJGWCA+TeZE4=;
        b=JV+63/gWo3/SSEKci3gDbj2tuoMj11RoKziRK6Iq7CnCEiDaHHeUpLXyU/VfJhR/vR
         D5StuIuQsguawvxIZyJ/keWrO7+n4QbknKKX0eRO70TJx6GwpSUry7K9solm/pZ5G55g
         aveSWcFOQSVXi/PmrWQ0Kp07jnXbGEpA9HKcMBpqiwVivq8ePTj5VQKp4L2piVAttIFA
         b0rpKsRA7HEqj7cAoquESMh6u5lR/86NcdVvRVYyCu/4kZjtJuEsgYxwdF2qvDwfv1DG
         A8aSZnH2LKIBs/zUcs5+DlFMtnMQNJHJQqL8i55f8+bNmOxt65V+QNyi2uqtCLNanCPT
         j0fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=1l6/STObwpusTSDxzxobq9F4ZjYYB8ZnJGWCA+TeZE4=;
        b=1vuGrZYjTi3P20okqH5P8Qgtxr18oOuewsyZZIXN0fGQ+JREHnP5b3nmmPwt4dj03h
         nGByQNWCaYzmVgU147Sl1NSd52wHF7bJy7VBGz1ltEYnqDzhRuny+oLkIPlLBfgCNGzc
         VjE9oJ/w7ZDQCV/pswwO11rsCHAq+og/PY980uk4H3UGOmHA13ui7vE5fNzQ5sVYYg85
         75e+5QkVctSkXfNPgjYHT2ODY8wuMAFExqCLdRkv9hc+2BZj3gay0vjkrOvTWhCWRmov
         1kcu060aP84W+x5+NlSO+ne27b12vtQZO4Tw0xua+vQGyKriF5IC3MGz+XDiktYgQcMs
         UoaQ==
X-Gm-Message-State: AOAM533GaPK4VewzIe6V2xiYmf71SEpvpl1UPmadqZJ1ZFN+2e6xZ/FG
        hwL7/LMjvs1SwNLThUOYti0=
X-Google-Smtp-Source: ABdhPJyj4E4HDT+39vsVxIvX2YXBf+20GXt8mlVraA/HGNfvaSlwbGnmshYm27k1phTgOJ2LBjHO6Q==
X-Received: by 2002:a05:6214:1d25:b0:464:55a9:48df with SMTP id f5-20020a0562141d2500b0046455a948dfmr47202902qvd.113.1654902319815;
        Fri, 10 Jun 2022 16:05:19 -0700 (PDT)
Received: from ?IPV6:2601:18f:801:dd40:c38c:a019:12ef:edc9? ([2601:18f:801:dd40:c38c:a019:12ef:edc9])
        by smtp.gmail.com with ESMTPSA id c20-20020ac84e14000000b00304bbcc1b8asm278573qtw.28.2022.06.10.16.05.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Jun 2022 16:05:19 -0700 (PDT)
Message-ID: <aed54ce4-e1bf-39f7-cf91-a67e29f59d52@gmail.com>
Date:   Fri, 10 Jun 2022 19:05:16 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [RFC PATCH v2] xfsrestore: fix rootdir due to xfsdump bulkstat
 misuse
Content-Language: en-US
To:     Gao Xiang <hsiangkao@redhat.com>, linux-xfs@vger.kernel.org
Cc:     Eric Sandeen <sandeen@sandeen.net>,
        Donald Douwsma <ddouwsma@redhat.com>
References: <20201113125127.966243-1-hsiangkao@redhat.com>
 <20201116080723.1486270-1-hsiangkao@redhat.com>
From:   Hironori Shiina <shiina.hironori@gmail.com>
In-Reply-To: <20201116080723.1486270-1-hsiangkao@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 11/16/20 03:07, Gao Xiang wrote:
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

I agree that this function is optional for another reason. This fix
cannot be the default behavior because of a workaround for a case where
a fake root's gen is zero. This workaround prevents a correct dump
without a fake root from being restored.

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

As far as I see intialization for a root in tree_init(), isn't it
necessary to adopt the orphanage node(persp->p_orphh) to the new root?

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

As I mentioned above, this workaround makes this correction optional.
This workaround assumes the initially created root is fake. If a dump is
created correctly without a fake root, this function returns NH_NULL for
the correct root.


Thanks,
Hironori

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
