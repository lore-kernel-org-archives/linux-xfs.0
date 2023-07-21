Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53226EB64DD
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Jul 2023 06:26:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230085AbjGUG0F (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 21 Jul 2023 02:26:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229644AbjGUG0E (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Jul 2023 02:26:04 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE24A1984;
        Thu, 20 Jul 2023 23:26:02 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 7D6C168AA6; Fri, 21 Jul 2023 08:25:59 +0200 (CEST)
Date:   Fri, 21 Jul 2023 08:25:58 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Hannes Reinecke <hare@suse.de>
Cc:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Matthew Wilcox <willy@infradead.org>,
        Christian Brauner <christian@brauner.io>,
        linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/6] fs: add CONFIG_BUFFER_HEAD
Message-ID: <20230721062558.GB20845@lst.de>
References: <20230720140452.63817-1-hch@lst.de> <20230720140452.63817-7-hch@lst.de> <80507f03-86b4-6406-5ab1-5687b6d12d93@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <80507f03-86b4-6406-5ab1-5687b6d12d93@suse.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jul 20, 2023 at 05:53:52PM +0200, Hannes Reinecke wrote:
> Can we modify this to not have a compile-time option but rather a setting 
> somewhere? EG kernel option or flag in struct address_space?

Modify what?  The current code diables buffer_head suport on the
block devices when the kernel does not support buffer_heads.  There
is no good way to make that a run time decision :)
