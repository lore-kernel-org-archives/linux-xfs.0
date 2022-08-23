Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D994C32793
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Aug 2022 07:22:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239257AbiHWHWG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 23 Aug 2022 03:22:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240690AbiHWHWE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 23 Aug 2022 03:22:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDBD662A8A;
        Tue, 23 Aug 2022 00:22:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 71DACB81BDE;
        Tue, 23 Aug 2022 07:22:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8B82C433C1;
        Tue, 23 Aug 2022 07:21:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661239319;
        bh=e9x9TwkptHkFi7m5kizk+IsBMTWlxe2MCiXeYCaPwIs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UJIcBxPwoSGJj+UZnzSGe2/7/tpMamcD5ZKWT87yzBtTqvfjU9DKkD94UIj34RY8K
         j+ajfpi4NrmKdpSFLRC79BxdySrf38JdiiSA50AhnbDAIALz7VBBx8rtDN6k43BvCT
         rycf/tWeXSSGAmfdqmoXE1U+6EZhaJiiRjdWZr9s=
Date:   Tue, 23 Aug 2022 09:21:48 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Leah Rumancik <leah.rumancik@gmail.com>
Cc:     stable@vger.kernel.org, linux-xfs@vger.kernel.org,
        amir73il@gmail.com
Subject: Re: [PATCH 5.15 0/9] xfs stable candidate patches for 5.15.y (part 4)
Message-ID: <YwSADLkBPNe7hZQs@kroah.com>
References: <20220819181431.4113819-1-leah.rumancik@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220819181431.4113819-1-leah.rumancik@gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Aug 19, 2022 at 11:14:22AM -0700, Leah Rumancik wrote:
> Hello,
> 
> Here's another round of xfs backports for 5.15.y that have been
> through testing and ACK'd.

All now queued up, thanks.

greg k-h
