Return-Path: <SRS0=br+O=CM=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2F37C433E7
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Sep 2020 08:28:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ACAA620767
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Sep 2020 08:28:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aaPBOZSI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726479AbgICI2p (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 3 Sep 2020 04:28:45 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:23865 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726162AbgICI2p (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Sep 2020 04:28:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599121723;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=PKaZiX/m3cChjrvTg6tlaVjYg6lSZpe26kzooVdYTi0=;
        b=aaPBOZSIHd2gaJMnRIJC/eZ8PeTGB2bDs4Dj81iT8bjAxaJhUVc84z8zno+ZgfybixBB7R
        77SIKlNCqMvvucdVsXSMRO3tvgTv6eCF0E6JeuNF+CdqA7ER1A8MJ71DKneGhzaX3A26PG
        u9mnMrDRj5k4PG/cuz3A54yoOPrDHsk=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-338-AL7QSqwtMWmWq1zcMJsV3g-1; Thu, 03 Sep 2020 04:28:41 -0400
X-MC-Unique: AL7QSqwtMWmWq1zcMJsV3g-1
Received: by mail-wm1-f69.google.com with SMTP id x6so688944wmb.6
        for <linux-xfs@vger.kernel.org>; Thu, 03 Sep 2020 01:28:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=PKaZiX/m3cChjrvTg6tlaVjYg6lSZpe26kzooVdYTi0=;
        b=oT/AV6OOddT1icVKr+0VKKZyAtKFiioSI4aCHPXc/SfVDCGI/u6z8ZhwsXzKKFZKzy
         C5y342v/VrvkDfqewfPrBH6OduYCm3QJUZGqObnzod4DKfcy4541D58YZJG1U/qmzj60
         saMjR57aaHXYSflw//Rp2w2nmdKdVMG/MpM8uIr/whMaHvLMYuN90EYn23T1gCrpdny1
         Eiyz2vaWMjoKBdGlH7Rm4tCUQs3qSJNfp5DL+u7Oimkwl7VcuKNF5GlUV8CpUOjfx0ZD
         l4H8TkHfximrmUDS2GefUEALEk/2fPMWX0Dcli1mcD1y1TOWjs9Lk1nFCH0VgIFvZv4a
         ElOg==
X-Gm-Message-State: AOAM5333fmjsPl94EEGXfNzXFsosG52O5R/vA2wae4x989g7C0TmBQXN
        CnMkrzvqyj/rEGl0Kklf/JNZkQ47mVlgGUevp9/c/ei3tmHe4CHqRUOs2Nsrko3F7XnKG8xY9Qp
        VpSnR1cfJf8PveaC6CjZK
X-Received: by 2002:a5d:6412:: with SMTP id z18mr1200503wru.30.1599121720554;
        Thu, 03 Sep 2020 01:28:40 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxG8q8Nek3hlMBJrzHynXWMORoAuCRcQG1uWhxZbPJY9JdmSp/S87B7wKKmPp615cmVFZe1iQ==
X-Received: by 2002:a5d:6412:: with SMTP id z18mr1200492wru.30.1599121720411;
        Thu, 03 Sep 2020 01:28:40 -0700 (PDT)
Received: from eorzea (ip-89-102-9-109.net.upcbroadband.cz. [89.102.9.109])
        by smtp.gmail.com with ESMTPSA id o129sm1723530wmb.27.2020.09.03.01.28.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Sep 2020 01:28:39 -0700 (PDT)
Date:   Thu, 3 Sep 2020 10:28:36 +0200
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH V2 2/4] xfs: Remove typedef xfs_attr_shortform_t
Message-ID: <20200903082836.uowcvwuuek52bu73@eorzea>
Mail-Followup-To: "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org
References: <20200902144059.284726-1-cmaiolino@redhat.com>
 <20200902144059.284726-3-cmaiolino@redhat.com>
 <20200902173610.GS6096@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200902173610.GS6096@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Sep 02, 2020 at 10:36:10AM -0700, Darrick J. Wong wrote:
> On Wed, Sep 02, 2020 at 04:40:57PM +0200, Carlos Maiolino wrote:
> > Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> > ---
> > 
> > Changelog:
> > 	V2:
> > 	 - Reordered within the series, no functional changes.
> > 

looks like your reply went straight into /dev/null? :)

-- 
Carlos

