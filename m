Return-Path: <SRS0=TUUv=4H=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B98BC34047
	for <linux-xfs@archiver.kernel.org>; Wed, 19 Feb 2020 10:33:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3CB63208E4
	for <linux-xfs@archiver.kernel.org>; Wed, 19 Feb 2020 10:33:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QXZ0aQxh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726491AbgBSKc7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Feb 2020 05:32:59 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:27964 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726453AbgBSKc7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Feb 2020 05:32:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582108377;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=FueltgpkzAlhJDAhIe85WleMfHR8Az0odD0aapskUck=;
        b=QXZ0aQxhN0S3D4sBJIoYMz9DBQALB494DK+aTzP/VNEVuGH/zsXjgLR7DbGGgHjGcrFZnk
        7TxyU85oStBwfh8QUTztvINUpNFZXS4fBXl/kFslNDtgyoK8pcXAhFrQyaOyi8yGIsgZzg
        admgl7+REK81FgKIBMWiXMOkQTbD3k4=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-266-E3pdZds7NGKjEcf2z-R2jg-1; Wed, 19 Feb 2020 05:32:56 -0500
X-MC-Unique: E3pdZds7NGKjEcf2z-R2jg-1
Received: by mail-wr1-f72.google.com with SMTP id o6so12319406wrp.8
        for <linux-xfs@vger.kernel.org>; Wed, 19 Feb 2020 02:32:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=FueltgpkzAlhJDAhIe85WleMfHR8Az0odD0aapskUck=;
        b=l5ui+OMMDc/P5d6g67xaimFL8iVJg3nPpq30icMwLYofTvC2HfP3rLsfQh+cH3vcZ+
         awfyUsj0cazum+EtnyPFFde+YSodfJ7hJyDiBbymX1RuWW9892ZieJjZpFuiNKskiNgU
         OzJsmsBUDJpaaQQUA48RYzo+BHtYLI842vasB8I3XQDBNIdlXdipt9C6b27TuMkyGVrV
         jR+WDtxaB/+FX6SI/z1AqZztPRreVD4AgV7L2Z05RKi/4ng+BihWGI9Wk8zPIfGqUftB
         xsdkRRIg9cSXwgzteH5dEL+jrLkXOsmWzf8QTdT8LGNQ42DrFEP/1e7Qfg6jY/RXki4N
         3GTw==
X-Gm-Message-State: APjAAAWE4ReSmJAA94sH7bInHmJj11iniFyo9RNE7Wspa/bLGkH3ZUcx
        g4ov4NSu4coulQLus4IAK8ZnD84oSC57eiHcJ65Ip4uzlcsERsUXIWapsZ1ESBwrrotAF+n46Yj
        ympd8R9TNsRXKCkbxWt+U
X-Received: by 2002:a5d:6404:: with SMTP id z4mr8320151wru.262.1582108375038;
        Wed, 19 Feb 2020 02:32:55 -0800 (PST)
X-Google-Smtp-Source: APXvYqyEBmwVbQxdAuZuruB1+01qm7Mr8gSt9LDSMaBs8O3010RfxmbOPdx8dK+S+jon3Kw6tzm0PQ==
X-Received: by 2002:a5d:6404:: with SMTP id z4mr8320131wru.262.1582108374780;
        Wed, 19 Feb 2020 02:32:54 -0800 (PST)
Received: from andromeda (ip-89-103-126-188.net.upcbroadband.cz. [89.103.126.188])
        by smtp.gmail.com with ESMTPSA id z6sm2370996wrw.36.2020.02.19.02.32.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Feb 2020 02:32:54 -0800 (PST)
Date:   Wed, 19 Feb 2020 11:32:52 +0100
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 1/3] xfs: ensure that the inode uid/gid match values
 match the icdinode ones
Message-ID: <20200219103252.354iqhl2td7ekzdg@andromeda>
Mail-Followup-To: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
References: <20200218210020.40846-1-hch@lst.de>
 <20200218210020.40846-2-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200218210020.40846-2-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Feb 18, 2020 at 01:00:18PM -0800, Christoph Hellwig wrote:
