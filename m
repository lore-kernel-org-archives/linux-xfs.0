Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46716 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753342AbeCVOgE (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 22 Mar 2018 10:36:04 -0400
Date: Thu, 22 Mar 2018 15:35:59 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] [RFC] iomap: Use FUA for pure data O_DSYNC DIO writes
Message-ID: <20180322143559.pmwwwz4gic4wkq7r@quack2.suse.cz>
References: <20180301014144.28892-1-david@fromorbit.com>
 <CAA9_cmebHisbzU9CHVpq77UrtCTev_yT=3_SWhUX5oZNOJZwcw@mail.gmail.com>
 <CY4PR21MB074130B753A5BF81332A5171B8D20@CY4PR21MB0741.namprd21.prod.outlook.com>
 <20180313051037.GC18129@dastard>
 <BN6PR21MB074023CEF5DE1B70D0AA2363B8D20@BN6PR21MB0740.namprd21.prod.outlook.com>
 <20180313161242.GA11168@lst.de>
 <BN6PR21MB0740E78F2E7945B563BC71A8B8D20@BN6PR21MB0740.namprd21.prod.outlook.com>
 <20180319160650.mavedzwienzgwgqi@quack2.suse.cz>
 <BN6PR21MB074023968CDB8780FE9443A2B8D40@BN6PR21MB0740.namprd21.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BN6PR21MB074023968CDB8780FE9443A2B8D40@BN6PR21MB0740.namprd21.prod.outlook.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Robert Dorr <rdorr@microsoft.com>
Cc: Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@lst.de>, Dave Chinner <david@fromorbit.com>, Dan Williams <dan.j.williams@intel.com>, "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Theodore Ts'o <tytso@mit.edu>, Matthew Wilcox <mawilcox@microsoft.com>, Scott Konersmann <scottkon@microsoft.com>, Slava Oks <slavao@microsoft.com>, Jasraj Dange <jasrajd@microsoft.com>, Michael Nelson <micn@microsoft.com>

On Mon 19-03-18 16:14:16, Robert Dorr wrote:
> Awesome news on the spin.   
> 
> Are you going to be able to make changes to EXT4 to accommodate REQ_FUA
> without generic_write_flush to improve performance like was done for xfs?

I'm currently on a sick leave so I'm slow on replies. Sorry. I don't see a
reason why ext4 could not have the same optimization as XFS for that case
of direct IO. However I'm not sure when I get to implementing that.

								Honza

> -----Original Message-----
> From: Jan Kara <jack@suse.cz> 
> Sent: Monday, March 19, 2018 11:07 AM
> To: Robert Dorr <rdorr@microsoft.com>
> Cc: Christoph Hellwig <hch@lst.de>; Dave Chinner <david@fromorbit.com>; Dan Williams <dan.j.williams@intel.com>; linux-xfs@vger.kernel.org; linux-fsdevel <linux-fsdevel@vger.kernel.org>; Jan Kara <jack@suse.cz>; Theodore Ts'o <tytso@mit.edu>; Matthew Wilcox <mawilcox@microsoft.com>; Scott Konersmann <scottkon@microsoft.com>; Slava Oks <slavao@microsoft.com>; Jasraj Dange <jasrajd@microsoft.com>; Michael Nelson <micn@microsoft.com>
> Subject: Re: [PATCH] [RFC] iomap: Use FUA for pure data O_DSYNC DIO writes
> 
> On Tue 13-03-18 18:52:57, Robert Dorr wrote:
> > I tried the RWF_ODSYNC and xfs seems to honor properly but it causes 
> > ext4 to go spin out a single CPU and hang the system. 😊
> 
> Yeah, that's a bug in generic direct IO code that I've just recently fixed
> (d9c10e5b8863 "direct-io: Fix sleep in atomic due to sync AIO" in 4.16-rc4).
> 
> 								Honza
> 
> > 
> > 
> > -----Original Message-----
> > From: Christoph Hellwig <hch@lst.de>
> > Sent: Tuesday, March 13, 2018 11:13 AM
> > To: Robert Dorr <rdorr@microsoft.com>
> > Cc: Dave Chinner <david@fromorbit.com>; Dan Williams 
> > <dan.j.williams@intel.com>; linux-xfs@vger.kernel.org; Christoph 
> > Hellwig <hch@lst.de>; linux-fsdevel <linux-fsdevel@vger.kernel.org>; 
> > Jan Kara <jack@suse.cz>; Theodore Ts'o <tytso@mit.edu>; Matthew Wilcox 
> > <mawilcox@microsoft.com>; Scott Konersmann <scottkon@microsoft.com>; 
> > Slava Oks <slavao@microsoft.com>; Jasraj Dange 
> > <jasrajd@microsoft.com>; Michael Nelson <micn@microsoft.com>
> > Subject: Re: [PATCH] [RFC] iomap: Use FUA for pure data O_DSYNC DIO 
> > writes
> > 
> > > I think the answer is the iomap* logic makes sure to issue generic_write_sync for O_DSYNC W1 after W1 is completed by hardware and then waits for completion of the flush request (REQ_PREFLUSH) before W1 is returned to the AIO completion ring, preventing io_getevents from processing W1 before the flush occurs and completes.   I just need proper confirmation from the experts on this code that this is the expected behavior.
> > 
> > Yes. that is the case.
> > 
> > > For SQL Server using O_DIRECT | O_DSYNC on current kernels is very performance impacting.   Instead we enable a mode for SQL that opens O_DIRECT only and issues fsync/fdatasync when we are hardening log files or checkpointing data files.   This reduces the write, flush, write, flush pattern allowing for write, write, write, ... then flush as we only issue flush requests when required to maintain the data integrity boundaries of SQL Server.  The performance is significantly better then the device flush for each write as you can imagine.
> > > 
> > > Testing shows the FUA enhancement is better then the write, flush pattern.   For SQL Server we want to dynamically open with O_DIRECT | O_DSYNC when REQ_FUA can be properly used and open with O_DIRECT and leverage SQL Server's alternate flush scheme when running on older kernel or a system that does not support FUA (SATA, IDE, ...)
> > 
> > There is no really good way to figure this out except for benchmarking, given that the FUA use an implementation detail.
> > 
> > Btw, another feature that might be interesting to you is the RWF_DSYNC flag to the pwritev2 syscall, which allows to apply O_DSYNC semantics on a per-I/O basis instead of using it at open time.
> --
> Jan Kara <jack@suse.com>
> SUSE Labs, CR
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
