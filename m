Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFB2DC19F2B
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Aug 2022 11:40:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231177AbiHDLkJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 4 Aug 2022 07:40:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230457AbiHDLkI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 4 Aug 2022 07:40:08 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4517A39BBD
        for <linux-xfs@vger.kernel.org>; Thu,  4 Aug 2022 04:40:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659613206;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HLXEW2mdOIF9hJWRhSp+ups+Kg0/fl9J9nPxeCv+I2w=;
        b=BsPE0E3NwFN6iVeWRU64rUuVURDhmg3fxY/cG8WAlelw0M2a6tqF40UvN4R2oW4aTAaXBY
        TiAPMRhoo2szDuVDu3Wwe6qfX0aSQSNZXs64gkV1mmvSs5eWDt2ZEGI6NYAqTJcwyRDZjQ
        CjabswSFguYYtWmLBG/I/KU7TaXTxfw=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-674-KKbwBwrsNPmV8jNt8teTSQ-1; Thu, 04 Aug 2022 07:40:04 -0400
X-MC-Unique: KKbwBwrsNPmV8jNt8teTSQ-1
Received: by mail-ej1-f72.google.com with SMTP id jg25-20020a170907971900b00730b0d3531cso1359241ejc.10
        for <linux-xfs@vger.kernel.org>; Thu, 04 Aug 2022 04:40:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc;
        bh=HLXEW2mdOIF9hJWRhSp+ups+Kg0/fl9J9nPxeCv+I2w=;
        b=OoKelDwJndTt38IxRj7tIP2LHnLV3f2cvRPQbvArVBIFSFxUW5yV1Tlh81KDjbFpaQ
         wZ47XFoVcYPajzg/OivNSLXMLgNVGhOirfsvqQgdIYVD2/D6qtp/CmjFUnhnownB+GX3
         3u8QkOE5r0qPLiVYvsQrlqOrHGVOhQWH35M3+YDZQ7LUppnNowwVo17N4odPDvPFg1qd
         JYNQoswn7XX1E8phIxgybvbDX4+iqgWx2xJvroHNMsUIFCo7oYKt6AKc56aR9Sn2J2cB
         XoDfXWDVTK/+O8iG5SlmpS95/cILxULuFa/fIhTvt/sU8h7mkoqo1R1NQRFA3wmYoJne
         0Bww==
X-Gm-Message-State: ACgBeo3ZFZbfw0NCRmwa4NHS/Pm2bSQtkAa/LBkJDe/v4V8A/HRuZBbM
        1TUJi9+WmO714PoDqrGgKFO6QCdP+m3PhC+PeNLy+ns6lLEMBoMa1swMNLLMQQ84szmjF99Yr9z
        8q3R+3NhMGL8MwQTOA/Xz
X-Received: by 2002:a17:906:d54b:b0:72e:ece1:2956 with SMTP id cr11-20020a170906d54b00b0072eece12956mr1120864ejc.156.1659613203367;
        Thu, 04 Aug 2022 04:40:03 -0700 (PDT)
X-Google-Smtp-Source: AA6agR6kDBWPWTAQzDiM5cz4EIKRpQFUCaB4ppls5h/GPU5EAIUCCZvPsxnNvBRIvSZUZVdOval3dQ==
X-Received: by 2002:a17:906:d54b:b0:72e:ece1:2956 with SMTP id cr11-20020a170906d54b00b0072eece12956mr1120839ejc.156.1659613203060;
        Thu, 04 Aug 2022 04:40:03 -0700 (PDT)
Received: from orion (ip4-46-39-172-19.cust.nbox.cz. [46.39.172.19])
        by smtp.gmail.com with ESMTPSA id ez17-20020a056402451100b0043ba7df7a42sm530828edb.26.2022.08.04.04.40.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Aug 2022 04:40:02 -0700 (PDT)
Date:   Thu, 4 Aug 2022 13:40:00 +0200
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Eric Sandeen <sandeen@redhat.com>, xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs_restore: remove DMAPI support
Message-ID: <20220804114000.64qih3tbrouyh56z@orion>
References: <20220203174540.GT8313@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220203174540.GT8313@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Feb 03, 2022 at 09:45:40AM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> The last of the DMAPI stubs were removed from Linux 5.17, so drop this
> functionality altogether.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Patch looks good, and fixes the broken build:

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Tested-by: Carlos Maiolino <cmaiolino@redhat.com>

