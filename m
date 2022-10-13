Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06D96C43217
	for <linux-xfs@archiver.kernel.org>; Thu, 13 Oct 2022 15:54:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229874AbiJMPyl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 13 Oct 2022 11:54:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229879AbiJMPyl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 13 Oct 2022 11:54:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 824BFC63;
        Thu, 13 Oct 2022 08:54:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1EF7661871;
        Thu, 13 Oct 2022 15:54:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78467C433D6;
        Thu, 13 Oct 2022 15:54:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665676476;
        bh=qCPhp9pGRQ/Qa1Mv0P86SvoG4h9oyaxO9+MR7N0g35o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=G+KWz4Lg781nJFvGIvjZiSO3ggLCgOaE7oUIV0m4dkzsu5I8k/dClWKuqAOuMLUz0
         CnrN5LSjWfSg+lj+1K44r1beGnyD6gH/viPugZZcbfeid/ZK76rAUKEvReARevwdIm
         0zzIcv5ecCTBuDTvSsaOc3tj03t5JHBDQ5yNVprOPS+AQYVlSNdJXjSYCM/u3aQoRf
         zfJLTLXYZTafUwfQvL0ea2yNSNrwU10VQw/hTSZc7WaaKfXFzEtnhSdhlMVaevQE44
         S3I87l4vweDFELnx+74itz5PR84izxmYFpmezTfCZeUp75C1VEUdCCxshk5NRWg3Oq
         va+lY1LfnN//A==
Date:   Thu, 13 Oct 2022 08:54:35 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Zorro Lang <zlang@redhat.com>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 1/5] populate: export the metadump description name
Message-ID: <Y0g0u5byHQK/aOEz@magnolia>
References: <166553912229.422450.15473762183660906876.stgit@magnolia>
 <166553912788.422450.6797363004980943410.stgit@magnolia>
 <20221013145515.2vx3xy6hnf37777o@zlang-mailbox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221013145515.2vx3xy6hnf37777o@zlang-mailbox>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 13, 2022 at 10:55:15PM +0800, Zorro Lang wrote:
> On Tue, Oct 11, 2022 at 06:45:27PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Not sure why this hasn't been broken all along, but we should be
> > exporting this variable so that it shows up in subshells....
> 
> May I ask where's the subshell which uses $POPULATE_METADUMP?

_scratch_xfs_fuzz_metadata does this:

	echo "${fields}" | while read field; do
		echo "${verbs}" | while read fuzzverb; do
			__scratch_xfs_fuzz_mdrestore
				_xfs_mdrestore "${POPULATE_METADUMP}"

The (nested) echo piped to while starts subshells.

> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  common/populate |    6 +++---
> >  1 file changed, 3 insertions(+), 3 deletions(-)
> > 
> > 
> > diff --git a/common/populate b/common/populate
> > index cfdaf766f0..b501c2fe45 100644
> > --- a/common/populate
> > +++ b/common/populate
> > @@ -868,9 +868,9 @@ _scratch_populate_cached() {
> >  	local meta_tag="$(echo "${meta_descr}" | md5sum - | cut -d ' ' -f 1)"
> >  	local metadump_stem="${TEST_DIR}/__populate.${FSTYP}.${meta_tag}"
> >  
> > -	# These variables are shared outside this function
> > -	POPULATE_METADUMP="${metadump_stem}.metadump"
> > -	POPULATE_METADUMP_DESCR="${metadump_stem}.txt"
> > +	# This variable is shared outside this function
> > +	export POPULATE_METADUMP="${metadump_stem}.metadump"
> > +	local POPULATE_METADUMP_DESCR="${metadump_stem}.txt"
> 
> If the POPULATE_METADUMP_DESCR is not shared outside anymore, how about change
> it to lower-case?

Ok.

--D

> >  
> >  	# Don't keep metadata images cached for more 48 hours...
> >  	rm -rf "$(find "${POPULATE_METADUMP}" -mtime +2 2>/dev/null)"
> > 
> 
