Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 36D637F61
	for <xfs@oss.sgi.com>; Thu, 22 Jan 2015 14:19:01 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 23770304062
	for <xfs@oss.sgi.com>; Thu, 22 Jan 2015 12:19:01 -0800 (PST)
Received: from newverein.lst.de (verein.lst.de [213.95.11.211]) by
	cuda.sgi.com with ESMTP id 4eHMacQxrv4hAR58 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 22 Jan 2015 12:18:59 -0800 (PST)
Date: Thu, 22 Jan 2015 21:18:57 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 03/20] fs: add FL_LAYOUT lease type
Message-ID: <20150122201857.GA14577@lst.de>
References: <1421925006-24231-1-git-send-email-hch@lst.de>
	<1421925006-24231-4-git-send-email-hch@lst.de>
	<20150122201442.GJ898@fieldses.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150122201442.GJ898@fieldses.org>
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
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org, Jeff Layton <jlayton@primarydata.com>, Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

On Thu, Jan 22, 2015 at 03:14:42PM -0500, J. Bruce Fields wrote:
> On Thu, Jan 22, 2015 at 12:09:49PM +0100, Christoph Hellwig wrote:
> > This (ab-)uses the file locking code to allow filesystems to recall
> > outstanding pNFS layouts on a file.  This new lease type is similar but
> > not quite the same as FL_DELEG.  A FL_LAYOUT lease can always be granted,
> > an a per-filesystem lock (XFS iolock for the initial implementation)
> > ensures not FL_LAYOUT leases granted when we would need to recall them.
> 
> So when there's a conflicting operation it's xfs's responsibility to
> call break_layout and wait for the recall?
> 
> (And what roughly is the set of conflicting operations?)

The last patch in the series has a comment explaining this.

There's two categories:

 a) operations that need to be protected to maintain filesystem integrity:
    truncate, hole punch, collapse range, a well as any new operation
    that can deallocate blocks.
 b) operations that write data locally, and we want to provide a best
    effort attempt at data cohrency between local use and pFNS clients.
    This covers writes in all variants, and should apply to shared mmap
    writes, but sleeping in the page fault handler is too hard to bother
    with for this sort of best effort coherency.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
