Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC112C433E0
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Feb 2021 09:13:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8AF5864EBA
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Feb 2021 09:13:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230196AbhBIJNK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 9 Feb 2021 04:13:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230360AbhBIJLA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 9 Feb 2021 04:11:00 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 157A3C06178C
        for <linux-xfs@vger.kernel.org>; Tue,  9 Feb 2021 01:10:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=QarM1sllOayEKAFMp/UHRXKGPPrUXeXlQnAbut7oKqY=; b=cnLSJ5vdj04oLi8G3GK4wMOKN8
        29WOSLAFRVCj1hTmS3xBq75PF1otky6fGVgBUSMgK1hikMNDqfzUuapAnQEjDlsNe1pzveEluG4mw
        GNmkuNIGB05Wk/g+ySRpGLHeP0GKKupdmaNFMQYmLtO4rQAyuPajrZDb0gnIOqT5LWGdYRaPqFJZS
        bbiPb2k0+Qst14XXT5S4Q+MFkYuKyhsnSQkNAx/Shz5D74UmsV3sOlTsr8mg/+2RsKRJmmksEEu7d
        QBIWsR/rH9EHv8ZvYYLDjLNEJLYVBr3n4O1UFDz6pdqg22afMsoAQJi7CB9C+3kPk7lvSdkuOnwwV
        AzWN2GMg==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1l9P2G-007DBm-HM; Tue, 09 Feb 2021 09:10:16 +0000
Date:   Tue, 9 Feb 2021 09:10:16 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org, bfoster@redhat.com
Subject: Re: [PATCH 05/10] xfs_repair: clear quota CHKD flags on the incore
 superblock too
Message-ID: <20210209091016.GE1718132@infradead.org>
References: <161284380403.3057868.11153586180065627226.stgit@magnolia>
 <161284383258.3057868.6167060787728229726.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161284383258.3057868.6167060787728229726.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Feb 08, 2021 at 08:10:32PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> At the end of a repair run, xfs_repair clears the superblock's quota
> checked flags if it found mistakes in the quota accounting to force a
> quotacheck at the next mount.  This is currently the last time repair
> modifies the primary superblock, so it is sufficient to update the
> ondisk buffer and not the incore mount structure.
> 
> However, we're about to introduce code to clear the needsrepair feature
> at the very end of repair, after all metadata blocks have been written
> to disk and all disk caches flush.  Since the convention everywhere else
> in xfs is to update the incore superblock, call libxfs_sb_to_disk to
> translate that into the ondisk buffer, and then write the buffer to
> disk, switch the quota CHKD code to use this mechanism too.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
