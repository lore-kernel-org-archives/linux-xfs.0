Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0236C0015E
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Aug 2023 17:17:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229737AbjHIRRZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 9 Aug 2023 13:17:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229651AbjHIRRY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 9 Aug 2023 13:17:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 165BA1FEF;
        Wed,  9 Aug 2023 10:17:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A7C7A64286;
        Wed,  9 Aug 2023 17:17:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0842FC433C8;
        Wed,  9 Aug 2023 17:17:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1691601443;
        bh=94i1PotkcLg9jI+MLSbKHuM8C7QSTJimTmZuP2Otc6U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EIpzweUbA9V5Z/oKkSwI+O4V/5jICySvAVER/UhObpw7aH98J3Yp5C00T4fU30T04
         nYpDViuDfTXMAlx2bZeIsW+i1T3Cg3Ldzt8weeKXpCWfFUwN6z8VpJX51XDVwahyVI
         hXe34vMf2Z5nNzqCYekkyOOg/COYvCu5ETjQxajWiKeda3sdnRL8wNn3bKz1QZClev
         dYNM5xuILF5Oui6lXQCgw21StSLDBS1O37SerU9VNTl6T8NNTRa7Hmuv0NFWmsuo/y
         E3YVJnl6tDGLsrvrRbo+wmX7XW4t1IPB4XW6BxN090Bd/PNPKG7OTbTWbDy5dx7jye
         6Ojjpd745w0Ig==
Date:   Wed, 9 Aug 2023 10:17:22 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Al Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <brauner@kernel.org>,
        Namjae Jeon <linkinjeon@kernel.org>,
        Sungjong Seo <sj1557.seo@samsung.com>,
        Theodore Ts'o <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
        linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        ntfs3@lists.linux.dev, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 07/13] xfs: close the external block devices in
 xfs_mount_free
Message-ID: <20230809171722.GF11336@frogsfrogsfrogs>
References: <20230808161600.1099516-1-hch@lst.de>
 <20230808161600.1099516-8-hch@lst.de>
 <20230809155524.GU11352@frogsfrogsfrogs>
 <20230809161411.GA2346@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230809161411.GA2346@lst.de>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Aug 09, 2023 at 06:14:11PM +0200, Christoph Hellwig wrote:
> On Wed, Aug 09, 2023 at 08:55:24AM -0700, Darrick J. Wong wrote:
> > If I'm following this correctly, putting the superblock flushes the
> > bdevs (though it doesn't invalidate the bdev mapping!) and only later
> > when we free the xfs_mount do we actually put the buftargs?
> > 
> > That works, though I still think we need to invalidate the bdev
> > pagecache for the log and data bdevs.
> 
> Yes, I'll respin it with that.  And I'll also add a comment to the
> invalidate_bdev calls because it's completely non-obvious as-is.

Ok, thanks!  You can reuse the commit message if you want. :)

--D
