Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p59B8XER172381 for <xfs@oss.sgi.com>; Thu, 9 Jun 2011 06:08:34 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E586E10C061F
	for <xfs@oss.sgi.com>; Thu,  9 Jun 2011 04:08:30 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	QqLExRBqsU9hj0W2 for <xfs@oss.sgi.com>;
	Thu, 09 Jun 2011 04:08:30 -0700 (PDT)
Date: Thu, 9 Jun 2011 07:08:26 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Port xfstests 145, 161, 175, 176, 185?
Message-ID: <20110609110826.GA14899@infradead.org>
References: <4DEFC41A.9070701@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4DEFC41A.9070701@linux.vnet.ibm.com>
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
To: Allison Henderson <achender@linux.vnet.ibm.com>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, Ext4 Developers List <linux-ext4@vger.kernel.org>, xfs-oss <xfs@oss.sgi.com>

On Wed, Jun 08, 2011 at 11:48:58AM -0700, Allison Henderson wrote:
> During one of my reviews for the punch hole tests patch set it was
> mentioned that it would be helpful to take the xfstests 145, 161,
> 175, 176, 185 and modify them such that they can run with out
> requiring the dmapi.  These tests contain some more interesting
> punch hole tests, but they dont normally run unless there is support
> for dmapi.
> 
> I did take a peek at them and I was thinking that if we decide to do
> this, we would probably need to do something like introduce a new
> set of source code that is similar to what is seen under the dmapi
> folder, but modified to use a generic interface instead of the dmapi
> libraries.  We could try to merge them into a single code path, but
> I think that may introduce more complexities than would be
> desirable.

Most of it should be doable using xfs_io.  If it's nessecary to write
new source files because of e.g. concurrency tests that we can't easily
do from xfs_io please add new source files to the src/ directory.

Also, please don't rewrite the actual existing dmapi test cases, but
add new ones testing these patterns using the fallocate interface, as
the coverage for the dmapi interface still is useful.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
