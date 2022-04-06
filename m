Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA8E9C433F5
	for <linux-xfs@archiver.kernel.org>; Wed,  6 Apr 2022 17:42:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239257AbiDFRoZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 6 Apr 2022 13:44:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239557AbiDFRoJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 Apr 2022 13:44:09 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12F52107AAB
        for <linux-xfs@vger.kernel.org>; Wed,  6 Apr 2022 09:26:12 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 6E01B68AFE; Wed,  6 Apr 2022 18:26:09 +0200 (CEST)
Date:   Wed, 6 Apr 2022 18:26:08 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/5] xfs: remove a superflous hash lookup when
 inserting new buffers
Message-ID: <20220406162608.GB590@lst.de>
References: <20220403120119.235457-1-hch@lst.de> <20220403120119.235457-4-hch@lst.de> <20220403230452.GP1544202@dread.disaster.area> <20220405150027.GB15992@lst.de> <20220405220121.GZ1544202@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220405220121.GZ1544202@dread.disaster.area>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Apr 06, 2022 at 08:01:21AM +1000, Dave Chinner wrote:
> Agreed, but you're making two distinct, significant modifications in
> the one patchset. One is changing the way we use a generic library
> functionality, the other is changing the entire structure of the
> lookup path.
> 
> IOWs, I was not saying the end result was bad, I was (clumsily)
> trying to suggest that you should split these two modifications into
> separate patches because they are largely separate changes.
> 
> Once I thought about it that way, and
> looking that them that way made me want to structure the code quite
> differently.

Ok, I'll see if I can split things up a bit better.

> 
> e.g. Most of the complexity goes away if we factor out the buffer
> trylock/locking code into a helper (like we have in the iomap code)
> and then have xfs_buf_insert() call it when it finds an existing
> buffer. Then the -EEXIST return value can go away, and
> xfs_buf_insert can return a locked buffer exactly the same as if it
> inserted a new buffer. Have the newly allocated buffer take a new
> perag reference, too, instead of stealing the caller's reference,
> and then all the differences between insert and -EEXIST cases go
> away.

I actually had that earlier as well and really like the flow of
the single function.  So it certainly is doable.
