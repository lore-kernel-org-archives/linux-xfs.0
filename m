Return-Path: <SRS0=R4OI=CF=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB018C433DF
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Aug 2020 13:44:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C0450207CD
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Aug 2020 13:44:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727772AbgH0Nnz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 Aug 2020 09:43:55 -0400
Received: from sandeen.net ([63.231.237.45]:56220 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726188AbgH0Nnv (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 27 Aug 2020 09:43:51 -0400
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id B2D3F2ACC;
        Thu, 27 Aug 2020 08:43:20 -0500 (CDT)
Subject: Re: [PATCH V2] xfs: fix boundary test in xfs_attr_shortform_verify
To:     Christoph Hellwig <hch@infradead.org>,
        Eric Sandeen <sandeen@redhat.com>
Cc:     linux-xfs@vger.kernel.org
References: <63722af5-2d8d-2455-17ee-988defd3126f@redhat.com>
 <689c4eda-dd80-c1bd-843f-1b485bfddc5a@redhat.com>
 <20200827081239.GC7605@infradead.org>
From:   Eric Sandeen <sandeen@sandeen.net>
Message-ID: <2087b7d7-2210-17a1-3b92-12519d945866@sandeen.net>
Date:   Thu, 27 Aug 2020 08:43:32 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.1.1
MIME-Version: 1.0
In-Reply-To: <20200827081239.GC7605@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 8/27/20 3:12 AM, Christoph Hellwig wrote:
> Looks good,
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> Can you follow up with the struct definition fix ASAP?

Working on delegating that task, yes.

-Eric
