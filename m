Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82B23C433EF
	for <linux-xfs@archiver.kernel.org>; Fri, 15 Jul 2022 13:55:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232965AbiGONzy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 15 Jul 2022 09:55:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232739AbiGONzx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 15 Jul 2022 09:55:53 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DA7C24E606
        for <linux-xfs@vger.kernel.org>; Fri, 15 Jul 2022 06:55:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657893352;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FM+xA/5ASJQhFsuxcdBU2IzGa1tql1SDAYAYsb99YTI=;
        b=J3meoWWn0UY4Uc5cVM6X6/F8YNM9MVF7KSl6B4MjOBxXweMWB9LyvZN+VYHLvqvrCVtGqG
        0mdG6frFy7nlrpRb1nqTKEY23FH1JUtZWLmXJRTUSLgZtsgUhfDpBfWZOBtvGgkcavT1Q2
        zL57foxMGIQqsCEEqGlBEP/RonYg2XA=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-576-3jPZSohxO5SSVBSOvkqoJw-1; Fri, 15 Jul 2022 09:55:44 -0400
X-MC-Unique: 3jPZSohxO5SSVBSOvkqoJw-1
Received: by mail-il1-f197.google.com with SMTP id h28-20020a056e021d9c00b002dc15a95f9cso2792032ila.2
        for <linux-xfs@vger.kernel.org>; Fri, 15 Jul 2022 06:55:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=FM+xA/5ASJQhFsuxcdBU2IzGa1tql1SDAYAYsb99YTI=;
        b=cAXMsMOfDerpm41zRG1wNeL9oe9aonJYhOkM51yIBFJjHqN1nGBx2PoeElt5MYmvFD
         R9h5WAmiQ0/8NlP8qDKJcmEIwQZxsr3CGggkCNUHRzICJnxrDYSY/iF/0Z1JLwxfuxhw
         opxwOLGSz+tiz7FX5GQtJJVKNW9F37CsgWyIV4M3M/BPR5RcexkYxQywGngLZkpmwUZS
         Suv9CNJHyJIZ9XxOYorM+TO1qhDYcFiJ1uowuu+X4vJ29Yib3W13GmHDaL8DJL+ksNd6
         xuStEAy5IwYEFFP4pC9rIon4V9D0z7mc5zSnPS+z0FdTO+qKcB298jJwrZ7KFvcGy1CS
         KDXQ==
X-Gm-Message-State: AJIora/XhXWaEJWgMd+DLfsS2nTGL9+1UatqQTTCNxrYsLpqoT/PSz8S
        dRz8GG1LJ4BwenYVPdY/n4WKQspb8uLpQm6qoog0CszfqYZp1aeOJArzdPaVNUmXFThVV8pPM5Y
        jnGKCdPBoBWooUMkVQcNC
X-Received: by 2002:a05:6638:1651:b0:33f:8147:b1eb with SMTP id a17-20020a056638165100b0033f8147b1ebmr7459973jat.312.1657893343898;
        Fri, 15 Jul 2022 06:55:43 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1snhkCOZylRu9A2ERD6AgO92PIN/zxFqkm2O4+5fwEbfGv5ByFrepllNnVK9/wBOwGLQQU3Ow==
X-Received: by 2002:a05:6638:1651:b0:33f:8147:b1eb with SMTP id a17-20020a056638165100b0033f8147b1ebmr7459964jat.312.1657893343581;
        Fri, 15 Jul 2022 06:55:43 -0700 (PDT)
Received: from [10.0.0.146] (sandeen.net. [63.231.237.45])
        by smtp.gmail.com with ESMTPSA id e12-20020a02860c000000b0032e21876ea8sm1942756jai.72.2022.07.15.06.55.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Jul 2022 06:55:42 -0700 (PDT)
Message-ID: <18e803e6-3cb1-6151-35fe-8ad215b960a6@redhat.com>
Date:   Fri, 15 Jul 2022 08:55:41 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
Subject: Re: [PATCH v1 1/2] xfsdocs: fix inode timestamps lower limit value
Content-Language: en-US
To:     hexiaole <hexiaole1994@126.com>, linux-xfs@vger.kernel.org
Cc:     hexiaole@kylinos.cn
References: <1657882427-96-1-git-send-email-hexiaole1994@126.com>
From:   Eric Sandeen <sandeen@redhat.com>
In-Reply-To: <1657882427-96-1-git-send-email-hexiaole1994@126.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 7/15/22 5:53 AM, hexiaole wrote:
> From: hexiaole <hexiaole@kylinos.cn>

