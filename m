Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86D7ACDB482
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Oct 2023 04:27:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235228AbjJLE1D (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 12 Oct 2023 00:27:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232842AbjJLE1B (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 Oct 2023 00:27:01 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DBF7A9;
        Wed, 11 Oct 2023 21:27:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=e0FwqvfdxBmrvTERo6MCwRNwMqkA7Y6Yy3C8ha1G0xI=; b=OiaVt9IlvQNv4caj9VAT/DgbaA
        0J1gfxXqjiZCGFGPalBL8l616nS7ODYVPNpzp57yWf0duxpzX0nC77+v5/B3D8kEoJK5TvjFtEYQY
        gQ8u86Jx+oQMvsBvaIzBAdrLDkQmzf2an7pHVQvvVYVxRv0/rwjI/AvIiqI1xBuJXD0lZSYx4XAAH
        bDx1JQQHjSkFmyP0WAFp2crLnqyf3Jur0iOCekCW+Ybk4R5Y1XHWiudDiU/8HgjqTQ/JPg35rfCEG
        9cqhfKWE4w4pFL/rb/mM7HA4XvMH5LJsPTU7870oNXYdSYyE2Qrmbk4BntCzmTgCEXOpgGgKrb6C0
        CczWwrPw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1qqnHf-00HMjq-1y;
        Thu, 12 Oct 2023 04:26:51 +0000
Date:   Wed, 11 Oct 2023 21:26:51 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Christoph Hellwig <hch@infradead.org>, zlang@redhat.com,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 1/3] xfs/178: don't fail when SCRATCH_DEV contains random
 xfs superblocks
Message-ID: <ZSd1i6nRut0FedmA@infradead.org>
References: <169687550821.3948976.6892161616008393594.stgit@frogsfrogsfrogs>
 <169687551395.3948976.8425812597156927952.stgit@frogsfrogsfrogs>
 <ZST2zRvtMrU0KlkN@infradead.org>
 <20231011191025.GX21298@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231011191025.GX21298@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 11, 2023 at 12:10:25PM -0700, Darrick J. Wong wrote:
> I'm pretty sure I've seen some NVME SSDs where you can issue devicewide
> DISCARDs and slowly watch the namespace utilization go down over tens of
> minutes; and reads will only eventually start returning zeroes.

Well, the second part is broken.  The first part is fine, and I've briefly
consulted with a firmware team implementing such a feature.  It just needs
to make sure to return zeroes right after the return of the discard
even if the blocks aren't erased yet, including after a powerfail.
(anyone who knows the XFS truncate / hole punch code will have a vague
idea of how that could work).

> However, that's orthogonal to this patch -- if the device doesn't
> support discard, _scratch_mkfs won't zero the entire disk to remove old
> dead superblocks that might have been written by previous tests.  After
> we shatter the primary super, the xfs_repair scanning code can still
> trip over those old supers and break the golden output.

True.  I have to admit I stopped reading the patch after the unmap
description.  I'll take another look.

