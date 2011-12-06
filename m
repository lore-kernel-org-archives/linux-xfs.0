Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pB6GF3iE239476 for <xfs@oss.sgi.com>; Tue, 6 Dec 2011 10:15:03 -0600
Received: from e5.ny.us.ibm.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B965B578879
	for <xfs@oss.sgi.com>; Tue,  6 Dec 2011 08:15:02 -0800 (PST)
Received: from e5.ny.us.ibm.com (e5.ny.us.ibm.com [32.97.182.145]) by
	cuda.sgi.com with ESMTP id f0nvE304Br6OcS8D for
	<xfs@oss.sgi.com>; Tue, 06 Dec 2011 08:15:02 -0800 (PST)
Received: from /spool/local
	by e5.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
	Violators will be prosecuted
	for <xfs@oss.sgi.com> from <sekharan@us.ibm.com>;
	Tue, 6 Dec 2011 11:15:00 -0500
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay05.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	pB6GAM7J129210 for <xfs@oss.sgi.com>; Tue, 6 Dec 2011 11:10:24 -0500
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id
	pB6GACva025891 for <xfs@oss.sgi.com>; Tue, 6 Dec 2011 14:10:13 -0200
Subject: Re: [PATCH] security: Delay freeing inode->i_security till the end
	of RCU grace period
From: Chandra Seetharaman <sekharan@us.ibm.com>
In-Reply-To: <20111206151429.GB11874@infradead.org>
References: <1323110541.31919.1451.camel@chandra-lucid.austin.ibm.com>
	<20111206151429.GB11874@infradead.org>
Date: Tue, 06 Dec 2011 10:09:38 -0600
Message-ID: <1323187778.31919.1469.camel@chandra-lucid.austin.ibm.com>
Mime-Version: 1.0
Reply-To: sekharan@us.ibm.com
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
To: Christoph Hellwig <hch@infradead.org>
Cc: Eric Paris <eparis@parisplace.org>, linux-security-module@vger.kernel.org, XFS Mailing List <xfs@oss.sgi.com>

On Tue, 2011-12-06 at 10:14 -0500, Christoph Hellwig wrote:
> On Mon, Dec 05, 2011 at 12:42:21PM -0600, Chandra Seetharaman wrote:
> > while running test case 234 from xfstests test suite, I was getting an
> > occational memory fault in inode_has_perm() with the following stack
> 
> Interesting.  Given that have no good way to free other data with the
> normal inode callback it looks like we indeed need to do this
> separately.
> 
> What about IMA or similar monsters?  Posix ACLs already are covered at
> least.
> 

Hi Christoph,

The problem is pretty much located in the function
fs/inode.c:destroy_inode(), which calls __destroy_inode(), which does
the freeing, and then does the call_rcu() on the inode.

I looked at all the functions in __destroy_inode() and found only
security_inode_free() to be problematic. Others would handle the
situation gracefully.

Sorry for the lack of knowledge. what is IMA ?

Chandra


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
