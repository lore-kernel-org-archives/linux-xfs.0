Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E241DC433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 19 May 2022 07:05:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233486AbiESHFb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 19 May 2022 03:05:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232578AbiESHF0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 19 May 2022 03:05:26 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5D4DBA540;
        Thu, 19 May 2022 00:05:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=Y8eCw9I+3GvyTeVsRu3iF7t/os
        G5K0v/pABcPNYA/V0ySZ5E9fkOtBGPudPc7DriUmkcsyHFP8EsG9WxdN9TewBjWVOWV10Jxsbf/UN
        Kf3GgIakz9FIVHnUru632fnhkjetHZQYyPHNbFFyQ7cAMakjsZLeTkuapE48frmxWX2ocElecbgnJ
        JAZYj+qxEJPzjib8lR5dFxutcI0flYsVohHR/3ID1f0UiX+dAPFmPTCf4eqqurs0hfQvWqpQvlPRS
        16P3nvlTZBXQnBV4/y+ZgZ+hbxzxdE1V5qysznl2OlcRjhL3slS9C/QSVMbKHfsEdm7X7Iazzwm5z
        u4uWYH6g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nraDs-005QR0-D6; Thu, 19 May 2022 07:05:24 +0000
Date:   Thu, 19 May 2022 00:05:24 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org,
        linux-api@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        Keith Busch <kbusch@kernel.org>
Subject: Re: [RFC PATCH v2 1/7] statx: add I/O alignment information
Message-ID: <YoXsNDG/WMbCzz0x@infradead.org>
References: <20220518235011.153058-1-ebiggers@kernel.org>
 <20220518235011.153058-2-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220518235011.153058-2-ebiggers@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
