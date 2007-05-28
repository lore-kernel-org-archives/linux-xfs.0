Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 28 May 2007 16:06:19 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l4SN6DWt000883
	for <xfs@oss.sgi.com>; Mon, 28 May 2007 16:06:15 -0700
Date: Tue, 29 May 2007 09:06:08 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: raid5: I lost a XFS file system due to a minor IDE cable problem
Message-ID: <20070528230608.GH85884050@sgi.com>
References: <200705241318.30711.dap@mail.index.hu> <200705280350.18384.dap@mail.index.hu> <20070528021718.GZ85884050@sgi.com> <200705281317.32384.dap@mail.index.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200705281317.32384.dap@mail.index.hu>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Pallai Roland <dap@mail.index.hu>
Cc: David Chinner <dgc@sgi.com>, Linux-Raid <linux-raid@vger.kernel.org>, xfs@oss.sgi.com

On Mon, May 28, 2007 at 01:17:31PM +0200, Pallai Roland wrote:
> On Monday 28 May 2007 04:17:18 David Chinner wrote:
> > Hmmmm. A quick look at the linux code makes me thikn that background
> > writeback on linux has never been able to cause a shutdown in this case.
> > However, the same error on Irix will definitely cause a shutdown,
> > though....
>  I hope Linux will follow Irix, that's a consistent standpoint.

I raised a bug for this yesterday when writing that reply. It won't
get forgotten now....

>  David, have you a plan to implement your "reporting raid5 block layer"
>  idea?  No one else has caring about this silent data loss on temporary
>  (cable, power) failed raid5 arrays as I see, I really hope you do at least!

Yeah, I'd love to get something like this happening, but given it's about
half way down my list of "stuff to do when I have some spare time" I'd
say it will be about 2015 before I get to it.....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
