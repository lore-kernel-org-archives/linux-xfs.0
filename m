Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24F7ECDB474
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Oct 2023 12:38:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232059AbjJPMiO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 16 Oct 2023 08:38:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbjJPMiO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 16 Oct 2023 08:38:14 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 371B1AB
        for <linux-xfs@vger.kernel.org>; Mon, 16 Oct 2023 05:37:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1697459846;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Su8yaNN6gleYsl9c5NRTrh5jb8id9qjQrOt8Qy4EQT8=;
        b=iWgThIuAEyKnSQbfjX3fZqVz6Z4I/xAnriGZzdD+u+RaF6VWL1D7uYGf6bBrxP8bJC7HGa
        YxZolEQoUnWkQIncgmZaAMYQJ0TYiohV2SfQKox1OjhiXRTQi/SaVrlpHT0qogtfud1K89
        JRraLPHWcBsoLRcX1cu7emp/+4RS/Ek=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-130-bbKOEdDuP0eqcqcTXDOtmA-1; Mon, 16 Oct 2023 08:37:14 -0400
X-MC-Unique: bbKOEdDuP0eqcqcTXDOtmA-1
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-9b2e030e4caso579206666b.1
        for <linux-xfs@vger.kernel.org>; Mon, 16 Oct 2023 05:37:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697459833; x=1698064633;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Su8yaNN6gleYsl9c5NRTrh5jb8id9qjQrOt8Qy4EQT8=;
        b=ioL5HAdoDWFp2ft7pvPCtxoeRaGckgBzFv1M1HG9mnuBgRTqpAixSQZT8NodPaGBhf
         BvrfTLEaBbdaAjvTL/MU9uZBTRAb/1azf5ZYnkpoQXypcZY1nGQej8YGTcfN0Z2o9CEs
         KGCQB3pTXFyPQUuGukzkHQOwXkf8goc3lI/5NEiEwjHDie7hsT92LeknW0PtzpeUaf6q
         0bKkaYGsaEpBK712qQeJsJu5icAdr33VQZHIFnl5DtNKZqjcXmSLm6/rv58y4rjIPmOI
         6O81li/Jzwi/4G23i4gXb/aMVUJrRcruRZpjwhpycnxEetqQMDBAeJWab7JJKQLQGyxE
         +v1Q==
X-Gm-Message-State: AOJu0Yw1qDNJzysuXycGXhNeETHxME7nQLDMIjRmW++LXvT4NyLtIRzh
        vioCGEj7AIhAbpkCbVzfEoj7R7USVCOq+e20J/XNko0NahDybKXpUpsesngec8zwGCCNOA5BP8L
        /hxAbKQYxDWCPIaYRzYE=
X-Received: by 2002:a17:907:7ea7:b0:9ad:cbc0:9f47 with SMTP id qb39-20020a1709077ea700b009adcbc09f47mr6137032ejc.12.1697459833631;
        Mon, 16 Oct 2023 05:37:13 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGTeQ/M+ycZkOVQebj4aUcWiSA9VpuBVUaM9K8JgYaF1bg0BBb1USApDPF/nmxRKtrWDQwtMg==
X-Received: by 2002:a17:907:7ea7:b0:9ad:cbc0:9f47 with SMTP id qb39-20020a1709077ea700b009adcbc09f47mr6137016ejc.12.1697459833363;
        Mon, 16 Oct 2023 05:37:13 -0700 (PDT)
Received: from thinky ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id ck22-20020a170906c45600b009b2d46425absm3979682ejb.85.2023.10.16.05.37.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Oct 2023 05:37:12 -0700 (PDT)
Date:   Mon, 16 Oct 2023 14:37:12 +0200
From:   Andrey Albershteyn <aalbersh@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        fsverity@lists.linux.dev, ebiggers@kernel.org, david@fromorbit.com,
        dchinner@redhat.com
Subject: Re: [PATCH v3 15/28] xfs: introduce workqueue for post read IO work
Message-ID: <skhqdob6wt3azlx64ndumvk3mxd2bxrbvqxho6ykf3otwed5vj@5bzi44xmh7vs>
References: <20231006184922.252188-1-aalbersh@redhat.com>
 <20231006184922.252188-16-aalbersh@redhat.com>
 <20231011185558.GS21298@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231011185558.GS21298@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 2023-10-11 11:55:58, Darrick J. Wong wrote:
> On Fri, Oct 06, 2023 at 08:49:09PM +0200, Andrey Albershteyn wrote:
> > As noted by Dave there are two problems with using fs-verity's
> > workqueue in XFS:
> > 
> > 1. High priority workqueues are used within XFS to ensure that data
> >    IO completion cannot stall processing of journal IO completions.
> >    Hence using a WQ_HIGHPRI workqueue directly in the user data IO
> >    path is a potential filesystem livelock/deadlock vector.
> > 
> > 2. The fsverity workqueue is global - it creates a cross-filesystem
> >    contention point.
> > 
> > This patch adds per-filesystem, per-cpu workqueue for fsverity
> > work.
> 
> If we ever want to implement compression and/or fscrypt, can we use this
> pread workqueue for that too?

I think yes.

> Sounds good to me...
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>

Thanks!

-- 
- Andrey

