Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F215C04FE0
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Aug 2023 18:15:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230504AbjHCSPq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 3 Aug 2023 14:15:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229527AbjHCSPo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Aug 2023 14:15:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D1871704;
        Thu,  3 Aug 2023 11:15:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 096E061E6C;
        Thu,  3 Aug 2023 18:15:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60162C433C8;
        Thu,  3 Aug 2023 18:15:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1691086541;
        bh=Yz12o17pxjfv8UNlGb+RqV6iHvHIX5yYabFhIVcGnJQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NzNzQ0kZIAWvy0jQWijO38E4IFU1ELuOTm+2z0/vri0vio9s55oaqAQUbTAugZAIc
         pzSwoiINevuBV/XhzNXc0q3NFdO0ZzAFSLxi3cGXgl3HAJB+X2Uh/r/FdNfEqxzs+x
         oEq7YaNNZC/rU+FCceLfXnczQ2a6sngVIJgi7nDzGkT1xBRDxTdPkZIen5+avgHd07
         8LXZzFT3Mn8qRcc0ic5S1kmXh1ScTSp3TgroiVqjyefr1jttGt6WWRWdWDbRFCjKZx
         XR0/Ri/7v2mM1CSXfr+YKoex1c07NyImzjyMt49SbRHVJ4+fuKehgj3MggKmlENRpl
         ceZJCjJnHL38w==
Date:   Thu, 3 Aug 2023 20:15:34 +0200
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
Subject: Re: [PATCH 08/12] fs: export fs_holder_ops
Message-ID: <20230803-hergibt-nachzahlen-296067ae0bb8@brauner>
References: <20230802154131.2221419-1-hch@lst.de>
 <20230802154131.2221419-9-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230802154131.2221419-9-hch@lst.de>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Aug 02, 2023 at 05:41:27PM +0200, Christoph Hellwig wrote:
> Export fs_holder_ops so that file systems that open additional block
> devices can use it as well.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Looks good to me,
Reviewed-by: Christian Brauner <brauner@kernel.org>
