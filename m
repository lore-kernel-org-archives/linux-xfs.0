Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1A89C4332F
	for <linux-xfs@archiver.kernel.org>; Tue, 13 Dec 2022 17:44:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236149AbiLMRoh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 13 Dec 2022 12:44:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236311AbiLMRoZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 13 Dec 2022 12:44:25 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3A9D205F5
        for <linux-xfs@vger.kernel.org>; Tue, 13 Dec 2022 09:43:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670953426;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hq1k1DYaSlNwrW9zUpeSaQNVENAlTPEkQgzrv3qXyjs=;
        b=WPqmNmYTH/CIRvXwv/ZH5yLa1JqcAmJT0+zl+4L1YuPe8HKFiBvu07qNl9Nf27Wv4kfvT5
        hi45QIjNF1+IzZO1j3isx5ZP2WanvcQ3Fl0t+ZnrHeIIk6RleP98EQt5Rc4SPt52/n36eU
        hBm7oXtx8e9j2dw+iirC2YGCzQLzOU4=
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com
 [209.85.166.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-135-AQhUTZAwMZOL_D-qZqU0og-1; Tue, 13 Dec 2022 12:43:45 -0500
X-MC-Unique: AQhUTZAwMZOL_D-qZqU0og-1
Received: by mail-il1-f200.google.com with SMTP id s4-20020a056e02216400b00304cd64ce20so1220408ilv.6
        for <linux-xfs@vger.kernel.org>; Tue, 13 Dec 2022 09:43:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hq1k1DYaSlNwrW9zUpeSaQNVENAlTPEkQgzrv3qXyjs=;
        b=tB2W6q52sD71uKgsfOdh6EVF2ZkMMZcAp9efbFtAiPrfHfM808EyV3dC5zVJOEGRS/
         iN1YbCCgbqxl5MUsY3nbZlYwyE3CxlXBJunec4Qd9Igmm+eQ5IAVoWqQbBCZJTmgspJU
         IOmbUX7Zp9vRZEMbSMKKXiRDkNmhtu9C+VAdOTXfq+fvBWQgJBoX0lEUASK1edL2AqOn
         DXeoSH3MFSVHPxjUsyaonsuq40waneLfU4mshEFEUSSlOQ8woESS6MsUpP/PUes9Vz5c
         OuSoPTwVaVEWEwSo6MSBg93KJ+C0PHvbtZjCvwzMiMzxycAWDVVMmgiIRmZSjDVTCJI+
         8niA==
X-Gm-Message-State: ANoB5plVtXj4vYxlPhh7Pcsd423DQIM9AjHpuNKA4UlSMLHxiMNqUeGE
        5UIJKeU10O5xjDFjjCofUGR+d32Uyz0kJZZbBOYr2QMTWdQW/CICrVAaRV1T7LfNbiK2zsd6JSq
        gexE4HzKu0DpvfIm1RtA4
X-Received: by 2002:a6b:4e0e:0:b0:6ca:d145:9e with SMTP id c14-20020a6b4e0e000000b006cad145009emr11512665iob.14.1670953423869;
        Tue, 13 Dec 2022 09:43:43 -0800 (PST)
X-Google-Smtp-Source: AA0mqf7jwqunq+jXYvfeI1EBTbH77VZw3KgSksjImP+PYOQQp2A2JolwObRQQo3oDc6GvazHHd0Pww==
X-Received: by 2002:a6b:4e0e:0:b0:6ca:d145:9e with SMTP id c14-20020a6b4e0e000000b006cad145009emr11512654iob.14.1670953423571;
        Tue, 13 Dec 2022 09:43:43 -0800 (PST)
Received: from [10.0.0.146] (sandeen.net. [63.231.237.45])
        by smtp.gmail.com with ESMTPSA id l20-20020a0566022dd400b006dfbfec899esm583737iow.28.2022.12.13.09.43.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Dec 2022 09:43:43 -0800 (PST)
Message-ID: <733b882c-30fc-eea0-db01-55d25f272d92@redhat.com>
Date:   Tue, 13 Dec 2022 11:43:42 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.5.1
Subject: Re: [RFC PATCH 03/11] xfs: add attribute type for fs-verity
Content-Language: en-US
To:     Andrey Albershteyn <aalbersh@redhat.com>,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <20221213172935.680971-1-aalbersh@redhat.com>
 <20221213172935.680971-4-aalbersh@redhat.com>
From:   Eric Sandeen <sandeen@redhat.com>
In-Reply-To: <20221213172935.680971-4-aalbersh@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 12/13/22 11:29 AM, Andrey Albershteyn wrote:
> The Merkle tree pages and descriptor are stored in the extended
> attributes of the inode. Add new attribute type for fs-verity
> metadata. Skip fs-verity attributes for getfattr as it can not parse
> binary page names.
> 
> Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>


>  DECLARE_EVENT_CLASS(xfs_attr_list_class,
> diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
> index 5b57f6348d630..acbfa29d04af0 100644
> --- a/fs/xfs/xfs_xattr.c
> +++ b/fs/xfs/xfs_xattr.c
> @@ -237,6 +237,9 @@ xfs_xattr_put_listent(
>  	if (flags & XFS_ATTR_PARENT)
>  		return;
>  
> +	if (flags & XFS_ATTR_VERITY)
> +		return;
> +

Just a nitpick, but now that there are already 2 cases like this, I wonder
if it would be wise to #define something like an XFS_ATTR_VISIBLE_MASK
(or maybe XFS_ATTR_INTERNAL_MASK) and use that to decide, rather than
testing each one individually?

Thanks,
-Eric

