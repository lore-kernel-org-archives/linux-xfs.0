Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2528EECAAD3
	for <linux-xfs@archiver.kernel.org>; Sun,  4 Sep 2022 13:16:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233865AbiIDNQL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 4 Sep 2022 09:16:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233694AbiIDNQJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 4 Sep 2022 09:16:09 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D59FB32ECE
        for <linux-xfs@vger.kernel.org>; Sun,  4 Sep 2022 06:16:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662297364;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=yJ5kx5GSVqmDyMggaz6MuQ7w9VCEp5UcT1diD2YpI2E=;
        b=FxWHv0Jy0KoW017ENyzPNcJsP1bc7zNV5usq9K/pJbznCm3xBlazZVf4wkVXGauboCFsSb
        oUj7AWsyUiTq4FPBlRrkGlVUtuLg7kvgvBD4+nX+ohsotmQOL1B/4mQ0sYe4jKP/bH+64H
        uJPMb+9zEg4dC9SPnoPaV7493HohOa4=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-639-pHT-nE5jNJGd3T7DNYt3uQ-1; Sun, 04 Sep 2022 09:16:00 -0400
X-MC-Unique: pHT-nE5jNJGd3T7DNYt3uQ-1
Received: by mail-qt1-f200.google.com with SMTP id v5-20020ac873c5000000b003434ef0a8c7so5200795qtp.21
        for <linux-xfs@vger.kernel.org>; Sun, 04 Sep 2022 06:16:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=yJ5kx5GSVqmDyMggaz6MuQ7w9VCEp5UcT1diD2YpI2E=;
        b=yv4pwIbZBKCOXtLSIFziaG+haJjjqnsXdrX3YpsRti1BE+S2CHL98HaRQ/aoa3pdxZ
         ncoAsTwdhDrvVyj/60ENkvujZfSLr+grpZEHumsJRNHTsNSW0v7B7IKh5VdTAr3fLkKu
         1Ep1M1k9XqVB9YKNSLl2PU6qR9LZU/5I9jTSrI0406qdJbHFCEcPJuGqYBja3l6TfamG
         6M2cj5UhNBSiqvud0NeNvR+l8Xc7Pds0dpAx33SD/8DMVrtpSGlQUMFFB3Va+nkoYwDj
         kii60JYj7H9TV9vru1hy/89vKdikO0oCbsUGd6I230awLPtxtcFnHrZtl/9lX7lpkKFp
         y73g==
X-Gm-Message-State: ACgBeo22qpiuPsqjkWV7Xm9rOIh/+PMwOPK7Lgq8jO7de4XGEcsmWx5L
        RmPv4kmfGacQcoIZfCCNGelxv0ShGotLBkIBoT6xxkiWqbTK9lwQ8iAVfeIbeJv8gjCwplf8kce
        IhXH4vcfdMbAb2IXRsRAo
X-Received: by 2002:a05:622a:95:b0:343:66b1:d32a with SMTP id o21-20020a05622a009500b0034366b1d32amr35221188qtw.32.1662297359302;
        Sun, 04 Sep 2022 06:15:59 -0700 (PDT)
X-Google-Smtp-Source: AA6agR73D/KejJPoRZVOG1bs+e3JWf8wwl21iYdMBPVw1L5/bD73hUocaF4XSUQctjWKIEzxEUeHDA==
X-Received: by 2002:a05:622a:95:b0:343:66b1:d32a with SMTP id o21-20020a05622a009500b0034366b1d32amr35221169qtw.32.1662297359104;
        Sun, 04 Sep 2022 06:15:59 -0700 (PDT)
Received: from zlang-mailbox ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id l2-20020ac87242000000b0034455ff76ddsm4941002qtp.34.2022.09.04.06.15.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Sep 2022 06:15:58 -0700 (PDT)
Date:   Sun, 4 Sep 2022 21:15:53 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     "fstests@vger.kernel.org" <fstests@vger.kernel.org>
Cc:     Linux NFS Mailing List <linux-nfs@vger.kernel.org>,
        Chuck Lever III <chuck.lever@oracle.com>,
        djwong@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: generic/650 makes v6.0-rc client unusable
Message-ID: <20220904131553.bqdsfbfhmdpuujd3@zlang-mailbox>
References: <3E21DFEA-8DF7-484B-8122-D578BFF7F9E0@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3E21DFEA-8DF7-484B-8122-D578BFF7F9E0@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Sep 03, 2022 at 06:43:29PM +0000, Chuck Lever III wrote:
> While investigating some of the other issues that have been
> reported lately, I've found that my v6.0-rc3 NFS/TCP client
> goes off the rails often (but not always) during generic/650.
> 
> This is the test that runs a workload while offlining and
> onlining CPUs. My test client has 12 physical cores.
> 
> The test appears to start normally, but then after a bit
> the NFS server workload drops to zero and the NFS mount
> disappears. I can't run programs (sudo, for example) on
> the client. Can't log in, even on the console. The console
> has a constant stream of "can't rotate log: Input/Output
> error" type messages.
> 
> I haven't looked further into this yet. Actually I'm not
> quite sure where to start looking.
> 
> I recently switched this client from a local /home to an
> NFS-mounted one, and that's where the xfstests are built
> and run from, fwiw.

If most of users complain generic/650, I'd like to exclude g/650 from the
"auto" default run group. Any more points?

Thanks,
Zorro

> 
> 
> --
> Chuck Lever
> 
> 
> 

