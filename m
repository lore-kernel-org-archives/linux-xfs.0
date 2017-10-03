Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46617 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751667AbdJCUzD (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 3 Oct 2017 16:55:03 -0400
Date: Tue, 3 Oct 2017 22:54:59 +0200
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: Re: [RFC 0/5] fs: replace kthread freezing with filesystem
 freeze/thaw
Message-ID: <20171003205459.GI2294@wotan.suse.de>
References: <20171003185313.1017-1-mcgrof@kernel.org>
 <20171003193300.GD5362@ming.t460p>
 <20171003200511.GD2294@wotan.suse.de>
 <20171003204755.GB8848@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171003204755.GB8848@bombadil.infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Matthew Wilcox <willy@infradead.org>
Cc: "Luis R. Rodriguez" <mcgrof@kernel.org>, Ming Lei <ming.lei@redhat.com>, viro@zeniv.linux.org.uk, bart.vanassche@wdc.com, tytso@mit.edu, darrick.wong@oracle.com, jikos@kernel.org, rjw@rjwysocki.net, pavel@ucw.cz, len.brown@intel.com, linux-fsdevel@vger.kernel.org, boris.ostrovsky@oracle.com, jgross@suse.com, todd.e.brandt@linux.intel.com, nborisov@suse.com, jack@suse.cz, martin.petersen@oracle.com, ONeukum@suse.com, oleksandr@natalenko.name, oleg.b.antonyan@gmail.com, linux-pm@vger.kernel.org, linux-block@vger.kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org

On Tue, Oct 03, 2017 at 01:47:55PM -0700, Matthew Wilcox wrote:
> On Tue, Oct 03, 2017 at 10:05:11PM +0200, Luis R. Rodriguez wrote:
> > On Wed, Oct 04, 2017 at 03:33:01AM +0800, Ming Lei wrote:
> > > Even though this patch can make kthread to not do I/O during
> > > suspend/resume, the SCSI quiesce still can cause similar issue
> > > in other case, like when sending SCSI domain validation
> > > to transport_spi, which happens in revalidate path, nothing
> > > to do with suspend/resume.
> > 
> > Are you saying that the SCSI layer can generate IO even without the filesystem
> > triggering it?
> 
> The SCSI layer can send SCSI commands; they aren't I/Os in the sense that
> they do reads and writes to media,

Then there should be no issue waiting for the device to respond?

> but they are block requests.  Maybe those should be allowed even to frozen
> devices?

I'm afraid *maybe* won't suffice here, we need a clear explanation as
to what happens with frozen devices on the block layer *if* the device
driver is already suspended. Does the block layer just queue these?
If the goal is to just get queued but not processed, then why even
send these quiesce commands? Wouldn't they only be processed *after*
resume?

  Luis
