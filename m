Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:44231 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751100AbdHLHe1 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 12 Aug 2017 03:34:27 -0400
Date: Sat, 12 Aug 2017 09:34:26 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v2 0/5] fs, xfs: block map immutable files for dax,
        dma-to-storage, and swap
Message-ID: <20170812073426.GB12679@lst.de>
References: <150181368442.32119.13336247800141074356.stgit@dwillia2-desk3.amr.corp.intel.com> <CAPcyv4ii41F-Rj9pPGc0FHwrQ=hkSF_f0niQDn5_NjU-wcL+gg@mail.gmail.com> <20170805095013.GC14930@lst.de> <CAPcyv4jgKmakB0WRUjx=2eD3YJ1x+C8cgnR6tA+g4+m+0etawQ@mail.gmail.com> <20170811104429.GA13736@lst.de> <CAPcyv4jrZ5a+zmAehZDxfP=+6BNCFAXOFWro2L7ruLkk+cY7OQ@mail.gmail.com> <CALCETrVvMbaxobdydtsdQWHyP1VhL1fpq1qS4M3=SmR1y4x5kw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrVvMbaxobdydtsdQWHyP1VhL1fpq1qS4M3=SmR1y4x5kw@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Andy Lutomirski <luto@kernel.org>
Cc: Dan Williams <dan.j.williams@intel.com>, Christoph Hellwig <hch@lst.de>, "Darrick J. Wong" <darrick.wong@oracle.com>, Jan Kara <jack@suse.cz>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Dave Chinner <david@fromorbit.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-xfs@vger.kernel.org, Jeff Moyer <jmoyer@redhat.com>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Ross Zwisler <ross.zwisler@linux.intel.com>, Linux API <linux-api@vger.kernel.org>

On Fri, Aug 11, 2017 at 08:57:18PM -0700, Andy Lutomirski wrote:
> One thing that makes me quite nervous about S_IOMAP_IMMUTABLE is the
> degree to which things go badly if one program relies on it while
> another program clears the flag: you risk corrupting unrelated
> filesystem metadata.  I think a userspace interface to pin the extent
> mapping of a file really wants a way to reliably keep it pinned (or to
> reliably zap the userspace application if it gets unpinned).

The nice thing is that no application can rely on it anyway..
