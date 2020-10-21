Return-Path: <SRS0=FA9X=D4=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19FC2C4363A
	for <linux-xfs@archiver.kernel.org>; Wed, 21 Oct 2020 09:37:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8651C2080C
	for <linux-xfs@archiver.kernel.org>; Wed, 21 Oct 2020 09:37:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=veeam.com header.i=@veeam.com header.b="ay80zau7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438089AbgJUJha (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 21 Oct 2020 05:37:30 -0400
Received: from mx4.veeam.com ([104.41.138.86]:52582 "EHLO mx4.veeam.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438077AbgJUJha (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 21 Oct 2020 05:37:30 -0400
Received: from mail.veeam.com (spbmbx01.amust.local [172.17.17.171])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx4.veeam.com (Postfix) with ESMTPS id 6A17487A40;
        Wed, 21 Oct 2020 12:37:27 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=veeam.com; s=mx4;
        t=1603273047; bh=tJsAbN1NcN6TjebUf8UeNi+/vIRbD2jLAJixwRT20K8=;
        h=Date:From:To:CC:Subject:References:In-Reply-To:From;
        b=ay80zau7ICyWOBC+G2DwpixnFknBiDy5+6dEvpL4XpdbZgFFslkrAPD9wxGbRqltw
         ksPnnHFiVxwIhsUDq3NvqSCgKYiqAIKUTYFUw2yf/42/oZkyaQgFkEeiEvr7qipqnr
         zOtxh6nD0E5MN6dCti9ZZUc3rYiMPrV95xlqFXPo=
Received: from veeam.com (172.24.14.5) by spbmbx01.amust.local (172.17.17.171)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.595.3; Wed, 21 Oct 2020
 12:37:25 +0300
Date:   Wed, 21 Oct 2020 12:37:27 +0300
From:   Sergei Shtepa <sergei.shtepa@veeam.com>
To:     Pavel Machek <pavel@ucw.cz>
CC:     "axboe@kernel.dk" <axboe@kernel.dk>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "hch@infradead.org" <hch@infradead.org>,
        "darrick.wong@oracle.com" <darrick.wong@oracle.com>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "rjw@rjwysocki.net" <rjw@rjwysocki.net>,
        "len.brown@intel.com" <len.brown@intel.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "johannes.thumshirn@wdc.com" <johannes.thumshirn@wdc.com>,
        "ming.lei@redhat.com" <ming.lei@redhat.com>,
        "jack@suse.cz" <jack@suse.cz>, "tj@kernel.org" <tj@kernel.org>,
        "gustavo@embeddedor.com" <gustavo@embeddedor.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "osandov@fb.com" <osandov@fb.com>,
        "koct9i@gmail.com" <koct9i@gmail.com>,
        "damien.lemoal@wdc.com" <damien.lemoal@wdc.com>,
        "steve@sk2.org" <steve@sk2.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH 2/2] blk-snap - snapshots and change-tracking for block
 devices
Message-ID: <20201021093727.GA20749@veeam.com>
References: <1603271049-20681-1-git-send-email-sergei.shtepa@veeam.com>
 <1603271049-20681-3-git-send-email-sergei.shtepa@veeam.com>
 <20201021090837.GA30282@duo.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20201021090837.GA30282@duo.ucw.cz>
X-Originating-IP: [172.24.14.5]
X-ClientProxiedBy: spbmbx02.amust.local (172.17.17.172) To
 spbmbx01.amust.local (172.17.17.171)
X-EsetResult: clean, is OK
X-EsetId: 37303A295605D26A677562
X-Veeam-MMEX: True
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

#pragma once still banned? I think need to add a check for this ./scripts/checkpatch.pl.
Comment code style - ok, thank you.
-- 
Sergei Shtepa
Veeam Software developer.
