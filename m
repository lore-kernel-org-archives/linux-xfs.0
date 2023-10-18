Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C684CDB482
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Oct 2023 04:52:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235237AbjJREwT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 Oct 2023 00:52:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235121AbjJREvz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Oct 2023 00:51:55 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EAA21B9
        for <linux-xfs@vger.kernel.org>; Tue, 17 Oct 2023 21:50:33 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 6C3D268B05; Wed, 18 Oct 2023 06:50:29 +0200 (CEST)
Date:   Wed, 18 Oct 2023 06:50:29 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Christoph Hellwig <hch@lst.de>, osandov@fb.com,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/8] xfs: use accessor functions for bitmap words
Message-ID: <20231018045029.GB15759@lst.de>
References: <169755742135.3167663.6426011271285866254.stgit@frogsfrogsfrogs> <169755742240.3167663.3888314487214346782.stgit@frogsfrogsfrogs> <20231017185316.GA31091@lst.de> <20231018020101.GB3195650@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231018020101.GB3195650@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Oct 17, 2023 at 07:01:01PM -0700, Darrick J. Wong wrote:
> Note that I still need this (and the _infoptr helper) for online repair
> to be able to generate an in-memory replacement of the bitmap and
> summary file and then be able to memcpy the words into the new ondisk
> file.
> 
> That said, I also noticed that the _rtbitmap_[gs]etword and
> _suminfo_{get,add} functions can be static inlines in xfs_rtbitmap.h, so
> I'll put them right after here and the compiler will (hopefully)
> collapse the nested inlines into something fairly compact.
> 
> Ok, I've made all those changes and I'll resend this patchset tomorrow
> after letting it test overnight.

Ok.  We'll also need to do the same for the summary file.  I still offer
to do the full work myself, but I won't have time for that until next
week.  I didn't really have time for this hack either, but I just carved
it off..
