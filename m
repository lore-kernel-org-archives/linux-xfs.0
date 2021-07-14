Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9260C47E48
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Jul 2021 23:35:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D4AB6613D0
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Jul 2021 23:35:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236420AbhGNXie (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 14 Jul 2021 19:38:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:42544 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229535AbhGNXie (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 14 Jul 2021 19:38:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BEC976109E;
        Wed, 14 Jul 2021 23:35:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626305741;
        bh=AXdCk/O1Z7Lfd8dQdJcRXoWgixXquKfwq5ibsJSOBBI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DCksgt9LIdSIbfUNmuEgcYIWzCUGpW9qRP/GZQE6S2B4ugH8pj7V4T+xP9jsNWgHO
         6na1pflMTXoVCvXoPE5kdzHH9UPrgxSdSdOTyMQAymJICEetb3fd2AsjwrGqrYhRUt
         h0IlTjcZHdqJvb00lxGkM7xH6Ri3WfAdgLsW96x+GzPV5JIRpU0cwtjFUHfhodMkJo
         /dKQMyD73/Pq/A13TgY/AdPnDHPpcsX+Ps6UrOmGtQSdi0xnnjvcqX8XnGDdwT0QGl
         f+IqfoxrsFFUD1IcZPviZExzx1YziQ90E3yN20GkNwOkIXcHQAXHQ+Y2jCbnRcxKYD
         E2LLpmkyC8dxA==
Date:   Wed, 14 Jul 2021 16:35:41 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/6] xfs/007: unmount after disabling quota
Message-ID: <20210714233541.GQ22402@magnolia>
References: <20210712111146.82734-1-hch@lst.de>
 <20210712111146.82734-3-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210712111146.82734-3-hch@lst.de>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jul 12, 2021 at 01:11:42PM +0200, Christoph Hellwig wrote:
> With the pending patches to remove support for disabling quota
> accounting on a mounted file system we need to unmount the
> file system first before removing the quota files.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  tests/xfs/007 | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/tests/xfs/007 b/tests/xfs/007
> index 09268e8c..d1946524 100755
> --- a/tests/xfs/007
> +++ b/tests/xfs/007
> @@ -41,6 +41,9 @@ do_test()
>  	_qmount
>  	echo "*** turn off $off_opts quotas"
>  	xfs_quota -x -c "off -$off_opts" $SCRATCH_MNT
> +	_scratch_unmount
> +	_qmount_option ""
> +	_scratch_mount
>  	xfs_quota -x -c "remove -$off_opts" $SCRATCH_MNT
>  	echo "*** umount"
>  	_scratch_unmount
> -- 
> 2.30.2
> 
