Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 101A7C7EE29
	for <linux-xfs@archiver.kernel.org>; Thu, 25 May 2023 12:04:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233449AbjEYMEI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 08:04:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240892AbjEYMEH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 08:04:07 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B40C12E;
        Thu, 25 May 2023 05:04:06 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 244AA68AFE; Thu, 25 May 2023 14:04:03 +0200 (CEST)
Date:   Thu, 25 May 2023 14:04:02 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Murphy Zhou <jencce.kernel@gmail.com>
Cc:     Linux-Next <linux-next@vger.kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>, akpm@linux-foundation.org
Subject: Re: your mail
Message-ID: <20230525120402.GA6281@lst.de>
References: <CADJHv_ujo+QUE7f420t4XACGw4RvVpckKSJcJ_9_Z0b2gdmr+g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADJHv_ujo+QUE7f420t4XACGw4RvVpckKSJcJ_9_Z0b2gdmr+g@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, May 25, 2023 at 08:01:22PM +0800, Murphy Zhou wrote:
> Hi Christoph,
> 
> The linux-next tree, since the next-20230522 tag, LTP/writev07[1]
> starts to fail on xfs, not on other fs. It was pass on the previous
> tag next-20230519.
> 
> After those 2 commits reverted on the top of 0522 tree, it passed.
> 
>     iomap: update ki_pos in iomap_file_buffered_write
>     iomap: assign current->backing_dev_info in iomap_file_buffered_write
> 
> (the second one was reverted because the first one depends on it)

Yes, they are known broken.  There has been a v2 on the list already,
which still has issues for fuse, so there will be a v3.

