Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDD24CDB46E
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Oct 2023 15:07:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233039AbjJLPHQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 12 Oct 2023 11:07:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232712AbjJLPHP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 Oct 2023 11:07:15 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23E9A90
        for <linux-xfs@vger.kernel.org>; Thu, 12 Oct 2023 08:07:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=g75qOUtlM2UxdqGnT+sgTAeAKCMXu4QiHMG9BPg1AHk=; b=GNGwFoLwbecaUV4uMaDAYD47zw
        w4iD85V6MZebmNjcEBkaFTNx/+YeBfHVziWZfr5bwFG7Q6mEfvbqQ4a5BkLP/A9l5JnjzUPJWduhw
        Hh01WTOi/0BIT4aY82+DGHf5zrXfXF63cUr5Pz+uds6wA+CKKOcUoWzYngJU+OficW3gKa1WdVo6P
        CJiRHoPXgvhtT9nu74jWV/UP3JKkhErSE+D2nM2zKXx1Mgcvvh3HSgVHtJMmuOMQvKdRbOByIIJ1u
        kMePic1BQjtJ16+ZjJNZaz++N0bgh95PXY33c7Bt2kVXX92VvUrEtCYp4Ttr11ZG/8sYEIZfe0qGG
        OXg+DRZg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1qqxHM-001FZr-18;
        Thu, 12 Oct 2023 15:07:12 +0000
Date:   Thu, 12 Oct 2023 08:07:12 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Catherine Hoang <catherine.hoang@oracle.com>,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH v3] xfs: allow read IO and FICLONE to run concurrently
Message-ID: <ZSgLoD0NWRH0bCGE@infradead.org>
References: <20231012010845.64286-1-catherine.hoang@oracle.com>
 <ZSevmga8j3dNl34J@infradead.org>
 <20231012150231.GE21298@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231012150231.GE21298@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 12, 2023 at 08:02:31AM -0700, Darrick J. Wong wrote:
> Catherine started with this,
> https://lore.kernel.org/linux-xfs/8911B94D-DD29-4D6E-B5BC-32EAF1866245@oracle.com/
> 
> and the rest of us whittled it down to the single patch you see here.
> Sections 1-2 are still relevant; S3 was the path not taken.

I'd still take the core of that into the actual commit message.  This
part, maybe slightly rewored:

"One of our VM cluster management products needs to snapshot KVM image
files so that they can be restored in case of failure. Snapshotting is
done by redirecting VM disk writes to a sidecar file and using reflink
on the disk image, specifically the FICLONE ioctl as used by
"cp --reflink". Reflink locks the source and destination files while it
operates, which means that reads from the main vm disk image are blocked,
causing the vm to stall. When an image file is heavily fragmented, the
copy process could take several minutes. Some of the vm image files have
50-100 million extent records, and duplicating that much metadata locks
the file for 30 minutes or more. Having activities suspended for such
a long time in a cluster node could result in node eviction."

