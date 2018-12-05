Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:43384 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727309AbeLEVaB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 5 Dec 2018 16:30:01 -0500
Date: Wed, 5 Dec 2018 13:30:00 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 01/11] vfs: copy_file_range source range over EOF should
 fail
Message-ID: <20181205213000.GA27133@infradead.org>
References: <20181203083416.28978-1-david@fromorbit.com>
 <20181203083416.28978-2-david@fromorbit.com>
 <CAOQ4uxhOQY8M5rbgHKREN5qpeDGHv0-xK3r37Lj6XfqFoE4qjg@mail.gmail.com>
 <20181204151332.GA32245@infradead.org>
 <20181204212948.GO6311@dastard>
 <20181205141252.GB21109@infradead.org>
 <20181205210824.GT6311@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181205210824.GT6311@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, Amir Goldstein <amir73il@gmail.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, Olga Kornievskaia <olga.kornievskaia@gmail.com>, Linux NFS Mailing List <linux-nfs@vger.kernel.org>, overlayfs <linux-unionfs@vger.kernel.org>, ceph-devel@vger.kernel.org, linux-cifs@vger.kernel.org

On Thu, Dec 06, 2018 at 08:08:24AM +1100, Dave Chinner wrote:
> On Wed, Dec 05, 2018 at 06:12:52AM -0800, Christoph Hellwig wrote:
> > > Realistically, though, I think an attempt to read beyond EOF for the
> > > copy should result in behaviour like read() (i.e. return 0 bytes),
> > > not EINVAL. The existing behaviour needs to change, though.
> > 
> > I agree with this statement.  So we don't we implement these semantics?
> 
> No, we don't.

Sorry - I was rushing that sentence out.  It should have been:

So why don't we implement these semantics?

> 
> I will rework the patch series to make attempts to copy beyond the
> end of the source file return 0 to indicate that there is no more
> data to copy rather than return an error.

Great, thanks!
