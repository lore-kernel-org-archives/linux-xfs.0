Return-Path: <SRS0=dZhK=A2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10F25C433E8
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Jul 2020 18:44:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E22F62065F
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Jul 2020 18:44:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="UESP5hPC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726715AbgGOSoZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Jul 2020 14:44:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726354AbgGOSoZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 Jul 2020 14:44:25 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 364EAC061755
        for <linux-xfs@vger.kernel.org>; Wed, 15 Jul 2020 11:44:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=uVH1Moyrb9OzH55A13dZ0EJLLQ3oElby+zMtsJ8XfwE=; b=UESP5hPC9cCaniLUObUGjSx41z
        J8O7D90Uf0UY/zyUSUfqYBP2fCotciqXi6XlVfanObQvk+sfGbZt8ssGp3K8JT4fHVKySxFmpYppX
        eCK1E0ZMdtuZ2uYEB/JB52pnJRXI5lV6o66ZvSfSGlyKPWE71UMYA80eUvff8+JkMfeztjGUMHSG4
        WYrjAt3bilxj6+iEvJR7wKWP2lLc7ftK1Xx4K5mFL4YCTwdMA1aH8R8sEgrBZpB+/yKiw8oodpKuL
        ijf39zOzuXMPK+bdxYZxECcr6QvuEzhjElVejSB4PlY1vdWPGVZUrnlYhlLzpuM7Vk9VUOBog/ChG
        EprOlwMw==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jvmOF-0006H4-UA; Wed, 15 Jul 2020 18:44:23 +0000
Date:   Wed, 15 Jul 2020 19:44:23 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/4] repair: remove custom dir2 sf fork verifier from
 phase6
Message-ID: <20200715184423.GD23618@infradead.org>
References: <20200715140836.10197-1-bfoster@redhat.com>
 <20200715140836.10197-5-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200715140836.10197-5-bfoster@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 15, 2020 at 10:08:36AM -0400, Brian Foster wrote:
> The custom verifier exists to catch the case of repair setting a
> dummy parent value of zero on directory inodes and temporarily
> replace it with a valid inode number so the rest of the directory
> verification can proceed. The custom verifier is no longer needed
> now that the rootino is used as a dummy value for invalid on-disk
> parent values.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
