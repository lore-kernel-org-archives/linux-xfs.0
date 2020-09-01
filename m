Return-Path: <SRS0=ZxTw=CK=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEABEC433E2
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Sep 2020 09:05:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 965912071B
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Sep 2020 09:05:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="btsV4Ppp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726078AbgIAJFD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 1 Sep 2020 05:05:03 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:59483 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725989AbgIAJFC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Sep 2020 05:05:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598951101;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ZRMfd1Ojg52uZn3PpFFKZFU8lGZ3/xBuEGUrM++javY=;
        b=btsV4PppFMfpHn+ZxVVCvX6+b9t9XVgoyjYlFsJbQL0f2YVyeViErVkyj5y96EB1q0AL00
        Fm/1RbrVxZoacDemIGqa3P8TdrIXXBJW81AeZUKDkcZ3VhJGJwCTf4rCEjSS8c8T20puCS
        gXEdaILzknC48e6Tpz4HdeiXswYm8Sc=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-256-Jgg3paeJNK6GdO9JvrDWdA-1; Tue, 01 Sep 2020 05:04:59 -0400
X-MC-Unique: Jgg3paeJNK6GdO9JvrDWdA-1
Received: by mail-pl1-f198.google.com with SMTP id w20so291722plp.8
        for <linux-xfs@vger.kernel.org>; Tue, 01 Sep 2020 02:04:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=ZRMfd1Ojg52uZn3PpFFKZFU8lGZ3/xBuEGUrM++javY=;
        b=ZKOskXkMSgjEOg4KefKRvc/rd6vgdnzcWx/6mMDCbYAiX1yrDrP2XaAt4pX6bfrcQQ
         JJ+r5db1/9OxY9miTQWL6Zmv63Y5b5YvL9dC3MP5JIKgLTxSOptyCS2aQLiwdFYV5atI
         IMX/wpSnLIdF8ODlRwM5njVg8gknAieYb5I5shi0VsXdnmcq9mggsD5MdtC9VZ7pVCXe
         qbll+V+maFHiopW8EjM9vfZMO/XLabIUtGVi0A6zWkqjOUIe0caF4XHi+6xcri3TRc2n
         i0UHQLxPWTz2B86xWPJpU6eWf074gu8huNckrXvtJnq1b+N0BkhHROh64Grp6Xu858Ik
         m96w==
X-Gm-Message-State: AOAM532HfBzP7vAZqVtvrZ9q2OXRhXrC7wYpCnHdH96cWtfyFTCPfsVI
        dg8JhLPi4qbxPanlsefR1IZznaibFuuRJrvMNkx070tjYJ3l8gs7lPmSjHlORzEuiLVsqn0iD8C
        A/D4RKUUKDKElhOTmcBDE
X-Received: by 2002:a17:902:7b8a:: with SMTP id w10mr534587pll.145.1598951098309;
        Tue, 01 Sep 2020 02:04:58 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwgVEfhUKCICpeasyQdRbsj6+iSaKLWY728G4THgiBwssk0bjYKu4NMAij/DL8g1Anb4GApQg==
X-Received: by 2002:a17:902:7b8a:: with SMTP id w10mr534574pll.145.1598951098084;
        Tue, 01 Sep 2020 02:04:58 -0700 (PDT)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id i1sm1264224pgq.41.2020.09.01.02.04.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Sep 2020 02:04:57 -0700 (PDT)
Date:   Tue, 1 Sep 2020 17:04:47 +0800
From:   Gao Xiang <hsiangkao@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     david@fromorbit.com, hch@infradead.org, linux-xfs@vger.kernel.org,
        amir73il@gmail.com, sandeen@sandeen.net
Subject: Re: [PATCH 07/11] xfs: redefine xfs_ictimestamp_t
Message-ID: <20200901090447.GD32609@xiangao.remote.csb>
References: <159885400575.3608006.17716724192510967135.stgit@magnolia>
 <159885405305.3608006.13513560786992998269.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159885405305.3608006.13513560786992998269.stgit@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Aug 30, 2020 at 11:07:33PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Redefine xfs_ictimestamp_t as a uint64_t typedef in preparation for the
> bigtime functionality.  Preserve the legacy structure format so that we
> can let the compiler take care of the masking and shifting.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Reviewed-by: Gao Xiang <hsiangkao@redhat.com>

Thanks,
Gao Xiang

