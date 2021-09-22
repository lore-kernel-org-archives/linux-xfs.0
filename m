Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E069C433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 22 Sep 2021 16:17:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8507D611EE
	for <linux-xfs@archiver.kernel.org>; Wed, 22 Sep 2021 16:17:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236620AbhIVQTW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 22 Sep 2021 12:19:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:52172 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236523AbhIVQTW (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 22 Sep 2021 12:19:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2ACCA611CA;
        Wed, 22 Sep 2021 16:17:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632327472;
        bh=6xURudNGYFT+xwYFM4dvhTcedWRpJiT5e99ox4zjrhs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Y3SCLQrkEgSPf1zbBPqsN/FVhCqcugzS3Yvd5BxN/kwq0CfayFHwL16bQNG+qr+J5
         kPZLNA3Tl/R0w7HPkcwGBlXb5dxelVzgFF77cn9gh74BHVWxW4ZKGxedybL18GbAFb
         yIx9dVao/YNjpgszsTe2lqPm+o9h6fY+18Yza5MB1tcRHzfhFuviGDW4DDWnS61CX7
         GWUr/l3efWsZxDTc+nijNfj9FmbTmZeheeTMcQ4tU/pnzBOBBkQC9rX5T1oGH+eN5W
         IXYsNNjqVjZhMZ+70c5iZKlQN6ReT+76h1oHzwgB7eiLS0ELBy1L+DYfZiJB0PeRWD
         mYPAHa9PeBEEA==
Date:   Wed, 22 Sep 2021 09:17:51 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     chandan.babu@oracle.com, chandanrlinux@gmail.com,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH 03/14] xfs: dynamically allocate btree scrub context
 structure
Message-ID: <20210922161751.GG570615@magnolia>
References: <163192854958.416199.3396890438240296942.stgit@magnolia>
 <163192856634.416199.12496831484611764326.stgit@magnolia>
 <YUmbJvitO5DeRR5D@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YUmbJvitO5DeRR5D@infradead.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Sep 21, 2021 at 09:43:18AM +0100, Christoph Hellwig wrote:
> On Fri, Sep 17, 2021 at 06:29:26PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Reorganize struct xchk_btree so that we can dynamically size the context
> > structure to fit the type of btree cursor that we have.  This will
> > enable us to use memory more efficiently once we start adding very tall
> > btree types.
> 
> So bs->levels[0].has_lastkey replaces bs->firstkey?  Can you explain
> a bit more how this works for someone not too familiar with the scrub
> code.

For each record and key that the btree scrubber encounters, it needs to
know if it should call ->{recs,keys}_inorder to check the ordering of
each item in the btree block.

Hmm.  Come to think of it, we could use "cur->bc_ptrs[level] > 0"
instead of tracking it separately.  Ok, that'll become a separate
cleanup patch to reduce memory further.  Good question!

> > +static inline size_t
> > +xchk_btree_sizeof(unsigned int levels)
> > +{
> > +	return sizeof(struct xchk_btree) +
> > +				(levels * sizeof(struct xchk_btree_levels));
> 
> This should probably use struct_size().

Assuming it's ok with sending a typed null pointer into a macro:

	return struct_size((struct xchk_btree *)NULL, levels, nr_levels);

Then ok.

--D
