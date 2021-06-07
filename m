Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4325C47094
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Jun 2021 16:27:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A8853610FB
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Jun 2021 16:27:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234651AbhFGQ2t (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 7 Jun 2021 12:28:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:33388 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234258AbhFGQZh (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 7 Jun 2021 12:25:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3D5676145A;
        Mon,  7 Jun 2021 16:19:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623082795;
        bh=4QYi/MRyFOyQ0U3bfRqYOd+KTTV78k9720Uzm9zcXM8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fRJPbXrwUQufum7I8wNdNHk5ycbHURz9mpFK83R+R/MsQNQN/95qa/ur4aP4l/geQ
         cnr6m+j8RXpWsfargxHIbhl2m/bS3qgEJrrXMcy08/ijVKet9CuJjPmUTN0Lrkbmdc
         4GlL0+Pje1jYqi3hbriUcttQAqUYyWyRq2O5mu8Wplhvo8Ncmegt7TaoJE3uOytBqs
         BkpzMYc2rnF5h+7AgF06kvlpTzoVzIRlAzKrcwAs71oui8wi68CZOsU6YZ73zE0JTl
         mNt4tqOKd1UgyzqwL6JLsH2F8OzETrBIh1bQLXPXkeueCFrAD06uu/nTi1t+8gT4HM
         hI3CmNILSxlqA==
Date:   Mon, 7 Jun 2021 09:19:54 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v20 13/14] xfs: Fix default ASSERT in xfs_attr_set_iter
Message-ID: <20210607161954.GK2945738@locust>
References: <20210607052747.31422-1-allison.henderson@oracle.com>
 <20210607052747.31422-4-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210607052747.31422-4-allison.henderson@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Jun 06, 2021 at 10:27:46PM -0700, Allison Henderson wrote:
> This ASSERT checks for the state value of RM_SHRINK in the set path
> which should never happen.  Change to ASSERT(0);
> 
> Suggested-by: Darrick J. Wong <djwong@kernel.org>
> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_attr.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 2387a41..a0edebc 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -612,7 +612,7 @@ xfs_attr_set_iter(
>  		error = xfs_attr_node_addname_clear_incomplete(dac);
>  		break;
>  	default:
> -		ASSERT(dac->dela_state != XFS_DAS_RM_SHRINK);
> +		ASSERT(0);
>  		break;
>  	}
>  out:
> -- 
> 2.7.4
> 
