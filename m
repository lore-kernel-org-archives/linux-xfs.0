Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBDEDC433E0
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Feb 2021 09:31:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 885D864F49
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Feb 2021 09:31:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231389AbhBCJb3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 3 Feb 2021 04:31:29 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58644 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233317AbhBCJbW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 3 Feb 2021 04:31:22 -0500
Received: from ip5f5af0a0.dynamic.kabel-deutschland.de ([95.90.240.160] helo=wittgenstein)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <christian.brauner@ubuntu.com>)
        id 1l7EUg-0001jk-JE; Wed, 03 Feb 2021 09:30:38 +0000
Date:   Wed, 3 Feb 2021 10:30:37 +0100
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     Shaokun Zhang <zhangshaokun@hisilicon.com>,
        Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org, "Darrick J. Wong" <djwong@kernel.org>
Subject: Re: [PATCH -next] xfs: Fix unused variable 'mp' warning
Message-ID: <20210203093037.v2bhmjqrq7n5mlxx@wittgenstein>
References: <1612341558-22171-1-git-send-email-zhangshaokun@hisilicon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1612341558-22171-1-git-send-email-zhangshaokun@hisilicon.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Feb 03, 2021 at 04:39:18PM +0800, Shaokun Zhang wrote:
> There is a warning on arm64 platform:
>   CC [M]  fs/xfs/xfs_ioctl32.o
> fs/xfs/xfs_ioctl32.c: In function ‘xfs_file_compat_ioctl’:
> fs/xfs/xfs_ioctl32.c:441:20: warning: unused variable ‘mp’ [-Wunused-variable]
>   441 |  struct xfs_mount *mp = ip->i_mount;
>       |                    ^~
>   LD [M]  fs/xfs/xfs.o
> 
> Fix this warning.
> 
> Fixes: f736d93d76d3 ("xfs: support idmapped mounts")
> Cc: "Darrick J. Wong" <djwong@kernel.org>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Christian Brauner <christian.brauner@ubuntu.com> 
> Signed-off-by: Shaokun Zhang <zhangshaokun@hisilicon.com>
> ---

Want me to take that on top of the series, Christoph?

Christian
