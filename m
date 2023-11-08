Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3B26C4332F
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Nov 2023 07:44:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231192AbjKHHoJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 8 Nov 2023 02:44:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230025AbjKHHoJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Nov 2023 02:44:09 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FC601706
        for <linux-xfs@vger.kernel.org>; Tue,  7 Nov 2023 23:44:07 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB2F0C433C8;
        Wed,  8 Nov 2023 07:44:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1699429446;
        bh=KxsPsYQYbqsrYWqGrrDaW0152U1m16lqZK5WSOKQaCc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MIg9NF9UabUlqFioBMpaTdpqGwBFglrlP4hfHO6anfA9th1RaCV4NzCK91NsnZ67q
         FXndXvkZgqkiaIwTA29sUdXthovGwrQoWnHAZZwNah1dyr9cB6RN+a+TQUfFgHPcj+
         wnbxm0yn+nHVQAI9tWxJPqUgnnk3bYcPuYdO8VESSu+BpH+h5VUUCakv+M8JwYdx3/
         134owHhXeE2GwkL6iiZLIS0qUTefAmaEZiSyncAkPUAX6+fSRb4d5kShuKi+YUgM9N
         uh6LIg1P1IyROHgd8Hn2z/j+MMlocOCiK25IrXMmB31cCoEPtrDTCp0bjXJ65xmfVq
         gzuhl/9NQRn1w==
Date:   Tue, 7 Nov 2023 23:44:06 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/5] xfs_scrub: allow auxiliary pathnames for sandboxing
Message-ID: <20231108074406.GL1758611@frogsfrogsfrogs>
References: <168506074508.3746099.18021671464566915249.stgit@frogsfrogsfrogs>
 <168506074522.3746099.11941443473290571582.stgit@frogsfrogsfrogs>
 <ZUn55/68v2VfQHCX@infradead.org>
 <20231107183511.GN1205143@frogsfrogsfrogs>
 <ZUs3Lex9NS55gXy3@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZUs3Lex9NS55gXy3@infradead.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Nov 07, 2023 at 11:22:21PM -0800, Christoph Hellwig wrote:
> On Tue, Nov 07, 2023 at 10:35:11AM -0800, Darrick J. Wong wrote:
> > The reason why I bolted on the SERVICE_MOUNTPOINT= environment variable
> > is to preserve procfs discoverability.  The bash translation of these
> > systemd unit definitions for a scrub of /home is:
> > 
> >   mount /home /tmp/scrub --bind
> >   SERVICE_MODE=1 SERVICE_MOUNTPOINT=/tmp/scrub xfs_scrub -b /home
> > 
> > And the top listing for that will look like:
> > 
> >     PID USER      PR  NI %CPU  %MEM     TIME+ COMMAND
> >   11804 xfs_scru+ 20  19 10.3   0.1   1:26.94 xfs_scrub -b /home
> > 
> > (I omitted a few columns to narrow the top output.)
> 
> So if you make the pretty print mount point a new variable and pass
> that first this would become say:
> 
> 	xfs_scrub -p /home -b /tmp/scrub
> 
> ad should still be fine.  OR am I missing something?

Nope, you're not missing anything.  I could have implemented it as
another CLI switch and gotten the same result.  The appearance of
"/tmp/scrub" in comm is a bit ugly, but I'm not all that invested in
avoiding that.

> > For everyone else following at home -- the reason for bind mounting the
> > actual mountpoint into a private mount tree at /tmp/scrub is (a) to
> > make it so that the scrub process can only see a ro version of a subset
> > of the filesystem tree; and (b) separate the mountpoint in the scrub
> > process so that the sysadmin typing "umount /home" will see it disappear
> > out of most process' mount trees without that affecting scrub.
> > 
> > (I don't think xfs_scrub is going to go rogue and start reading users'
> > credit card numbers out of /home, but why give it an easy opportunity?)
> 
> But scrub has by definition full access to the fs as it's scrubbing
> that.  But I guess that access is in the kernel code, which we trust
> more than the user space code?

Yep.  Scrub runs with CAP_SYS_RAWIO, but I want to make it at least a
little harder for people who specialize in weird ld exploits and the
like. :)

--D
