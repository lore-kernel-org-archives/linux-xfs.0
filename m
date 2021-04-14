Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9F02C433ED
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Apr 2021 15:27:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9B2646100B
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Apr 2021 15:27:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352244AbhDNP1p (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 14 Apr 2021 11:27:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:47656 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352239AbhDNP1k (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 14 Apr 2021 11:27:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EDFCC61158;
        Wed, 14 Apr 2021 15:27:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618414039;
        bh=Cf9uo/qa6nfC1eAHVFXo06g5urbcaImkqWlV6OCRVaw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ryR51Nhxvmrp8B+6Mf7mil0xSvGWRmf5ncgfIuzdZzbtsxFMY+BQrEvrwK0D9n3KM
         vaiSR1gL+oo6XT+2IC4G8Ifc43t545BnGrWcAX3iiKLkQOV17fy5PFbNlWnXBccqnV
         m6j9A+5YF7nHG7ot+Lg6MebRJB1Z6nGM0iur+/A81OR/mTrm2Jj0ypYVeS2qv3VQyi
         uoCpfdXKFESV0xZ/5iJSkjVXO0YGQ2af/l+vKVKetsuDCQ4zIG7rxN4bTjvHxrpM+n
         AlIa2mDmvU1HVZQ63bL34VF+bPVv0zreMk3Ww+lZq8fkWN4Ywi+Q89Q+7MFGiROO1D
         NXKp1+hap+qDw==
Date:   Wed, 14 Apr 2021 08:27:18 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 7/7] xfs: remove XFS_IFEXTENTS
Message-ID: <20210414152718.GB3957620@magnolia>
References: <20210412133819.2618857-1-hch@lst.de>
 <20210412133819.2618857-8-hch@lst.de>
 <20210414003744.GU3957620@magnolia>
 <20210414055923.GA24575@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210414055923.GA24575@lst.de>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Apr 14, 2021 at 07:59:23AM +0200, Christoph Hellwig wrote:
> On Tue, Apr 13, 2021 at 05:37:44PM -0700, Darrick J. Wong wrote:
> > <shrug> Seeing how we already had a go-round where Dave and stumbled
> > over each other about the somewhat duplicative flags and format fields
> > I'm inclined to take this sooner or later just to eliminate the
> > ambiguity...
> 
> Do you want me to resend for the comment that Brian wants to see, or
> do you want to just fold that in?

Hm?  I thought Brian was describing a comment that's already in
xfs_btree_staging.c around line 195 as his reason for adding an RVB?

--D
