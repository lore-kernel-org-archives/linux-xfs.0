Return-Path: <SRS0=xOwi=4F=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1919BC34021
	for <linux-xfs@archiver.kernel.org>; Mon, 17 Feb 2020 13:43:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DA00F2070B
	for <linux-xfs@archiver.kernel.org>; Mon, 17 Feb 2020 13:43:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="tIJO5QEW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728102AbgBQNnj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 17 Feb 2020 08:43:39 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:51344 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726314AbgBQNnj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 Feb 2020 08:43:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=MonZqIXk2pJdKbMhV+3AoRSFrLSohp1Rmx+YzsOp+p0=; b=tIJO5QEWWzrTKMduBoISaoAN31
        umw05oXoQHxv9WxNUGpFeIv90hA8TpeRefLOii31eC9oSCuZUu7cKiA0cCUxdEH7Z2SpxfAg1YHRu
        pH57yKeartI1Ct9l5ivUv57hlOuh96298+//Zlw8mJ1sc2ZrqUqcF+TBt1qDknJGSBaiBFTP4C+AB
        kxd8Ynie0dGR6keMXM1SF3/Vw6qx66vyDbhQ0eYa3dOF4Gk0nLk0HAbMP0cDlQybYibHqxZYewj8j
        L85j4PYOA83MUfuThBWT1CncRasgneZxuIrBLND1QTGpIoNjcgINM3adAADq2RYKI/l/ApxtQXSe6
        /n9HVN/A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j3ggV-0004jg-3O; Mon, 17 Feb 2020 13:43:39 +0000
Date:   Mon, 17 Feb 2020 05:43:39 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 4/4] xfs: per-type quota timers and warn limits
Message-ID: <20200217134339.GI31012@infradead.org>
References: <333ea747-8b45-52ae-006e-a1804e14de32@redhat.com>
 <7a35e397-dbc7-b991-6277-5f9931d03950@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7a35e397-dbc7-b991-6277-5f9931d03950@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

>  	struct xfs_disk_dquot	*d = &dq->q_core;
> +	struct xfs_def_quota	*defq;
> +
>  	ASSERT(d->d_id);
> +	defq = xfs_get_defquota(dq);

Move up to the declaration line?

> +	switch (type) {
> +	case XFS_DQ_USER:
> +		defq = &qinf->qi_usr_default;
> +		break;
> +	case XFS_DQ_GROUP:
> +		defq = &qinf->qi_grp_default;
> +		break;
> +	case XFS_DQ_PROJ:
> +		defq = &qinf->qi_prj_default;
> +		break;
> +	default:
> +		ASSERT(0);
> +		/* fall through */
> +	}

Should this go into a helper?  Or even better replace the
qi_*default members with an array that the type can index into?

> @@ -592,39 +609,31 @@ xfs_qm_init_timelimits(
>  	 *
>  	 * Since we may not have done a quotacheck by this point, just read
>  	 * the dquot without attaching it to any hashtables or lists.
> -	 *
> -	 * Timers and warnings are globally set by the first timer found in
> -	 * user/group/proj quota types, otherwise a default value is used.
> -	 * This should be split into different fields per quota type.
>  	 */
> -	if (XFS_IS_UQUOTA_RUNNING(mp))
> -		type = XFS_DQ_USER;
> -	else if (XFS_IS_GQUOTA_RUNNING(mp))
> -		type = XFS_DQ_GROUP;
> -	else
> -		type = XFS_DQ_PROJ;
>  	error = xfs_qm_dqget_uncached(mp, 0, type, &dqp);
>  	if (error)
>  		return;
>  
>  	ddqp = &dqp->q_core;
> +	defq = xfs_get_defquota(dqp);

Isn't the defq variable already initialized earlier in the function?
