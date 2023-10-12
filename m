Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54CC3CDB46E
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Oct 2023 18:20:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379664AbjJLSUd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 12 Oct 2023 14:20:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379577AbjJLSUc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 Oct 2023 14:20:32 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEDD6A9
        for <linux-xfs@vger.kernel.org>; Thu, 12 Oct 2023 11:20:31 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C597C433C7;
        Thu, 12 Oct 2023 18:20:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697134831;
        bh=Xl51yxMiOnLm/991zJx3ynINGVIGH+Uwhs9F/+3hQAc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WlnTPD1YD27gGVmjiAgw/DPm113eng74Onv4bSWVtEHd4xK4Cd3g1wHHSA94BQdFA
         clPz/zVtOG1CLRt9Us9YgEE1L16CXr++p/kpo3fe7EI/sYQxmhu0IS3f0IiOrIwwIn
         Cxcg8Yec9PSWZ6JdQn5vEyE6GAfOuq0/PhRH1GQBECeXaHUyki+CnJY6aOIWT9ZSfv
         RxobEm2u+qteoTZgIVJio44VIOg8LzI1c4LTwFErWSwgPqa0gaqNkxcVESqkxhIO9V
         O1DKdKMnHSwI93b9lB+NiCqiEZdABu3roRV+/mfUOrPWO7xax9XPfoLKf/6DlM97lU
         keqck547q4j5Q==
Date:   Thu, 12 Oct 2023 11:20:30 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org, osandov@osandov.com
Subject: Re: [PATCH 2/8] xfs: remove XFS_BLOCKWSIZE and XFS_BLOCKWMASK macros
Message-ID: <20231012182030.GL21298@frogsfrogsfrogs>
References: <169704721623.1773834.8031427054893583456.stgit@frogsfrogsfrogs>
 <169704721662.1773834.1354453014423462886.stgit@frogsfrogsfrogs>
 <20231012053306.GA2795@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231012053306.GA2795@lst.de>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 12, 2023 at 07:33:06AM +0200, Christoph Hellwig wrote:
> On Wed, Oct 11, 2023 at 11:06:45AM -0700, Darrick J. Wong wrote:
> > @@ -181,7 +181,7 @@ xfs_rtfind_back(
> >  				return error;
> >  			}
> >  			bufp = bp->b_addr;
> > -			word = XFS_BLOCKWMASK(mp);
> > +			word = mp->m_blockwsize - 1;
> >  			b = &bufp[word];
> >  		} else {
> >  			/*
> > @@ -227,7 +227,7 @@ xfs_rtfind_back(
> >  				return error;
> >  			}
> >  			bufp = bp->b_addr;
> > -			word = XFS_BLOCKWMASK(mp);
> > +			word = mp->m_blockwsize - 1;
> >  			b = &bufp[word];
> >  		} else {
> 
> Random rambling: there is a fairly large chunk of code duplicated
> here.  Maybe the caching series and/or Dave's suggest args cleanup
> would be good opportunity to refactor it.  Same for the next two
> clusters of two chunks.

Yeah, Dave and I will have to figure out how to integrate these two.
I might just pull in his rtalloc_args patch at the end of this series.

--D

> The patch itself looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
