Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 052C0C433FE
	for <linux-xfs@archiver.kernel.org>; Sat, 15 Oct 2022 07:28:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229581AbiJOH2O (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 15 Oct 2022 03:28:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229504AbiJOH2N (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 15 Oct 2022 03:28:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84BAE52DF9;
        Sat, 15 Oct 2022 00:28:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 35416B81190;
        Sat, 15 Oct 2022 07:28:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA2F0C433D6;
        Sat, 15 Oct 2022 07:28:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665818889;
        bh=BVdsuiiv1AvEXnnGGyRBV9Kpy2HMEyry37nBM0TQEjc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XD39NeQteICCunXeReOBvTQh9D7uwxaOXJxf8MAiAht4mb6za5SllwA7w1rPR//q2
         u0c3onTKdCAoPcBZj9wLnPKgKCz9e5RjT39rWbY9iCA1DOMyi2qwjj9AdumhIgQDuD
         p8iZL1g4Sl2PiNRkv+64sxqAqP3uKEF5w/bIAS5rXGoJKw5xYZGDc8GX3TwpWZwgLg
         q1f2IlKQiCcxQT7wDjRi8NDhVtsEgOp+VGsHpCOpIxGQK0mwmcPDg01jQ8TiiXMpP1
         8E9iJSAoebI138qEoI3QPdVt6RSQrcmBp6XGtJ1aAToKFW0CH0kZG+dJIhlayy8msb
         1EQhuvm8poeNw==
Date:   Sat, 15 Oct 2022 00:28:09 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Zorro Lang <zlang@redhat.com>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH v1.1 1/5] populate: export the metadump description name
Message-ID: <Y0phCRO5Y3QMIBMU@magnolia>
References: <166553912229.422450.15473762183660906876.stgit@magnolia>
 <166553912788.422450.6797363004980943410.stgit@magnolia>
 <Y0mowyuRHSivs3ho@magnolia>
 <20221015050144.w4bq5vycditc6fgs@zlang-mailbox>
 <20221015051009.y2pgscuadxfyljjx@zlang-mailbox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221015051009.y2pgscuadxfyljjx@zlang-mailbox>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Oct 15, 2022 at 01:10:09PM +0800, Zorro Lang wrote:
> On Sat, Oct 15, 2022 at 01:01:44PM +0800, Zorro Lang wrote:
> > On Fri, Oct 14, 2022 at 11:21:55AM -0700, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <djwong@kernel.org>
> > > 
> > > Make the variable that holds the contents of the metadump description
> > > file a local variable since we don't need it outside of that function.
> > > 
> > > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > > Reviewed-by: Zorro Lang <zlang@redhat.com>
> > > ---
> > > v1.1: dont export POPULATE_METADUMP; change the description a bit
> > > ---
> > 
> > So you don't need to export the POPULATE_METADUMP anymore? I remembered you
> > said something broken and "exporting the variable made it work". Before I
> > merge this patch, hope to double check with you.
> 
> And the subject is still "populate: export the metadump description name", I
> think it's not suit for this change. Anyway, as this patch is not depended by
> others, I can merge other 4 patches at first. To give you enough time to think
> about what do you really like to change :)

<sigh> I updated the commit message in git and forgot to copy-paste the
new subject into the email.  Sorry about all this stupid crap, bash is a
terrible language and email is a godawful process and both should be
smote off the planet.

--D

> Thanks,
> Zorro
> 
> > 
> > Thanks,
> > Zorro
> > 
> > >  common/populate |    8 ++++----
> > >  1 file changed, 4 insertions(+), 4 deletions(-)
> > > 
> > > diff --git a/common/populate b/common/populate
> > > index cfdaf766f0..ba34ca5844 100644
> > > --- a/common/populate
> > > +++ b/common/populate
> > > @@ -868,15 +868,15 @@ _scratch_populate_cached() {
> > >  	local meta_tag="$(echo "${meta_descr}" | md5sum - | cut -d ' ' -f 1)"
> > >  	local metadump_stem="${TEST_DIR}/__populate.${FSTYP}.${meta_tag}"
> > >  
> > > -	# These variables are shared outside this function
> > > +	# This variable is shared outside this function
> > >  	POPULATE_METADUMP="${metadump_stem}.metadump"
> > > -	POPULATE_METADUMP_DESCR="${metadump_stem}.txt"
> > > +	local populate_metadump_descr="${metadump_stem}.txt"
> > >  
> > >  	# Don't keep metadata images cached for more 48 hours...
> > >  	rm -rf "$(find "${POPULATE_METADUMP}" -mtime +2 2>/dev/null)"
> > >  
> > >  	# Throw away cached image if it doesn't match our spec.
> > > -	cmp -s "${POPULATE_METADUMP_DESCR}" <(echo "${meta_descr}") || \
> > > +	cmp -s "${populate_metadump_descr}" <(echo "${meta_descr}") || \
> > >  		rm -rf "${POPULATE_METADUMP}"
> > >  
> > >  	# Try to restore from the metadump
> > > @@ -885,7 +885,7 @@ _scratch_populate_cached() {
> > >  
> > >  	# Oh well, just create one from scratch
> > >  	_scratch_mkfs
> > > -	echo "${meta_descr}" > "${POPULATE_METADUMP_DESCR}"
> > > +	echo "${meta_descr}" > "${populate_metadump_descr}"
> > >  	case "${FSTYP}" in
> > >  	"xfs")
> > >  		_scratch_xfs_populate $@
> > > 
> > 
> 
