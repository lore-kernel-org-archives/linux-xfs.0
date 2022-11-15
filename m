Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C2DCC4332F
	for <linux-xfs@archiver.kernel.org>; Tue, 15 Nov 2022 02:59:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236120AbiKOC7Y (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 14 Nov 2022 21:59:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237748AbiKOC7L (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 14 Nov 2022 21:59:11 -0500
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50DDB1CB1B
        for <linux-xfs@vger.kernel.org>; Mon, 14 Nov 2022 18:56:24 -0800 (PST)
Received: by mail-pg1-x530.google.com with SMTP id h193so12017253pgc.10
        for <linux-xfs@vger.kernel.org>; Mon, 14 Nov 2022 18:56:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=pLWv5TKet1EnKPeqdAcxKSI0eXNGLx0AIoKERyK9vQc=;
        b=4v7wcSnVVP3Rah2mzyBv2pcjfJ/n2CgeIwoQ6G9+GbxFL057QodT/5Bhe+Ch5aStn7
         CrHwzCY4YBQCSSoGfpwN0cvqXVS3RBr/0sp2T72t3UPxJVHa79ZjHyK+lHItkmoE8OjA
         yk8yZJ8N2Zfdng5A7qqMxGyuAybNBh11aBN7uiWA28U3uYEqlkcHh6F42TE22qWyD4vM
         WZIzZgGvLEbRUseHM4xjJhc/Pv0p4hob1hS1+i/k9V9K4agv0vohDr4vOlB21OMrcw+i
         2mOaKdm/fFJAMMmmQn8/W6pscd9piRigkHVfo+GWWP5ERIBzXG2cG1axh4GGa+FgzGZs
         pSYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pLWv5TKet1EnKPeqdAcxKSI0eXNGLx0AIoKERyK9vQc=;
        b=ePBvbuUIMi3Odt8bu4n5LuRqgR1U/1CchFO5a/cSGuOs0Ww/EpMr5PZfvau6qfnDSg
         gsCk3fb2xPGz5pKpo+xPVcNgnJs83/KK4pEKY63Z8o6N6qArpEpZ4Mjwlms9h6Y6gxUn
         hJWOOYiKNMazUD3W6wKmaR3isYnd/2oke9OgIwuLBFNtsCXfsbljwUYzkUWBX139nL5M
         uWX/Pze1H9GpHs2tDMIGR09OIqmlAchSosZ4Gqme+GcZhKGW3DPc9ZbfgRPxyWDRcGSK
         slHcicXZwgD+IC4n5gNSxFlX1FmUqbPsYzNSAZIV2It6Z45I36RlwIbTdcOv3W1cHahT
         k1KQ==
X-Gm-Message-State: ANoB5pltTWfo/tlBlDzDA5KEfmgwvOv8Nv/k5HY36E9X+G25YM0VzjoR
        SGs8ALHp2o5f5NViUrFjCGAFwhGfeHmx6Q==
X-Google-Smtp-Source: AA0mqf7Ewbor0KrYivGdtvmBRSinFWtoH1VNU3tXlRL/rBzjZ30DOB5qlGO0+Fn+6vGcWMClk1a+AQ==
X-Received: by 2002:aa7:8dc2:0:b0:56b:b520:3751 with SMTP id j2-20020aa78dc2000000b0056bb5203751mr16225732pfr.29.1668480983832;
        Mon, 14 Nov 2022 18:56:23 -0800 (PST)
Received: from dread.disaster.area (pa49-181-106-210.pa.nsw.optusnet.com.au. [49.181.106.210])
        by smtp.gmail.com with ESMTPSA id mt18-20020a17090b231200b001f559e00473sm10486823pjb.43.2022.11.14.18.56.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Nov 2022 18:56:23 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1oum7Z-00ELh2-3Q; Tue, 15 Nov 2022 13:56:21 +1100
Date:   Tue, 15 Nov 2022 13:56:21 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: don't warn about files that are exactly
 s_maxbytes long
Message-ID: <20221115025621.GU3600936@dread.disaster.area>
References: <166473482605.1084588.1965700384229898125.stgit@magnolia>
 <166473482622.1084588.7922921296626975279.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <166473482622.1084588.7922921296626975279.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Oct 02, 2022 at 11:20:26AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> We can handle files that are exactly s_maxbytes bytes long; we just
> can't handle anything larger than that.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/scrub/inode.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
LGTM.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
