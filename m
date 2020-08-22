Return-Path: <SRS0=ZMk+=CA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F32E9C433E1
	for <linux-xfs@archiver.kernel.org>; Sat, 22 Aug 2020 07:18:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C46AA2072D
	for <linux-xfs@archiver.kernel.org>; Sat, 22 Aug 2020 07:18:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="T2NZwKkM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726356AbgHVHSd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 22 Aug 2020 03:18:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725864AbgHVHSc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 22 Aug 2020 03:18:32 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77666C061573
        for <linux-xfs@vger.kernel.org>; Sat, 22 Aug 2020 00:18:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=6CorsR7iErmfUgtNXl1h84Xbio8r8fG0pR6Zh+UWhaA=; b=T2NZwKkMzQdwXC02Im5R0VHnLl
        K9KUU65xqUbOOHxSTLUJGDTs+kHmukB8AYbPJuI34QBmj3Zydkdso8nJMGopwrLMDhYwYQ7TsGrjV
        RtSAeMJzSXUCUtW82mlBTald++7dx2npGfOitVXs1c2Yu1KOeUPen9GkO1Ypg+92FomVmI8du7pWe
        5V7TPzl3BSBvSWMtXx6W0ahsVpqEzmo+5R7Lx2xD9Uw8u7CBQl9t8DTlj9ZG76jadaiMjBGa5lN3L
        9zRerwTrB7BbCxPR7CLRBcMvt7u1/ehwNucGecDvyHveo47BBQySB8KwqNNm7ysPq+cZBRna+yqwh
        qnfr+PRA==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1k9NnK-0000xM-LL; Sat, 22 Aug 2020 07:18:30 +0000
Date:   Sat, 22 Aug 2020 08:18:30 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Amir Goldstein <amir73il@gmail.com>, linux-xfs@vger.kernel.org,
        sandeen@sandeen.net
Subject: Re: [PATCH 07/11] xfs: convert struct xfs_timestamp to union
Message-ID: <20200822071830.GG1629@infradead.org>
References: <159797588727.965217.7260803484540460144.stgit@magnolia>
 <159797593518.965217.18264791906308377426.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159797593518.965217.18264791906308377426.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 20, 2020 at 07:12:15PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Convert the xfs_timestamp struct to a union so that we can overload it
> in the next patch.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> Reviewed-by: Amir Goldstein <amir73il@gmail.com>
> ---
>  fs/xfs/libxfs/xfs_format.h     |   16 +++++++++-------
>  fs/xfs/libxfs/xfs_inode_buf.c  |    4 ++--
>  fs/xfs/libxfs/xfs_inode_buf.h  |    4 ++--
>  fs/xfs/libxfs/xfs_log_format.h |   16 +++++++++-------
>  fs/xfs/scrub/inode.c           |    2 +-
>  fs/xfs/xfs_inode_item.c        |    6 +++---
>  fs/xfs/xfs_ondisk.h            |    4 ++--
>  7 files changed, 28 insertions(+), 24 deletions(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
> index 1f3a2be6c396..772113db41aa 100644
> --- a/fs/xfs/libxfs/xfs_format.h
> +++ b/fs/xfs/libxfs/xfs_format.h
> @@ -856,9 +856,11 @@ struct xfs_agfl {
>   * Inode timestamps consist of signed 32-bit counters for seconds and
>   * nanoseconds; time zero is the Unix epoch, Jan  1 00:00:00 UTC 1970.
>   */
> -struct xfs_timestamp {
> -	__be32		t_sec;		/* timestamp seconds */
> -	__be32		t_nsec;		/* timestamp nanoseconds */
> +union xfs_timestamp {
> +	struct {
> +		__be32		t_sec;		/* timestamp seconds */
> +		__be32		t_nsec;		/* timestamp nanoseconds */
> +	};
>  };

Wouldn't it make sense to merge the typedef removal patch into this
one to avoid touching all the users twice?
