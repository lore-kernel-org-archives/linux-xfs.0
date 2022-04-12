Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 439A7C433FE
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Apr 2022 10:01:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347293AbiDLKAv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 Apr 2022 06:00:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243839AbiDLJmc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 Apr 2022 05:42:32 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id EDD4D61A33
        for <linux-xfs@vger.kernel.org>; Tue, 12 Apr 2022 01:47:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649753245;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=tUlVlY57ZX7uV3RPkJUwhJgZ9Q5YSBMyxFuTi8R7RpU=;
        b=MyQw3LcOGnEZjMfKHsUyxVvli1QTwF9G6vbstZwA+nQ4l4me/EtVIEISdViepUKl++hX4w
        ZaefvUvHkVneR2ggP0cPkrJP8ljEICm+4uLOTeUOKhqjY3C4OevbhqHHu/fIjEculVwkKY
        9k9F7Dw+ZtEuqqLOSqtUTqYTvBu/9Gg=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-263-hOcFE4WRPvCIBITVDeb1dQ-1; Tue, 12 Apr 2022 04:47:24 -0400
X-MC-Unique: hOcFE4WRPvCIBITVDeb1dQ-1
Received: by mail-qk1-f197.google.com with SMTP id v14-20020a05620a0f0e00b00699f4ea852cso9184194qkl.9
        for <linux-xfs@vger.kernel.org>; Tue, 12 Apr 2022 01:47:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=tUlVlY57ZX7uV3RPkJUwhJgZ9Q5YSBMyxFuTi8R7RpU=;
        b=KKROSpRe3/75PL4oxc/gCcSYtExZPZu6PKbDfP14ARv4jEWbb8M4iezj6BVxZRzrWM
         Bl+StQT+GvgbAu7j610esimJAD9bHvibOzFhKkrNZKUFesTugJixse+iY8E+hUo0Hu7O
         vyFhsnySHxn++FmIyobtZoyrAQTtH3kKSN2mvj/C/GQHCDpu1IVZ5s7Rcz7v/28HY1Je
         6Ysv5tSW0JilkXiEo3SfJI2tuKhqAenGvXIEPuV+nmkpzRa95b16dCeKUeA831lArlLu
         TqCG0dBU0ZCMVqUqNm05ikT7jKElZhTP6jQPQQdtYZwu0GjiZcntO0zyU/4CbjI2dCZS
         5cHg==
X-Gm-Message-State: AOAM531HI6vtpZeSjKHB/DUSGJJoxvkXLDg8YiwThrkc4jxCDg+LZmZM
        gmRtyfuPo/Aswp99MoLDFdAdSZTtQZtQzaKYJBICqroQ+OO5RA4vfAnng8lqyzZ1+c4N0EG+kNQ
        EAkfD42tZiUfR3F2QZ6pN
X-Received: by 2002:ac8:5e4c:0:b0:2e2:2bbf:57fa with SMTP id i12-20020ac85e4c000000b002e22bbf57famr2440547qtx.278.1649753243024;
        Tue, 12 Apr 2022 01:47:23 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyvycSwxVRjJOhT+Jr5XOeyZael71AMFX7+JlCFx5ZUU29mGMcKJPTHsxSVvR4WZRU1Ts39Gw==
X-Received: by 2002:ac8:5e4c:0:b0:2e2:2bbf:57fa with SMTP id i12-20020ac85e4c000000b002e22bbf57famr2440539qtx.278.1649753242798;
        Tue, 12 Apr 2022 01:47:22 -0700 (PDT)
Received: from zlang-mailbox ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id 20-20020ac84e94000000b002ef2ab3f499sm3511038qtp.3.2022.04.12.01.47.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Apr 2022 01:47:22 -0700 (PDT)
Date:   Tue, 12 Apr 2022 16:47:16 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs/187: don't rely on FSCOUNTS for free space data
Message-ID: <20220412084716.vwljkrc7bpnzl75z@zlang-mailbox>
Mail-Followup-To: "Darrick J. Wong" <djwong@kernel.org>,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org
References: <164971765670.169895.10730350919455923432.stgit@magnolia>
 <164971766238.169895.2389864738831855587.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <164971766238.169895.2389864738831855587.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Apr 11, 2022 at 03:54:22PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Currently, this test relies on the XFS_IOC_FSCOUNTS ioctl to return
> accurate free space information.  It doesn't.  Convert it to use statfs,
> which uses the accurate versions of the percpu counters.  Obviously,
> this only becomes a problem when we convert the free rtx count to use
> (sloppier) percpu counters instead of the (more precise and previously
> buggy) ondisk superblock counts.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  tests/xfs/187 |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> 
> diff --git a/tests/xfs/187 b/tests/xfs/187
> index 1929e566..a9dfb30a 100755
> --- a/tests/xfs/187
> +++ b/tests/xfs/187
> @@ -135,7 +135,7 @@ punch_off=$((bigfile_sz - frag_sz))
>  $here/src/punch-alternating $SCRATCH_MNT/bigfile -o $((punch_off / fsbsize)) -i $((rtextsize_blks * 2)) -s $rtextsize_blks
>  
>  # Make sure we have some free rtextents.
> -free_rtx=$($XFS_IO_PROG -c 'statfs' $SCRATCH_MNT | grep counts.freertx | awk '{print $3}')
> +free_rtx=$($XFS_IO_PROG -c 'statfs' $SCRATCH_MNT | grep statfs.f_bavail | awk '{print $3}')

Do you mean the "cnt->freertx = mp->m_sb.sb_frextents" in xfs_fs_counts() isn't
right?

Thanks,
Zorro

>  if [ $free_rtx -eq 0 ]; then
>  	echo "Expected fragmented free rt space, found none."
>  fi
> 

