Return-Path: <SRS0=3WhG=6P=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE549C47254
	for <linux-xfs@archiver.kernel.org>; Fri,  1 May 2020 08:08:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7F919214D8
	for <linux-xfs@archiver.kernel.org>; Fri,  1 May 2020 08:08:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="pYnJepK7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728313AbgEAIIF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 1 May 2020 04:08:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726452AbgEAIIE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 May 2020 04:08:04 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E461C035494
        for <linux-xfs@vger.kernel.org>; Fri,  1 May 2020 01:08:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=QfUWO04gG5dEmAqm++HzEQBhGivKmtGchl4mgGRqKFg=; b=pYnJepK787Vh8E6vz/h8wFz3JM
        VIcgjDAWY+hKeKSfjSPBKWu3Pkxw6rBa1wjK8VyFRzrMDeHm4qZ4kFlV9oXqnt4swE0jaKTXnaf63
        B+iBaiQvr1X4OvodGHtzVTmqkjmzBNty9laPCK3Q2kI4xr6uz4oyaIwpAXG+uaio/4yHMKWzq/rAl
        VzVKosMAqMxMimFlwafvaT34zLKU1OhSo0iZc+s3Wg7jzMJWROwU+MDoFt2yLugcjHQvhIYoqZTqF
        7JkB5RBbIwvetSf3uGOIgR2/ljB5DmzgkWPlvSnYOD/3WRaqE9QqvuM63OOVKrtroLZuyOWog2kTd
        xEtQCMiw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jUQiJ-0007me-Vn; Fri, 01 May 2020 08:08:03 +0000
Date:   Fri, 1 May 2020 01:08:03 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 01/21] xfs: refactor log recovery item sorting into a
 generic dispatch structure
Message-ID: <20200501080803.GC17731@infradead.org>
References: <158820765488.467894.15408191148091671053.stgit@magnolia>
 <158820766135.467894.13993542565087629835.stgit@magnolia>
 <20200430055309.GA29110@infradead.org>
 <20200430150821.GY6742@magnolia>
 <20200430181628.GB6742@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200430181628.GB6742@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Apr 30, 2020 at 11:16:28AM -0700, Darrick J. Wong wrote:
> Ok, so I looked into this, and I don't know of a good way to avoid
> exporting 14 *somethings*.  If we require a xlog_register_recovery_item
> call to link the item types when the module loads, something has to call
> that registration function.  That can be an __init function in each item
> recovery source file, but now we have to export all fourteen of those
> functions so that we can call them from init_xfs_fs.  Unless you've got
> a better suggestion, I don't think this is worth the effort.

Ok, let's keep the externs for now.
