Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B63A2CDB46E
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Oct 2023 05:33:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232808AbjJLFdP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 12 Oct 2023 01:33:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235289AbjJLFdO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 Oct 2023 01:33:14 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42C55B7
        for <linux-xfs@vger.kernel.org>; Wed, 11 Oct 2023 22:33:12 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 6F9456732D; Thu, 12 Oct 2023 07:33:07 +0200 (CEST)
Date:   Thu, 12 Oct 2023 07:33:06 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, osandov@osandov.com, hch@lst.de
Subject: Re: [PATCH 2/8] xfs: remove XFS_BLOCKWSIZE and XFS_BLOCKWMASK
 macros
Message-ID: <20231012053306.GA2795@lst.de>
References: <169704721623.1773834.8031427054893583456.stgit@frogsfrogsfrogs> <169704721662.1773834.1354453014423462886.stgit@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <169704721662.1773834.1354453014423462886.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 11, 2023 at 11:06:45AM -0700, Darrick J. Wong wrote:
> @@ -181,7 +181,7 @@ xfs_rtfind_back(
>  				return error;
>  			}
>  			bufp = bp->b_addr;
> -			word = XFS_BLOCKWMASK(mp);
> +			word = mp->m_blockwsize - 1;
>  			b = &bufp[word];
>  		} else {
>  			/*
> @@ -227,7 +227,7 @@ xfs_rtfind_back(
>  				return error;
>  			}
>  			bufp = bp->b_addr;
> -			word = XFS_BLOCKWMASK(mp);
> +			word = mp->m_blockwsize - 1;
>  			b = &bufp[word];
>  		} else {

Random rambling: there is a fairly large chunk of code duplicated
here.  Maybe the caching series and/or Dave's suggest args cleanup
would be good opportunity to refactor it.  Same for the next two
clusters of two chunks.

The patch itself looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
