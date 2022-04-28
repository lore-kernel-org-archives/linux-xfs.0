Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33BE8C433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 28 Apr 2022 13:15:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230267AbiD1NSg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 28 Apr 2022 09:18:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235700AbiD1NSf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 28 Apr 2022 09:18:35 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1577C33A0F
        for <linux-xfs@vger.kernel.org>; Thu, 28 Apr 2022 06:15:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=9o1Jx9Q8tQ5adRvk3R8xb/l7Mt6RZ9HGYwKinsKCYQI=; b=HABECzoNCGW7YUo1EfQ8Z41O6D
        jOPnWlXIz4Sljbkh1uGNm8hUb882NkBJM5RWGKtURgtIul3Qx9v3ju7ibp+ROsmsxzKQkrLyQzX8K
        sDUKPUbDbI8WJWnghCAbjnFViCPELrNwmjLNTGOrXo2K/1mE8awBZzAs7brczdNwpS68B2UmCFe8z
        3bh92j+WYOAUatX8cFG/frjCEXl4W5s/jxqQ08k9isdT2+nm29vYBLC/w+8ABZpBDW1pFiyE+jDAU
        vAy+fRWkKBuA5PIWUeBEihlZzR54tuXD4z5O5fFKuhOu1Vb9emBExVmZn94s6ObyMhFePLi7mE1fM
        08tJFHKw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nk3zM-006wt5-ND; Thu, 28 Apr 2022 13:15:20 +0000
Date:   Thu, 28 Apr 2022 06:15:20 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 7/8] xfs: whiteouts release intents that are not in the
 AIL
Message-ID: <YmqTaO0rv/vsh7tT@infradead.org>
References: <20220427022259.695399-1-david@fromorbit.com>
 <20220427022259.695399-8-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220427022259.695399-8-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Apr 27, 2022 at 12:22:58PM +1000, Dave Chinner wrote:
> +	if (!atomic_dec_and_test(&buip->bui_refcount))
> +		return;
> +
> +	if (test_bit(XFS_LI_IN_AIL, &buip->bui_item.li_flags))
>  		xfs_trans_ail_delete(&buip->bui_item, SHUTDOWN_LOG_IO_ERROR);

Wouldn't it make more sense to just call xfs_trans_ail_delete with
shutdown_type set to 0 here?  That mean there will be another ail_lock
cycle if it isn't in the AIL (do we even need that the I think single
remaining other caller?), but the code would be simpler and 
self-documenting.

Same for the other instances.
