Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46148 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S932322AbdHVJel (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 22 Aug 2017 05:34:41 -0400
Date: Tue, 22 Aug 2017 11:34:38 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 10/13] mm: Wire up MAP_SYNC
Message-ID: <20170822093438.GC4909@quack2.suse.cz>
References: <20170817160815.30466-1-jack@suse.cz>
 <20170817160815.30466-11-jack@suse.cz>
 <20170821215703.GA24473@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170821215703.GA24473@linux.intel.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, linux-nvdimm@lists.01.org, Andy Lutomirski <luto@kernel.org>, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Dan Williams <dan.j.williams@intel.com>, Boaz Harrosh <boazh@netapp.com>

On Mon 21-08-17 15:57:03, Ross Zwisler wrote:
> On Thu, Aug 17, 2017 at 06:08:12PM +0200, Jan Kara wrote:
> > Pretty crude for now...
> > 
> > Signed-off-by: Jan Kara <jack@suse.cz>
> 
> One other thing that should probably be wired up before this is all said and
> done is the VmFlag string in /proc/<pid>/smaps.  Right now when we set this
> flag it ends up as ??:

Thanks. Patch folded so that I don't forget about this when updating the
patch to the new interface :).

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
