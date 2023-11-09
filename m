Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59A58C4332F
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Nov 2023 05:21:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232350AbjKIFVN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 9 Nov 2023 00:21:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbjKIFVM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Nov 2023 00:21:12 -0500
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 731252683;
        Wed,  8 Nov 2023 21:21:10 -0800 (PST)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 07AAF67373; Thu,  9 Nov 2023 06:21:07 +0100 (CET)
Date:   Thu, 9 Nov 2023 06:21:06 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     zlang@redhat.com, hch@lst.de, fstests@vger.kernel.org,
        linux-xfs@vger.kernel.org, guan@eryu.me
Subject: Re: [PATCHSET v27.0 0/2] fstests: FIEXCHANGE is now an XFS ioctl
Message-ID: <20231109052106.GA29241@lst.de>
References: <169947992096.220003.8427995158013553083.stgit@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <169947992096.220003.8427995158013553083.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Nov 08, 2023 at 01:45:20PM -0800, Darrick J. Wong wrote:
> This has been running on the djcloud for months with no problems.  Enjoy!
> Comments and questions are, as always, welcome.

Isn't the branch all new?

Anyway, this fixes skipping the tests when not supported, and runs them
fine when supported:

Reviewed-by: Christoph Hellwig <hch@lst.de>
Tested-by: Christoph Hellwig <hch@lst.de>

although I wonder a bit if keeping functionality not actually supported
upstream in upstream xfstests is such a good idea.  Keeping it in
a development branch for the feature seems more flexible to me.  I guess
there is no point doing a forth and back for this one now, but maybe
should be more careful in the future.
