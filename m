Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D599DC001B0
	for <linux-xfs@archiver.kernel.org>; Fri, 14 Jul 2023 14:56:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235917AbjGNO40 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 14 Jul 2023 10:56:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235897AbjGNO4Z (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 14 Jul 2023 10:56:25 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36F6D35AD
        for <linux-xfs@vger.kernel.org>; Fri, 14 Jul 2023 07:56:15 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id ACD8F67373; Fri, 14 Jul 2023 16:56:11 +0200 (CEST)
Date:   Fri, 14 Jul 2023 16:56:11 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Christoph Hellwig <hch@lst.de>, cem@kernel.org,
        linux-xfs@vger.kernel.org, keescook@chromium.org,
        david@fromorbit.com
Subject: Re: [PATCH 1/3] xfs: convert flex-array declarations in struct
 xfs_attrlist*
Message-ID: <20230714145611.GA4012@lst.de>
References: <168934590524.3368057.8686152348214871657.stgit@frogsfrogsfrogs> <168934591095.3368057.15849162788748534581.stgit@frogsfrogsfrogs> <20230714144638.GA3628@lst.de> <20230714145439.GY108251@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230714145439.GY108251@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jul 14, 2023 at 07:54:39AM -0700, Darrick J. Wong wrote:
> FWIW I tried removing the attrlist ioctl structs, but I couldn't find
> anywhere else in the kernel uapi headers that defines them so that the
> ioctl code can actually format the buffer.

We need to keep them somewhere.  But I'd rather not do that in xfs_fs.h
which through xfsprogs goes into /usr/include/.

I'd probably do it locally in xfs_ioctl.c with an extended version of
the comment about matching the libattr structures.
