Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98F66C43334
	for <linux-xfs@archiver.kernel.org>; Mon, 11 Jul 2022 05:17:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229479AbiGKFRa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 11 Jul 2022 01:17:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbiGKFR3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 11 Jul 2022 01:17:29 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 142BA19020
        for <linux-xfs@vger.kernel.org>; Sun, 10 Jul 2022 22:17:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=hAp8647cdemdlJDG/pFLps4CNrZ21FeM0XMAqRGGrbY=; b=erjgvJy3bnGcDYYSqswDRnOVk0
        oWUXXtbQmVNSx9CJ5gHRK9TMBkBeK1jaEl96ojnfAcB2jPlh8uJEEImxpiDO4KFqpx66kPTFdWAYQ
        534a8JnYE7FnbeWUBFz74TvDtaymRRItcwiD0SLzb8o6RHXfHepCuwp9uWLMaXLhCeLMzx1R+dgRk
        k9BohnBZbCsVpmPn64VVeTF6723ECTzIQlZWLvq3UwI1HX5n2dlDcYRIK798BGlLMIL8K9yaITrOW
        zJ4oEF+JtrIWN8aMl/aSCvZnNI5OKQdUpta0D7gzAfaVMm8Wc8k2rPdelXF2Ier3tdyov1hKf9UXY
        66qh1F3Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oAlnU-00G5Kr-OW; Mon, 11 Jul 2022 05:17:28 +0000
Date:   Sun, 10 Jul 2022 22:17:28 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/9] xfs: track the iunlink list pointer in the xfs_inode
Message-ID: <YsuyaLit0+QLKXmr@infradead.org>
References: <20220707234345.1097095-1-david@fromorbit.com>
 <20220707234345.1097095-3-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220707234345.1097095-3-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jul 08, 2022 at 09:43:38AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Having direct access to the i_next_unlinked pointer in unlinked
> inodes greatly simplifies the processing of inodes on the unlinked
> list. We no longer need to look up the inode buffer just to find
> next inode in the list if the xfs_inode is in memory. These
> improvements will be realised over upcoming patches as other
> dependencies on the inode buffer for unlinked list processing are
> removed.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
