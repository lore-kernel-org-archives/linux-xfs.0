Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D524C433EF
	for <linux-xfs@archiver.kernel.org>; Mon, 18 Apr 2022 03:04:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231620AbiDRDHG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 17 Apr 2022 23:07:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230506AbiDRDHF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 17 Apr 2022 23:07:05 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0F3D018B07
        for <linux-xfs@vger.kernel.org>; Sun, 17 Apr 2022 20:04:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650251063;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kqhFZT5SobYTnPgdFY0kzfO4S6KCKic7s1jHUjYq5VQ=;
        b=SmNkwCKQncUqIQt48tj2oeef7p7xuFcclSuJ7GvYDXLPNfmoXBxIMBZhP8f5IGohbjCi87
        U5z8LDRAfYC+9fRm97bENQnR77XtBqF+mOY5lT36yRNOMrAeIG5Jp+Sqc+v76ENe6lLR1k
        WFyU1+2Mm+1UXffi8yJ+7Vkmjes3F8g=
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com
 [209.85.215.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-3-YuE0q2j5P0W0z3dNRFSLGA-1; Sun, 17 Apr 2022 23:04:22 -0400
X-MC-Unique: YuE0q2j5P0W0z3dNRFSLGA-1
Received: by mail-pg1-f198.google.com with SMTP id t3-20020a656083000000b0039cf337edd6so7974827pgu.18
        for <linux-xfs@vger.kernel.org>; Sun, 17 Apr 2022 20:04:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=kqhFZT5SobYTnPgdFY0kzfO4S6KCKic7s1jHUjYq5VQ=;
        b=8H0NQaI+YRp6JvUav26TyrG04doKqkiZCf8dQqi+hTrr2UmeaddXvBBoYZTukErJ6X
         HclBbOPDqu09QQIshSlfw+k6sCT3CdNyCxdZ5DJUfXkeO3nALN4REBro2E1dLN+Jt/uq
         D4QoZkdm8XprMcKxpT43nkWoawbGIVqUM5XUAomsPe1NKjKKfTs57QS72r7m70LZWK/G
         lQRj3InlUbeDTIGfbQTd82geVdhhzfwRaEvtm2t6Rhdz//Qu0EWltre8xhuMafNkXmKK
         Nze21XlWwt8iksFngxeRYGnEeQFXpRvSeQbfU8DwYs/ibkcmGbw5l5mFJwxSyL/IpLNQ
         XmuA==
X-Gm-Message-State: AOAM532M7GRnSxHri+0xuoPzPHjjL21sX02uLHYH2zBwha5SfK3+8gVn
        4bPywHeCfEf9SXZBqKHjYKtyog1R4fnja9HSOwRHNcDIt8BwtCmQvDC8VYUJymHD7gbLsl8O9XP
        tVEuFM4ISVVVkZUDdQa+i
X-Received: by 2002:a17:902:854c:b0:158:35ce:9739 with SMTP id d12-20020a170902854c00b0015835ce9739mr8880076plo.150.1650251061663;
        Sun, 17 Apr 2022 20:04:21 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwFmGkrLS7i0nLz7OIAzvk++53AKMXfM0Mx8XUkioDfWxX6+VSI8xm58OPKZutB5XT3pPdu4w==
X-Received: by 2002:a17:902:854c:b0:158:35ce:9739 with SMTP id d12-20020a170902854c00b0015835ce9739mr8880057plo.150.1650251061397;
        Sun, 17 Apr 2022 20:04:21 -0700 (PDT)
Received: from [10.72.12.77] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id m10-20020a17090a414a00b001cb776494a5sm15419779pjg.0.2022.04.17.20.04.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 17 Apr 2022 20:04:20 -0700 (PDT)
Subject: Re: [PATCH v3 7/7] ceph: Remove S_ISGID clear code in
 ceph_finish_async_create
To:     Yang Xu <xuyang2018.jy@fujitsu.com>, david@fromorbit.com,
        djwong@kernel.org, brauner@kernel.org
Cc:     linux-fsdevel@vger.kernel.org, ceph-devel@vger.kernel.org,
        linux-nfs@vger.kernel.org, linux-xfs@vger.kernel.org,
        viro@zeniv.linux.org.uk, jlayton@kernel.org
References: <1650020543-24908-1-git-send-email-xuyang2018.jy@fujitsu.com>
 <1650020543-24908-7-git-send-email-xuyang2018.jy@fujitsu.com>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <c26f5638-b97e-babf-3177-99fbcd4bbec2@redhat.com>
Date:   Mon, 18 Apr 2022 11:04:13 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <1650020543-24908-7-git-send-email-xuyang2018.jy@fujitsu.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org


On 4/15/22 7:02 PM, Yang Xu wrote:
> Since vfs has stripped S_ISGID, we don't need this code any more.
>
> Signed-off-by: Yang Xu <xuyang2018.jy@fujitsu.com>
> ---
>   fs/ceph/file.c | 4 ----
>   1 file changed, 4 deletions(-)
>
> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> index 6c9e837aa1d3..8e3b99853333 100644
> --- a/fs/ceph/file.c
> +++ b/fs/ceph/file.c
> @@ -651,10 +651,6 @@ static int ceph_finish_async_create(struct inode *dir, struct dentry *dentry,
>   		/* Directories always inherit the setgid bit. */
>   		if (S_ISDIR(mode))
>   			mode |= S_ISGID;
> -		else if ((mode & (S_ISGID | S_IXGRP)) == (S_ISGID | S_IXGRP) &&
> -			 !in_group_p(dir->i_gid) &&
> -			 !capable_wrt_inode_uidgid(&init_user_ns, dir, CAP_FSETID))
> -			mode &= ~S_ISGID;

Could you point me where has done this for ceph ?

-- Xiubo


>   	} else {
>   		in.gid = cpu_to_le32(from_kgid(&init_user_ns, current_fsgid()));
>   	}

