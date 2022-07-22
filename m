Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 299A3CCA48D
	for <linux-xfs@archiver.kernel.org>; Fri, 22 Jul 2022 08:11:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234695AbiGVILq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 22 Jul 2022 04:11:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230367AbiGVILo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 22 Jul 2022 04:11:44 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8577E9CE04;
        Fri, 22 Jul 2022 01:11:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=ta3rvx+Batm6nlecC0K7iwKchb/Me2mo/w2bTMnndwY=; b=Icpp3ZraJ98dzkqejg7ojIFZlW
        twhBghYZj8E0XytNLt5zspXTcWQ9DdL0bSjxTxEf8HvC4iii/6mfrgHZqL+86uIfAarieFyUa4mZk
        QVCe6tpTIigKLnLYC0/U+Cwsn2ooqs/VGY+HpeCzDCbl1QRRbBVyRSGjTTATVDKHepfiwvvOq7X7f
        9ugB6djOL1o1F2qEXRT2AC456mpMcxlXm8ncni/gOi/3Ur5oa8ATDDRQd+3jGJ9ROxV9fIEMxTsR4
        heID/JaqnPVRGe58CI6SMsk28zG5vle3mGee6VSe1P61JQnjJxyIwKKABdDlsVZnth2Gd+iXmdprl
        TTE2a/fA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oEnl9-000uTi-6h; Fri, 22 Jul 2022 08:11:43 +0000
Date:   Fri, 22 Jul 2022 01:11:43 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org,
        linux-api@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        Keith Busch <kbusch@kernel.org>
Subject: Re: [PATCH v4 9/9] xfs: support STATX_DIOALIGN
Message-ID: <Ytpbv1sDoh8pqWXx@infradead.org>
References: <20220722071228.146690-1-ebiggers@kernel.org>
 <20220722071228.146690-10-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220722071228.146690-10-ebiggers@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jul 22, 2022 at 12:12:28AM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> Add support for STATX_DIOALIGN to xfs, so that direct I/O alignment
> restrictions are exposed to userspace in a generic way.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
