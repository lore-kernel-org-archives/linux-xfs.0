Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pB6GZ758241047 for <xfs@oss.sgi.com>; Tue, 6 Dec 2011 10:35:08 -0600
Received: from e3.ny.us.ibm.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1F0D929ED86
	for <xfs@oss.sgi.com>; Tue,  6 Dec 2011 08:35:06 -0800 (PST)
Received: from e3.ny.us.ibm.com (e3.ny.us.ibm.com [32.97.182.143]) by
	cuda.sgi.com with ESMTP id 7BN1q83xKT3vBQN8 for
	<xfs@oss.sgi.com>; Tue, 06 Dec 2011 08:35:06 -0800 (PST)
Received: from /spool/local
	by e3.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
	Violators will be prosecuted
	for <xfs@oss.sgi.com> from <zohar@linux.vnet.ibm.com>;
	Tue, 6 Dec 2011 11:35:03 -0500
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d01relay05.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	pB6GYajD084756 for <xfs@oss.sgi.com>; Tue, 6 Dec 2011 11:34:36 -0500
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP
	id pB6GYOgP030828
	for <xfs@oss.sgi.com>; Tue, 6 Dec 2011 09:34:24 -0700
Subject: Re: [PATCH] security: Delay freeing inode->i_security till the end
	of RCU grace period
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
Date: Tue, 06 Dec 2011 11:30:36 -0500
In-Reply-To: <20111206151429.GB11874@infradead.org>
References: <1323110541.31919.1451.camel@chandra-lucid.austin.ibm.com>
	<20111206151429.GB11874@infradead.org>
Message-ID: <1323189102.2165.39.camel@falcor>
Mime-Version: 1.0
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
Cc: Paris <eparis@parisplace.org>, linux-security-module@vger.kernel.org, Eric@oss.sgi.com, sekharan@linux.vnet.ibm.com, XFS Mailing List <xfs@oss.sgi.com>

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

Looks like a similar problem exists with the 'iint'.

Mimi

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
