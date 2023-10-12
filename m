Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D11EFCDB46E
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Oct 2023 18:10:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347349AbjJLSKu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 12 Oct 2023 14:10:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344076AbjJLSKu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 Oct 2023 14:10:50 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1297DA9
        for <linux-xfs@vger.kernel.org>; Thu, 12 Oct 2023 11:10:49 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9215EC433C7;
        Thu, 12 Oct 2023 18:10:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697134248;
        bh=SRW+ZShioHstKDiocTUCRr56Y+Y7Wtqm5fFXErNueoQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MHea36gM/gK6UBFTZvuAoQuGsQ2/5TF0brMukUMMUJeccPufhD6UXTqnaV0/4Jg3F
         JEzDBUp+Hfz4VIO7TEy13YEt62XiuOaHigP6pOlXbCG9MNQCDvRkPa1dChzGsXwaNO
         8yVtyTRIgPwgFmsRK48h4JIh015JR5s5luT1g9jjBHyiGpvEysxOJe6aTbqErkUGY0
         fImfAO6Ld7V+KkgoSfp9gl5ouCuhLHB6RGzH8Q6m2W+bIqoTJe56NdsrsDIYjd0XUh
         sCutUO2jL5LJ841UaAKQQsExdncERr2sanwPGCWiplYpIXFj1hf+fAPRIXYN4NyAvU
         IQRyYhejVtVVQ==
Date:   Thu, 12 Oct 2023 11:10:48 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org, osandov@osandov.com
Subject: Re: [PATCH 5/7] xfs: convert do_div calls to xfs_rtb_to_rtx helper
 calls
Message-ID: <20231012181048.GJ21298@frogsfrogsfrogs>
References: <169704721170.1773611.12311239321983752854.stgit@frogsfrogsfrogs>
 <169704721255.1773611.7719978115841778913.stgit@frogsfrogsfrogs>
 <20231012052218.GD2184@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231012052218.GD2184@lst.de>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 12, 2023 at 07:22:18AM +0200, Christoph Hellwig wrote:
> On Wed, Oct 11, 2023 at 11:05:42AM -0700, Darrick J. Wong wrote:
> > -	if (isrt) {
> > -		uint64_t rtexts = XFS_FSB_TO_B(mp, del->br_blockcount);
> > -
> > -		do_div(rtexts, mp->m_sb.sb_rextsize);
> > -		xfs_mod_frextents(mp, rtexts);
> > -	}
> > +	if (isrt)
> > +		xfs_mod_frextents(mp, xfs_rtb_to_rtxt(mp, del->br_blockcount));
> 
> This is losing the XFS_FSB_TO_B conversion.  Now that conversion is
> bogus and doesn't match the rest of the code, and only the fact that
> we don't currently support delalloc on the RT device has saved our
> ass since fa5c836ca8e.  Maybe split this into a little prep patch with
> the a fixes tag?

Done.

--D
