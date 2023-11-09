Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0CFDC4167D
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Nov 2023 16:15:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230461AbjKIQPE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 9 Nov 2023 11:15:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234670AbjKIQPB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Nov 2023 11:15:01 -0500
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E80AC324A
        for <linux-xfs@vger.kernel.org>; Thu,  9 Nov 2023 08:14:58 -0800 (PST)
Received: by verein.lst.de (Postfix, from userid 2407)
        id F1FE068B05; Thu,  9 Nov 2023 17:14:54 +0100 (CET)
Date:   Thu, 9 Nov 2023 17:14:54 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] repair: fix the call to search_rt_dup_extent in
 scan_bmapbt
Message-ID: <20231109161454.GA5453@lst.de>
References: <20231109160233.703566-1-hch@lst.de> <20231109161319.GF1205143@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231109161319.GF1205143@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Nov 09, 2023 at 08:13:19AM -0800, Darrick J. Wong wrote:
> In the longer run: whenever the libxfs 6.7 sync hits the list, I'll be
> ready to go with a pair of broader patches to fix all the confusing /
> incorrect units and variable names in xfs_repair.  This ought to get
> merged to xfsprogs 6.6.

Yes, please!

FYI, I've done a prototype of annotation the rxtnumber_t with __nocast
in the kernel, and except for the ugliness in casting all the 0 values
it actually looks pretty nice.  I hope with the extra work Luc promised
we can actually annotate our non-byte offset/bno/len fields with it and
get real type checking for them.

