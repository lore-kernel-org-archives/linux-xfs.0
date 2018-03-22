Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:48071 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751455AbeCVRCy (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 22 Mar 2018 13:02:54 -0400
Date: Thu, 22 Mar 2018 18:02:52 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v7 14/14] xfs, dax: introduce xfs_break_dax_layouts()
Message-ID: <20180322170252.GA5542@lst.de>
References: <152167302988.5268.4370226749268662682.stgit@dwillia2-desk3.amr.corp.intel.com> <152167311132.5268.8502709708606276650.stgit@dwillia2-desk3.amr.corp.intel.com> <20180322074303.GC28713@lst.de> <CAPcyv4iO+xDLTgYcAApQwec1hDrVSrAyeAiFoA=anzpxEiBydA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4iO+xDLTgYcAApQwec1hDrVSrAyeAiFoA=anzpxEiBydA@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dan Williams <dan.j.williams@intel.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-nvdimm <linux-nvdimm@lists.01.org>, Jan Kara <jack@suse.cz>, Dave Chinner <david@fromorbit.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>

On Thu, Mar 22, 2018 at 09:28:11AM -0700, Dan Williams wrote:
> I can switch to the for() loop model, but it isn't 'done' flag, it's a
> 'retry' flag. I.e. if xfs_break_leased_layouts() dropped
> XFS_MMAPLOCK_EXCL we need to retry xfs_break_dax_layouts(), and if

Oh, indeed.

> xfs_break_dax_layouts() slept we need to immediately retry it.
> So, how
> about this?

Ah, with that that the loop doesn't work too well, especially the
continue inside a switch statement is probably not to good.  I guess
we should just stick to your original, modulo better variable naming.
