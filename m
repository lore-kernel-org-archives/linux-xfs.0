Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67C8DC433FE
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Mar 2022 11:56:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233167AbiCQL5l (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 17 Mar 2022 07:57:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233181AbiCQL5l (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Mar 2022 07:57:41 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31ED51E5339
        for <linux-xfs@vger.kernel.org>; Thu, 17 Mar 2022 04:56:25 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id E6B551F38D;
        Thu, 17 Mar 2022 11:56:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1647518183; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=rPc5bsFOJzH9Nz6UMXBH3hM1vKtdO3qEOxOw6Z/DJAE=;
        b=VCp7aMigkAp+CMRr/FCublbnOr2DyKKpGvzMjY8wA9RSMd3+96BeilL/EJ+N7MsxlDM06x
        365Zd/DQqHzO3nSJt7pDdw3Pxm5dbkrpSc0pUFgePUex4MRo6Jz61CjNqHhPZpFXDOfxwH
        MP8j+vIr+gROAookcUs+3291JxKbhCs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1647518183;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=rPc5bsFOJzH9Nz6UMXBH3hM1vKtdO3qEOxOw6Z/DJAE=;
        b=CLtZ4qaDEFUSTuUol6qOoFSKYOGNTCM/JLMD6cOmRC8OceE62UJ5IALRHFXvtlEKAPaSFq
        UQSkHiyXLF7ZKSAg==
Received: from quack3.suse.cz (unknown [10.100.200.198])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 6FAA0A3B83;
        Thu, 17 Mar 2022 11:56:23 +0000 (UTC)
Received: by quack3.suse.cz (Postfix, from userid 1000)
        id A0FCBA0615; Thu, 17 Mar 2022 12:56:21 +0100 (CET)
Date:   Thu, 17 Mar 2022 12:56:21 +0100
From:   Jan Kara <jack@suse.cz>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Jan Kara <jack@suse.cz>, linux-xfs@vger.kernel.org,
        "Darrick J. Wong" <djwong@kernel.org>,
        Dave Chinner <dchinner@redhat.com>
Subject: Re: Regression in XFS for fsync heavy workload
Message-ID: <20220317115621.fwb4kfqx4xti4kyb@quack3.lan>
References: <20220315124943.wtgwrrkuthnwto7w@quack3.lan>
 <20220316010627.GO3927073@dread.disaster.area>
 <20220316095437.ogwo2fxfpddaerie@quack3.lan>
 <20220316233828.GU3927073@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220316233828.GU3927073@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu 17-03-22 10:38:28, Dave Chinner wrote:
> On Wed, Mar 16, 2022 at 10:54:37AM +0100, Jan Kara wrote:
> > On Wed 16-03-22 12:06:27, Dave Chinner wrote:
> > > When doing this work, I didn't count cache flushes. What I looked at
> > > was the number of log forces vs the number of sleeps waiting on log
> > > forces vs log writes vs the number of stalls waiting for log writes.
> > > These numbers showed improvements across the board, so any increase
> > > in overhead from physical cache flushes was not reflected in the
> > > throughput increases I was measuring at the "fsync drives log
> > > forces" level.
> > 
> > Thanks for detailed explanation! I'd just note that e.g. for a machine with
> > 8 CPUs, 32 GB of Ram and Intel SSD behind a megaraid_sas controller (it is
> > some Dell PowerEdge server) we see even larger regressions like:
> > 
> >                     good                      bad
> > Amean 	1	97.93	( 0.00%)	135.67	( -38.54%)
> > Amean 	2	147.69	( 0.00%)	194.82	( -31.91%)
> > Amean 	4	242.82	( 0.00%)	352.98	( -45.36%)
> > Amean 	8	375.36	( 0.00%)	591.03	( -57.45%)
> > 
> > I didn't investigate on this machine (it was doing some other tests and I
> > had another machine in my hands which also showed some, although smaller,
> > regression) but now reading your explanations I'm curious why the
> > regression grows with number of threads on that machine. Maybe the culprit
> > is different there or just the dynamics isn't as we imagine it on that
> > storage controller... I guess I'll borrow the machine and check it.
> 
> That sounds more like a poor caching implementation in the hardware
> RAID controller than anything else.

Likely. I did a run with your patch on this machine now and original
performance was restored.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
