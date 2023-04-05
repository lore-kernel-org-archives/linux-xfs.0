Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E988C7619A
	for <linux-xfs@archiver.kernel.org>; Wed,  5 Apr 2023 15:03:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238654AbjDEPC7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 5 Apr 2023 11:02:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238651AbjDEPC4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 5 Apr 2023 11:02:56 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0C5E6A5F
        for <linux-xfs@vger.kernel.org>; Wed,  5 Apr 2023 08:01:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680706915;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ijdR/MHnRs9yin6C5jhmGmV2EeFx7fyGP+HaH521iTo=;
        b=WUTYMNAHwT9P6DLyzlLvQwky1xOg890lbUA/Z4uFCTdqjsYP4w6zRJeDUFZbqKMflg9hvo
        0b8Rkh+JQSY1HMj/vYgtFSTPhf7FAP7BTGcIlny9e4oeZTc3MRwG9sTYYDZJ2CIU3RM7yD
        VRGpMfOWgGQ0uUkkVaOTQFx2nvxusPQ=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-292-bMfvCR5sMwm2hxiVaComuw-1; Wed, 05 Apr 2023 11:01:53 -0400
X-MC-Unique: bMfvCR5sMwm2hxiVaComuw-1
Received: by mail-qv1-f71.google.com with SMTP id px9-20020a056214050900b005d510cdfc41so16459721qvb.7
        for <linux-xfs@vger.kernel.org>; Wed, 05 Apr 2023 08:01:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680706911;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ijdR/MHnRs9yin6C5jhmGmV2EeFx7fyGP+HaH521iTo=;
        b=C4Jjl9iq/wwBwLFS4LFqUndaDWTmbKgtgQLGWPGMXKNDQ/xd2CtArd/BudXA3sn8w6
         63z+/2mwVekuK35yk6AfzpHpX5v2i4yzemYsHO6AscIlM5XPX66H/pURD40iiT0gDaU3
         gnYWxWiyOWabhnNlU8ji8QylRym6LjBW8lY9lkNPdCh11VxqVMgvhXrCYb13QwNim2aj
         99AFOR6CvDdhpmnkkR/gJfBABzuw8MNgqaNuQsNy7VZWihflWhQa+43IeV0D5kqfSSHu
         TIZDx0mmDNDFQk+DHU3Da1rOPdm2THMJoWcP5L1SXVN7WNT2BWP4XmUoCuR56zFe3ydJ
         wQVw==
X-Gm-Message-State: AAQBX9fo1wwy1+adFcl7O1cz/Sb3CRTlwTD7ruBHUOwD4qLDHOuRuY8n
        klpdaEl3MD5+bXEriVKruQNhez6sNEnyOFXAwjfi0HLOX/DWOmZC1Wg2ce/Fz1W2yau5Al0m2Xv
        /GjtlZ+tsJKgUoeEjZCg=
X-Received: by 2002:a05:6214:2504:b0:5a3:cbc6:8145 with SMTP id gf4-20020a056214250400b005a3cbc68145mr11557267qvb.19.1680706910929;
        Wed, 05 Apr 2023 08:01:50 -0700 (PDT)
X-Google-Smtp-Source: AKy350YVeAhEKCJSk+gIHwjGx6PP08vlMKC4voUohfc6ezEBe0HN6HJNbkVZpy9LxJ1aS1g8D9uc0g==
X-Received: by 2002:a05:6214:2504:b0:5a3:cbc6:8145 with SMTP id gf4-20020a056214250400b005a3cbc68145mr11557235qvb.19.1680706910656;
        Wed, 05 Apr 2023 08:01:50 -0700 (PDT)
Received: from aalbersh.remote.csb ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id o8-20020a0cc388000000b005dd8b93457dsm4236165qvi.21.2023.04.05.08.01.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Apr 2023 08:01:49 -0700 (PDT)
Date:   Wed, 5 Apr 2023 17:01:42 +0200
From:   Andrey Albershteyn <aalbersh@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     dchinner@redhat.com, ebiggers@kernel.org, hch@infradead.org,
        linux-xfs@vger.kernel.org, fsverity@lists.linux.dev,
        rpeterso@redhat.com, agruenba@redhat.com, xiang@kernel.org,
        chao@kernel.org, damien.lemoal@opensource.wdc.com, jth@kernel.org,
        linux-erofs@lists.ozlabs.org, linux-btrfs@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        cluster-devel@redhat.com
Subject: Re: [PATCH v2 19/23] xfs: disable direct read path for fs-verity
 sealed files
Message-ID: <20230405150142.3jmxzo5i27bbc4c4@aalbersh.remote.csb>
References: <20230404145319.2057051-1-aalbersh@redhat.com>
 <20230404145319.2057051-20-aalbersh@redhat.com>
 <20230404161047.GA109974@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230404161047.GA109974@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Apr 04, 2023 at 09:10:47AM -0700, Darrick J. Wong wrote:
> On Tue, Apr 04, 2023 at 04:53:15PM +0200, Andrey Albershteyn wrote:
> > The direct path is not supported on verity files. Attempts to use direct
> > I/O path on such files should fall back to buffered I/O path.
> > 
> > Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
> > ---
> >  fs/xfs/xfs_file.c | 14 +++++++++++---
> >  1 file changed, 11 insertions(+), 3 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> > index 947b5c436172..9e072e82f6c1 100644
> > --- a/fs/xfs/xfs_file.c
> > +++ b/fs/xfs/xfs_file.c
> > @@ -244,7 +244,8 @@ xfs_file_dax_read(
> >  	struct kiocb		*iocb,
> >  	struct iov_iter		*to)
> >  {
> > -	struct xfs_inode	*ip = XFS_I(iocb->ki_filp->f_mapping->host);
> > +	struct inode		*inode = iocb->ki_filp->f_mapping->host;
> > +	struct xfs_inode	*ip = XFS_I(inode);
> >  	ssize_t			ret = 0;
> >  
> >  	trace_xfs_file_dax_read(iocb, to);
> > @@ -297,10 +298,17 @@ xfs_file_read_iter(
> >  
> >  	if (IS_DAX(inode))
> >  		ret = xfs_file_dax_read(iocb, to);
> > -	else if (iocb->ki_flags & IOCB_DIRECT)
> > +	else if (iocb->ki_flags & IOCB_DIRECT && !fsverity_active(inode))
> >  		ret = xfs_file_dio_read(iocb, to);
> > -	else
> > +	else {
> > +		/*
> > +		 * In case fs-verity is enabled, we also fallback to the
> > +		 * buffered read from the direct read path. Therefore,
> > +		 * IOCB_DIRECT is set and need to be cleared
> > +		 */
> > +		iocb->ki_flags &= ~IOCB_DIRECT;
> >  		ret = xfs_file_buffered_read(iocb, to);
> 
> XFS doesn't usually allow directio fallback to the pagecache. Why
> would fsverity be any different?

Didn't know that, this is what happens on ext4 so I did the same.
Then it probably make sense to just error on DIRECT on verity
sealed file.

> 
> --D
> 
> > +	}
> >  
> >  	if (ret > 0)
> >  		XFS_STATS_ADD(mp, xs_read_bytes, ret);
> > -- 
> > 2.38.4
> > 
> 

-- 
- Andrey

