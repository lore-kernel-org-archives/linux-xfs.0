Return-Path: <SRS0=zZWs=CB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DDD4C433DF
	for <linux-xfs@archiver.kernel.org>; Sun, 23 Aug 2020 17:24:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F147B204FD
	for <linux-xfs@archiver.kernel.org>; Sun, 23 Aug 2020 17:24:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Kr7cR3AW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726706AbgHWRYi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 23 Aug 2020 13:24:38 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:23028 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726664AbgHWRYh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 23 Aug 2020 13:24:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598203475;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=JftHt3pwQKfxFDIT2eNemnqZayhs22vU5f4b2TIqFSY=;
        b=Kr7cR3AW/fOWmeMPGCUgz+xQCn3lrJQC2Px+hZDFI3eiCaApkbfISIS75rSKNDAtklEYqW
        Fe1vwpSCct/TV4vLc2qhj4KPjAqU7p6jvXnOifhz4/ufPi0jkOAoX8majjFqND8mrro8sL
        HEZ26T3Gkei+iP2X+q0Qpt6mSyL3iKA=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-484-27zJZDfXPduR1VjXZtBSBA-1; Sun, 23 Aug 2020 13:24:33 -0400
X-MC-Unique: 27zJZDfXPduR1VjXZtBSBA-1
Received: by mail-pj1-f71.google.com with SMTP id j1so615323pjs.6
        for <linux-xfs@vger.kernel.org>; Sun, 23 Aug 2020 10:24:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=JftHt3pwQKfxFDIT2eNemnqZayhs22vU5f4b2TIqFSY=;
        b=LKMNSoTB0yV30WdORVecGmmVX5IDGbjbNheMAsJ+kv7MyGsU2Y8tn2r075WS7MtJYZ
         iE7WdfPilUNFNMbqpXygfJ2EQp0sg/sXVQvrr83jGAnX4lKWYw7NRN+W/+rm4wrChub6
         4NFktDdEGCEFHZqkHB/9qxEArvXYrfQf+AujGDMRp5l24ZFdjl5rUwijp72kZlULVkbL
         7Sm98cEjiq60SjmUpSfX0y+dWhOmkKwLfgz7s782Ak4QqrWdUnJIkxINN8G9G7GmYkml
         S2XyTaCs5YkkKva3fiDD4qNSHxMtk9ON4lN82lYPR0CmHgnrlPBgENB5Gz0KLl2nmuAG
         QiDw==
X-Gm-Message-State: AOAM5315R6m9/Qx7CyfxtP2aWVPI/sw4KBBykEQR6bh/dJEEvf7LWBVT
        FMqAR7Mv3DX79FOOSe5o5AW3VhClDqvd5IyyBt48i4WmfwZc/3KvZ6ESqF6Ax8C6/VLZrb7sUOI
        VFpz9oEx63Nh0K20IGXCW
X-Received: by 2002:aa7:9494:: with SMTP id z20mr1404040pfk.55.1598203472491;
        Sun, 23 Aug 2020 10:24:32 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzPtaaZfz7+RToSqqH/xfr34fxk4n+7a4H2a/3yrjKq4zN8rlb99Iy7s+F8zm410i0pnLgodQ==
X-Received: by 2002:aa7:9494:: with SMTP id z20mr1404035pfk.55.1598203472263;
        Sun, 23 Aug 2020 10:24:32 -0700 (PDT)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id b63sm8887957pfg.43.2020.08.23.10.24.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Aug 2020 10:24:31 -0700 (PDT)
Date:   Mon, 24 Aug 2020 01:24:21 +0800
From:   Gao Xiang <hsiangkao@redhat.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 04/13] xfs: arrange all unlinked inodes into one list
Message-ID: <20200823172421.GA16579@xiangao.remote.csb>
References: <20200812092556.2567285-1-david@fromorbit.com>
 <20200812092556.2567285-5-david@fromorbit.com>
 <20200818235959.GR6096@magnolia>
 <20200819005830.GA20276@xiangao.remote.csb>
 <20200822090145.GA25623@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200822090145.GA25623@infradead.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Christoph,

On Sat, Aug 22, 2020 at 10:01:45AM +0100, Christoph Hellwig wrote:
> On Wed, Aug 19, 2020 at 08:58:30AM +0800, Gao Xiang wrote:
> > btw, if my understanding is correct, as I mentioned starting from my v1,
> > this new feature isn't forward compatible since old kernel hardcode
> > agino % XFS_AGI_UNLINKED_BUCKETS but not tracing original bucket_index
> > from its logging recovery code. So yeah, a bit awkward from its original
> > design...
> 
> I think we should add a log_incompat feature just to be safe.

Thanks for your suggestion.
Okay, if no other concern, I will try to look into that tomorrow...

Thanks,
Gao Xiang

> 

