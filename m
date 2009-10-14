Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n9EDJ4iA192884 for <xfs@oss.sgi.com>; Wed, 14 Oct 2009 08:19:04 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C222314C42D1
	for <xfs@oss.sgi.com>; Wed, 14 Oct 2009 06:20:33 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id rta74t3Z6U2sNsUC for
	<xfs@oss.sgi.com>; Wed, 14 Oct 2009 06:20:33 -0700 (PDT)
Date: Wed, 14 Oct 2009 09:20:30 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Wrapped journal record corruption on read at recovery - patch
	attached (was Re: XFS corruption with failover)
Message-ID: <20091014132030.GB15001@infradead.org>
References: <mailman.0.1255458988.141519.xfs@oss.sgi.com>
	<alpine.DEB.2.00.0910131342440.11546@andydesk>
	<20091013233324.GA28942@infradead.org>
	<alpine.DEB.2.00.0910131853200.11546@andydesk>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0910131853200.11546@andydesk>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Andy Poling <andy@realbig.com>
Cc: Christoph Hellwig <hch@infradead.org>, John Quigley <jquigley@cleversafe.com>, xfs@oss.sgi.com

On Tue, Oct 13, 2009 at 07:29:00PM -0500, Andy Poling wrote:
> Agreed.  I aimed for the smallest possible patch, thinking it might increase
> the likelihood of acceptance.  :-)

Heh.  In the Linux world and especially for this project we don't have
any problem with large fixes as long as they are well-explained and
self-contained, epecially if they are as well-documented as yours.

> I think the complexity here stems from an uncertainty (as we prepare for the
> "second" read) whether there was a first read or not.  As the code reads
> today, if there is data before the end, the first read is done and offset has
> been set.  If not, offset is NULL.
>
> It seems like the more elegant approach would be to set offset before the
> first read, and then update it if the first read takes place (in case it was
> unaligned).  That also gets rid of bufaddr, and seems like it might read
> better.

Yeah.  Note that in Linux 2.6.29 I did some changes in that are to
take the read and offset calculation into a common helper, so if the
changes become larger we might see some cosmetic difference between
older and newer kernels.

>> I suspect we might even be able to come up with a small enough testcase
>> for this for xfsqa, we just need to make sure logs are aligned and then
>> find a good enough heuristic to reproduce log wrapping.
>
> I don't know if it would be appropriate in that context, but maybe a tool to
> process an unwrapped log and wrap it would be easier?

We have a tool called loggen to produce log traffic as part of the QA
test suite.  We could try to use it to reproduce this case.  The most
important bit is that we work on a filesystem that actually requires
the alignment bits, that is one using a larger log sector size.  Just
curious, what is the value of sb_logsectlog for your test fs?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
