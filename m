Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 864E9C07E9A
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Jul 2021 11:10:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5BDCF61279
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Jul 2021 11:10:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231178AbhGNLNr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 14 Jul 2021 07:13:47 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:40464 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229899AbhGNLNq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 14 Jul 2021 07:13:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626261055;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=IxsnFdaBIw2VMBlO406m3XS5I52ETpWvbO+Le1HFvYc=;
        b=bWaJZARU3XnOMaVAB5sTM/+0fq0eZQJcjBMyQLvVG2T7hYMPCHrpXQl9G11CoEO/wEjV5X
        T0EFznrW5pC0VYrSWCA+Rk0XHD1uRNwqAYvlIqm/MAMJTWAho8tS0NPsmPOHTdmJ+Le0/k
        nPVtiB502JGVMVRSLa3BBEK8/mW1U2M=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-550-JFKyiIwzOveNVn157q09Ig-1; Wed, 14 Jul 2021 07:10:53 -0400
X-MC-Unique: JFKyiIwzOveNVn157q09Ig-1
Received: by mail-wr1-f71.google.com with SMTP id d9-20020adffbc90000b029011a3b249b10so1328492wrs.3
        for <linux-xfs@vger.kernel.org>; Wed, 14 Jul 2021 04:10:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=IxsnFdaBIw2VMBlO406m3XS5I52ETpWvbO+Le1HFvYc=;
        b=jWwVDb5tiCf4HA3pGU3Mi0pqNktTnDhN470BLGebkUO6GPvkTA4XbitXig89CdJwNM
         TYhhTe7jmspvtK55F9+iPIIaquNG37SiWIpZamb7GXxHlqmOLGIWAPrFUuP3viNMr+IC
         dPrKK5ns1stCfXWOZuyzmB71Yu+OeMoB3PK2iCaSPKWUNn0ni7E9euvQRTYQY2no6Wzu
         cD5yVuJO/OEVtoui+v0cKBxdii85q7X2rUssonF0ejXqOttb8QrLtV40puLxCw1Yzf1O
         gm4XQjjSM1aTMzsPYhgncj4GBJP9ZFPScR1UoHPUZ/UHTFdP0Lli93RscYvVhjGqsG+r
         eC1A==
X-Gm-Message-State: AOAM531k9ZvLEG6SBHgjRfzhGEu6ZdNBMlsMEV6XkMt5iykJgOKehIdj
        6fCCMMqdP9OwRB+pbp8qJDqsMB0HN3sIpEtvk1xpOe+xozPQWZlByi9hbVMOp/exmCu7CPnT/3c
        3ljeRfLeXtWRV/SnJEqdZ
X-Received: by 2002:a05:600c:2290:: with SMTP id 16mr10665192wmf.32.1626261052223;
        Wed, 14 Jul 2021 04:10:52 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyALieYwYRP0iCvjLCRyvxQFqs3w4nDMR8vxp2ukIeKW1TziINOlbesEBBZfTMXR+xSfqkqhA==
X-Received: by 2002:a05:600c:2290:: with SMTP id 16mr10665174wmf.32.1626261051952;
        Wed, 14 Jul 2021 04:10:51 -0700 (PDT)
Received: from omega.lan (ip4-46-39-172-19.cust.nbox.cz. [46.39.172.19])
        by smtp.gmail.com with ESMTPSA id e11sm2732310wrt.0.2021.07.14.04.10.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jul 2021 04:10:51 -0700 (PDT)
Date:   Wed, 14 Jul 2021 13:10:49 +0200
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/3] xfs: remove support for disabling quota accounting
 on a mounted file system
Message-ID: <20210714111049.dxhrtupk46ls4ujb@omega.lan>
Mail-Followup-To: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
References: <20210712111426.83004-1-hch@lst.de>
 <20210712111426.83004-2-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210712111426.83004-2-hch@lst.de>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jul 12, 2021 at 01:14:24PM +0200, Christoph Hellwig wrote:
> Disabling quota accounting is hairy, racy code with all kinds of pitfalls.
> And it has a very strange mind set, as quota accounting (unlike
> enforcement) really is a propery of the on-disk format.  There is no good
> use case for supporting this.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

> -	if ((dqtype & XFS_QMOPT_UQUOTA) && q->qi_uquotaip) {
> -		xfs_irele(q->qi_uquotaip);
> -		q->qi_uquotaip = NULL;
> -	}
> -	if ((dqtype & XFS_QMOPT_GQUOTA) && q->qi_gquotaip) {
> -		xfs_irele(q->qi_gquotaip);
> -		q->qi_gquotaip = NULL;
> -	}
> -	if ((dqtype & XFS_QMOPT_PQUOTA) && q->qi_pquotaip) {
> -		xfs_irele(q->qi_pquotaip);
> -		q->qi_pquotaip = NULL;
> -	}
> +	mutex_lock(&mp->m_quotainfo->qi_quotaofflock);
> +	mp->m_qflags &= ~(flags & XFS_ALL_QUOTA_ENFD);
> +	spin_lock(&mp->m_sb_lock);
> +	mp->m_sb.sb_qflags = mp->m_qflags;
> +	spin_unlock(&mp->m_sb_lock);
> +	mutex_unlock(&mp->m_quotainfo->qi_quotaofflock);
>  
> -out_unlock:
> -	if (error && qoffstart)
> -		xfs_qm_qoff_logitem_relse(qoffstart);
> -	mutex_unlock(&q->qi_quotaofflock);
> -	return error;
> +	/* XXX what to do if error ? Revert back to old vals incore ? */
> +	return xfs_sync_sb(mp, false);

May be too strict, but I wonder if we shouldn't shut the FS down in case we fail
here?


Patch looks good though.

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>


-- 
Carlos

