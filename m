Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D48AFC4707F
	for <linux-xfs@archiver.kernel.org>; Tue, 25 May 2021 20:52:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AF5196140B
	for <linux-xfs@archiver.kernel.org>; Tue, 25 May 2021 20:52:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233207AbhEYUyN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 May 2021 16:54:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:39346 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232381AbhEYUyN (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 25 May 2021 16:54:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C330F610A0;
        Tue, 25 May 2021 20:52:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621975962;
        bh=UaCbijnemf8pJdYw67i08WMnaysCJI4eMJGVWiX3ruI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=P+RVq4uPy/lQXOnXGNOxjvCWFxfDU3Pyus0Ig0tmsaLFMI13Gqes8B5SDr1fR31ZJ
         +ZgNxc3JKebR9Gfol214s6JxZE4yQVw1masWVKRX0a+CpG8AtbPgZp0jno0KKyIOWU
         NqxZ4Qcc13RIliQImQ+2Bld7mcHLzNzehLUNRDD4X3xFqW3aWJpiuFxP8a/0m0zIJi
         +6AuLzLavGkTaAN3zR6+0Uln5zW2biGNhncVHSgtALgijm3q/SON+j5ATa7HsVPbzv
         ODlNVgCCBLvKM1nfidb/ucd9/BZqhQvVfzTwu/Q7uGvkfhbfQKG/ciMrdeN4xNyT3O
         0AQq/ZIGRQBAA==
Date:   Tue, 25 May 2021 13:52:42 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v19 13/14] xfs: Remove default ASSERT in xfs_attr_set_iter
Message-ID: <20210525205242.GN202121@locust>
References: <20210525195504.7332-1-allison.henderson@oracle.com>
 <20210525195504.7332-14-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210525195504.7332-14-allison.henderson@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 25, 2021 at 12:55:03PM -0700, Allison Henderson wrote:
> This ASSERT checks for the state value of RM_SHRINK in the set path.
> Which would be invalid, and should never happen.  This change is being
> set aside from the rest of the set for further discussion
> 
> Suggested-by: Darrick J. Wong <djwong@kernel.org>
> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_attr.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 32d451b..7294a2e 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -612,7 +612,6 @@ xfs_attr_set_iter(
>  		error = xfs_attr_node_addname_clear_incomplete(dac);
>  		break;
>  	default:
> -		ASSERT(dac->dela_state != XFS_DAS_RM_SHRINK);

ASSERT(0); ?

AFAICT the switch statement covers all the states mentioned in the state
diagram for attr setting, so in theory it should be impossible to land
in this state, correct?

--D

>  		break;
>  	}
>  out:
> -- 
> 2.7.4
> 
