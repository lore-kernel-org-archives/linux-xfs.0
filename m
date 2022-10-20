Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FB34C433FE
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Oct 2022 20:32:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229649AbiJTUcO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 20 Oct 2022 16:32:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229558AbiJTUcN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 20 Oct 2022 16:32:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E807C1FB797;
        Thu, 20 Oct 2022 13:32:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 92EA1B828D6;
        Thu, 20 Oct 2022 20:32:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32DADC433C1;
        Thu, 20 Oct 2022 20:32:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666297930;
        bh=7xwv/dLv0cVvjzu0MHHnsjyuHU9q5UbTs/+8hnxtDNs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sdJ6HdANe/bQIsRqic7l9F6in0UwAWJdroMuQmk4ossW4XgPcGNiru/rk9gCb+DWF
         rU8X+Qw1/U4kfkIlb4LcpG1QMaf6frJRu0JeGcwhAqt/XAEYLKVib6qOwKN89QH/np
         Py9SltXk+GWUe2r5FvYBiL5/32pRsRsw0FPUcfw59c8xWrZSFcGLEs8YNVjsuZCtDG
         GL/WE9iUSdxsKcyaNL/M0RQ94AnK5LalrhgPIzbyIr4lgbF347LyJ4OPHIWGHpo8yi
         eTtZiUezW9SOimgsjlJxg0mzeLqE2KpxmpHt6FPdT2W1XT4OO9LfO/7OZYUvE5xOQg
         QbHJPCZnznqBQ==
Date:   Thu, 20 Oct 2022 13:32:09 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Zorro Lang <zlang@redhat.com>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 1/1] populate: unexport the metadump description text
Message-ID: <Y1GwSUwtk1dVuKN4@magnolia>
References: <166613310432.868003.6099082434184908563.stgit@magnolia>
 <166613311003.868003.9672066347833155217.stgit@magnolia>
 <20221020043547.rcojqbhxihkcaszi@zlang-mailbox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221020043547.rcojqbhxihkcaszi@zlang-mailbox>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 20, 2022 at 12:35:47PM +0800, Zorro Lang wrote:
> On Tue, Oct 18, 2022 at 03:45:10PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Make the variable that holds the contents of the metadump description
> > file a local variable since we don't need it outside of that function.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > Reviewed-by: Zorro Lang <zlang@redhat.com>
> > ---
> 
> OK, will merge this one in next release.

Thank you!  Sorry about all the trouble last week. :(

--D

> >  common/populate |    8 ++++----
> >  1 file changed, 4 insertions(+), 4 deletions(-)
> > 
> > 
> > diff --git a/common/populate b/common/populate
> > index b2d37b47d8..58b07e33be 100644
> > --- a/common/populate
> > +++ b/common/populate
> > @@ -901,15 +901,15 @@ _scratch_populate_cached() {
> >  	local meta_tag="$(echo "${meta_descr}" | md5sum - | cut -d ' ' -f 1)"
> >  	local metadump_stem="${TEST_DIR}/__populate.${FSTYP}.${meta_tag}"
> >  
> > -	# These variables are shared outside this function
> > +	# This variable is shared outside this function
> >  	POPULATE_METADUMP="${metadump_stem}.metadump"
> > -	POPULATE_METADUMP_DESCR="${metadump_stem}.txt"
> > +	local populate_metadump_descr="${metadump_stem}.txt"
> >  
> >  	# Don't keep metadata images cached for more 48 hours...
> >  	rm -rf "$(find "${POPULATE_METADUMP}" -mtime +2 2>/dev/null)"
> >  
> >  	# Throw away cached image if it doesn't match our spec.
> > -	cmp -s "${POPULATE_METADUMP_DESCR}" <(echo "${meta_descr}") || \
> > +	cmp -s "${populate_metadump_descr}" <(echo "${meta_descr}") || \
> >  		rm -rf "${POPULATE_METADUMP}"
> >  
> >  	# Try to restore from the metadump
> > @@ -918,7 +918,7 @@ _scratch_populate_cached() {
> >  
> >  	# Oh well, just create one from scratch
> >  	_scratch_mkfs
> > -	echo "${meta_descr}" > "${POPULATE_METADUMP_DESCR}"
> > +	echo "${meta_descr}" > "${populate_metadump_descr}"
> >  	case "${FSTYP}" in
> >  	"xfs")
> >  		_scratch_xfs_populate $@
> > 
> 
