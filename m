Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AA75C77B75
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Apr 2023 06:17:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229720AbjDUGRy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 21 Apr 2023 02:17:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229716AbjDUGRV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Apr 2023 02:17:21 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CEA983D6
        for <linux-xfs@vger.kernel.org>; Thu, 20 Apr 2023 23:17:06 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id d9443c01a7336-1a68f2345c5so16567935ad.2
        for <linux-xfs@vger.kernel.org>; Thu, 20 Apr 2023 23:17:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1682057825; x=1684649825;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=plSoFJ/9xt5akvMzS0vlcy0Bck9Fhhm6Ac7SreRfm1g=;
        b=WJ0aau/PDmvM8hCtow/0gMKY7ISkgchzkZRsUROXsuK/zUkk3kV+EVlxDpCyx/osRf
         +ifntgnzCvCmCBP2V2pOVSYxSsqbpwqFeV2oNofvdeJueMnVDxCJVNAWegXVSHM58qsn
         Z4Fg0+ZjVF0xLjMQNCGrfksvoGlkK7iWaWUlrYG36Z0QbfEzxjywZAQm7u46eVT+/SAo
         ijF+d949rb3VifHn1kSrBo3lWB+Ob+tg71csgT64bfrsKltmcH3dfOmVVefwVi3zcRvw
         d7MbfaWXYo5a6ovOdPD2gM2hD7MBenVqarW0m87NmZiVuDyJoPdAmfcyw4V8wcag4nbV
         ts5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682057825; x=1684649825;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=plSoFJ/9xt5akvMzS0vlcy0Bck9Fhhm6Ac7SreRfm1g=;
        b=W3SqySuhoCgOWoO2bD6Aoqz5dK0b+hunZ+EzzoUqYTswrfjJY3AZSxl83UiiRS+Qf0
         5URJ4Q2PUWWo+FT36+dIkqtRqAYCykWMtUj5ERKJDSZJLhnz5B+cH3K7upF3+LSicnII
         fVb199UYO7Rm4mso+hv3jYYopppZ+L8Fyb7McaBdzwOJ7mt2lh0Jq/HK/C2yBnIzQcSC
         LwdsvBJ/WVbYGg0KMM4Kh0ckBekPi7lVNrxDit2Abt6W7wpfQaXQEILQV2/Qlf6IeuBL
         L2zBMC/ovr+r9Icp97/jyQMBBoBN1JO6gk/Hn2FsAibjZPnrGmZuqG9fCqxfYOpSu+C+
         eaKg==
X-Gm-Message-State: AAQBX9csNNCYBkAQckHfDL4uP5nr0y5HdYMgqCN4SR1GB1AO7JsISLmZ
        CXLdtDaH+lvzSgNBNTLhatnxPg==
X-Google-Smtp-Source: AKy350bdv6A4Ta2QHNYoryT+uaa4tMqJyqGHtWs/fDVl9L7M/yvJ8yJRqjGZYBfq94Wpi1LZA3m9Lg==
X-Received: by 2002:a17:902:d591:b0:1a6:b2e3:5dc4 with SMTP id k17-20020a170902d59100b001a6b2e35dc4mr3606479plh.14.1682057825557;
        Thu, 20 Apr 2023 23:17:05 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-41-174.pa.nsw.optusnet.com.au. [49.180.41.174])
        by smtp.gmail.com with ESMTPSA id jf12-20020a170903268c00b0019aa6bf4450sm2032502plb.188.2023.04.20.23.17.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Apr 2023 23:17:04 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1ppk4r-005x4R-PK; Fri, 21 Apr 2023 16:17:01 +1000
Date:   Fri, 21 Apr 2023 16:17:01 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Guo Xuenan <guoxuenan@huawei.com>
Cc:     djwong@kernel.org, dchinner@redhat.com, linux-xfs@vger.kernel.org,
        sandeen@redhat.com, guoxuenan@huaweicloud.com, houtao1@huawei.com,
        fangwei1@huawei.com, jack.qiu@huawei.com, yi.zhang@huawei.com
Subject: Re: [PATCH 2/3] xfs: fix xfs print level wrong parsing
Message-ID: <20230421061701.GB3223426@dread.disaster.area>
References: <20230421033142.1656296-1-guoxuenan@huawei.com>
 <20230421033142.1656296-3-guoxuenan@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230421033142.1656296-3-guoxuenan@huawei.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Apr 21, 2023 at 11:31:41AM +0800, Guo Xuenan wrote:
