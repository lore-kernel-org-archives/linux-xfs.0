Return-Path: <SRS0=RLxe=2J=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA67BC43603
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Dec 2019 13:17:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A0C2E227BF
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Dec 2019 13:17:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QzROy/GO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726879AbfLSNRc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 19 Dec 2019 08:17:32 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:51081 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726695AbfLSNRb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 19 Dec 2019 08:17:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576761450;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=zPU+1O8ZmSxLesMtg0sFCEx9ElTPjO13lLXg31aIhTI=;
        b=QzROy/GOx8nTQNP7+jnRBrpB0CcT4JJmfB87igVDRiOWthaT1FzHMNqllKI3N7DgkpCKn3
        0mtIAOOYJbL/iPf7amsN3YMQ1K+E47nKRpGrw+c9gA5uRqISw6qIX7NGIsHP9U+uoNwbjB
        NrI3fN9q3wBQcJVBYoURSWEA0K5Gh7A=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-283-H429-nm7PD2XSbWqjiiYcg-1; Thu, 19 Dec 2019 08:17:27 -0500
X-MC-Unique: H429-nm7PD2XSbWqjiiYcg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D9FE9800D4C;
        Thu, 19 Dec 2019 13:17:25 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 580AA60BC7;
        Thu, 19 Dec 2019 13:17:25 +0000 (UTC)
Date:   Thu, 19 Dec 2019 08:17:23 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com, alex@zadara.com
Subject: Re: [PATCH 1/3] xfs: refactor agfl length computation function
Message-ID: <20191219131723.GC6995@bfoster>
References: <157669784202.117895.9984764081860081830.stgit@magnolia>
 <157669784878.117895.2399564206474502745.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157669784878.117895.2399564206474502745.stgit@magnolia>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Dec 18, 2019 at 11:37:28AM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Refactor xfs_alloc_min_freelist to accept a NULL @pag argument, in which
> case it returns the largest possible minimum length.  This will be used
> in an upcoming patch to compute the length of the AGFL at mkfs time.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/libxfs/xfs_alloc.c |   18 +++++++++++++-----
>  1 file changed, 13 insertions(+), 5 deletions(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> index c284e10af491..fc93fd88ec89 100644
> --- a/fs/xfs/libxfs/xfs_alloc.c
> +++ b/fs/xfs/libxfs/xfs_alloc.c
> @@ -2248,24 +2248,32 @@ xfs_alloc_longest_free_extent(
>  	return pag->pagf_flcount > 0 || pag->pagf_longest > 0;
>  }
>  
> +/*
> + * Compute the minimum length of the AGFL in the given AG.  If @pag is NULL,
> + * return the largest possible minimum length.
> + */
>  unsigned int
>  xfs_alloc_min_freelist(
>  	struct xfs_mount	*mp,
>  	struct xfs_perag	*pag)
>  {
> +	/* AG btrees have at least 1 level. */
> +	static const uint8_t	fake_levels[XFS_BTNUM_AGF] = {1, 1, 1};
> +	const uint8_t		*levels = pag ? pag->pagf_levels : fake_levels;
>  	unsigned int		min_free;
>  
> +	ASSERT(mp->m_ag_maxlevels > 0);
> +
>  	/* space needed by-bno freespace btree */
> -	min_free = min_t(unsigned int, pag->pagf_levels[XFS_BTNUM_BNOi] + 1,
> +	min_free = min_t(unsigned int, levels[XFS_BTNUM_BNOi] + 1,
>  				       mp->m_ag_maxlevels);
>  	/* space needed by-size freespace btree */
> -	min_free += min_t(unsigned int, pag->pagf_levels[XFS_BTNUM_CNTi] + 1,
> +	min_free += min_t(unsigned int, levels[XFS_BTNUM_CNTi] + 1,
>  				       mp->m_ag_maxlevels);
>  	/* space needed reverse mapping used space btree */
>  	if (xfs_sb_version_hasrmapbt(&mp->m_sb))
> -		min_free += min_t(unsigned int,
> -				  pag->pagf_levels[XFS_BTNUM_RMAPi] + 1,
> -				  mp->m_rmap_maxlevels);
> +		min_free += min_t(unsigned int, levels[XFS_BTNUM_RMAPi] + 1,
> +						mp->m_rmap_maxlevels);
>  
>  	return min_free;
>  }
> 

