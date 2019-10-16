Return-Path: <SRS0=pjFm=YJ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8E3DECE588
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Oct 2019 08:36:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7402621835
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Oct 2019 08:36:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="YGSFd9rC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729578AbfJPIgr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 16 Oct 2019 04:36:47 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:50640 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726804AbfJPIgr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 Oct 2019 04:36:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=9Vc+32EUtJF1alVhmtvHmrvsV3IA6/7Wf8GNawMgTcI=; b=YGSFd9rCVjSur4+63SSozD0dc
        a6oGpG/vILVDsRzx5BdWqDX3MxX8PuKX2zlqjykjS4PqtVBENfDf87s9e/CwRNy5M28KJ2QanlQlZ
        3U7EB8ao+fyIbBe3CQUd4JU46s29Orheumok18af98YJzV4e+rxzNzbkgzn21U6GTB5DchyxsVmW6
        1ABdqgRD4GlCcDZjpv2Jtv07NghD/slTQg76PmcXtzHADe9/z6vONn0UPNIoJj5KdCWEkIbpf6XXk
        lpz8AdyGFEpn9/wfDOSVrZcOyo7DSxPA4bxC4WkpBx5E0zlUKePscYx0qxTLlT8b0UicX1sTQFkSK
        oo3t4pZ9w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iKenW-0005fR-La; Wed, 16 Oct 2019 08:36:46 +0000
Date:   Wed, 16 Oct 2019 01:36:46 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Ian Kent <raven@themaw.net>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        David Howells <dhowells@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH v6 11/12] xfs: dont set sb in xfs_mount_alloc()
Message-ID: <20191016083646.GI29140@infradead.org>
References: <157118625324.9678.16275725173770634823.stgit@fedora-28>
 <157118650328.9678.16779922388175839197.stgit@fedora-28>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157118650328.9678.16779922388175839197.stgit@fedora-28>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 16, 2019 at 08:41:43AM +0800, Ian Kent wrote:
> When changing to use the new mount api the super block won't be
> available when the xfs_mount info struct is allocated so move
> setting the super block in xfs_mount to xfs_fs_fill_super().
> 
> Also change xfs_mount_alloc() decalaration static -> STATIC.

Looks fine:

Reviewed-by: Christoph Hellwig <hch@lst.de>
