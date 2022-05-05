Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5583EC433F5
	for <linux-xfs@archiver.kernel.org>; Thu,  5 May 2022 15:07:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356783AbiEEPLB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 May 2022 11:11:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232149AbiEEPK7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 May 2022 11:10:59 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 848C22D1FE;
        Thu,  5 May 2022 08:07:20 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id E05E368AA6; Thu,  5 May 2022 17:07:17 +0200 (CEST)
Date:   Thu, 5 May 2022 17:07:17 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     Christoph Hellwig <hch@lst.de>, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        "Darrick J. Wong" <djwong@kernel.org>, linux-btrfs@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 5/5] btrfs: allocate the btrfs_dio_private as part of
 the iomap dio bio
Message-ID: <20220505150717.GB19810@lst.de>
References: <20220504162342.573651-1-hch@lst.de> <20220504162342.573651-6-hch@lst.de> <c0335baa-3df5-5523-3537-6c419ace9f82@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c0335baa-3df5-5523-3537-6c419ace9f82@suse.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, May 05, 2022 at 11:12:45AM +0300, Nikolay Borisov wrote:
> nit: You are actually removing this member when copying the struct, that's 
> an independent change (albeit I'd say insignificant). Generally we prefer 
> such changes to be in separate patches with rationale when the given member 
> became redundant.

This one actually was entirely unused, but yes, this could have been
split into another patch.
