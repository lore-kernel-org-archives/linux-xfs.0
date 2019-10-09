Return-Path: <SRS0=7gTY=YC=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30372ECE58D
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Oct 2019 15:02:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EF69A218AC
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Oct 2019 15:02:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="GRnhrk2h"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731645AbfJIPCH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 9 Oct 2019 11:02:07 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:54056 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731343AbfJIPCH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 9 Oct 2019 11:02:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=ErzSCYlit0RDbTvGU7VjwBFtzeLUA2Cgn0VuqfUSAeU=; b=GRnhrk2hX2ThAu+yQQA2eEUe9
        1k7oOYHUEpPkBNJuJGcCRgV1puyqNA94upN89qao8NwdzYpmHxWtFIJprJAdlpjK+HntPUwFQwoV4
        4M0wLkDLtY2RfZkYbs6kdy6J60kR6TuH1pkLGVylrVTtf69dp6JfRu1hlDCWqVy/ePa0KDooxliBr
        7Xob0Yqhq9ZeuMfO7JgMEExoiaPfebO/yO9C2AdW9yLuqCGBWk86d0IVnmP3osdCWVg8pJ6j2IgmU
        4PzDtK3byIdvTgRADylIap86EQ8LlntxpDwKuEeNHysdDZYjfxLTUBMz+QVIZ/FJIaOXnHxC6QerJ
        F6UMpZuYQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.2 #3 (Red Hat Linux))
        id 1iIDTb-0007nJ-0q; Wed, 09 Oct 2019 15:02:07 +0000
Date:   Wed, 9 Oct 2019 08:02:06 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Ian Kent <raven@themaw.net>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        David Howells <dhowells@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH v5 08/17] xfs: mount-api - move xfs_parseargs()
 validation to a helper
Message-ID: <20191009150206.GF10349@infradead.org>
References: <157062043952.32346.977737248061083292.stgit@fedora-28>
 <157062065250.32346.13350789812067183237.stgit@fedora-28>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157062065250.32346.13350789812067183237.stgit@fedora-28>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 09, 2019 at 07:30:52PM +0800, Ian Kent wrote:
> +#ifndef CONFIG_XFS_QUOTA
> +	if (XFS_IS_QUOTA_RUNNING(mp)) {
> +		xfs_warn(mp, "quota support not available in this kernel.");
> +		return -EINVAL;
> +	}
> +#endif

this can use IS_ENABLED.
