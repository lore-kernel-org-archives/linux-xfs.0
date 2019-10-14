Return-Path: <SRS0=3dSt=YH=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC070C4CECE
	for <linux-xfs@archiver.kernel.org>; Mon, 14 Oct 2019 19:03:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 94878206A3
	for <linux-xfs@archiver.kernel.org>; Mon, 14 Oct 2019 19:03:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732674AbfJNTDP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 14 Oct 2019 15:03:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41966 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728005AbfJNTDP (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 14 Oct 2019 15:03:15 -0400
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com [209.85.128.70])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id D55D475755
        for <linux-xfs@vger.kernel.org>; Mon, 14 Oct 2019 19:03:14 +0000 (UTC)
Received: by mail-wm1-f70.google.com with SMTP id p6so4501494wmc.3
        for <linux-xfs@vger.kernel.org>; Mon, 14 Oct 2019 12:03:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to:user-agent;
        bh=1qo2+hC7szEvcDXtjNEo7+GiyVoqPh/wiqnJbY50UkU=;
        b=RBmwYEFbSHJPErHG0+rS+/3KNTcZxEEgMGGIXpSugi/DqxhvTkzDh6AmYm9iItLU+a
         86dZheZD3CtUazgan0fMhkg8rNWA26EaceZ4JfAazgruvsqUL4KRTH9ec8h6XiGe0oKM
         wLHkya1iaGo2+7inJuy/MNPIwUMwDd4Kra3dblP5geXfymPLJJvFRxX4xIdI92aRHIA6
         duu2O9K1+JtA2EKLobfqkROX101Y7Iq6WPygFY/WC5bIk09VPbWCfPoEW8PYePy/RgWh
         ineJIK8+jx3Is714zZMFivuT/kcvD+TPyyYVEFdb5EexPUrAprBKrGCh0DA+GoPceKOK
         7dpw==
X-Gm-Message-State: APjAAAVeWb2Sd4yC9LiJownst/IWeO26U1Um5Y+EDrOzElPmCsoG6lXX
        W3mdd89JVwQ2KWXvoXjXBSbui1rMJIOFXnrg57jmMq+XcwmruxQakqzhQmLD74k3vN4G9vdi4Ww
        JESpqCA/qJKov76zu4lgs
X-Received: by 2002:adf:cc8e:: with SMTP id p14mr28961444wrj.301.1571079793644;
        Mon, 14 Oct 2019 12:03:13 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxVazUW1KTfxxVMoy7ZMS42dRodbVOoXELB05h+i577/FcOxK5PiRuX74h5sne+zY5rp4e66Q==
X-Received: by 2002:adf:cc8e:: with SMTP id p14mr28961423wrj.301.1571079793463;
        Mon, 14 Oct 2019 12:03:13 -0700 (PDT)
Received: from orion.maiolino.org (ip-89-103-126-188.net.upcbroadband.cz. [89.103.126.188])
        by smtp.gmail.com with ESMTPSA id j26sm33915835wrd.2.2019.10.14.12.03.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Oct 2019 12:03:13 -0700 (PDT)
Date:   Mon, 14 Oct 2019 21:03:10 +0200
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     xfs <linux-xfs@vger.kernel.org>, Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] xfs: change the seconds fields in xfs_bulkstat to signed
Message-ID: <20191014190310.tkelhxq3xdxuxngc@orion.maiolino.org>
Mail-Followup-To: "Darrick J. Wong" <darrick.wong@oracle.com>,
        xfs <linux-xfs@vger.kernel.org>, Eric Sandeen <sandeen@redhat.com>
References: <20191014171211.GG26541@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191014171211.GG26541@magnolia>
User-Agent: NeoMutt/20180716
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Oct 14, 2019 at 10:12:11AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> 64-bit time is a signed quantity in the kernel, so the bulkstat
> structure should reflect that.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> ---
>  fs/xfs/libxfs/xfs_fs.h |    8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
> index b0c884e80915..8b77eace70f1 100644
> --- a/fs/xfs/libxfs/xfs_fs.h
> +++ b/fs/xfs/libxfs/xfs_fs.h
> @@ -368,11 +368,11 @@ struct xfs_bulkstat {
>  	uint64_t	bs_blocks;	/* number of blocks		*/
>  	uint64_t	bs_xflags;	/* extended flags		*/
>  
> -	uint64_t	bs_atime;	/* access time, seconds		*/
> -	uint64_t	bs_mtime;	/* modify time, seconds		*/
> +	int64_t		bs_atime;	/* access time, seconds		*/
> +	int64_t		bs_mtime;	/* modify time, seconds		*/
>  
> -	uint64_t	bs_ctime;	/* inode change time, seconds	*/
> -	uint64_t	bs_btime;	/* creation time, seconds	*/
> +	int64_t		bs_ctime;	/* inode change time, seconds	*/
> +	int64_t		bs_btime;	/* creation time, seconds	*/
>  
>  	uint32_t	bs_gen;		/* generation count		*/
>  	uint32_t	bs_uid;		/* user id			*/

-- 
Carlos
