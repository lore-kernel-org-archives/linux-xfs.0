Return-Path: <SRS0=jPpR=BA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06970C433E5
	for <linux-xfs@archiver.kernel.org>; Tue, 21 Jul 2020 14:58:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CBFC120729
	for <linux-xfs@archiver.kernel.org>; Tue, 21 Jul 2020 14:58:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="UgoVuKpX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728800AbgGUO6F (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 21 Jul 2020 10:58:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728700AbgGUO6F (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 21 Jul 2020 10:58:05 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AA25C0619DA
        for <linux-xfs@vger.kernel.org>; Tue, 21 Jul 2020 07:58:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=/VC97fv2Jo9vZpJ4aDuZVclOX3IHdf2rMxMJwiNTPW8=; b=UgoVuKpXfRPR68vvLJr600CGkH
        Pbr4nzi7Ux8Y2ovOo//1rKhO4tKkOp+MHekSCfF3mEyfHYvmRCDQ1Wpxu+jcJ3URGnHMWxvgCvnin
        Vj8HdnoxJUHdDaZyiqPESZLaeZ5Z8e7MBjt8kjeFzJN4gzuZATSKYiNA/ycju+K5iyaiHos1LdEVh
        0m4Z6SE2KM9S1AKBxnKB2jHlKboir1f+jXXvTsAbQjzBui58p8eh0abI5zrqUiqQgh7Il4xoYg/0/
        Jt5nnuTU8BGh1T36bn26U0OYPa17U+ydMkNRD7GLXrPpphFmEVCcPVWTnuZ4jg0PEGBK/M4kk0ew/
        OaHznlqA==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jxtiV-0001t1-Im; Tue, 21 Jul 2020 14:58:03 +0000
Date:   Tue, 21 Jul 2020 15:58:03 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 09/11] xfs: create xfs_dqtype_t to represent quota types
Message-ID: <20200721145803.GI6208@infradead.org>
References: <159488191927.3813063.6443979621452250872.stgit@magnolia>
 <159488197642.3813063.4673664984532713595.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159488197642.3813063.4673664984532713595.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 15, 2020 at 11:46:16PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Create a new type (xfs_dqtype_t) to represent the type of an incore
> dquot (user, group, project, or none).  Rename the incore dquot's
> dq_flags field to q_type.
> 
> This allows us to replace all the "uint type" arguments to the quota
> functions with "xfs_dqtype_t type", to make it obvious when we're
> passing a quota type argument into a function.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
