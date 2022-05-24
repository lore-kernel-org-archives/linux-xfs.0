Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A796FC433F5
	for <linux-xfs@archiver.kernel.org>; Tue, 24 May 2022 03:48:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231964AbiEXDsL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 23 May 2022 23:48:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233070AbiEXDsK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 23 May 2022 23:48:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6B736C0FB
        for <linux-xfs@vger.kernel.org>; Mon, 23 May 2022 20:48:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 97C77B8170B
        for <linux-xfs@vger.kernel.org>; Tue, 24 May 2022 03:48:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B413C385AA;
        Tue, 24 May 2022 03:48:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653364087;
        bh=mDYRey7GUvbrWDrNnJ2w4KCjkAqXxD1qG2uz44KqaBc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UOtJE5GV3kbQwlZ/T5E9in5novKj0teRf3WhCcjv9Itp2RukOBK0Huk3Pvg+RgLyW
         qFn1hvO9jkcCujj+c+z+ztHMB4SkSlYeS7AoKwHHaCWgoWGAZ0ass/7TqRgcCbeRgN
         EfGDd/XXI8iKLjqH+63YDxvX3WcZbK340K7QfayoIN4CGs3ehoASKYy875H+xP/utW
         XomOoj/SoIyiA91iuJskHRQmhbpZcln37JOaeFAXskuzh1H563sQLMRDAOX90uVEaP
         /F6QcZZlQCCpc2xwaJ3+6NnfhmZso1LrMnD7Ukkv9RDJ08WOCMZPaW8GY6yM/rH8WW
         j4Uz06nxMeEWA==
Date:   Mon, 23 May 2022 20:48:06 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3] xfs: don't assert fail on perag references on
 teardown
Message-ID: <YoxVdipmKR4PHUyH@magnolia>
References: <20220524022158.1849458-1-david@fromorbit.com>
 <20220524022158.1849458-3-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220524022158.1849458-3-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 24, 2022 at 12:21:57PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Not fatal, the assert is there to catch developer attention. I'm
> seeing this occasionally during recoveryloop testing after a
> shutdown, and I don't want this to stop an overnight recoveryloop
> run as it is currently doing.
> 
> Convert the ASSERT to a XFS_IS_CORRUPT() check so it will dump a
> corruption report into the log and cause a test failure that way,
> but it won't stop the machine dead.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_ag.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
> index 1e4ee042d52f..3e920cf1b454 100644
> --- a/fs/xfs/libxfs/xfs_ag.c
> +++ b/fs/xfs/libxfs/xfs_ag.c
> @@ -173,7 +173,6 @@ __xfs_free_perag(
>  	struct xfs_perag *pag = container_of(head, struct xfs_perag, rcu_head);
>  
>  	ASSERT(!delayed_work_pending(&pag->pag_blockgc_work));
> -	ASSERT(atomic_read(&pag->pag_ref) == 0);

Er, shouldn't this also be converted to XFS_IS_CORRUPT?  That's what the
commit message said...

--D

>  	kmem_free(pag);
>  }
>  
> @@ -192,7 +191,7 @@ xfs_free_perag(
>  		pag = radix_tree_delete(&mp->m_perag_tree, agno);
>  		spin_unlock(&mp->m_perag_lock);
>  		ASSERT(pag);
> -		ASSERT(atomic_read(&pag->pag_ref) == 0);
> +		XFS_IS_CORRUPT(pag->pag_mount, atomic_read(&pag->pag_ref) != 0);
>  
>  		cancel_delayed_work_sync(&pag->pag_blockgc_work);
>  		xfs_iunlink_destroy(pag);
> -- 
> 2.35.1
> 
