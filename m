Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8A59C433E0
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Feb 2021 07:40:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5F68F64E09
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Feb 2021 07:40:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234797AbhBYHk3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 Feb 2021 02:40:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234800AbhBYHi4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Feb 2021 02:38:56 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 220C8C061788
        for <linux-xfs@vger.kernel.org>; Wed, 24 Feb 2021 23:38:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=aO1/t7JDSB04nxD0+toMJkkWhlOqAQUXDTZXJtJiEOc=; b=ZM2PHRmPX+P5/yAiIpRN+qwvmw
        /DUKVIxj96kgfuSPrbjHj0t3JecdnZJY6zm55CmYQTH5inmoV1emBsUo14eQV5h/knRPEjUJsh5Jp
        v9YfD4J3c2uNkcxIIB6jGkWV3xHuYpWxg9B5P551U8k8sQ8jfVZqIpngO57cNaTxwCQM60nUphEdI
        n9JCxfS6FOKU4BadEGww2B6u+1F0JqqU7RSZcKsYdinRLIS5pt5DdT1iS+K4RsZDshCbZh3s1Sf9j
        trc38T7uqAWNbzNLyPr9TOrn0hWlt2w40UbYri7Ic8uvTdcemRst8r5iDoOPN7ngwhj8ueBCwzJWK
        FMbBVrUg==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lFBDl-00AQ51-8w; Thu, 25 Feb 2021 07:38:02 +0000
Date:   Thu, 25 Feb 2021 07:38:01 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/3] xfs/{010,030}: update repair output to deal with
 inobtcount feature
Message-ID: <20210225073801.GB2483198@infradead.org>
References: <161319441183.403510.7352964287278809555.stgit@magnolia>
 <161319441737.403510.17676442588323841952.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161319441737.403510.17676442588323841952.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Feb 12, 2021 at 09:33:37PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Update both of these tests to filter out the new error messages from
> repair when the inode btree counter feature is enabled.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> Reviewed-by: Brian Foster <bfoster@redhat.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
