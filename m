Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6CE6C433FE
	for <linux-xfs@archiver.kernel.org>; Thu, 13 Oct 2022 19:13:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229613AbiJMTMk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 13 Oct 2022 15:12:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229944AbiJMTMV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 13 Oct 2022 15:12:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E388BDCADA;
        Thu, 13 Oct 2022 12:12:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 812F56192A;
        Thu, 13 Oct 2022 19:12:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE9B8C433D6;
        Thu, 13 Oct 2022 19:12:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665688339;
        bh=567LbA9shaX1tXs+e4bvh1/IPrSjFDnNzR588EPfruY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pANyC/LMW+hBEd4YSKpwHLRup4ZZyn25YReKA4IxT4DyOwtQ+M9RKetU3WqrDhasV
         wIOgxh0+gLy7uWKt73ci0BX2vY8YCJ6fsU4rK6jaDKbezAhmhoqM6x0l+cjWOYKHF9
         jfDdtAkmeyw6EkH/0sOFlPDSHOtmY0uwPmny7o5DfkxwjujekWS3qbnSuCccqb6kPc
         U/MKOR9M52sg/IAx18C1qlspf/T4/WNlqkxXWZaKwpeYtJcQc+wyQAG5XGAMkGFS+5
         Wqgu6mgZ78lXdjgbD9eKmNCsYiPh8hkEu6mHoDKzCsK1IiNUjYSdtAOvP9UEmntBDj
         8CewTPKM6f+gg==
Date:   Thu, 13 Oct 2022 12:12:19 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Zorro Lang <zlang@redhat.com>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 1/5] populate: export the metadump description name
Message-ID: <Y0hjE3neN2rDhkxw@magnolia>
References: <166553912229.422450.15473762183660906876.stgit@magnolia>
 <166553912788.422450.6797363004980943410.stgit@magnolia>
 <20221013145515.2vx3xy6hnf37777o@zlang-mailbox>
 <Y0g0u5byHQK/aOEz@magnolia>
 <20221013162826.hfs75s33giqmfu4t@zlang-mailbox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221013162826.hfs75s33giqmfu4t@zlang-mailbox>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Oct 14, 2022 at 12:28:26AM +0800, Zorro Lang wrote:
> On Thu, Oct 13, 2022 at 08:54:35AM -0700, Darrick J. Wong wrote:
> > On Thu, Oct 13, 2022 at 10:55:15PM +0800, Zorro Lang wrote:
> > > On Tue, Oct 11, 2022 at 06:45:27PM -0700, Darrick J. Wong wrote:
> > > > From: Darrick J. Wong <djwong@kernel.org>
> > > > 
> > > > Not sure why this hasn't been broken all along, but we should be
> > > > exporting this variable so that it shows up in subshells....
> > > 
> > > May I ask where's the subshell which uses $POPULATE_METADUMP?
> > 
> > _scratch_xfs_fuzz_metadata does this:
> > 
> > 	echo "${fields}" | while read field; do
> > 		echo "${verbs}" | while read fuzzverb; do
> > 			__scratch_xfs_fuzz_mdrestore
> > 				_xfs_mdrestore "${POPULATE_METADUMP}"
> > 
> > The (nested) echo piped to while starts subshells.
> 
> I'm not so familar with this part, so I didn't a simple test[1], and looks like
> the PARAM can be seen, even it's not exported. Do I misunderstand something?
> 
> Thanks,
> Zorro
> 
> [1]
> $ echo "$list"
> a
> b
> cc
> $ PARAM="This's a test"
> $ echo "$list"|while read c1;do echo "$list"|while read c2;do echo $PARAM;done; done
> This's a test
> This's a test
> This's a test
> This's a test
> This's a test
> This's a test
> This's a test
> This's a test
> This's a test

Hmm.  I can't figure out why I needed the export here.  It was late one
night, something was broken, and exporting the variable made it work.
Now I can't recall exactly what that was and it seems fine without
it...?

I guess I'll put it back and rerun the entire fuzz suite to see what
pops out...

--D

> > 
> > > > 
> > > > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > > > ---
> > > >  common/populate |    6 +++---
> > > >  1 file changed, 3 insertions(+), 3 deletions(-)
> > > > 
> > > > 
> > > > diff --git a/common/populate b/common/populate
> > > > index cfdaf766f0..b501c2fe45 100644
> > > > --- a/common/populate
> > > > +++ b/common/populate
> > > > @@ -868,9 +868,9 @@ _scratch_populate_cached() {
> > > >  	local meta_tag="$(echo "${meta_descr}" | md5sum - | cut -d ' ' -f 1)"
> > > >  	local metadump_stem="${TEST_DIR}/__populate.${FSTYP}.${meta_tag}"
> > > >  
> > > > -	# These variables are shared outside this function
> > > > -	POPULATE_METADUMP="${metadump_stem}.metadump"
> > > > -	POPULATE_METADUMP_DESCR="${metadump_stem}.txt"
> > > > +	# This variable is shared outside this function
> > > > +	export POPULATE_METADUMP="${metadump_stem}.metadump"
> > > > +	local POPULATE_METADUMP_DESCR="${metadump_stem}.txt"
> > > 
> > > If the POPULATE_METADUMP_DESCR is not shared outside anymore, how about change
> > > it to lower-case?
> > 
> > Ok.
> > 
> > --D
> > 
> > > >  
> > > >  	# Don't keep metadata images cached for more 48 hours...
> > > >  	rm -rf "$(find "${POPULATE_METADUMP}" -mtime +2 2>/dev/null)"
> > > > 
> > > 
> > 
> 
