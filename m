Return-Path: <SRS0=ZxTw=CK=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5D13C433E2
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Sep 2020 11:48:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A13FC20707
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Sep 2020 11:48:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NY953dPS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727792AbgIALrr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 1 Sep 2020 07:47:47 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:39337 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727784AbgIALr1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Sep 2020 07:47:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598960833;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=BOY0Rwr9tCLQU1FXR4YjS3fRop71+72KzvDRvs1bwj4=;
        b=NY953dPSOAg6eGssos/yX583q/zNdPR7Zk/REn5BurfdbkInwhrjrpzTAn4236POjOvYZa
        LG1rAtX6DXrYEIy9UkbpTLnZYp0kaa8J4BYtIAm4rhgf0EHxKp8ejaoxEU3zs8SkFvkF72
        d9EJCTEUiAwgPTQ1vm5Mp0gqh7lpfGs=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-166-zyxgZLAWMrmRHXw63rFY2Q-1; Tue, 01 Sep 2020 07:47:11 -0400
X-MC-Unique: zyxgZLAWMrmRHXw63rFY2Q-1
Received: by mail-pl1-f198.google.com with SMTP id w24so479433ply.5
        for <linux-xfs@vger.kernel.org>; Tue, 01 Sep 2020 04:47:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=BOY0Rwr9tCLQU1FXR4YjS3fRop71+72KzvDRvs1bwj4=;
        b=b+I3W0LjD4jEAaTF2iZ3tl6P9oZvcl2KFaw/QVT64ksbV5tHfuGO0L06zHdXRZuiym
         y42zAjgoYNyxRovbY/84OOnM9U9onPaxQSnFKlt9JnjMB+uWaK1WSjlfyRUHSJ1x9H0e
         xuDNsnxO0VwGy8e2COhjyMySD9pwoeIpQJC5YA2NJEn5L8qef/fe1zrDL2for4LDwGRp
         2xbAEoOuv8Xdybc6s3gLIy+e9F8F8IaRv6MJ9mwHpPydx9Dagwt2DT8tw/zYmACPHcx1
         ItRnwqVk01DJS9wHICXyK/uO+AopRm0X/2hFvqt4puYKNjMQB91BmdG3P12jD9t+9AW+
         Opqg==
X-Gm-Message-State: AOAM532OUEh6x196A9m6i0oobD1UA4tR3F6865wuB3iNO4B0dbOtPLJO
        m6L9HQonBu8jgPpdTkqi3sPLXvgZ3Whw+RpUw3ffr2xzqiD+7fLQkgZW03++mLsdMvH8DyD/E1U
        zUWM4w25o9L8nPAngMDmw
X-Received: by 2002:a17:90a:c253:: with SMTP id d19mr1208455pjx.113.1598960830909;
        Tue, 01 Sep 2020 04:47:10 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwqdEAjy26yh6f6aADc/Oo8MHzJXHy9gw1ILmJ8TZec3jo+a6/YTFmGbOuiaW5uXhyRjrT+hQ==
X-Received: by 2002:a17:90a:c253:: with SMTP id d19mr1208445pjx.113.1598960830719;
        Tue, 01 Sep 2020 04:47:10 -0700 (PDT)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id 143sm1678445pfc.66.2020.09.01.04.47.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Sep 2020 04:47:10 -0700 (PDT)
Date:   Tue, 1 Sep 2020 19:46:59 +0800
From:   Gao Xiang <hsiangkao@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     david@fromorbit.com, hch@infradead.org,
        Christoph Hellwig <hch@lst.de>,
        Allison Collins <allison.henderson@oracle.com>,
        linux-xfs@vger.kernel.org, amir73il@gmail.com, sandeen@sandeen.net
Subject: Re: [PATCH 10/11] xfs: trace timestamp limits
Message-ID: <20200901114659.GF32609@xiangao.remote.csb>
References: <159885400575.3608006.17716724192510967135.stgit@magnolia>
 <159885407279.3608006.14001785784663274058.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159885407279.3608006.14001785784663274058.stgit@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Aug 30, 2020 at 11:07:52PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Add a couple of tracepoints so that we can check the timestamp limits
> being set on inodes and quotas.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Allison Collins <allison.henderson@oracle.com>

Reviewed-by: Gao Xiang <hsiangkao@redhat.com>

Thanks,
Gao Xiang

