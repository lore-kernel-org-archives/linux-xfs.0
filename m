Return-Path: <SRS0=e/GO=67=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A0BAC433DF
	for <linux-xfs@archiver.kernel.org>; Sun, 17 May 2020 09:58:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 31A0B20727
	for <linux-xfs@archiver.kernel.org>; Sun, 17 May 2020 09:58:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="kZsBaD5b"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727123AbgEQJ6T (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 17 May 2020 05:58:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727082AbgEQJ6T (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 17 May 2020 05:58:19 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 604D6C061A0C
        for <linux-xfs@vger.kernel.org>; Sun, 17 May 2020 02:58:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=rKLJyq0WJmjuB7W3FbUVFVtgbN+XLsm0xYYbxddt84U=; b=kZsBaD5b+XsnrzXLMBfraZddjG
        wSRYTAPIirb6KKPijYcsyek/Bf+oVoo8f3z7waxONbi6bcL4+RIDEqXsK+dqxx2ZKrqw9HgDS3hhA
        nEx/T5mvo/mkyeMprIXZwq4CF+DGDZJek+8UJVOxfNxSiGx72LQF7xYNvKDCVYeKFeT1Mr2AqK+sL
        dDvysTKkB5chvzrVCA91ZgqXZF9rNQzWi10kPc98X9yY4bA9s6PnnbIaPpMKUIHjjA1Xjm6ZveKvp
        fyD4+eEUbRoO84L4sfNvj7U9LgpJA/klpPyiQIRGNYVEQs0Mfwj6Y+rwkkNXA9ejGvnLeixzCsbw5
        hGfd1XHw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jaG3i-0000IP-Qo; Sun, 17 May 2020 09:58:14 +0000
Date:   Sun, 17 May 2020 02:58:14 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH, RFCRAP] xfs: handle ENOSPC quota return in
 xfs_file_buffered_aio_write
Message-ID: <20200517095814.GA441@infradead.org>
References: <e6b9090b-722a-c9d1-6c82-0dcb3f0be5a2@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e6b9090b-722a-c9d1-6c82-0dcb3f0be5a2@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, May 14, 2020 at 04:43:36PM -0500, Eric Sandeen wrote:
> +		if (ret == -EDQUOT ||
> +		    (ret == -ENOSPC && ip->i_pdquot &&
> +		     XFS_IS_PQUOTA_ENFORCED(mp) && ip->i_pdquot)) {
> +			xfs_iunlock(ip, iolock);
> +			enospc |= xfs_inode_free_quota_eofblocks(ip);
> +			enospc |= xfs_inode_free_quota_cowblocks(ip);
> +			iolock = 0;

Fun fact of the day: xfs_inode_free_quota_eofblocks and
xfs_inode_free_quota_cowblocks don't actually do anything for project
quotas.  I've started to prepare a little cleanup series to help
implementing what you want.  Give me some time to do a quick test
run and send it out.
