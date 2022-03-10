Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E861C433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 10 Mar 2022 08:07:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240203AbiCJIIs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 10 Mar 2022 03:08:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240204AbiCJIIr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 10 Mar 2022 03:08:47 -0500
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA92A12E159
        for <linux-xfs@vger.kernel.org>; Thu, 10 Mar 2022 00:07:47 -0800 (PST)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 0FC7568AFE; Thu, 10 Mar 2022 09:07:44 +0100 (CET)
Date:   Thu, 10 Mar 2022 09:07:43 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, fdmanana@kernel.org,
        andrey.zhadchenko@virtuozzo.com, brauner@kernel.org,
        david@fromorbit.com, hch@lst.de
Subject: Re: [PATCH 1/2] xfs: use setattr_copy to set vfs inode attributes
Message-ID: <20220310080743.GA25823@lst.de>
References: <164685372611.495833.8601145506549093582.stgit@magnolia> <164685373184.495833.7593050602112292799.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <164685373184.495833.7593050602112292799.stgit@magnolia>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