> ---
>  doc/xfsdump.html  |    1 -
>  po/de.po          |    5 ---
>  po/pl.po          |    5 ---
>  restore/content.c |   99 +++--------------------------------------------------
>  restore/tree.c    |   33 ------------------
>  restore/tree.h    |    1 -
>  6 files changed, 6 insertions(+), 138 deletions(-)
> 
> diff --git a/doc/xfsdump.html b/doc/xfsdump.html
> index d4d157f..2c9324b 100644
> --- a/doc/xfsdump.html
> +++ b/doc/xfsdump.html
> @@ -1092,7 +1092,6 @@ the size of the hash table.
>          bool_t p_ownerpr - whether to restore directory owner/group attributes
>          bool_t p_fullpr - whether restoring a full level 0 non-resumed dump
>          bool_t p_ignoreorphpr - set if positive subtree or interactive
> -        bool_t p_restoredmpr - restore DMI event settings
>  </pre>
>  <p>
>  The hash table maps the inode number to the tree node. It is a
> diff --git a/po/de.po b/po/de.po
> index 62face8..bdf47d1 100644
> --- a/po/de.po
> +++ b/po/de.po
> @@ -3972,11 +3972,6 @@ msgstr ""
>  msgid "no additional media objects needed\n"
>  msgstr "keine zusätzlichen Mediendateien benötigt\n"
>  
> -#: .././restore/content.c:9547
> -#, c-format
> -msgid "fssetdm_by_handle of %s failed %s\n"
> -msgstr "fssetdm_by_handle von %s fehlgeschlagen %s\n"
> -
>  #: .././restore/content.c:9566
>  #, c-format
>  msgid "%s quota information written to '%s'\n"
> diff --git a/po/pl.po b/po/pl.po
> index 3cba8d6..ba25420 100644
> --- a/po/pl.po
> +++ b/po/pl.po
> @@ -3455,11 +3455,6 @@ msgstr "nie są potrzebne dodatkowe obiekty nośnika\n"
>  msgid "path_to_handle of %s failed:%s\n"
>  msgstr "path_to_handle na %s nie powiodło się: %s\n"
>  
> -#: .././restore/content.c:9723
> -#, c-format
> -msgid "fssetdm_by_handle of %s failed %s\n"
> -msgstr "fssetdm_by_handle na %s nie powiodło się: %s\n"
> -
>  #: .././restore/content.c:9742
>  #, c-format
>  msgid "%s quota information written to '%s'\n"
> diff --git a/restore/content.c b/restore/content.c
> index 6b22965..e9b0a07 100644
> --- a/restore/content.c
> +++ b/restore/content.c
> @@ -477,9 +477,6 @@ struct pers {
>  			/* how many pages following the header page are reserved
>  			 * for the subtree descriptors
>  			 */
> -		bool_t restoredmpr;
> -			/* restore DMAPI event settings
> -			 */
>  		bool_t restoreextattrpr;
>  			/* restore extended attributes
>  			 */
> @@ -858,7 +855,6 @@ static void partial_reg(ix_t d_index, xfs_ino_t ino, off64_t fsize,
>                          off64_t offset, off64_t sz);
>  static bool_t partial_check (xfs_ino_t ino, off64_t fsize);
>  static bool_t partial_check2 (partial_rest_t *isptr, off64_t fsize);
> -static int do_fssetdm_by_handle(char *path, fsdmidata_t *fdmp);
>  static int quotafilecheck(char *type, char *dstdir, char *quotafile);
>  
>  /* definition of locally defined global variables ****************************/
> @@ -894,7 +890,6 @@ content_init(int argc, char *argv[], size64_t vmsz)
>  	bool_t changepr;/* cmd line overwrite inhibit specification */
>  	bool_t interpr;	/* cmd line interactive mode requested */
>  	bool_t ownerpr;	/* cmd line chown/chmod requested */
> -	bool_t restoredmpr; /* cmd line restore dm api attrs specification */
>  	bool_t restoreextattrpr; /* cmd line restore extended attr spec */
>  	bool_t sesscpltpr; /* force completion of prev interrupted session */
>  	ix_t stcnt;	/* cmd line number of subtrees requested */
> @@ -956,7 +951,6 @@ content_init(int argc, char *argv[], size64_t vmsz)
>  	newerpr = BOOL_FALSE;
>  	changepr = BOOL_FALSE;
>  	ownerpr = BOOL_FALSE;
> -	restoredmpr = BOOL_FALSE;
>  	restoreextattrpr = BOOL_TRUE;
>  	sesscpltpr = BOOL_FALSE;
>  	stcnt = 0;
> @@ -1162,8 +1156,11 @@ content_init(int argc, char *argv[], size64_t vmsz)
>  			tranp->t_noinvupdatepr = BOOL_TRUE;
>  			break;
>  		case GETOPT_SETDM:
> -			restoredmpr = BOOL_TRUE;
> -			break;
> +			mlog(MLOG_NORMAL | MLOG_ERROR, _(
> +			      "-%c option no longer supported\n"),
> +			      GETOPT_SETDM);
> +			usage();
> +			return BOOL_FALSE;
>  		case GETOPT_ALERTPROG:
>  			if (!optarg || optarg[0] == '-') {
>  				mlog(MLOG_NORMAL | MLOG_ERROR, _(
> @@ -1574,12 +1571,6 @@ content_init(int argc, char *argv[], size64_t vmsz)
>  	}
>  
>  	if (persp->a.valpr) {
> -		if (restoredmpr && persp->a.restoredmpr != restoredmpr) {
> -			mlog(MLOG_NORMAL | MLOG_ERROR, _(
> -			     "-%c cannot reset flag from previous restore\n"),
> -			      GETOPT_SETDM);
> -			return BOOL_FALSE;
> -		}
>  		if (!restoreextattrpr &&
>  		       persp->a.restoreextattrpr != restoreextattrpr) {
>  			mlog(MLOG_NORMAL | MLOG_ERROR, _(
> @@ -1734,7 +1725,6 @@ content_init(int argc, char *argv[], size64_t vmsz)
>  			persp->a.newerpr = newerpr;
>  			persp->a.newertime = newertime;
>  		}
> -		persp->a.restoredmpr = restoredmpr;
>  		if (!persp->a.dstdirisxfspr) {
>  			restoreextattrpr = BOOL_FALSE;
>  		}
> @@ -2365,7 +2355,6 @@ content_stream_restore(ix_t thrdix)
>  					scrhdrp->cih_inomap_nondircnt,
>  					tranp->t_vmsz,
>  					fullpr,
> -					persp->a.restoredmpr,
>  					persp->a.dstdirisxfspr,
>  					grhdrp->gh_version,
>  					tranp->t_truncategenpr);
> @@ -7549,12 +7538,6 @@ restore_reg(drive_t *drivep,
>  		}
>  	}
>  
> -	if (persp->a.dstdirisxfspr && persp->a.restoredmpr) {
> -		HsmBeginRestoreFile(bstatp,
> -				     *fdp,
> -				     &strctxp->sc_hsmflags);
> -	}
> -
>  	return BOOL_TRUE;
>  }
>  
> @@ -7726,26 +7709,6 @@ restore_complete_reg(stream_context_t *strcxtp)
>  		      strerror(errno));
>  	}
>  
> -	if (persp->a.dstdirisxfspr && persp->a.restoredmpr) {
> -		fsdmidata_t fssetdm;
> -
> -		/* Set the DMAPI Fields. */
> -		fssetdm.fsd_dmevmask = bstatp->bs_dmevmask;
> -		fssetdm.fsd_padding = 0;
> -		fssetdm.fsd_dmstate = bstatp->bs_dmstate;
> -
> -		rval = ioctl(fd, XFS_IOC_FSSETDM, (void *)&fssetdm);
> -		if (rval) {
> -			mlog(MLOG_NORMAL | MLOG_WARNING,
> -			      _("attempt to set DMI attributes of %s "
> -			      "failed: %s\n"),
> -			      path,
> -			      strerror(errno));
> -		}
> -
> -		HsmEndRestoreFile(path, fd, &strcxtp->sc_hsmflags);
> -	}
> -
>  	/* set any extended inode flags that couldn't be set
>  	 * prior to restoring the data.
>  	 */
> @@ -8064,17 +8027,6 @@ restore_symlink(drive_t *drivep,
>  				      strerror(errno));
>  			}
>  		}
> -
> -		if (persp->a.restoredmpr) {
> -		fsdmidata_t fssetdm;
> -
> -		/*	Restore DMAPI fields. */
> -
> -		fssetdm.fsd_dmevmask = bstatp->bs_dmevmask;
> -		fssetdm.fsd_padding = 0;
> -		fssetdm.fsd_dmstate = bstatp->bs_dmstate;
> -		rval = do_fssetdm_by_handle(path, &fssetdm);
> -		}
>  	}
>  
>  	return BOOL_TRUE;
> @@ -8777,7 +8729,7 @@ restore_extattr(drive_t *drivep,
>  		}
>  		assert(nread == (int)(recsz - EXTATTRHDR_SZ));
>  
> -		if (!persp->a.restoreextattrpr && !persp->a.restoredmpr) {
> +		if (!persp->a.restoreextattrpr) {
>  			continue;
>  		}
>  
> @@ -8796,19 +8748,6 @@ restore_extattr(drive_t *drivep,
>  			}
>  		} else if (isfilerestored && path[0] != '\0') {
>  			setextattr(path, ahdrp);
> -
> -			if (persp->a.dstdirisxfspr && persp->a.restoredmpr) {
> -				int flag = 0;
> -				char *attrname = (char *)&ahdrp[1];
> -				if (ahdrp->ah_flags & EXTATTRHDR_FLAGS_ROOT)
> -					flag = ATTR_ROOT;
> -				else if (ahdrp->ah_flags & EXTATTRHDR_FLAGS_SECURE)
> -					flag = ATTR_SECURE;
> -
> -				HsmRestoreAttribute(flag,
> -						     attrname,
> -						     &strctxp->sc_hsmflags);
> -			}
>  		}
>  	}
>  	/* NOTREACHED */
> @@ -9709,32 +9648,6 @@ display_needed_objects(purp_t purp,
>  	}
>  }
>  
> -static int
> -do_fssetdm_by_handle(
> -	char		*path,
> -	fsdmidata_t	*fdmp)
> -{
> -	void		*hanp;
> -	size_t		hlen=0;
> -	int		rc;
> -
> -	if (path_to_handle(path, &hanp, &hlen)) {
> -		mlog(MLOG_NORMAL | MLOG_WARNING, _(
> -			"path_to_handle of %s failed:%s\n"),
> -			path, strerror(errno));
> -		return -1;
> -	}
> -
> -	rc = fssetdm_by_handle(hanp, hlen, fdmp);
> -	free_handle(hanp, hlen);
> -	if (rc) {
> -		mlog(MLOG_NORMAL | MLOG_WARNING, _(
> -			"fssetdm_by_handle of %s failed %s\n"),
> -			path, strerror(errno));
> -	}
> -	return rc;
> -}
> -
>  static int
>  quotafilecheck(char *type, char *dstdir, char *quotafile)
>  {
> diff --git a/restore/tree.c b/restore/tree.c
> index 0670318..5429b74 100644
> --- a/restore/tree.c
> +++ b/restore/tree.c
> @@ -108,9 +108,6 @@ struct treePersStorage {
>  	bool_t p_ignoreorphpr;
>  		/* set if positive subtree or interactive
>  		 */
> -	bool_t p_restoredmpr;
> -		/* restore DMI event settings
> -		 */
>  	bool_t p_truncategenpr;
>  		/* truncate inode generation number (for compatibility
>  		 * with xfsdump format 2 and earlier)
> @@ -348,7 +345,6 @@ tree_init(char *hkdir,
>  	   size64_t nondircnt,
>  	   size64_t vmsz,
>  	   bool_t fullpr,
> -	   bool_t restoredmpr,
>  	   bool_t dstdirisxfspr,
>  	   uint32_t dumpformat,
>  	   bool_t truncategenpr)
> @@ -508,10 +504,6 @@ tree_init(char *hkdir,
>  	 */
>  	persp->p_fullpr = fullpr;
>  
> -	/* record if DMI event settings should be restored
> -	 */
> -	persp->p_restoredmpr = restoredmpr;
> -
>  	/* record if truncated generation numbers are required
>  	 */
>  	if (dumpformat < GLOBAL_HDR_VERSION_3) {
> @@ -2550,31 +2542,6 @@ setdirattr(dah_t dah, char *path)
>  		}
>  	}
>  
> -	if (tranp->t_dstdirisxfspr && persp->p_restoredmpr) {
> -		fsdmidata_t fssetdm;
> -
> -		fssetdm.fsd_dmevmask = dirattr_get_dmevmask(dah);
> -		fssetdm.fsd_padding = 0;	/* not used */
> -		fssetdm.fsd_dmstate = (uint16_t)dirattr_get_dmstate(dah);
> -
> -		/* restore DMAPI event settings etc.
> -		 */
> -		rval = ioctl(fd,
> -			      XFS_IOC_FSSETDM,
> -			      (void *)&fssetdm);
> -		if (rval) {
> -			mlog(errno == EINVAL
> -			      ?
> -			      (MLOG_NITTY + 1) | MLOG_TREE
> -			      :
> -			      MLOG_NITTY | MLOG_TREE,
> -			      "set DMI attributes"
> -			      " of %s failed: %s\n",
> -			      path,
> -			      strerror(errno));
> -		}
> -	}
> -
>  	utimbuf.actime = dirattr_get_atime(dah);
>  	utimbuf.modtime = dirattr_get_mtime(dah);
>  	rval = utime(path, &utimbuf);
> diff --git a/restore/tree.h b/restore/tree.h
> index 4f9ffe8..bf66e3d 100644
> --- a/restore/tree.h
> +++ b/restore/tree.h
> @@ -31,7 +31,6 @@ extern bool_t tree_init(char *hkdir,
>  			 size64_t nondircnt,
>  			 size64_t vmsz,
>  			 bool_t fullpr,
> -			 bool_t restoredmpr,
>  			 bool_t dstdirisxfspr,
>  			 uint32_t dumpformat,
>  			 bool_t truncategenpr);
> 

-- 
Carlos

