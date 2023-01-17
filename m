Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77D12C46467
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Jan 2023 01:08:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233398AbjAQBIK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 16 Jan 2023 20:08:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233304AbjAQBIJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 16 Jan 2023 20:08:09 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D746025E14
        for <linux-xfs@vger.kernel.org>; Mon, 16 Jan 2023 17:08:07 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id 20so4628679plo.3
        for <linux-xfs@vger.kernel.org>; Mon, 16 Jan 2023 17:08:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=+2M4ZfahdSuZhpYDbNJI9MpnCjUCFbpRhMvAR6bQrYo=;
        b=YeFsBM5CQtSbpahfw4KRgHWjlt1K32OcHp+TvUdOQfosuFJeg9TT0Ouk5r6WDpX9W7
         Ev23/E9i6l0nYloG0FUTAagzhWCNBWEVOXzBs/AoZJePmHQtEyvRykdHsSJJTLpaokR8
         RTsFvetOSQwuRHN7pUKymb5J58JO9WmWzimCLdQ0gFQLa6ESY7H6aAKCkIvsPCDqtckE
         Dl4Dow2zCny45OI06+6SIS68qroZZwdv0ee9ShYeoJ7D6OvmqBDjtW0srzWlQaDboNx1
         MYxQDRmT9x+QpCyS3NS7OTDsDOuPs8tqqnVCPPXvYm0E58F9eKi/mb4IiXrGJu5zJf64
         iQTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+2M4ZfahdSuZhpYDbNJI9MpnCjUCFbpRhMvAR6bQrYo=;
        b=5YUMWg53MZEkf+NXT+PS0Ceq09Oxu2nDh0YZpKJrFEngHUjgaywKi9KoNVgj4/5jd5
         +z7Kq/frKDelTAfppSuodCXRFyhTAdmekwnW4TS/DhQ7RlwzHca0w0DdX/4htoGKbyQn
         ue27KMXkbdcBNlAFK9h9lvqSx6MM2OIe6q4C9MUorIRqx+2sjkzoD7lH9J9trXvNUu3x
         /f5tEJcbyudlP1Yp7FRgD8iSj/QPJCT+fZtV+2f5bWDYIM5kRAPjoJQyTDak1wbAYpbZ
         USOfRMXeo6CAMy0FMMcKgLMATyvIWDuv5+hAC85saqupM/fsSXyPahu1lxl9wqD7s+eK
         PfvQ==
X-Gm-Message-State: AFqh2krls/kAkaB3yRt38yUKfNaSlYg1YzbIqEXprn/X/6Ud329DUic3
        0aRg7cdg354WvOofyuPYUekeblEcpNtaUgDS
X-Google-Smtp-Source: AMrXdXtbmwSBKOB3KjZ9r4XuE2hzXOUI5Kt88+kKqQKo/Dx4Nye2PY6giWe1PIaJUe7N6LGkGVekqw==
X-Received: by 2002:a17:903:516:b0:192:b40b:e41 with SMTP id jn22-20020a170903051600b00192b40b0e41mr434619plb.61.1673917687402;
        Mon, 16 Jan 2023 17:08:07 -0800 (PST)
Received: from dread.disaster.area (pa49-186-146-207.pa.vic.optusnet.com.au. [49.186.146.207])
        by smtp.gmail.com with ESMTPSA id t2-20020a170902e84200b001946a3f4d9csm7464884plg.38.2023.01.16.17.08.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Jan 2023 17:08:06 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1pHaSH-003xyn-L2; Tue, 17 Jan 2023 12:08:01 +1100
Date:   Tue, 17 Jan 2023 12:08:01 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Csaba Henk <chenk@redhat.com>
Cc:     linux-xfs@vger.kernel.org, "Darrick J. Wong" <djwong@kernel.org>
Subject: Re: [PATCH v2] xfsdocs: add epub output
Message-ID: <20230117010801.GE360264@dread.disaster.area>
References: <20230116201258.a4debvbbbr724ilm@nixos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230116201258.a4debvbbbr724ilm@nixos>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jan 16, 2023 at 09:12:58PM +0100, Csaba Henk wrote:
> Epub is a widespread open format for standalone reflowable
> electronic documents, and it's a core feature of Asciidoc tooling
> to be able to produce it, so we can get it "for free".
> ---
>  .gitignore                               |  1 +
>  admin/Makefile                           | 13 +++++++++++--
>  admin/XFS_Performance_Tuning/Makefile    | 13 +++++++++++--
>  design/Makefile                          | 13 +++++++++++--
>  design/XFS_Filesystem_Structure/Makefile | 13 +++++++++++--
>  5 files changed, 45 insertions(+), 8 deletions(-)

Looks fine.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
