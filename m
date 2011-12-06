Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pB6Gq8iE242276 for <xfs@oss.sgi.com>; Tue, 6 Dec 2011 10:52:08 -0600
Received: from e2.ny.us.ibm.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BBFE057844F
	for <xfs@oss.sgi.com>; Tue,  6 Dec 2011 08:52:07 -0800 (PST)
Received: from e2.ny.us.ibm.com (e2.ny.us.ibm.com [32.97.182.142]) by
	cuda.sgi.com with ESMTP id zclFQX8MlAKfFQew for
	<xfs@oss.sgi.com>; Tue, 06 Dec 2011 08:52:07 -0800 (PST)
Received: from /spool/local
	by e2.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
	Violators will be prosecuted
	for <xfs@oss.sgi.com> from <zohar@linux.vnet.ibm.com>;
	Tue, 6 Dec 2011 11:52:02 -0500
Received: from d03av06.boulder.ibm.com (d03av06.boulder.ibm.com [9.17.195.245])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	pB6GlMKx308870 for <xfs@oss.sgi.com>; Tue, 6 Dec 2011 11:47:23 -0500
Received: from d03av06.boulder.ibm.com (loopback [127.0.0.1])
	by d03av06.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP
	id pB6GlMNj004478
	for <xfs@oss.sgi.com>; Tue, 6 Dec 2011 09:47:22 -0700
Subject: Re: [PATCH] security: Delay freeing inode->i_security till the end
	of RCU grace period
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
Date: Tue, 06 Dec 2011 11:44:39 -0500
In-Reply-To: <1323187778.31919.1469.camel@chandra-lucid.austin.ibm.com>
References: <1323110541.31919.1451.camel@chandra-lucid.austin.ibm.com>
	<20111206151429.GB11874@infradead.org>
	<1323187778.31919.1469.camel@chandra-lucid.austin.ibm.com>
Message-ID: <1323189880.2165.43.camel@falcor>
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
To: sekharan@linux.vnet.ibm.com
Cc: Christoph Hellwig <hch@infradead.org>, Eric Paris <eparis@parisplace.org>, linux-security-module@vger.kernel.org, XFS Mailing List <xfs@oss.sgi.com>

On Tue, 2011-12-06 at 10:09 -0600, MAILER-DAEMON wrote:
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
> > 
> 
> Hi Christoph,
> 
> The problem is pretty much located in the function
> fs/inode.c:destroy_inode(), which calls __destroy_inode(), which does
> the freeing, and then does the call_rcu() on the inode.
> 
> I looked at all the functions in __destroy_inode() and found only
> security_inode_free() to be problematic. Others would handle the
> situation gracefully.
> 
> Sorry for the lack of knowledge. what is IMA ?
> 
> Chandra

security_inode_free() calls security/integrity/iint.c:
integrity_inode_free(), which frees the 'iint'.  For more information on
IMA, refer to linux-ima.sf.net.

thanks,

Mimi

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
