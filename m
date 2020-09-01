Return-Path: <SRS0=ZxTw=CK=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AACDC433E2
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Sep 2020 14:54:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D502D2078B
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Sep 2020 14:54:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Sc6l+hsi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728720AbgIAOyH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 1 Sep 2020 10:54:07 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:28184 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727807AbgIALs1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Sep 2020 07:48:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598960877;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Zh2HerV6rWg9oliTGGXvRm15q/KpJ1R2KbtJMG2tbPw=;
        b=Sc6l+hsi0p8maio7fFK92PdikFu8Ax0wGlAnNhpnxYreNLYY1VV+1OoVNkeU0owgaviVPn
        R512Bp1pBPybSKPTRt6tqYUuY+sjdazArmDpCoMfctPXHu7HpQHrHC97BcoePvpLMaWIKN
        kDbWt9TJ8XXgaxDlowGP+m1dghQs+OM=
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com
 [209.85.210.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-230-TMCFHfHbMQe5xtzwbEILuA-1; Tue, 01 Sep 2020 07:47:56 -0400
X-MC-Unique: TMCFHfHbMQe5xtzwbEILuA-1
Received: by mail-pf1-f198.google.com with SMTP id x125so493317pfc.4
        for <linux-xfs@vger.kernel.org>; Tue, 01 Sep 2020 04:47:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Zh2HerV6rWg9oliTGGXvRm15q/KpJ1R2KbtJMG2tbPw=;
        b=Bx5URfGADo+f/3jeplzeqmuluHKRBfTGY+pTaA+GTBhFaB3MuTZUQvaW2u44qgoSzK
         zvbM9NB4egmf3vEXxBI+LbYxYH4OjUj2tO0QMi2JXMSuNqROwlyYj13PRYyBpei5f1p6
         Yl70dTgG2Ro1pVxr6NtkDluDZwhe1fWyGPDIRpvorV+cMfa5IIMphrtlAVNULgadiAS6
         izttyY+o0UXoIGUatSaiJd8KrJrVeaLRybKVHa+ASZ5GMqAcFXIalRqjpT6O87LhcX3W
         fipNXgEhSLZlWEjJzThq0SqUxgXPnvBE8wZGovRcU0LRmxnStJSl3/p3dKKhnuSaowVu
         00sQ==
X-Gm-Message-State: AOAM533ynEzW63OQXb8dRq3otTxDWcQAGHMnMyg2381/y44ZqFO/eE1X
        o4bazxNMryRL10HsrbTz6Hfyb4cGBpbLcF7iTUSvItCCrqnMAIWVz6LWdEqsQAs8yxlhJSrMbPd
        uN4DLN1uFqG5krzfccPu/
X-Received: by 2002:a17:90b:4d0d:: with SMTP id mw13mr1191393pjb.43.1598960875086;
        Tue, 01 Sep 2020 04:47:55 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz1r6A561I4kp/WUycEepgRQsmKl4jDWvQ0lw8qwfFCHWgZ65EonSR1/7uIeWkJ2Yc5npZNgg==
X-Received: by 2002:a17:90b:4d0d:: with SMTP id mw13mr1191379pjb.43.1598960874856;
        Tue, 01 Sep 2020 04:47:54 -0700 (PDT)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id s8sm1680209pfm.180.2020.09.01.04.47.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Sep 2020 04:47:54 -0700 (PDT)
Date:   Tue, 1 Sep 2020 19:47:43 +0800
From:   Gao Xiang <hsiangkao@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     david@fromorbit.com, hch@infradead.org,
        Amir Goldstein <amir73il@gmail.com>,
        Allison Collins <allison.henderson@oracle.com>,
        linux-xfs@vger.kernel.org, sandeen@sandeen.net
Subject: Re: [PATCH 11/11] xfs: enable big timestamps
Message-ID: <20200901114743.GG32609@xiangao.remote.csb>
References: <159885400575.3608006.17716724192510967135.stgit@magnolia>
 <159885407932.3608006.12834647369484871421.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159885407932.3608006.12834647369484871421.stgit@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Aug 30, 2020 at 11:07:59PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Enable the big timestamp feature.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> Reviewed-by: Amir Goldstein <amir73il@gmail.com>
> Reviewed-by: Allison Collins <allison.henderson@oracle.com>

Reviewed-by: Gao Xiang <hsiangkao@redhat.com>

Thanks,
Gao Xiang

