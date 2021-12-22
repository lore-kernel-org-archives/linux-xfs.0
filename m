Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DC7FC433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 22 Dec 2021 22:08:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234122AbhLVWIe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 22 Dec 2021 17:08:34 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:40148 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230063AbhLVWId (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 22 Dec 2021 17:08:33 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B8C10B81CFE
        for <linux-xfs@vger.kernel.org>; Wed, 22 Dec 2021 22:08:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7399DC36AE5;
        Wed, 22 Dec 2021 22:08:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640210906;
        bh=pLXNVpLHl2Lz6gE62PZTOGS40oPaX6m/H41TSwbX6lg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=presPs1/jgBYQT/xZfoahLPCZReeDvIIZZ4DyADAc3V7yeJsMcEwHQfhdgLfdcfHC
         V5EAsOtCMKuPw5yAPymwLQK+ZCShf7UKjOS4k9RdKWNIDxW9ifdo3brDreK9fEniJd
         QGbRcTSOC+Cs1MV0zs1TLwMKfuLwr5DYaL94HP8pV1DMdq3i4M4fFFuCS55rXG5yi8
         KpVzBLvCWhyqj+3dkT6w1bbubfv3CktVUPE0CBuYGH65KDUXKzjEffpl31btLB4q/Q
         epvVasVeBsxroxzYV5xkH3q/kqUNJbftpnYqQ+Nov1hcvzBJKs4BRw9GtSecUr0LgY
         nl+cP+xz2c18Q==
Date:   Wed, 22 Dec 2021 14:08:26 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     xfs <linux-xfs@vger.kernel.org>
Cc:     Wengang Wang <wen.gang.wang@oracle.com>
Subject: Re: [PATCH] design: fix computation of buffer log item bitmap size
Message-ID: <20211222220826.GD27664@magnolia>
References: <20211110015820.GX24307@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211110015820.GX24307@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Nov 09, 2021 at 05:58:20PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Wengang Wang was trying to work through a buffer log item by consulting
> the ondisk format documentation, and was confused by the formula given
> in section 14.3.14 regarding the size of blf_data_map, aka the dirty
> bitmap for buffer log items.  We noticed that the documentation doesn't
> match what the kernel actually does, so let's fix this.
> 
> Reported-by: Wengang Wang <wen.gang.wang@oracle.com>
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

This is probably a bad time for this, but... ping?

--D

> ---
>  .../journaling_log.asciidoc                        |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/design/XFS_Filesystem_Structure/journaling_log.asciidoc b/design/XFS_Filesystem_Structure/journaling_log.asciidoc
> index 1dba56e..894d3e5 100644
> --- a/design/XFS_Filesystem_Structure/journaling_log.asciidoc
> +++ b/design/XFS_Filesystem_Structure/journaling_log.asciidoc
> @@ -992,7 +992,7 @@ The size of +blf_data_map+, in 32-bit words.
>  This variable-sized array acts as a dirty bitmap for the logged buffer.  Each
>  1 bit represents a dirty region in the buffer, and each run of 1 bits
>  corresponds to a subsequent log item containing the new contents of the buffer
> -area.  Each bit represents +(blf_len * 512) / (blf_map_size * NBBY)+ bytes.
> +area.  Each bit represents +(blf_len * 512) / (blf_map_size * sizeof(unsigned int) * NBBY)+ bytes.
>  
>  [[Buffer_Data_Log_Item]]
>  === Buffer Data Log Item
