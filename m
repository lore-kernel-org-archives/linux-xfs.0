Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF7F6C43334
	for <linux-xfs@archiver.kernel.org>; Mon, 11 Jul 2022 06:59:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229628AbiGKG71 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 11 Jul 2022 02:59:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbiGKG70 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 11 Jul 2022 02:59:26 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CDEC764A
        for <linux-xfs@vger.kernel.org>; Sun, 10 Jul 2022 23:59:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=lcKuivU4uZeBIClSocr4yHfGq4kV8U/Pau8prEFMRvw=; b=QkMYYaXKpyQlMkw7kCuzmTQuID
        2M/nNIOG5aUDQvsnS1imkiH8bpS9dqidczPcHL+zlUDyWQaLOvQynp4M19UG3LtNKCjvrDxYaDe2H
        i2mVmRpcZlFKjZLcUjoK4f1zTdN6LVP9j1CObdBxLMw0xa3DptxwiFvQtLeIAOW6bHjMpd06cojeL
        Nh2Xtw3/gdmlScXgnhmdRvccYa4e9D9aWn8NfkCfE21tTuiqx+R9fNkTM3JuB9HhacnbA+Sx1P2a7
        PFdMrniEqGGZ13/S3GvoKytDICH1EhpqTKh5Acw7RCgpg5EA3ig3jaG2K2ZXiVt/wFr1mP2DrCFwq
        Y+SUKIhg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oAnO8-00GZ21-UA; Mon, 11 Jul 2022 06:59:24 +0000
Date:   Sun, 10 Jul 2022 23:59:24 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 8/8] xfs: grant heads track byte counts, not LSNs
Message-ID: <YsvKTBufcBi32z88@infradead.org>
References: <20220708015558.1134330-1-david@fromorbit.com>
 <20220708015558.1134330-9-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220708015558.1134330-9-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jul 08, 2022 at 11:55:58AM +1000, Dave Chinner wrote:
> +void
>  xlog_grant_sub_space(
>  	struct xlog		*log,
>  	struct xlog_grant_head	*head,
>  	int			bytes)
>  {
> +	atomic64_sub(bytes, &head->grant);
>  }
>  
>  static void
> @@ -165,93 +144,34 @@ xlog_grant_add_space(
>  	struct xlog_grant_head	*head,
>  	int			bytes)
>  {
> +	atomic64_add(bytes, &head->grant);
>  }

These probably make more senses as inlines and can you can drop their log
agument as well.  Or maybe just drop these helpers entirely?
