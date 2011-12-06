Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pB6H80oa244272 for <xfs@oss.sgi.com>; Tue, 6 Dec 2011 11:08:00 -0600
Received: from e33.co.us.ibm.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D426A29E2B6
	for <xfs@oss.sgi.com>; Tue,  6 Dec 2011 09:07:59 -0800 (PST)
Received: from e33.co.us.ibm.com (e33.co.us.ibm.com [32.97.110.151]) by
	cuda.sgi.com with ESMTP id 6ePbfR8cKFPjMoX1 for
	<xfs@oss.sgi.com>; Tue, 06 Dec 2011 09:07:59 -0800 (PST)
Received: from /spool/local
	by e33.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
	Violators will be prosecuted
	for <xfs@oss.sgi.com> from <sekharan@us.ibm.com>;
	Tue, 6 Dec 2011 10:06:48 -0700
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by d03relay05.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	pB6H4wIs040508 for <xfs@oss.sgi.com>; Tue, 6 Dec 2011 10:05:00 -0700
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP
	id pB6H4vKN020270
	for <xfs@oss.sgi.com>; Tue, 6 Dec 2011 10:04:58 -0700
Subject: Re: [PATCH] security: Delay freeing inode->i_security till the end
	of RCU grace period
From: Chandra Seetharaman <sekharan@us.ibm.com>
In-Reply-To: <1323189102.2165.39.camel@falcor>
References: <1323110541.31919.1451.camel@chandra-lucid.austin.ibm.com>
	<20111206151429.GB11874@infradead.org>
	<1323189102.2165.39.camel@falcor>
Date: Tue, 06 Dec 2011 11:04:53 -0600
Message-ID: <1323191093.31919.1475.camel@chandra-lucid.austin.ibm.com>
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
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>, Eric Paris <eparis@parisplace.org>, linux-security-module@vger.kernel.org, sekharan@linux.vnet.ibm.com, XFS Mailing List <xfs@oss.sgi.com>

On Tue, 2011-12-06 at 11:30 -0500, Mimi Zohar wrote:
> On Tue, 2011-12-06 at 10:14 -0500, Christoph Hellwig wrote:
> > On Mon, Dec 05, 2011 at 12:42:21PM -0600, Chandra Seetharaman wrote:
> > > while running test case 234 from xfstests test suite, I was getting an
> > > occational memory fault in inode_has_perm() with the following stack
> > 
> > Interesting.  Given that have no good way to free other data with the
> > normal inode callback it looks like we indeed need to do this
> > separately.
> > 
> > What about IMA or similar monsters?  Posix ACLs already are covered at
> > least.
> 
> Looks like a similar problem exists with the 'iint'.

I walked thru the code and saw integrity_iint_find() is the one that
would be used to see if a iint data structure is associated. And, all
all the invocations of integrity_iint_find() check for NULL and handle
it properly.

I might be wrong since I am not familiar with the code. Can you please
double check and let me know if I am wrong. 

Chandra
> 
> Mimi
> 


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
