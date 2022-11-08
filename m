Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4F6EC433FE
	for <linux-xfs@archiver.kernel.org>; Tue,  8 Nov 2022 10:00:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233671AbiKHKAx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 8 Nov 2022 05:00:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233800AbiKHKAw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 8 Nov 2022 05:00:52 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 596911A046
        for <linux-xfs@vger.kernel.org>; Tue,  8 Nov 2022 01:59:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667901591;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9PIZm9rky0ko7N/9L7/u20SoaI9rhjWzbW7BkWSKy20=;
        b=gODUGUtMc2mixzzupp24OLl896nLR6Q66abC5++ZAshyIo7Xw7l+qkp6lK82KKw6dtKIMv
        IlIY7EP3mEG07WqCzw9IytV5B2tjDbPd9n8IxT8AK9gpdy8beWtMHc4lK8yy7pS1wzYDxs
        R4bcfpILNbsTuCnhs2i4KFjR2QJ/9Jk=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-364-q1y3epGfMwGkBtzfL5AERw-1; Tue, 08 Nov 2022 04:59:50 -0500
X-MC-Unique: q1y3epGfMwGkBtzfL5AERw-1
Received: by mail-ed1-f69.google.com with SMTP id v18-20020a056402349200b004622e273bbbso10139715edc.14
        for <linux-xfs@vger.kernel.org>; Tue, 08 Nov 2022 01:59:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9PIZm9rky0ko7N/9L7/u20SoaI9rhjWzbW7BkWSKy20=;
        b=NM0Ma2mrNSBgne94fkjzH+NjU5amt1ZkiTT/mZy7yg0EKdnH4Da51Tp/AZHKwlCpw0
         qtWy9dXmO/ZN2Dtg9yLTvBHBKu0Yy7aBB5WNNa+KWUXH+cJKGb6+sNFSsk7XFKg8aWXh
         TCyMP8TVV77wrbng+AXOq1Tn0FG89uyWRzpT6xnBYZBzS0KGy1bZwwFGvHBQMrWaa6lH
         /YIn9UJvDubcLzYTWz/7OAs9zpkoaY0zYgYLPsEMhpJxN76OIpobPHslFKJWh4aQtgyB
         fgH7Dc5UEmuF8TV/c5Y/ISRRy24iatHwpBAAVieUDWactZd4jZ3jv9ntTi5EBdJ/3Ipu
         EwaA==
X-Gm-Message-State: ACrzQf1y1dHtz5y4tA++mA7NohW20Bag3rZHTCvnb94hbFowXA4fSach
        yWFOn3e1aMPcHgNkuP81ojMwkt3qcZd8WuwvYqYleFI14UGf2uIyDOQiaRWRzQnT0xCeH8M7HPH
        rysQM232BwIwKLiHnEiA=
X-Received: by 2002:a17:907:1de6:b0:7a5:ea4b:ddbb with SMTP id og38-20020a1709071de600b007a5ea4bddbbmr52484263ejc.757.1667901588874;
        Tue, 08 Nov 2022 01:59:48 -0800 (PST)
X-Google-Smtp-Source: AMsMyM5mEshjNl0Kjo0Ft5elIE3a26V4bMqNWavOhBhg2Pg69mvQfhi0eeOmgyhuU/p0fBDv/lPOyQ==
X-Received: by 2002:a17:907:1de6:b0:7a5:ea4b:ddbb with SMTP id og38-20020a1709071de600b007a5ea4bddbbmr52484251ejc.757.1667901588696;
        Tue, 08 Nov 2022 01:59:48 -0800 (PST)
Received: from aalbersh.remote.csb ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id sg43-20020a170907a42b00b0078db5bddd9csm4535175ejc.22.2022.11.08.01.59.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Nov 2022 01:59:48 -0800 (PST)
Date:   Tue, 8 Nov 2022 10:59:46 +0100
From:   Andrey Albershteyn <aalbersh@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: fix incorrect error-out in xfs_remove
Message-ID: <20221108095946.dtzbx3xsj652e7c5@aalbersh.remote.csb>
References: <Y2mw3oZ2YVyReWeg@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y2mw3oZ2YVyReWeg@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Nov 07, 2022 at 05:29:02PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Clean up resources if resetting the dotdot entry doesn't succeed.
> Observed through code inspection.
> 
> Fixes: 5838d0356bb3 ("xfs: reset child dir '..' entry when unlinking child")
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/xfs_inode.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index aa303be11576..d354ea2b74f9 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -2479,7 +2479,7 @@ xfs_remove(
>  			error = xfs_dir_replace(tp, ip, &xfs_name_dotdot,
>  					tp->t_mountp->m_sb.sb_rootino, 0);
>  			if (error)
> -				return error;
> +				goto out_trans_cancel;
>  		}
>  	} else {
>  		/*
> 

Looks good to me.
Reviewed-by: Andrey Albershteyn <aalbersh@redhat.com>

-- 
- Andrey

