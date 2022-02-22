Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0CD3C433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Feb 2022 08:33:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229489AbiBVIeJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 22 Feb 2022 03:34:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbiBVIeI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 22 Feb 2022 03:34:08 -0500
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0D35118614
        for <linux-xfs@vger.kernel.org>; Tue, 22 Feb 2022 00:33:43 -0800 (PST)
Received: by verein.lst.de (Postfix, from userid 2407)
        id A80B668AA6; Tue, 22 Feb 2022 09:33:40 +0100 (CET)
Date:   Tue, 22 Feb 2022 09:33:40 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Andrey Zhadchenko <andrey.zhadchenko@virtuozzo.com>
Cc:     linux-xfs@vger.kernel.org, christian.brauner@ubuntu.com,
        hch@lst.de, djwong@kernel.org
Subject: Re: [PATCH] xfs: do not clear S_ISUID|S_ISGID for idmapped mounts
Message-ID: <20220222083340.GA5899@lst.de>
References: <20220221182218.748084-1-andrey.zhadchenko@virtuozzo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220221182218.748084-1-andrey.zhadchenko@virtuozzo.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Feb 21, 2022 at 09:22:18PM +0300, Andrey Zhadchenko wrote:
> xfs_fileattr_set() handles idmapped mounts correctly and do not drop this
> bits.
> Unfortunately chown syscall results in different callstask:
> i_op->xfs_vn_setattr()->...->xfs_setattr_nonsize() which checks if process
> has CAP_FSETID capable in init_user_ns rather than mntns userns.

Can you add an xfstests the exercises this path?

The fix itself looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
