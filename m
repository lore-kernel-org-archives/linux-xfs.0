Return-Path: <SRS0=nIBV=A7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42D36C433E1
	for <linux-xfs@archiver.kernel.org>; Mon, 20 Jul 2020 05:38:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1BBC021775
	for <linux-xfs@archiver.kernel.org>; Mon, 20 Jul 2020 05:38:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="tEHK1RtN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726015AbgGTFiY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 20 Jul 2020 01:38:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725805AbgGTFiY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 Jul 2020 01:38:24 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34C45C0619D2
        for <linux-xfs@vger.kernel.org>; Sun, 19 Jul 2020 22:38:24 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id 72so8160439ple.0
        for <linux-xfs@vger.kernel.org>; Sun, 19 Jul 2020 22:38:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gzznrkQJ6dik1VklimjQucPMfv3ssP7Q98Ey7PQvNng=;
        b=tEHK1RtNnEAO3ntNaklT5b84bjYVZV4+bKkElVo1a2wfWdnkaqfxRlCmE+HI/d7ikk
         6IqMFKU1qu1OAZ+ghjia1bbgUn24dFNXVOkjLf0E5Pa6qd046rbdxCOyCk5s0TbDTVwE
         WUrE2sIhoZ5ggfiXo8TbMA9Qe2wu/JhQ3X+bBVfCuPTMHpvEqlw/6AH3S5p48dQDEJpt
         jMYGb7EENzMhwB9+pA/Khzcs1axapgn4gHgUvEw9KhII7aRPmFAKCMXJufk8pcREXOXM
         l/U6yL+0yhZm48El8juFU3zdk6WMZ07OJi67OwwdqXRCwDRw5h23gZee2xdYw3Ub1hY+
         PHEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gzznrkQJ6dik1VklimjQucPMfv3ssP7Q98Ey7PQvNng=;
        b=HaMqQco90zYkyII8rvGsIA9BWvpiWqevV3tUabHAfxZvlj6EfGz+0qKoxm6nezfbpq
         ciXRL3K6fIg4Ie7pgbmr970/Bktqi7PiUCjA6ES8aIU7oq7j0AuxNYVPP1IDg27xBTYj
         ACmxwGTHYagVnSGbFwZ5yHk7t5n2aecGHr+lrrJpZBhplGkg4r3wQTHzfufMQmAvr+7b
         ldnq0gsqNNloKtvOyxAZHn5Cs1Zo/HcBRIjfGZaEcaMuy7uy+2vJo0U1IhY1cjb98o74
         uPdwnDhnN1uu9jIJTPQ4AQpDB6HayYwOFkoWYpXvfBJEAks3qBrivUUwENAKxjlFoslR
         cvFQ==
X-Gm-Message-State: AOAM532MFrrTHgnek3XqM+co8KPaa6w8goOoUMeD52b4v8H2keVEyWZB
        rZ40mLPTMkfDsRtA80wlnD4=
X-Google-Smtp-Source: ABdhPJzOcPvBseWejL2KJKTAFf4JGuTehvLi4+hFPNrqDcQbj+APxC0bjjDT0Nzqh4duz5/neHERFQ==
X-Received: by 2002:a17:902:7483:: with SMTP id h3mr16079412pll.114.1595223503803;
        Sun, 19 Jul 2020 22:38:23 -0700 (PDT)
Received: from garuda.localnet ([122.171.166.148])
        by smtp.gmail.com with ESMTPSA id j8sm15708892pfd.145.2020.07.19.22.38.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Jul 2020 22:38:23 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 25/26] xfs: actually bump warning counts when we send warnings
Date:   Mon, 20 Jul 2020 11:08:13 +0530
Message-ID: <1711545.bsSymtsJ8m@garuda>
In-Reply-To: <159477799812.3263162.13957383827318048593.stgit@magnolia>
References: <159477783164.3263162.2564345443708779029.stgit@magnolia> <159477799812.3263162.13957383827318048593.stgit@magnolia>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wednesday 15 July 2020 7:23:18 AM IST Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Currently, xfs quotas have the ability to send netlink warnings when a
> user exceeds the limits.  They also have all the support code necessary
> to convert softlimit warnings into failures if the number of warnings
> exceeds a limit set by the administrator.  Unfortunately, we never
> actually increase the warning counter, so this never actually happens.
> Make it so we actually do something useful with the warning counts.
>

The changes look good to me.

Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>

> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_trans_dquot.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> 
> diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
> index 78201ff3696b..cbd92d8b693d 100644
> --- a/fs/xfs/xfs_trans_dquot.c
> +++ b/fs/xfs/xfs_trans_dquot.c
> @@ -596,6 +596,7 @@ xfs_dqresv_check(
>  			return QUOTA_NL_ISOFTLONGWARN;
>  		}
>  
> +		res->warnings++;
>  		return QUOTA_NL_ISOFTWARN;
>  	}
>  
> 
> 


-- 
chandan



