Return-Path: <SRS0=xOwi=4F=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC41FC34021
	for <linux-xfs@archiver.kernel.org>; Mon, 17 Feb 2020 13:53:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9B8B6206E2
	for <linux-xfs@archiver.kernel.org>; Mon, 17 Feb 2020 13:53:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="bkUPiq3u"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728797AbgBQNx2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 17 Feb 2020 08:53:28 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:59230 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727448AbgBQNx1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 Feb 2020 08:53:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=UXK/bQny5+KUv0rn92L65IsgQZJi/qm0kv/36wSrr5M=; b=bkUPiq3ungRyfCa+uAH2oTsp/S
        fDuZ1TiCbX66rJ/LDPuDR0uFmSAcjyqbefhBoCv/RVBSej+fXw7opsdFdBw5QGloIsvae3FJZ1LCA
        u7JDz2cuDzf6OeucCmcixx5QFBUOFyU6qD9Uy4hiy8CZGGQe2dZ2Aj5KurjQ4U88dSRblPIeQaUkq
        mddy+bmFLFQ0hk8CslTVppiDyjDDlJhIWsNwGS6kT/+Lrm9XBYHfgTPGAi4UMGGvQxEyi8E5QQEIF
        35a/EXVMP4UtOO5t3rTINrw2QXr069AKQIrYYC4qQEk8/9CzYrFdKTgohhuleRLZyWpD7Kfy/9cSO
        zOtBgsUQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j3gpy-0001r7-Gl; Mon, 17 Feb 2020 13:53:26 +0000
Date:   Mon, 17 Feb 2020 05:53:26 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org,
        Eric Sandeen <sandeen@redhat.com>, alex@zadara.com
Subject: Re: [PATCH 5/7] xfs_repair: use libxfs function to calculate root
 inode location
Message-ID: <20200217135326.GI18371@infradead.org>
References: <158086359783.2079685.9581209719946834913.stgit@magnolia>
 <158086362904.2079685.11538498774856180130.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158086362904.2079685.11538498774856180130.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Feb 04, 2020 at 04:47:09PM -0800, Darrick J. Wong wrote:
> +	rootino = libxfs_ialloc_calc_rootino(mp, mp->m_sb.sb_unit);
>  
> +	validate_sb_ino(&mp->m_sb.sb_rootino, rootino,
>  			_("root"));
> +	validate_sb_ino(&mp->m_sb.sb_rbmino, rootino + 1,
>  			_("realtime bitmap"));
> +	validate_sb_ino(&mp->m_sb.sb_rsumino, rootino + 2,

I think the first two calls don't need to be split over two lines.

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
