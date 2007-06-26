Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 26 Jun 2007 16:27:23 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l5QNRFtL008703
	for <xfs@oss.sgi.com>; Tue, 26 Jun 2007 16:27:16 -0700
Date: Wed, 27 Jun 2007 09:26:49 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: [PATCH 4/7][TAKE5] support new modes in fallocate
Message-ID: <20070626232649.GR31489@sgi.com>
References: <20070511110301.GB28425@in.ibm.com> <20070512080157.GF85884050@sgi.com> <20070612061652.GA6320@amitarora.in.ibm.com> <20070613235217.GS86004887@sgi.com> <20070614091458.GH5181@schatzie.adilger.int> <20070614120413.GD86004887@sgi.com> <20070614193347.GN5181@schatzie.adilger.int> <20070625132810.GA1951@amitarora.in.ibm.com> <20070625134500.GE1951@amitarora.in.ibm.com> <20070625215239.GK5181@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070625215239.GK5181@schatzie.adilger.int>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "Amit K. Arora" <aarora@linux.vnet.ibm.com>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, David Chinner <dgc@sgi.com>, suparna@in.ibm.com, cmm@us.ibm.com, xfs@oss.sgi.com

On Mon, Jun 25, 2007 at 03:52:39PM -0600, Andreas Dilger wrote:
> On Jun 25, 2007  19:15 +0530, Amit K. Arora wrote:
> > +#define FA_FL_DEALLOC	0x01 /* default is allocate */
> > +#define FA_FL_KEEP_SIZE	0x02 /* default is extend/shrink size */
> > +#define FA_FL_DEL_DATA	0x04 /* default is keep written data on DEALLOC */
> 
> In XFS one of the (many) ALLOC modes is to zero existing data on allocate.

No, none of the XFS allocation modes do that.

XFS_IOC_ALLOCSP, which does write zeros to disk, only allocates and
writes zeros in the range between the old file size and the new file size.
XFS_IOC_RESVSP, which alocates unwritten extents, only allocates
where extents do not currently exist. It does not zero existing
extents.

IOWs, you can't overwrite existing data with XFS preallocation.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
