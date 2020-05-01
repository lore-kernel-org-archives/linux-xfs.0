Return-Path: <SRS0=3WhG=6P=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3784C4724C
	for <linux-xfs@archiver.kernel.org>; Fri,  1 May 2020 14:21:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C010420757
	for <linux-xfs@archiver.kernel.org>; Fri,  1 May 2020 14:21:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GzuPFUmI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729557AbgEAOVb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 1 May 2020 10:21:31 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:40941 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728737AbgEAOVa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 May 2020 10:21:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588342888;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8kN58cUkXVoi8gPRVKyjsbPTK2wvKs+mxScTz2C6/vo=;
        b=GzuPFUmIsWg01+IVcVn+gTunQWGm2TsSF9GxUQBO2FZDx49nUVbEWynMBCR8D9SgaUWINr
        QL3C+vgQ+6DgYlfZNGjvFsgNYXtSGnTyXV46+oc5OFl8hXKVVQ1O5kyb1OxflllSANqxiX
        ZZ8bvso7M76OYZ9U3nrAhme49tIlRJo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-325-L_ftHKNYMpmULExYukNG7g-1; Fri, 01 May 2020 10:21:26 -0400
X-MC-Unique: L_ftHKNYMpmULExYukNG7g-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id ADD18107ACCA;
        Fri,  1 May 2020 14:21:25 +0000 (UTC)
Received: from [IPv6:::1] (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 6ABE060CCC;
        Fri,  1 May 2020 14:21:25 +0000 (UTC)
Subject: Re: [PATCH] xfsprogs: remove xfs_dir_ops
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
References: <20200501082347.2605743-1-hch@lst.de>
From:   Eric Sandeen <sandeen@redhat.com>
Message-ID: <9a973ceb-d5e5-4673-de5d-f6f36986c0e8@redhat.com>
Date:   Fri, 1 May 2020 09:21:24 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200501082347.2605743-1-hch@lst.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 5/1/20 3:23 AM, Christoph Hellwig wrote:
> The xfs_dir_ops infrastructure has been removed a while ago.  Remove
> a few always empty members in xfsprogs to finish the cleanup.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Whoops, the perils of not having everything quite in sync.

Maybe I should try to script checks for our xfsprogs-private structures
that mirror but don't duplicate kernel structures...

Other than the stray editline hunks in the patch, looks good.

I can drop those.

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  include/xfs_inode.h | 2 --
>  include/xfs_mount.h | 3 ---
>  libxcmd/input.c     | 2 ++
>  libxfs/rdwr.c       | 8 --------
>  libxfs/util.c       | 8 --------
>  repair/phase6.c     | 1 -
>  6 files changed, 2 insertions(+), 22 deletions(-)
> 
> diff --git a/include/xfs_inode.h b/include/xfs_inode.h
> index e95a4959..676960d1 100644
> --- a/include/xfs_inode.h
> +++ b/include/xfs_inode.h
> @@ -14,7 +14,6 @@
>  struct xfs_trans;
>  struct xfs_mount;
>  struct xfs_inode_log_item;
> -struct xfs_dir_ops;
>  
>  /*
>   * These are not actually used, they are only for userspace build
> @@ -60,7 +59,6 @@ typedef struct xfs_inode {
>  	unsigned int		i_cformat;	/* format of cow fork */
>  
>  	xfs_fsize_t		i_size;		/* in-memory size */
> -	const struct xfs_dir_ops *d_ops;	/* directory ops vector */
>  	struct xfs_ifork_ops	*i_fork_ops;	/* fork verifiers */
>  	struct inode		i_vnode;
>  } xfs_inode_t;
> diff --git a/include/xfs_mount.h b/include/xfs_mount.h
> index 7bd23fbb..20c8bfaf 100644
> --- a/include/xfs_mount.h
> +++ b/include/xfs_mount.h
> @@ -9,7 +9,6 @@
>  
>  struct xfs_inode;
>  struct xfs_buftarg;
> -struct xfs_dir_ops;
>  struct xfs_da_geometry;
>  
>  /*
> @@ -87,8 +86,6 @@ typedef struct xfs_mount {
>  
>  	struct xfs_da_geometry	*m_dir_geo;	/* directory block geometry */
>  	struct xfs_da_geometry	*m_attr_geo;	/* attribute block geometry */
> -	const struct xfs_dir_ops *m_dir_inode_ops; /* vector of dir inode ops */
> -	const struct xfs_dir_ops *m_nondir_inode_ops; /* !dir inode ops */
>  
>  	/*
>  	 * anonymous struct to allow xfs_dquot_buf.c to compile.
> diff --git a/libxcmd/input.c b/libxcmd/input.c
> index 203110df..84760784 100644
> --- a/libxcmd/input.c
> +++ b/libxcmd/input.c
> @@ -26,6 +26,7 @@ get_prompt(void)
>  }
>  
>  #ifdef ENABLE_EDITLINE
> +#warning "Using editline"
>  static char *el_get_prompt(EditLine *e) { return get_prompt(); }
>  char *
>  fetchline(void)
> @@ -55,6 +56,7 @@ fetchline(void)
>  	return line;
>  }
>  #else
> +#warning "Not using editline"
>  # define MAXREADLINESZ	1024
>  char *
>  fetchline(void)

these look stray ;)

> diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
> index fd656512..8c48e256 100644
> --- a/libxfs/rdwr.c
> +++ b/libxfs/rdwr.c
> @@ -1287,14 +1287,6 @@ libxfs_iget(
>  		return -EFSCORRUPTED;
>  	}
>  
> -	/*
> -	 * set up the inode ops structure that the libxfs code relies on
> -	 */
> -	if (XFS_ISDIR(ip))
> -		ip->d_ops = mp->m_dir_inode_ops;
> -	else
> -		ip->d_ops = mp->m_nondir_inode_ops;
> -
>  	*ipp = ip;
>  	return 0;
>  }
> diff --git a/libxfs/util.c b/libxfs/util.c
> index 2e2ade24..de0bfece 100644
> --- a/libxfs/util.c
> +++ b/libxfs/util.c
> @@ -351,14 +351,6 @@ libxfs_ialloc(
>  	ip->i_d.di_aformat = XFS_DINODE_FMT_EXTENTS;
>  	ip->i_d.di_anextents = 0;
>  
> -	/*
> -	 * set up the inode ops structure that the libxfs code relies on
> -	 */
> -	if (XFS_ISDIR(ip))
> -		ip->d_ops = ip->i_mount->m_dir_inode_ops;
> -	else
> -		ip->d_ops = ip->i_mount->m_nondir_inode_ops;
> -
>  	/*
>  	 * Log the new values stuffed into the inode.
>  	 */
> diff --git a/repair/phase6.c b/repair/phase6.c
> index beceea9a..de8c744b 100644
> --- a/repair/phase6.c
> +++ b/repair/phase6.c
> @@ -917,7 +917,6 @@ mk_root_dir(xfs_mount_t *mp)
>  	/*
>  	 * initialize the directory
>  	 */
> -	ip->d_ops = mp->m_dir_inode_ops;
>  	libxfs_dir_init(tp, ip, ip);
>  
>  	error = -libxfs_trans_commit(tp);
> 

