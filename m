Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F11EEC001DF
	for <linux-xfs@archiver.kernel.org>; Fri, 20 Oct 2023 15:22:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377601AbjJTPWv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 20 Oct 2023 11:22:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377651AbjJTPWu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 20 Oct 2023 11:22:50 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 905FB91
        for <linux-xfs@vger.kernel.org>; Fri, 20 Oct 2023 08:22:49 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E536C433CA;
        Fri, 20 Oct 2023 15:22:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697815369;
        bh=nE2bW4rMqxXFqsz90amRXqWhuGQM7w7MHrforPEtvuA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=a5k/qXC2aLuZk4Fpe9GqNWOVTJ6UKqAohvVAODq3baUj0PffcjwzZQejJEfwwJU63
         vNaXM84mJ5yJyhImZm2LqGPcaem1Y0a0sNxkgeF0Yok+qjSNnVO37F5NrvZHOPDP0N
         0rw4l15VT5pkEalHcrbZgTGZFhwvVh6/tMe8IX/a5YYs6FLmIr3YmaUv+pTcjaiN5E
         Xwqp4waNBjPnzQo2H/zU0SKSfK29u0OIY0YudZ6dXCwz/Sxe6G8tiiFljLTBYH9Soz
         54kBlIyUELa5h12J4jNvMAJdRPBU8xRVK5DIQuDpiaOFjkUA+mKnxQ6XzHnKErJiXd
         8BzWawMyEvrYw==
Date:   Fri, 20 Oct 2023 08:22:48 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Catherine Hoang <catherine.hoang@oracle.com>,
        linux-xfs@vger.kernel.org
Subject: Re: [RFC PATCH] generic: test reads racing with slow reflink
 operations
Message-ID: <20231020152248.GQ3195650@frogsfrogsfrogs>
References: <20231019200913.GO3195650@frogsfrogsfrogs>
 <ZTIZrT7ZcWQHypEG@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZTIZrT7ZcWQHypEG@infradead.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 19, 2023 at 11:09:49PM -0700, Christoph Hellwig wrote:
> On Thu, Oct 19, 2023 at 01:09:13PM -0700, Darrick J. Wong wrote:
> > permit reads, since the source file contents do  not change.  This is a
> 
> duplicate white space before "not"

Fixed.

> > +#ifndef FICLONE
> > +# define FICLONE	_IOW(0x94, 9, int)
> > +#endif
> 
> Can't we assume system headers with FICLONE by now?

That depends on the long tail of RHEL7.  But you're right, it has been
years now, I'll just kill this hunk and see who complains. :)

> > +# real QA test starts here
> > +_require_scratch_reflink
> 
> This needs a _require_scratch before the _require_scratch_reflink.

Ok, will do.

> Otherwise this looks good to me:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Thanks!

--D
