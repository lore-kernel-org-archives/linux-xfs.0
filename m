Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 02 Jul 2007 18:04:05 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l63140tL028956
	for <xfs@oss.sgi.com>; Mon, 2 Jul 2007 18:04:01 -0700
Date: Tue, 3 Jul 2007 11:03:50 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: [patch 3/3] Fix XFS_IOC_FSBULKSTAT{,_SINGLE} and XFS_IOC_FSINUMBERS in compat mode (try3)
Message-ID: <20070703010349.GP989688@sgi.com>
References: <20070619132549.266927601@suse.cz> <20070619132726.893544847@suse.cz> <20070628034957.GE989688@sgi.com> <4688C812.9020200@suse.cz> <20070702150509.GA32192@discovery.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070702150509.GA32192@discovery.suse.cz>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Michal Marek <mmarek@suse.cz>
Cc: David Chinner <dgc@sgi.com>, xfs@oss.sgi.com, linux-kernel@vger.kernel.org

On Mon, Jul 02, 2007 at 05:05:09PM +0200, Michal Marek wrote:
> On Mon, Jul 02, 2007 at 11:40:34AM +0200, Michal Marek wrote:
> > David Chinner wrote:
> > > I think we can remove xfs_bulkstat_one_compat() completely by using
> > > the same method you used with the xfs_inumber_fmt functions.
> > 
> > You mean xfs_ioc_bulkstat_compat() -> native xfs_bulkstat() -> native
> > xfs_bulkstat_one() -> a compat output formatter, so a
> > pointer-to-function passed to pointer-to-function? ;) I could (ab)use
> > the void *private_data arg which xfs_bulkstat passes unmodified to the
> > formatter; xfs_bulkstat_one() doesn't make use of it atm. I'll try it
> > and post the result in a while.
> 
> Hi David, what about this one? It about 30 lines shorter now :)

Great. Added to my tree. I'll run some tests and then get it
pushed out to the git trees.

FWIW, I reordered the includes to match the order in most other XFS
files so that it didn't break when I added other patches to
the tree....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
