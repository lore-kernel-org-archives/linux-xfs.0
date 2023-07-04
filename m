Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BD41EB64DA
	for <linux-xfs@archiver.kernel.org>; Tue,  4 Jul 2023 14:19:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231748AbjGDOTq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 4 Jul 2023 10:19:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229708AbjGDOTp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 Jul 2023 10:19:45 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16BE5E76
        for <linux-xfs@vger.kernel.org>; Tue,  4 Jul 2023 07:18:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1688480338;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1bX3l9kHHxprZ87a696qDndKt6iFUuC65A9XHK4GEDE=;
        b=I18StjqiENlgdYJuKfXgmc27EQ94w8W0Legg0Avfy6jLKC8sH1UoWVjNu5Bo9VbL0suHx9
        Htfsc+V5ynx41mN9ZACq8xMeoC9GGSJiZUOcL1tRNRd8qVd4z6pvpX6+Mj9HAz22+iV/IT
        i182qEHA0IXK3CI4ds5tg04hZM9swWY=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-438-hOmkdw8jOEmF7qQnChwa0A-1; Tue, 04 Jul 2023 10:18:57 -0400
X-MC-Unique: hOmkdw8jOEmF7qQnChwa0A-1
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-7656c94fc4eso679233385a.2
        for <linux-xfs@vger.kernel.org>; Tue, 04 Jul 2023 07:18:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688480336; x=1691072336;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1bX3l9kHHxprZ87a696qDndKt6iFUuC65A9XHK4GEDE=;
        b=iTDh7R2upjWgcH8Y6WA9u5+iY0cy396aAOgTRCyj/3BadShQ54SK4grEih0VXPD8UT
         9fUPMenhYngTc8N6oCxgDTamxp5fi+9Nm/z0OR3DP/YaY8txQVtxPzHpNjnsVIzJu8k+
         xXUZSRtHFkT2A94iyjjXq6W0hffQNQahykX5UgUKeitQ2zHTjTrBzWEt7seT+HQNL0zG
         ciEDoOrMIUQ6fsyq9FHxcbvKMbNVoLdigI+L5YxgVCDH1OxFHaXnoS7LaAAhCboWs4IW
         yLlSsn2y95Jh7PLUfzhHjOfr8VyMKYlndooPDAMEIoiARW93H8wjYrRwz18bY7YH38bE
         IBdA==
X-Gm-Message-State: AC+VfDzcw4pnSAbAWYy4cBrgBnrKZLzZ5oprG38w50Kuxk7d1RVWIWS+
        oMic6T6hgbplGKR/08Y0ps0MWIICo+z8EGCysS9czx4YNGs7d386IPZrY7umNGpZS8ebeS2800l
        ArVw1mtRPP9GHxSEjvqo=
X-Received: by 2002:a05:620a:1a04:b0:763:d33b:e7b8 with SMTP id bk4-20020a05620a1a0400b00763d33be7b8mr16042810qkb.45.1688480336786;
        Tue, 04 Jul 2023 07:18:56 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5COzTjGOXQOf5HoUvdopyT6F5TUbmRh8TnG/iC5Pxiu4c5Q5Ptzi0LbY1hnFEmf/4FUZZX0g==
X-Received: by 2002:a05:620a:1a04:b0:763:d33b:e7b8 with SMTP id bk4-20020a05620a1a0400b00763d33be7b8mr16042787qkb.45.1688480336465;
        Tue, 04 Jul 2023 07:18:56 -0700 (PDT)
Received: from aalbersh.remote.csb ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id w15-20020ae9e50f000000b00765aa3ffa07sm8646066qkf.98.2023.07.04.07.18.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Jul 2023 07:18:56 -0700 (PDT)
Date:   Tue, 4 Jul 2023 16:18:53 +0200
From:   Andrey Albershteyn <aalbersh@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     zlang@redhat.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
Subject: Re: [PATCH 2/5] xfs/569: skip post-test fsck run
Message-ID: <20230704141853.orxwkglv4fafwex5@aalbersh.remote.csb>
References: <168840381298.1317961.1436890061506567407.stgit@frogsfrogsfrogs>
 <168840382437.1317961.10711798856849951797.stgit@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <168840382437.1317961.10711798856849951797.stgit@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 2023-07-03 10:03:44, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> This test examines the behavior of mkfs.xfs with specific filesystem
> configuration files by formatting the scratch device directly with those
> exact parameters.  IOWs, it doesn't include external log devices or
> realtime devices.  If external devices are set up, the post-test fsck
> run fails because the filesystem doesnt' use the (allegedly) configured
> external devices.  Fix that by adding _require_scratch_nocheck.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  tests/xfs/569 |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> 
> diff --git a/tests/xfs/569 b/tests/xfs/569
> index e8902708bc..b6d5798058 100755
> --- a/tests/xfs/569
> +++ b/tests/xfs/569
> @@ -14,7 +14,7 @@ _begin_fstest mkfs
>  
>  # Modify as appropriate.
>  _supported_fs xfs
> -_require_scratch
> +_require_scratch_nocheck
>  
>  ls /usr/share/xfsprogs/mkfs/*.conf &>/dev/null || \
>  	_notrun "No mkfs.xfs config files installed"
> 

Looks good to me:
Reviewed-by: Andrey Albershteyn <aalbersh@redhat.com>

-- 
- Andrey

