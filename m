Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n9EGg1Qh201873 for <xfs@oss.sgi.com>; Wed, 14 Oct 2009 11:42:02 -0500
Received: from realbig.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5AEC51D79BB6
	for <xfs@oss.sgi.com>; Wed, 14 Oct 2009 09:43:31 -0700 (PDT)
Received: from realbig.com (realbig.com [207.36.196.230]) by cuda.sgi.com with
	ESMTP id Zy5AppKmZOy8Lumm for <xfs@oss.sgi.com>;
	Wed, 14 Oct 2009 09:43:31 -0700 (PDT)
Date: Wed, 14 Oct 2009 11:43:16 -0500 (CDT)
From: Andy Poling <andy@realbig.com>
Subject: Re: Wrapped journal record corruption on read at recovery - patch
	attached (was Re: XFS corruption with failover)
In-Reply-To: <20091014132030.GB15001@infradead.org>
Message-ID: <alpine.DEB.2.00.0910141053150.5504@andydesk>
References: <mailman.0.1255458988.141519.xfs@oss.sgi.com>
	<alpine.DEB.2.00.0910131342440.11546@andydesk>
	<20091013233324.GA28942@infradead.org>
	<alpine.DEB.2.00.0910131853200.11546@andydesk>
	<20091014132030.GB15001@infradead.org>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: John Quigley <jquigley@cleversafe.com>, xfs@oss.sgi.com

On Wed, 14 Oct 2009, Christoph Hellwig wrote:
>> I think the complexity here stems from an uncertainty (as we prepare for the
>> "second" read) whether there was a first read or not.  As the code reads
>> today, if there is data before the end, the first read is done and offset has
>> been set.  If not, offset is NULL.
>>
>> It seems like the more elegant approach would be to set offset before the
>> first read, and then update it if the first read takes place (in case it was
>> unaligned).  That also gets rid of bufaddr, and seems like it might read
>> better.
>
> Yeah.  Note that in Linux 2.6.29 I did some changes in that are to
> take the read and offset calculation into a common helper, so if the
> changes become larger we might see some cosmetic difference between
> older and newer kernels.

I'll definitely take a look at that.  When I looked into doing what I had
previously described above, I realized it doesn't end up looking any clearer
than the original code.  If there is no first read, the second read could
potentially be re-aligned by xlog_bread(), which means we then need to use
xlog_align() to determine the real beginning of the data.

Given that, I'm beginning to think the existing code that only sets offset
when a read is done is pretty good.  I have one more idea to clean it up a bit
that I'll try.

Additionally, I have not been able to conclusively convince myself that with a
wrapped record, after a first read, the second read will never need to be
re-aligned... which would be problematic.  Is the beginning of the log always
correctly aligned?  If so, I will stop worrying about it.


> We have a tool called loggen to produce log traffic as part of the QA
> test suite.  We could try to use it to reproduce this case.  The most
> important bit is that we work on a filesystem that actually requires
> the alignment bits, that is one using a larger log sector size.  Just
> curious, what is the value of sb_logsectlog for your test fs?

If I'm interpreting this correctly, xfs_info says it is 4KiB:

meta-data=/dev/loop0             isize=256    agcount=8, agsize=65536 blks
          =                       sectsz=4096  attr=1
data     =                       bsize=4096   blocks=524288, imaxpct=25
          =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0
log      =internal               bsize=4096   blocks=2560, version=2
          =                       sectsz=4096  sunit=1 blks, lazy-count=0
realtime =none                   extsz=4096   blocks=0, rtextents=0

-Andy

It ain't what you don't know that gets you into trouble.
It's what you know for sure that just ain't so. - Mark Twain

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
