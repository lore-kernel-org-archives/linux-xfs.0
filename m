Return-Path: <SRS0=AE4z=7E=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22A20C433DF
	for <linux-xfs@archiver.kernel.org>; Fri, 22 May 2020 12:24:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E451B20759
	for <linux-xfs@archiver.kernel.org>; Fri, 22 May 2020 12:24:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DMwtAmzG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728979AbgEVMYG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 22 May 2020 08:24:06 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:22307 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728409AbgEVMYG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 22 May 2020 08:24:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590150244;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=k91DgICM+lCUu30rNjDviYQDB63Fx/5Q0PYkLrdAlLQ=;
        b=DMwtAmzGeTpehdAEd21hMRMR8tDUdgsETm6RHNCk7nDhnjCUTzc5VxPgisPndB0mOphIWi
        eaHjE+IfYxCJlCTgkH9BU/R1FWjGLfT7FDtokfpEopFm3+dce0qRNQnOTJKLCDhX71bztP
        NUruzowqqKuve6ximHW51piB6YXwMgg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-232-0xWleCY8ODaUm24OlVOtSg-1; Fri, 22 May 2020 08:24:03 -0400
X-MC-Unique: 0xWleCY8ODaUm24OlVOtSg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 03E2219057A1;
        Fri, 22 May 2020 12:24:02 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 7121D5D9CC;
        Fri, 22 May 2020 12:24:01 +0000 (UTC)
Date:   Fri, 22 May 2020 08:23:59 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 12/12] xfs: rearrange xfs_inode_walk_ag parameters
Message-ID: <20200522122359.GM50656@bfoster>
References: <159011600616.77079.14748275956667624732.stgit@magnolia>
 <159011608512.77079.1442881398167792783.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159011608512.77079.1442881398167792783.stgit@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, May 21, 2020 at 07:54:45PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> The perag structure already has a pointer to the xfs_mount, so we don't
> need to pass that separately and can drop it.  Having done that, move
> iter_flags so that the argument order is the same between xfs_inode_walk
> and xfs_inode_walk_ag.  The latter will make things less confusing for a
> future patch that enables background scanning work to be done in
> parallel.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_icache.c |    9 ++++-----
>  1 file changed, 4 insertions(+), 5 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index baf59087caa5..fbd77467bb4d 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -797,13 +797,13 @@ xfs_inode_walk_ag_grab(
>   */
>  STATIC int
>  xfs_inode_walk_ag(
> -	struct xfs_mount	*mp,
>  	struct xfs_perag	*pag,
> +	int			iter_flags,
>  	int			(*execute)(struct xfs_inode *ip, void *args),
>  	void			*args,
> -	int			tag,
> -	int			iter_flags)
> +	int			tag)
>  {
> +	struct xfs_mount	*mp = pag->pag_mount;
>  	uint32_t		first_index;
>  	int			last_error = 0;
>  	int			skipped;
> @@ -932,8 +932,7 @@ xfs_inode_walk(
>  	ag = 0;
>  	while ((pag = xfs_inode_walk_get_perag(mp, ag, tag))) {
>  		ag = pag->pag_agno + 1;
> -		error = xfs_inode_walk_ag(mp, pag, execute, args, tag,
> -				iter_flags);
> +		error = xfs_inode_walk_ag(pag, iter_flags, execute, args, tag);
>  		xfs_perag_put(pag);
>  		if (error) {
>  			last_error = error;
> 

