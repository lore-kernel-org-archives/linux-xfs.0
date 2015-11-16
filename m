Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 0BB947CBF
	for <xfs@oss.sgi.com>; Mon, 16 Nov 2015 13:48:54 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id F09E78F8050
	for <xfs@oss.sgi.com>; Mon, 16 Nov 2015 11:48:53 -0800 (PST)
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20]) by
	cuda.sgi.com with ESMTP id tdEKvHxWVjlJEYTw for
	<xfs@oss.sgi.com>; Mon, 16 Nov 2015 11:48:49 -0800 (PST)
Date: Mon, 16 Nov 2015 12:48:46 -0700
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH v2 03/11] pmem: enable REQ_FUA/REQ_FLUSH handling
Message-ID: <20151116194846.GB32203@linux.intel.com>
References: <1447459610-14259-1-git-send-email-ross.zwisler@linux.intel.com>
	<1447459610-14259-4-git-send-email-ross.zwisler@linux.intel.com>
	<CAPcyv4j4arHE+iAALn1WPDzSb_QSCDy8udtXU1FV=kYSZDfv8A@mail.gmail.com>
	<22E0F870-C1FB-431E-BF6C-B395A09A2B0D@dilger.ca>
	<CAPcyv4jwx3VzyRugcpH7KCOKM64kJ4Bq4wgY=iNJMvLTHrBv-Q@mail.gmail.com>
	<20151116133714.GB3443@quack.suse.cz>
	<20151116140526.GA6733@quack.suse.cz>
	<CAPcyv4jZjnkz2YYtGWmkA23KAUMT092kjRtFkJ3QrzgPfTucfA@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4jZjnkz2YYtGWmkA23KAUMT092kjRtFkJ3QrzgPfTucfA@mail.gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dan Williams <dan.j.williams@intel.com>
Cc: Jan Kara <jack@suse.cz>, Dave Hansen <dave.hansen@linux.intel.com>, "J. Bruce Fields" <bfields@fieldses.org>, Linux MM <linux-mm@kvack.org>, "H. Peter Anvin" <hpa@zytor.com>, Jeff Layton <jlayton@poochiereds.net>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, X86 ML <x86@kernel.org>, Ingo Molnar <mingo@redhat.com>, Matthew Wilcox <willy@linux.intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, linux-ext4 <linux-ext4@vger.kernel.org>, XFS Developers <xfs@oss.sgi.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Thomas Gleixner <tglx@linutronix.de>, Andreas Dilger <adilger@dilger.ca>, Theodore Ts'o <tytso@mit.edu>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Jan Kara <jack@suse.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox <matthew.r.wilcox@intel.com>

On Mon, Nov 16, 2015 at 09:28:59AM -0800, Dan Williams wrote:
> On Mon, Nov 16, 2015 at 6:05 AM, Jan Kara <jack@suse.cz> wrote:
> > On Mon 16-11-15 14:37:14, Jan Kara wrote:
> [..]
> > But a question: Won't it be better to do sfence + pcommit only in response
> > to REQ_FLUSH request and don't do it after each write? I'm not sure how
> > expensive these instructions are but in theory it could be a performance
> > win, couldn't it? For filesystems this is enough wrt persistency
> > guarantees...
> 
> We would need to gather the performance data...  The expectation is
> that the cache flushing is more expensive than the sfence + pcommit.

I think we should revisit the idea of removing wmb_pmem() from the I/O path in
both the PMEM driver and in DAX, and just relying on the REQ_FUA/REQ_FLUSH
path to do wmb_pmem() for all cases.  This was brought up in the thread
dealing with the "big hammer" fsync/msync patches as well.

https://lkml.org/lkml/2015/11/3/730

I think we can all agree from the start that wmb_pmem() will have a nonzero
cost, both because of the PCOMMIT and because of the ordering caused by the
sfence.  If it's possible to avoid doing it on each I/O, I think that would be
a win.

So, here would be our new flows:

PMEM I/O:
	write I/O(s) to the driver
		PMEM I/O writes the data using non-temporal stores

	REQ_FUA/REQ_FLUSH to the PMEM driver
		wmb_pmem() to order all previous writes and flushes, and to
		PCOMMIT the dirty data durably to the DIMMs

DAX I/O:
	write I/O(s) to the DAX layer
		write the data using regular stores (eventually to be replaced
		with non-temporal stores)

		flush the data with wb_cache_pmem() (removed when we use
		non-temporal stores)

	REQ_FUA/REQ_FLUSH to the PMEM driver
		wmb_pmem() to order all previous writes and flushes, and to
		PCOMMIT the dirty data durably to the DIMMs

DAX msync/fsync:
	writes happen to DAX mmaps from userspace

	DAX fsync/msync
		all dirty pages are written back using wb_cache_pmem()

	REQ_FUA/REQ_FLUSH to the PMEM driver
		wmb_pmem() to order all previous writes and flushes, and to
		PCOMMIT the dirty data durably to the DIMMs
	
DAX/PMEM zeroing (suggested by Dave: https://lkml.org/lkml/2015/11/2/772):
	PMEM driver receives zeroing request
		writes a bunch of zeroes using non-temporal stores

	REQ_FUA/REQ_FLUSH to the PMEM driver
		wmb_pmem() to order all previous writes and flushes, and to
		PCOMMIT the dirty data durably to the DIMMs

Having all these flows wait to do wmb_pmem() in the PMEM driver in response to
REQ_FUA/REQ_FLUSH has several advantages:

1) The work done and guarantees provided after each step closely match the
normal block I/O to disk case.  This means that the existing algorithms used
by filesystems to make sure that their metadata is ordered properly and synced
at a known time should all work the same.

2) By delaying wmb_pmem() until REQ_FUA/REQ_FLUSH time we can potentially do
many I/Os at different levels, and order them all with a single wmb_pmem().
This should result in a performance win.

Is there any reason why this wouldn't work or wouldn't be a good idea?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
