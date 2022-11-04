Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 492FAC4332F
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Nov 2022 07:27:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230098AbiKDH1a (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 4 Nov 2022 03:27:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231201AbiKDH1U (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Nov 2022 03:27:20 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 632236364;
        Fri,  4 Nov 2022 00:27:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=bBDyqd2UpLsT0RcL46m98sqRhIWJvOwJHs6k+JP7zEw=; b=Nai/mKK7mpMBipVp8erJ2nHgNc
        /dMXEe+zm3MeYzVrNjeODB/xFOLzql8Chx0w+qn12WgGRkGNN0J3ZMtN7OLV1YRtfFkT1PSmGx3t7
        WZwDwel/zGe3+iuf8dv4EVKyVa0HajO2A5iv4Le5NBTnNav52ztaCEOlV2to0Ei625Fa2VTfg1mF3
        C//SzfitUOP3/3iK8Izeuyze3QSomyPb9X73vQp/oOrcCVJKBx1PfJ8UlB+KnEVepTrZpzCyw8+E9
        wnZymYx05OGx05/ehRIPg2bK7n+lVOBo5/SFtJeuMc+AX/g0ayiqnnFJpgCV8gJIsxO0v1XDXn72O
        qQcJFhpg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oqr6d-002lyD-EI; Fri, 04 Nov 2022 07:27:11 +0000
Date:   Fri, 4 Nov 2022 00:27:11 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Matthew Wilcox <willy@infradead.org>,
        Dave Chinner <david@fromorbit.com>,
        "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Aravinda Herle <araherle@in.ibm.com>,
        David Howells <dhowells@redhat.com>
Subject: Re: [RFC 2/2] iomap: Support subpage size dirty tracking to improve
 write performance
Message-ID: <Y2S+z2mFGRRy335L@infradead.org>
References: <cover.1666928993.git.ritesh.list@gmail.com>
 <886076cfa6f547d22765c522177d33cf621013d2.1666928993.git.ritesh.list@gmail.com>
 <20221028210422.GC3600936@dread.disaster.area>
 <Y19EXLfn8APg3adO@casper.infradead.org>
 <Y2IyTx0VwXMxzs0G@infradead.org>
 <Y2Kqahg+u2HzgeQG@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y2Kqahg+u2HzgeQG@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Nov 02, 2022 at 10:35:38AM -0700, Darrick J. Wong wrote:
> Just so long as nobody imports that nonfeature of the bufferhead code
> where dirtying an already dirty bufferhead skips marking the folio dirty
> and writepage failures also fail to redirty the page.  That bit us hard
> recently and I strongly prefer not to repeat that.

Yes, that absolutely needs to be avoided.

> > We can always optimize by having a bit for the fairly common all dirty
> > case and only track and look at the array if that is no the case.
> 
> Yes, it would help to make the ranges in the bit array better defined
> than the semi-opencoded logic there is now.  (I'm whining specifically
> about the test_bit calls sprinkled around).

That is an absolutely requirement.  It was so obviosu to me that I
didn't bother to restate it after two others already pointed it out :)

> Once that's done it
> shouldn't be hard to add one more bit for the all-dirty state.  Though
> I'd want to see the numbers to prove that it saves us time anywhere.

We might be able to just use PG_private_2 in the page for now, but
maybe just adding a flags field to the iomap_page might be a better
idea, as the pageflags tend to have strange entanglements.
