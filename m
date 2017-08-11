Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:24188 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753474AbdHKQ04 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 11 Aug 2017 12:26:56 -0400
Date: Fri, 11 Aug 2017 09:26:20 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] vfs: freeze filesystems just prior to reboot
Message-ID: <20170811162620.GC24087@magnolia>
References: <20170519002032.GA21202@birch.djwong.org>
 <1495202431.1896310.982081664.066926F8@webmail.messagingengine.com>
 <20170519190115.GJ4519@birch.djwong.org>
 <1501791890.2285873.1062452112.61520C55@webmail.messagingengine.com>
 <20170805141621.GA10457@infradead.org>
 <20170805154528.GI24087@magnolia>
 <20170811100230.GC7064@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170811100230.GC7064@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: Colin Walters <walters@verbum.org>, xfs <linux-xfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-ext4 <linux-ext4@vger.kernel.org>

On Fri, Aug 11, 2017 at 03:02:30AM -0700, Christoph Hellwig wrote:
> On Sat, Aug 05, 2017 at 08:45:28AM -0700, Darrick J. Wong wrote:
> > FSCHECKPOINT?  Since that's your requirement anyway...
> > 
> > "Ensures that all filesystem metadata (which may be in a journal
> > somewhere) has been checkpointed back to disk." ?
> 
> What about a file system that is entirely log structured and just
> garbage collects some times?

"Ensure that <insert insufficient engineering insult here> external fs
drivers can find files on disk." :P

--D

> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