> Instead of only synchronizing the uid/gid values in xfs_setup_inode,
> ensure that they always match to prepare for removing the icdinode
> fields.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>


Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>


> ---
>  fs/xfs/libxfs/xfs_inode_buf.c | 2 ++
>  fs/xfs/xfs_icache.c           | 4 ++++
>  fs/xfs/xfs_inode.c            | 8 ++++++--
>  fs/xfs/xfs_iops.c             | 3 ---
>  4 files changed, 12 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
> index 8afacfe4be0a..cc4efd34843a 100644
> --- a/fs/xfs/libxfs/xfs_inode_buf.c
> +++ b/fs/xfs/libxfs/xfs_inode_buf.c
> @@ -223,7 +223,9 @@ xfs_inode_from_disk(
>  
>  	to->di_format = from->di_format;
>  	to->di_uid = be32_to_cpu(from->di_uid);
> +	inode->i_uid = xfs_uid_to_kuid(to->di_uid);
>  	to->di_gid = be32_to_cpu(from->di_gid);
> +	inode->i_gid = xfs_gid_to_kgid(to->di_gid);
>  	to->di_flushiter = be16_to_cpu(from->di_flushiter);
>  
>  	/*
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index 8dc2e5414276..a7be7a9e5c1a 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -289,6 +289,8 @@ xfs_reinit_inode(
>  	uint64_t	version = inode_peek_iversion(inode);
>  	umode_t		mode = inode->i_mode;
>  	dev_t		dev = inode->i_rdev;
> +	kuid_t		uid = inode->i_uid;
> +	kgid_t		gid = inode->i_gid;
>  
>  	error = inode_init_always(mp->m_super, inode);
>  
> @@ -297,6 +299,8 @@ xfs_reinit_inode(
>  	inode_set_iversion_queried(inode, version);
>  	inode->i_mode = mode;
>  	inode->i_rdev = dev;
> +	inode->i_uid = uid;
> +	inode->i_gid = gid;
>  	return error;
>  }
>  
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index c5077e6326c7..938b0943bd95 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -812,15 +812,19 @@ xfs_ialloc(
>  
>  	inode->i_mode = mode;
>  	set_nlink(inode, nlink);
> -	ip->i_d.di_uid = xfs_kuid_to_uid(current_fsuid());
> -	ip->i_d.di_gid = xfs_kgid_to_gid(current_fsgid());
> +	inode->i_uid = current_fsuid();
> +	ip->i_d.di_uid = xfs_kuid_to_uid(inode->i_uid);
>  	inode->i_rdev = rdev;
>  	ip->i_d.di_projid = prid;
>  
>  	if (pip && XFS_INHERIT_GID(pip)) {
> +		inode->i_gid = VFS_I(pip)->i_gid;
>  		ip->i_d.di_gid = pip->i_d.di_gid;
>  		if ((VFS_I(pip)->i_mode & S_ISGID) && S_ISDIR(mode))
>  			inode->i_mode |= S_ISGID;
> +	} else {
> +		inode->i_gid = current_fsgid();
> +		ip->i_d.di_gid = xfs_kgid_to_gid(inode->i_gid);
>  	}
>  
>  	/*
> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index 81f2f93caec0..b818b261918f 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -1304,9 +1304,6 @@ xfs_setup_inode(
>  	/* make the inode look hashed for the writeback code */
>  	inode_fake_hash(inode);
>  
> -	inode->i_uid    = xfs_uid_to_kuid(ip->i_d.di_uid);
> -	inode->i_gid    = xfs_gid_to_kgid(ip->i_d.di_gid);
> -
>  	i_size_write(inode, ip->i_d.di_size);
>  	xfs_diflags_to_iflags(inode, ip);
>  
> -- 
> 2.24.1
> 

-- 
Carlos

