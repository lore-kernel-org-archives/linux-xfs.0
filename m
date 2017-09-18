Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35605 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1755160AbdIRJbq (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 18 Sep 2017 05:31:46 -0400
Date: Mon, 18 Sep 2017 11:31:37 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v4 2/3] mm: introduce MAP_VALIDATE a mechanism for adding
 new mmap flags
Message-ID: <20170918093137.GF32516@quack2.suse.cz>
References: <150277752553.23945.13932394738552748440.stgit@dwillia2-desk3.amr.corp.intel.com>
 <150277753660.23945.11500026891611444016.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20170815122701.GF27505@quack2.suse.cz>
 <CAA9_cmc0vejxCsc1NWp5b4C0CSsO5xetF3t6LCoCuEYB6yPiwQ@mail.gmail.com>
 <20170917173945.GA22200@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170917173945.GA22200@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: Dan Williams <dan.j.williams@intel.com>, Jan Kara <jack@suse.cz>, "Darrick J. Wong" <darrick.wong@oracle.com>, Arnd Bergmann <arnd@arndb.de>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Linux API <linux-api@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-xfs@vger.kernel.org, linux-mm <linux-mm@kvack.org>, Andy Lutomirski <luto@kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>

On Sun 17-09-17 19:39:45, Christoph Hellwig wrote:
> On Sat, Sep 16, 2017 at 08:44:14PM -0700, Dan Williams wrote:
> > So it wasn't all that easy, and Linus declined to take it. I think we
> > should add a new ->mmap_validate() file operation and save the
> > tree-wide cleanup until later.
> 
> Note that we already have a mmap_capabilities callout for nommu,
> I wonder if we could generalize that.

So if I understood Dan right, Linus refused to merge the patch which adds
'flags' argument to ->mmap callback. That is actually logically independent
change from validating flags passed to mmap(2) syscall. Dan did it just to
save himself from adding a VMA flag for MAP_DIRECT.

For validating flags passed to mmap(2), I agree we could use
->mmap_capabilities() instead of mmap_supported_mask Dan has added. But I
don't have a strong opinion there.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
