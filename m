Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AB05C7619A
	for <linux-xfs@archiver.kernel.org>; Wed,  5 Apr 2023 10:48:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236989AbjDEKsG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 5 Apr 2023 06:48:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237261AbjDEKsD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 5 Apr 2023 06:48:03 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85ADB4EDB
        for <linux-xfs@vger.kernel.org>; Wed,  5 Apr 2023 03:48:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=8bqp5bQA0dXBWU7S2ruHqXN/7TiazLagtAgqhuA/ox4=; b=4mcJaooEDghZXUCHZ1xqFlBVZv
        yG+zSG1rByXzMoePIX0vKFpwjCx+QJJnXy7+LUSrZ+YU+M93Y/BW7fVa+aSYgifxU/xsh3GcP8khl
        NmeKW2RXjiDVWgM1hHoJ+Z7qol1QYFOTTALmkIm6x+8IZ9b3nMyz4BDcW5Zlp92oJG8C7fpIyIJXM
        NHOPx8KiJBJMYPB9PlV+rOxmzIIy0sFyC9YZZj/SB/zcKo0X2dHWVGuruvulnos8NSovCZ03fn2Q4
        HYuG34ybqB3ubre2OQaDSVd2YcqwTf+s4MQvdenb61sBbYEk+No9UCO5KfbVL89ASH+GK3AfCND4z
        8VcDsEig==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1pk0gK-0048Eu-1e;
        Wed, 05 Apr 2023 10:48:00 +0000
Date:   Wed, 5 Apr 2023 03:48:00 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     torvalds@linux-foundation.org, linux-xfs@vger.kernel.org,
        david@fromorbit.com
Subject: Re: [PATCH 1/3] xfs: stabilize the tolower function used for
 ascii-ci dir hash computation
Message-ID: <ZC1R4IRx7ZiBeeLJ@infradead.org>
References: <168062802052.174368.10967543545284986225.stgit@frogsfrogsfrogs>
 <168062802637.174368.12108206682992075671.stgit@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <168062802637.174368.12108206682992075671.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Apr 04, 2023 at 10:07:06AM -0700, Darrick J. Wong wrote:
> Which means that the kernel and userspace do not agree on the hash value
> for a directory filename that contains those higher values.  The hash
> values are written into the leaf index block of directories that are
> larger than two blocks in size, which means that xfs_repair will flag
> these directories as having corrupted hash indexes and rewrite the index
> with hash values that the kernel now will not recognize.
> 
> Because the ascii-ci feature is not frequently enabled and the kernel
> touches filesystems far more frequently than xfs_repair does, fix this
> by encoding the kernel's toupper predicate and tolower functions into
> libxfs.  This makes userspace's behavior consistent with the kernel.

I agree with making the userspace behavior consistent with the actual
kernel behavior.  Sadly the documented behavior differs from both
of them, so I think we need to also document the actual tables used
in the mkfs.xfs manpage, as it isn't actually just ASCII.

Does the kernel twolower behavior map to an actual documented charset?
In that case we can just point to it, which would be way either than
documenting all the details.