> Recently, during my xfs bugfix work, notice a bug that makes
> xfs_stack_trace never take effect. This has been around here at xfs
> debug framework for a long time.
> 
> The root cause is misuse of `kstrtoint` which always return -EINVAL
> because KERN_<LEVEL> with KERN_SOH prefix unable to parse correctly by
> it. By skipping the prefix KERN_SOH we can get correct printk level.
> 
> Fixes: 847f9f6875fb ("xfs: more info from kmem deadlocks and high-level error msgs")
> Signed-off-by: Guo Xuenan <guoxuenan@huawei.com>
> ---
>  fs/xfs/xfs_message.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_message.c b/fs/xfs/xfs_message.c
> index 8f495cc23903..bda4c0a0ca42 100644
> --- a/fs/xfs/xfs_message.c
> +++ b/fs/xfs/xfs_message.c
> @@ -45,7 +45,7 @@ xfs_printk_level(
>  
>  	va_end(args);
>  
> -	if (!kstrtoint(kern_level, 0, &level) &&
> +	if (!kstrtoint(kern_level + strlen(KERN_SOH), 0, &level) &&
>  	    level <= LOGLEVEL_ERR &&
>  	    xfs_error_level >= XFS_ERRLEVEL_HIGH)
>  		xfs_stack_trace();

Ugh. KERN_* is a string with a special character as a header, not
just an stringified number. Ok, I see how this fixes the bug, but
let's have a look at where kern_level comes from. i.e.
xfs_message.h:

extern __printf(3, 4)
void xfs_printk_level(const char *kern_level, const struct xfs_mount *mp,
                        const char *fmt, ...);

define xfs_printk_index_wrap(kern_level, mp, fmt, ...)         \
({                                                              \
        printk_index_subsys_emit("%sXFS%s: ", kern_level, fmt); \
        xfs_printk_level(kern_level, mp, fmt, ##__VA_ARGS__);   \
})
#define xfs_emerg(mp, fmt, ...) \
        xfs_printk_index_wrap(KERN_EMERG, mp, fmt, ##__VA_ARGS__)
#define xfs_alert(mp, fmt, ...) \
        xfs_printk_index_wrap(KERN_ALERT, mp, fmt, ##__VA_ARGS__)
#define xfs_crit(mp, fmt, ...) \
        xfs_printk_index_wrap(KERN_CRIT, mp, fmt, ##__VA_ARGS__)
#define xfs_err(mp, fmt, ...) \
        xfs_printk_index_wrap(KERN_ERR, mp, fmt, ##__VA_ARGS__)
.....

IOWs, we define the level value directly in these macros, they
aren't spread throughout the code. Hence we should be able to use
some preprocessor string concatenation magic here to get rid of the
kstrtoint() call altogether.

 extern __printf(3, 4)
-void xfs_printk_level(const char *kern_level, const struct xfs_mount *mp,
-                        const char *fmt, ...);
+void xfs_printk_level(const char *kern_level, const int log_level,
+			const struct xfs_mount *mp, const char *fmt, ...);

 define xfs_printk_index_wrap(level, mp, fmt, ...)         \
 ({                                                              \
-        printk_index_subsys_emit("%sXFS%s: ", kern_level, fmt); \
-        xfs_printk_level(kern_level, mp, fmt, ##__VA_ARGS__);   \
+        printk_index_subsys_emit("%sXFS%s: ", KERN_##level, fmt); \
+        xfs_printk_level(KERN_##level, LOGLEVEL_##level mp, fmt, ##__VA_ARGS__);   \
 })
 #define xfs_emerg(mp, fmt, ...) \
-        xfs_printk_index_wrap(KERN_EMERG, mp, fmt, ##__VA_ARGS__)
+        xfs_printk_index_wrap(EMERG, mp, fmt, ##__VA_ARGS__)
 #define xfs_alert(mp, fmt, ...) \
-        xfs_printk_index_wrap(KERN_ALERT, mp, fmt, ##__VA_ARGS__)
-        xfs_printk_index_wrap(ALERT, mp, fmt, ##__VA_ARGS__)
 #define xfs_crit(mp, fmt, ...) \
-        xfs_printk_index_wrap(KERN_CRIT, mp, fmt, ##__VA_ARGS__)
-        xfs_printk_index_wrap(CRIT, mp, fmt, ##__VA_ARGS__)
 #define xfs_err(mp, fmt, ...) \
-       xfs_printk_index_wrap(KERN_ERR, mp, fmt, ##__VA_ARGS__)
-       xfs_printk_index_wrap(ERR, mp, fmt, ##__VA_ARGS__)
....

Then xfs_printk_level() is passed the log level as an integer value
at runtime - the compiler does is all for us - and the code
is then simply:

	if (log_level < LOGLEVEL_ERR &&
	    xfs_error_level >= XFS_ERRLEVEL_HIGH)
		xfs_stack_trace();

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
