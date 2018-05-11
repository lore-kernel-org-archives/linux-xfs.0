Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:51236 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752001AbeEKGUv (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 11 May 2018 02:20:51 -0400
Date: Fri, 11 May 2018 08:24:35 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 01/33] block: add a lower-level bio_add_page interface
Message-ID: <20180511062435.GD7962@lst.de>
References: <20180509074830.16196-1-hch@lst.de> <20180509074830.16196-2-hch@lst.de> <CACVXFVMPwQV8M0raTcLUtqDix-kEkYV3E3fJSVOVw8m=iiv5Uw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACVXFVMPwQV8M0raTcLUtqDix-kEkYV3E3fJSVOVw8m=iiv5Uw@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Ming Lei <tom.leiming@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>, "open list:XFS FILESYSTEM" <linux-xfs@vger.kernel.org>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, linux-block <linux-block@vger.kernel.org>, linux-mm <linux-mm@kvack.org>

On Thu, May 10, 2018 at 04:52:00PM +0800, Ming Lei wrote:
> On Wed, May 9, 2018 at 3:47 PM, Christoph Hellwig <hch@lst.de> wrote:
> > For the upcoming removal of buffer heads in XFS we need to keep track of
> > the number of outstanding writeback requests per page.  For this we need
> > to know if bio_add_page merged a region with the previous bvec or not.
> > Instead of adding additional arguments this refactors bio_add_page to
> > be implemented using three lower level helpers which users like XFS can
> > use directly if they care about the merge decisions.
> 
> The merge policy may be transparent to fs, such as multipage bvec.

The whole point of this series it to make it explicit.  That will have to
be carried over into a multipage bvec world.  That means the current
__bio_try_merge_page will have to remain as-is in that new world order,
but we'd also add a new __bio_try_merge_segment which merges beyond th
e page.  For the iomap and xfs code we'd first call __bio_try_merge_page,
if that fails increment the read/write count, and only after that
call __bio_try_merge_segment.

