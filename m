Return-Path: <SRS0=OQuR=ZA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD678C5DF60
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Nov 2019 06:30:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6924321D6C
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Nov 2019 06:30:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=themaw.net header.i=@themaw.net header.b="o7oqq6mo";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="SRU8MFUP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725730AbfKHGaF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 8 Nov 2019 01:30:05 -0500
Received: from wout3-smtp.messagingengine.com ([64.147.123.19]:52481 "EHLO
        wout3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725372AbfKHGaF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 8 Nov 2019 01:30:05 -0500
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id 2709B5A2;
        Fri,  8 Nov 2019 01:30:04 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Fri, 08 Nov 2019 01:30:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=themaw.net; h=
        message-id:subject:from:to:cc:date:in-reply-to:references
        :content-type:mime-version:content-transfer-encoding; s=fm1; bh=
        9AWth8NtH6iy/A3w/xpNONmPLTZreNK3+86K5me1qgE=; b=o7oqq6monJnK7udh
        CK/M9HGVxLM50jG1RxAXDOyD10rl/wiCaDV6feans4P2I58hg9+2YfrZOY8NAt9c
        Jwc4OE1x3WthILck5jNJH88cWn/TJCNzcUJTg6CZO8+gQBM3HwYJpAhF+E/a2w5i
        9hBLPmEOfqURp7Sw5BSLm+CoPQHLwBWqI1iOqQUsYlDKhONiTySyZauFDHbYh3x8
        qLS29Q5SqV4cqvBx7WpM/Zg0mLcevtqfgHtQa07bTULUHIn7c4+cTAoMjGdKnbOr
        ssmp/+u24kfcA6qEIy3qpoc4Y/gI9ktBdCSUaNJQH9iriZ1rKIch2mYn+CSI/b8l
        4drFlg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm1; bh=9AWth8NtH6iy/A3w/xpNONmPLTZreNK3+86K5me1q
        gE=; b=SRU8MFUPK9Ls4vEG1BkhythbN6gZqlKyIOeNDP+CSxnwDDYKHj8D2IOqd
        yGtF79mEovTcj3nCbWPUhWPEftgssOJ2aQ3uobNuBpPCk+AAurw/Zh1ciJrI3z9G
        BsitiQ0yJYAaR6ktNczuymmEn51URMLEJmvqF2sqAVXRmN5xWtLazDPjKp10h11J
        jxPjf2lrMEgpLkQRZyrbGGTZDZda6PPNBX+A1NEWQFpQimlbIwMwfzVDDqxSucfr
        ae+fNj6h+Op5eg2KhFb/Y+Z7H0DOD2FbxmUCtOCNxwYxsNFt9uFxOrIOCteP5GCV
        8toFsogRmFfr1AuvRR5idCnuaHXUw==
X-ME-Sender: <xms:awvFXR8MZs8V_JkqwB9_JplgaUjEWIibKUfjwhs4vw-78gLJ48Iuxw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedruddvtddgleejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepkffuhffvffgjfhgtfggggfesthejredttderjeenucfhrhhomhepkfgrnhcu
    mfgvnhhtuceorhgrvhgvnhesthhhvghmrgifrdhnvghtqeenucfkphepuddukedrvddtke
    drudekledrudeknecurfgrrhgrmhepmhgrihhlfhhrohhmpehrrghvvghnsehthhgvmhgr
    fidrnhgvthenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:awvFXRbTjRjpkdV_vLz8ZkkWF1r4hVzyvQdVBMiuMCZ2MPbjT3WbAA>
    <xmx:awvFXZv9mCgzU7PnfT8VioRWw8inzvZtGP8W9tPj6oJk8uZPXqoRfA>
    <xmx:awvFXWaEC8Aapn2J46WD9z5oVHtYoV6gEJfKgyg43zEmw5dU_Rdyhg>
    <xmx:awvFXYEyEi6NpZUekZt0nnC2CSlBXJgPn0IaOHjtXVu2HZjbjlnRuQ>
Received: from mickey.themaw.net (unknown [118.208.189.18])
        by mail.messagingengine.com (Postfix) with ESMTPA id 93233306005E;
        Fri,  8 Nov 2019 01:30:00 -0500 (EST)
Message-ID: <c87e0acc9f6cbf36a2860d7bebc28df6b1dcfc97.camel@themaw.net>
Subject: Re: [PATCH] xfs: remove a stray tab in xfs_remount_rw()
From:   Ian Kent <raven@themaw.net>
To:     Dan Carpenter <dan.carpenter@oracle.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, kernel-janitors@vger.kernel.org
Date:   Fri, 08 Nov 2019 14:29:56 +0800
In-Reply-To: <20191108051121.GA26279@mwanda>
References: <20191108051121.GA26279@mwanda>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, 2019-11-08 at 08:11 +0300, Dan Carpenter wrote:
> The extra tab makes the code slightly confusing.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
>  fs/xfs/xfs_super.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index b3188ea49413..ede6fac47c56 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -1599,7 +1599,7 @@ xfs_remount_rw(
>  	if (error) {
>  		xfs_err(mp,
>  			"Error %d recovering leftover CoW allocations.", error);
> -			xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
> +		xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
>  		return error;
>  	}
>  	xfs_start_block_reaping(mp);

Indeed, my bad.
Reviewed-by: Ian Kent <raven@themaw.net>

