Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C3EBC433E9
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Mar 2021 12:59:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 18A7F64FE9
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Mar 2021 12:59:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233061AbhCKM6u (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 11 Mar 2021 07:58:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233308AbhCKM6p (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 11 Mar 2021 07:58:45 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3308C061574;
        Thu, 11 Mar 2021 04:58:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=YZ1XqX7sSrMCL5GhLe95BObBDalJctddeY72Ra2tNxo=; b=M0ci0OF89oP1o70IM3IBZ7yHnq
        A0J+4mEvfFmI4oDHbZdzdbPixLvzG5VDjo5H+Yu6NnAedvyJv6X0jOcDnNplg8du4tTAphw1PauY/
        GojniwXsThjkuIAq7y5uEAluB4rdleLAwStuoM+V9ncuVs2r6KL/G0KJn8O+CdGkilrvsGtONMBam
        5Zt5gvS7jbAhNNraMX50T4MSX+sC8Uqpj+kDk3QWWA5k+Ch1qJ6gps7Pxca2UqFj5raoayjH5wCAM
        BxTyJ5eZ7SbpAr+P830y9zD9IeDwlkp0bxgRwz6vk+LV0A8gWXBY8v3SiaJ1BoPX7uwN+I4+HkioL
        nWC81VVQ==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lKKtO-007KVD-IM; Thu, 11 Mar 2021 12:58:21 +0000
Date:   Thu, 11 Mar 2021 12:58:18 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     guaneryu@gmail.com, Chandan Babu R <chandanrlinux@gmail.com>,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Subject: Re: [PATCH 07/10] xfs/122: fix test for xfs_attr_shortform_t
 conversion
Message-ID: <20210311125818.GE1742851@infradead.org>
References: <161526480371.1214319.3263690953532787783.stgit@magnolia>
 <161526484222.1214319.7083379928394196240.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161526484222.1214319.7083379928394196240.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Mar 08, 2021 at 08:40:42PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> The typedef xfs_attr_shortform_t was converted to a struct in 5.10.
> Update this test to pass.

Or rather the typedef was removed, the struct always existed.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
