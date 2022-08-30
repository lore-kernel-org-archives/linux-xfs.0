Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2C1FECAAA1
	for <linux-xfs@archiver.kernel.org>; Tue, 30 Aug 2022 21:01:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231124AbiH3VBl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 30 Aug 2022 17:01:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230205AbiH3VBk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 30 Aug 2022 17:01:40 -0400
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [IPv6:2a03:a000:7:0:5054:ff:fe1c:15ff])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 420977C769;
        Tue, 30 Aug 2022 14:01:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=tuW9Op8uxMm/s5nLDNhxNasVJzG36UM1W1yibCDcVxs=; b=aMj5jIDmRLUduMeC5sf764/02f
        ix+O9yo9c/B3Sm4b7XR1aXSypCXq+DgltDjDGAmsBlEG1ToVq7myUiP1rM8IOhYK2uj+3fHSZ1j7Z
        5VZxuGEnZ6J95mysPnGaKoNBEaQgPhdWO3O7+wcwEo8i0AKPhjXObG/2OqYavyFXR/k4hGaezQQmB
        wjsYmCS2AB57s2wSPBlH3E4wXHse7WdOnuSUq4W3k207Gp88aEGSUtXQ18rG0vz25HXJsNhaK2kaQ
        Unfolnqa7450aXTHXZcm7eIsRw4slhVpR9XMNXtcfpcuNnimXuI0gGj/ROPB9zS3yJde7Vipnzt8u
        hRCPyJ5w==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.95 #2 (Red Hat Linux))
        id 1oT8MX-00ALCc-DZ;
        Tue, 30 Aug 2022 21:01:33 +0000
Date:   Tue, 30 Aug 2022 22:01:33 +0100
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     linux-doc@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org,
        Christian Brauner <brauner@kernel.org>,
        Seth Forshee <sforshee@kernel.org>
Subject: Re: [PATCH] Documentation: filesystems: correct possessive "its"
Message-ID: <Yw56rVwBRg0LbC41@ZenIV>
References: <20220829235429.17902-1-rdunlap@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220829235429.17902-1-rdunlap@infradead.org>
Sender: Al Viro <viro@ftp.linux.org.uk>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Aug 29, 2022 at 04:54:29PM -0700, Randy Dunlap wrote:
>  compress_log_size=%u	 Support configuring compress cluster size, the size will
> -			 be 4KB * (1 << %u), 16KB is minimum size, also it's
> +			 be 4KB * (1 << %u), 16KB is minimum size, also its
>  			 default size.

That one doesn't look like possesive to me - more like "default size is 16KB and
values below that are not allowed"...
