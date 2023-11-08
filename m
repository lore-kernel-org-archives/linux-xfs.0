Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 202BAC4332F
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Nov 2023 16:25:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229579AbjKHQZa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 8 Nov 2023 11:25:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230493AbjKHQZ2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Nov 2023 11:25:28 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B77E1BFA
        for <linux-xfs@vger.kernel.org>; Wed,  8 Nov 2023 08:25:26 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BBB5C433C9;
        Wed,  8 Nov 2023 16:25:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1699460726;
        bh=qD+sFBOP9V2yUmYRqtOB3VeOWhm29ZlZGuTsoaz/cM4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=dPlufv1C6M7u5dLJzwxcRCXpDA0+ZgvcRrTe2ZqGH3BLqehtRYCWR6i1cL1M2WZw3
         zBqXj+z3CX/cBH0mDnRK+J3y9bRpJB+AcFtrOFH/pHZTrF9iNTm9MhA3mPNP1ZLCrg
         FEWSGkxIKc8R1WGnKVEc95ZpJR1M1keMyLMEqFy5+Nszf0NVJAJPn31Q49OxnPuJif
         AKSXzg7IZDHjEVpnUr3W/5oapj4V2707ml3npIpNNpbd+UIrSXLz4rXgza5C7gw5+R
         dMGnyYtQktoMsnQJ7cG2oh3p8ETYGci8MdSih6O2J4dZ7OGUWG+F0UHsVU9qHJx+gv
         8xKewJ9thyjmg==
Date:   Wed, 8 Nov 2023 08:25:25 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jens Axboe <axboe@kernel.dk>, Matthew Wilcox <willy@infradead.org>,
        Ilya Dryomov <idryomov@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-mm@kvack.org
Subject: Re: add and use a per-mapping stable writes flag v2
Message-ID: <20231108162525.GT1205143@frogsfrogsfrogs>
References: <20231025141020.192413-1-hch@lst.de>
 <20231108080518.GA6374@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231108080518.GA6374@lst.de>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Nov 08, 2023 at 09:05:18AM +0100, Christoph Hellwig wrote:
> Can we get at least patches 1 and 2 queued for for 6.7 given that
> they fix a regression?

I would say that all four should go in 6.7 because patches 3-4 fix wrong
behavior if the rtdev needs stablewrites but the datadev does not.

There probably aren't many users of a RHEL-disabled feature atop
specialty hardware, but IIRC it's still a data corruption vector.

(says me who blew up his last T10 PI drive last week :()

--D