Again, when you send patches, please include your Signed-off-by: line.

(with your legal name rather than a nick/handle)

While this is not the kernel itself, we do follow the same requirements as in
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Documentation/process/submitting-patches.rst

specifically the part under "Developer's Certificate of Origin 1.1"

This translation may also be helpful:

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Documentation/translations/zh_CN/process/submitting-patches.rst

Thanks,
-Eric

> 1. Fix description
> In kernel source tree 'fs/xfs/libxfs/xfs_format.h', there defined inode timestamps as 'xfs_legacy_timestamp' if the 'bigtime' feature disabled, and also defined the min and max time constants 'XFS_LEGACY_TIME_MIN' and 'XFS_LEGACY_TIME_MAX':
> 
> /* fs/xfs/libxfs/xfs_format.h begin */
> struct xfs_legacy_timestamp {
>         __be32          t_sec;          /* timestamp seconds */
>         __be32          t_nsec;         /* timestamp nanoseconds */
> };
> /* fs/xfs/libxfs/xfs_format.h end */
> /* include/linux/limits.h begin */
> /* include/linux/limits.h end */
> 
> When the 't_sec' and 't_nsec' are 0, the time value it represents is 1970-01-01 00:00:00 UTC, the 'XFS_LEGACY_TIME_MIN', that is -(2^31), represents the min
> second offset relative to the 1970-01-01 00:00:00 UTC, it can be converted to human-friendly time value by 'date' command:
> 
> /* command begin */
> [root@DESKTOP-G0RBR07 sources]# date --utc -d "@`echo '-(2^31)'|bc`" +'%Y-%m-%d %H:%M:%S'
> 1901-12-13 20:45:52
> [root@DESKTOP-G0RBR07 sources]#
> /* command end */
> 
> That is, the min time value is 1901-12-13 20:45:52 UTC, but the 'design/XFS_Filesystem_Structure/timestamps.asciidoc' write the min time value as 'The smalle
> st date this format can represent is 20:45:52 UTC on December 31st', there should be a typo, and this patch correct 2 places of wrong min time value, from '3
> 1st' to '13st'.
> 
> 2. Question
> In the section 'Quota Timers' of 'design/XFS_Filesystem_Structure/timestamps.asciidoc':
> 
> /* timestamps.asciidoc begin */
> With the introduction of the bigtime feature, the ondisk field now encodes the upper 32 bits of an unsigned 34-bit seconds counter.
> ...
> The smallest quota expiration date is now 00:00:04 UTC on January 1st, 1970;
> and the largest is 20:20:24 UTC on July 2nd, 2486.
> /* timestamps.asciidoc end */
> 
> It seems hard to understand the the relationship among the '32 bits of an unsigned 34-bit seconds counter', '00:00:04 UTC on January 1st, 1970', and 00:00:04 UTC on January 1st, 1970', is it there a typo for '34-bit' and the expected one is '64-bit'?
> ---
>  design/XFS_Filesystem_Structure/timestamps.asciidoc | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/design/XFS_Filesystem_Structure/timestamps.asciidoc b/design/XFS_Filesystem_Structure/timestamps.asciidoc
> index 08baa1e..56d4dc9 100644
> --- a/design/XFS_Filesystem_Structure/timestamps.asciidoc
> +++ b/design/XFS_Filesystem_Structure/timestamps.asciidoc
> @@ -26,13 +26,13 @@ struct xfs_legacy_timestamp {
>  };
>  ----
>  
> -The smallest date this format can represent is 20:45:52 UTC on December 31st,
> +The smallest date this format can represent is 20:45:52 UTC on December 13st,
>  1901, and the largest date supported is 03:14:07 UTC on January 19, 2038.
>  
>  With the introduction of the bigtime feature, the format is changed to
>  interpret the timestamp as a 64-bit count of nanoseconds since the smallest
>  date supported by the old encoding.  This means that the smallest date
> -supported is still 20:45:52 UTC on December 31st, 1901; but now the largest
> +supported is still 20:45:52 UTC on December 13st, 1901; but now the largest
>  date supported is 20:20:24 UTC on July 2nd, 2486.
>  
>  [[Quota_Timers]]

