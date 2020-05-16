Return-Path: <SRS0=gkwD=66=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40054C433E0
	for <linux-xfs@archiver.kernel.org>; Sat, 16 May 2020 20:01:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 25EDC207BB
	for <linux-xfs@archiver.kernel.org>; Sat, 16 May 2020 20:01:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726591AbgEPUBJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 16 May 2020 16:01:09 -0400
Received: from verein.lst.de ([213.95.11.211]:33243 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726364AbgEPUBJ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 16 May 2020 16:01:09 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 36F2D68B05; Sat, 16 May 2020 22:01:07 +0200 (CEST)
Date:   Sat, 16 May 2020 22:01:06 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: clean up xchk_bmap_check_rmaps usage of
 XFS_IFORK_Q
Message-ID: <20200516200106.GA23621@lst.de>
References: <20200510072404.986627-1-hch@lst.de> <20200510072404.986627-2-hch@lst.de> <20200516184259.GI6714@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200516184259.GI6714@magnolia>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

>  	for (agno = 0; agno < sc->mp->m_sb.sb_agcount; agno++) {
> @@ -651,8 +647,9 @@ xchk_bmap(
>  		}
>  		break;
>  	case XFS_ATTR_FORK:
> +		/* No fork means no attr data at all. */
>  		if (!ifp)
> -			goto out_check_rmap;
> +			goto out;

Maybe lift the !ifp to before the switch statement, or even to just after
assigning the value to ifp?  For the data fork it obviously won't be
true, but it still looks simple than duplicating it for the attr and
cow fork.

Otherwise looks fine:

Reviewed-by: Christoph Hellwig <hch@lst.de>
