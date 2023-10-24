Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93582C00A8F
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Oct 2023 15:10:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234700AbjJXPKp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 Oct 2023 11:10:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343600AbjJXPKg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 Oct 2023 11:10:36 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF5B910FA;
        Tue, 24 Oct 2023 08:10:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Ql2eltEQ8DJZApzT9fh9fzvtNpsHZrs3XNxvxh5UtMA=; b=d0OntYfe0ymPyU6quYfPhRqgcF
        OJxFCZ5PfPy9fB8HnMowNXML29uvEblIoET9udJzrwy3YZNOSsCcVkDS0LucMMqBEVLLiD10NcX5e
        I/xRRf+bmH+76vuIlWn/kMLFmrZjvjcGdbCSf+EOJTcR8TTNYr6h75dXk0j//BJdNgN1od94Uk9S3
        64Y1a2TvoE8Fll/xUUBIjP/3MUkVG7iixoNXWS1+M/koff/mE514g9i13gkaHcPiwUScwKBMgMgSW
        o4WN7pu1SJ9RLUvGq4V28TCcm/xcfitWI36hYIpYm5sXYf3R6z11gWbx6ALlpmiIm9HQlTeif7uo5
        86yxe23A==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1qvJ35-0039Gq-9s; Tue, 24 Oct 2023 15:10:27 +0000
Date:   Tue, 24 Oct 2023 16:10:27 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Ilya Dryomov <idryomov@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 1/3] filemap: add a per-mapping stable writes flag
Message-ID: <ZTfeYzvFV7QoVT1z@casper.infradead.org>
References: <20231024064416.897956-1-hch@lst.de>
 <20231024064416.897956-2-hch@lst.de>
 <20231024150053.GY3195650@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231024150053.GY3195650@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Oct 24, 2023 at 08:00:53AM -0700, Darrick J. Wong wrote:
> On Tue, Oct 24, 2023 at 08:44:14AM +0200, Christoph Hellwig wrote:
> > Add a per-address_space AS_STABLE_WRITES flag to control the behavior
> > in a more fine grained way.  The existing SB_I_STABLE_WRITES is kept
> > to initialize AS_STABLE_WRITES to the existing default which covers
> > most cases.
> 
> For a hot second I wondered if we could get rid of SB_I_STABLE_WRITES
> too, but then had an AHA moment when I saw that NFS also sets it.

I mean, we could if we're short on flags, or it just offends our
aesthetics to have it.  NFS (and others) would just have to
call mapping_set_stable_writes() in their inode initialisation
routines.  I don't personally find it a big deal either way.
