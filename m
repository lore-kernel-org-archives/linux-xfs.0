Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8971CEB64DD
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Aug 2023 18:17:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231357AbjHCSQw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 3 Aug 2023 14:16:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230284AbjHCSQu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Aug 2023 14:16:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D581E6B;
        Thu,  3 Aug 2023 11:16:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1FBFA61E59;
        Thu,  3 Aug 2023 18:16:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DF71C433C7;
        Thu,  3 Aug 2023 18:16:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1691086608;
        bh=jHElnSoIwa9PxqE0kOuribt4l2JQm4atAORM+XiqKXw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CUrkmNM33tsmjwf5s3/3SgDi3sohBFaejHQ29wPnGblVeGTpkVP4dw6ptwP5rUf52
         bJSPuSDA4dXyZN72xMkSDJ6OaFoO173j1o0L/17vDP4dkgqBuskZYwqIquSsxyz3RC
         wCWX2/drF2IX8rTb0TLskYJJSnSOdfGBxqmqJBlDjrO3IS+r86TmR+OF/Q8BpYZqVi
         Q2n/dbQQnUh5kGlWjFnlBpgtKfcpckUbVCKAUvCrdySzjp/dv5MDTITafunfNOvGxE
         3v+lyjRY19RaHE1ZyNoROaK2c8hsj9ouZh9WJbEv8yCLsCANRL+ss2Yhq040Y7FakV
         MQU1jo2tOUBQA==
Date:   Thu, 3 Aug 2023 20:16:41 +0200
From:   Christian Brauner <brauner@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Al Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
        Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, Theodore Ts'o <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>,
        Ryusuke Konishi <konishi.ryusuke@gmail.com>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Jens Axboe <axboe@kernel.dk>, linux-btrfs@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-nilfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-block@vger.kernel.org
Subject: Re: [PATCH 09/12] ext4: drop s_umount over opening the log device
Message-ID: <20230803-unsterblich-hinbekommen-55b083eead3f@brauner>
References: <20230802154131.2221419-1-hch@lst.de>
 <20230802154131.2221419-10-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230802154131.2221419-10-hch@lst.de>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Aug 02, 2023 at 05:41:28PM +0200, Christoph Hellwig wrote:
> Just like get_tree_bdev needs to drop s_umount when opening the main
> device, we need to do the same for the ext4 log device to avoid a
> potential lock order reversal with s_unmount for the mark_dead path.
> 
> It might be preferable to just drop s_umount over ->fill_super entirely,
> but that will require a fairly massive audit first, so we'll do the easy
> version here first.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Looks good to me,
Reviewed-by: Christian Brauner <brauner@kernel.org>
