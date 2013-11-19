Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id AD3457F56
	for <xfs@oss.sgi.com>; Tue, 19 Nov 2013 06:17:25 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 6FC1B304053
	for <xfs@oss.sgi.com>; Tue, 19 Nov 2013 04:17:22 -0800 (PST)
Received: from mail-pa0-f47.google.com (mail-pa0-f47.google.com
	[209.85.220.47]) by cuda.sgi.com with ESMTP id c1SeugC49eFwbWJv
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 19 Nov 2013 04:17:21 -0800 (PST)
Received: by mail-pa0-f47.google.com with SMTP id kq14so3662629pab.6
	for <xfs@oss.sgi.com>; Tue, 19 Nov 2013 04:17:21 -0800 (PST)
Date: Tue, 19 Nov 2013 20:20:02 +0800
From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [BUG] ext2/3/4: dio reads stale data when we do some append dio
	writes
Message-ID: <20131119122002.GB5339@gmail.com>
References: <20131119095302.GA4534@gmail.com>
	<20131119102235.GA5010@infradead.org>
	<20131119104508.GA4630@gmail.com>
	<20131119110147.GA3323@infradead.org>
	<20131119111947.GA4782@gmail.com>
	<20131119111826.GA20485@infradead.org>
	<20131119120112.GN11434@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131119120112.GN11434@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com

On Tue, Nov 19, 2013 at 11:01:12PM +1100, Dave Chinner wrote:
> On Tue, Nov 19, 2013 at 03:18:26AM -0800, Christoph Hellwig wrote:
> > On Tue, Nov 19, 2013 at 07:19:47PM +0800, Zheng Liu wrote:
> > > Yes, I know that XFS has a shared/exclusive lock.  I guess that is why
> > > it can pass the test.  But another question is why xfs fails when we do
> > > some append dio writes with doing buffered read.
> > 
> > Can you provide a test case for that issue?
> 
> For XFS, appending direct IO writes only hold the IOLOCK exclusive
> for as long as it takes to guarantee that the the region between the
> old EOF and the new EOF is full of zeros before it is demoted.  i.e.
> once the region is guaranteed not to expose stale data, the
> exclusive IO lock is demoted to to a shared lock and a buffered read
> is then allowed to proceed concurrently with the DIO write.
> 
> Hence even appending writes occur concurrently with buffered reads,
> and if the read overlaps the block at the old EOF then the page
> brought into the page cache will have zeros in it.
> 
> FWIW, there's a wonderful comment in generic_file_direct_write()
> that pretty much covers this case:
> 
>         /*
>          * Finally, try again to invalidate clean pages which might have been
>          * cached by non-direct readahead, or faulted in by get_user_pages()
>          * if the source of the write was an mmap'ed region of the file
>          * we're writing.  Either one is a pretty crazy thing to do,
>          * so we don't support it 100%.  If this invalidation
>          * fails, tough, the write still worked...
>          */
> 
> The kernel code simply does not have the exclusion mechanisms to
> make concurrent buffered and direct IO robust. This is one of the
> problems (amongst many) that we've been looking to solve with an VFS
> level IO range lock of some kind....

Thanks for pointing it out.

                                                - Zheng

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
