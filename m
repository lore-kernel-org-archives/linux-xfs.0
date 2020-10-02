Return-Path: <SRS0=RTOF=DJ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCA24C4363D
	for <linux-xfs@archiver.kernel.org>; Fri,  2 Oct 2020 08:53:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9492B206DC
	for <linux-xfs@archiver.kernel.org>; Fri,  2 Oct 2020 08:53:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kjt52rX2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726090AbgJBIxZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 2 Oct 2020 04:53:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725993AbgJBIxZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Oct 2020 04:53:25 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05F4DC0613D0
        for <linux-xfs@vger.kernel.org>; Fri,  2 Oct 2020 01:53:25 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id t23so428611pji.0
        for <linux-xfs@vger.kernel.org>; Fri, 02 Oct 2020 01:53:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XQF3jv1mnrYoDXvVuOir5WOLXN3C0c3UPYNpgx0sfbk=;
        b=kjt52rX2aP/WC0rMb3XagTaFN2vDD5GrTl4yH0jEu5B+gzZaZp2X2FWgSxn9rv3ZSt
         o4Tvcdyfe99UJWtHWLMKxX9tm9pjKMbXsxfAoKlhlDN8Ui30JePMiPYWGu6cPIMDTMnj
         k49BQ3tlKm5hP6ZhkDdVMWiAFID0wtMbn4jTsdqdsJS8QkaxuyQz5/e7RPL2OxIRgUyK
         pvuw0ng1lFMXifT7MUk0BpVTgRLCOCEpKJC5SuhmIMMV7J/uvN41em3P9YUppv/Is4hF
         ULY9CajPnz/fPGB3m02KoI3R9clWTCf+SoFuLrvYxwbNudlRMU5hOeqHGgWYudZ9kMo1
         GZ9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XQF3jv1mnrYoDXvVuOir5WOLXN3C0c3UPYNpgx0sfbk=;
        b=VPuXhPaiHju3VBH/kQowjIIXHHYaghPZ8MtUfkN6RT72XBsxRfykePZQbboOAFeZdp
         fm7aG8nIl3eBtw4o/Pnd27Ojyvf5JoVVqBeOfG5vyqGimhKIfn+NKjPLtLbcbF6d51nF
         6bUI72s1NAacAbxVK/4pt7Jivoz02J+mMW9Wa8d2tQ6j3GvssppkXeH4Pqv3t3+P81wn
         dgj+wKpr/FgQsB/GYZu2wHRSLHQhe+7SYVB4Ak6iHD2zhT7O6IJIbSBVcfUE82Ci94s4
         5WU3nvvuHpY2SO4mIKg5ID1pkxVW7uWF+ulCq52fCKZYXhfRwVLF+09eKMDXwFZxUVgK
         X04g==
X-Gm-Message-State: AOAM530boh1EaHuR3imgI1uUJSkZelS5jSbFavewVMUnPxCBX1HqNJQl
        6KKK13sNkkvoO6Vzi1c621M=
X-Google-Smtp-Source: ABdhPJxG6q1weCaf4mFQbmCL6RbSSGqPGUBBKEa+FoazG/R1Mes1gYj6BSJfY1zWLyAkdtJLIhAdGA==
X-Received: by 2002:a17:90a:db49:: with SMTP id u9mr1676275pjx.119.1601628804629;
        Fri, 02 Oct 2020 01:53:24 -0700 (PDT)
Received: from garuda.localnet ([122.172.184.91])
        by smtp.gmail.com with ESMTPSA id 84sm1127628pfw.14.2020.10.02.01.53.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Oct 2020 01:53:24 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: limit entries returned when counting fsmap records
Date:   Fri, 02 Oct 2020 14:21:10 +0530
Message-ID: <4857521.XMzPl6tNdl@garuda>
In-Reply-To: <160161416467.1967459.10753396346204946090.stgit@magnolia>
References: <160161415855.1967459.13623226657245838117.stgit@magnolia> <160161416467.1967459.10753396346204946090.stgit@magnolia>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Friday 2 October 2020 10:19:24 AM IST Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> If userspace asked fsmap to count the number of entries, we cannot
> return more than UINT_MAX entries because fmh_entries is u32.
> Therefore, stop counting if we hit this limit or else we will waste time
> to return truncated results.
> 
> Fixes: e89c041338ed ("xfs: implement the GETFSMAP ioctl")
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

The upper bound check is correct.

Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>

> ---
>  fs/xfs/xfs_fsmap.c |    3 +++
>  1 file changed, 3 insertions(+)
> 
> 
> diff --git a/fs/xfs/xfs_fsmap.c b/fs/xfs/xfs_fsmap.c
> index 4eebcec4aae6..aa36e7daf82c 100644
> --- a/fs/xfs/xfs_fsmap.c
> +++ b/fs/xfs/xfs_fsmap.c
> @@ -256,6 +256,9 @@ xfs_getfsmap_helper(
>  
>  	/* Are we just counting mappings? */
>  	if (info->head->fmh_count == 0) {
> +		if (info->head->fmh_entries == UINT_MAX)
> +			return -ECANCELED;
> +
>  		if (rec_daddr > info->next_daddr)
>  			info->head->fmh_entries++;
>  
> 
> 


-- 
chandan



