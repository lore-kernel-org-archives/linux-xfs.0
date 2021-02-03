Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F3A3C433E6
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Feb 2021 05:13:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3D8DE64F68
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Feb 2021 05:13:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229588AbhBCFNG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 3 Feb 2021 00:13:06 -0500
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:44336 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S229539AbhBCFNF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 3 Feb 2021 00:13:05 -0500
Received: from cwcc.thunk.org (pool-72-74-133-215.bstnma.fios.verizon.net [72.74.133.215])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 1135BrLY016312
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 3 Feb 2021 00:11:53 -0500
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id E4E2C15C39E2; Wed,  3 Feb 2021 00:11:52 -0500 (EST)
Date:   Wed, 3 Feb 2021 00:11:52 -0500
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v2 00/12] lazytime fix and cleanups
Message-ID: <YBowmPPHfZUTBgz1@mit.edu>
References: <20210109075903.208222-1-ebiggers@kernel.org>
 <20210111151517.GK18475@quack2.suse.cz>
 <X/y4s12YrXiUwWfN@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <X/y4s12YrXiUwWfN@sol.localdomain>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jan 11, 2021 at 12:44:35PM -0800, Eric Biggers wrote:
> > 
> > The series look good to me. How do you plan to merge it (after resolving
> > Christoph's remarks)? I guess either Ted can take it through the ext4 tree
> > or I can take it through my tree...
> 
> I think taking it through your tree would be best, unless Al or Ted wants to
> take it.

I'm happy to take it through the ext4 tree.  Are you planning on
issuing a newer version of this patch series to resolve Christoph's
comments?

					- Ted
