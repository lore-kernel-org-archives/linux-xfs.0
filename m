Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:54181 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751497AbdB1PMd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Feb 2017 10:12:33 -0500
Date: Tue, 28 Feb 2017 07:11:35 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: LTP write03 writev07 xfs failures
Message-ID: <20170228151135.GA17880@infradead.org>
References: <20170227042220.syhudcilvyettwnf@XZHOUW.usersys.redhat.com>
 <20170227160901.GB9344@bfoster.bfoster>
 <20170227201334.GC9344@bfoster.bfoster>
 <20170228140455.GB9371@infradead.org>
 <20170228145940.GA13377@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170228145940.GA13377@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, Xiong Zhou <xzhou@redhat.com>, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Tue, Feb 28, 2017 at 09:59:40AM -0500, Brian Foster wrote:
> Heh. I've appended what I'm currently playing around with. It's
> certainly uglier, but not terrible IMO (outside of the fact that we have
> to look at the buffer_heads). This seems to address the problem, but
> still only lightly tested...
> 
> An entirely different approach may be to somehow or another
> differentiate allocated delalloc blocks from "found" delalloc blocks in
> the iomap_begin() handler, and then perhaps encode that into the iomap
> such that the iomap_end() handler has an explicit reference of what to
> punch. Personally, I wouldn't mind doing something like the below short
> term to fix the regression and then incorporate an iomap enhancement to
> break the buffer_head dependency.

We actually have a IOMAP_F_NEW for this already, but so far it's
only used by the DIO and DAX code.
