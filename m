Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pB6Jo7Ns256832 for <xfs@oss.sgi.com>; Tue, 6 Dec 2011 13:50:08 -0600
Received: from e6.ny.us.ibm.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 71DDC29F9CC
	for <xfs@oss.sgi.com>; Tue,  6 Dec 2011 11:50:05 -0800 (PST)
Received: from e6.ny.us.ibm.com (e6.ny.us.ibm.com [32.97.182.146]) by
	cuda.sgi.com with ESMTP id Nb4qZQrf91OUBCx6 for
	<xfs@oss.sgi.com>; Tue, 06 Dec 2011 11:50:05 -0800 (PST)
Received: from /spool/local
	by e6.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
	Violators will be prosecuted
	for <xfs@oss.sgi.com> from <zohar@linux.vnet.ibm.com>;
	Tue, 6 Dec 2011 14:50:04 -0500
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay03.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	pB6Jmb77294236 for <xfs@oss.sgi.com>; Tue, 6 Dec 2011 14:48:37 -0500
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id
	pB6JmZTu014539 for <xfs@oss.sgi.com>; Tue, 6 Dec 2011 14:48:36 -0500
Subject: Re: [PATCH] security: Delay freeing inode->i_security till the end
	of RCU grace period
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
Date: Tue, 06 Dec 2011 14:45:53 -0500
In-Reply-To: <1323191093.31919.1475.camel@chandra-lucid.austin.ibm.com>
References: <1323110541.31919.1451.camel@chandra-lucid.austin.ibm.com>
	<20111206151429.GB11874@infradead.org>
	<1323189102.2165.39.camel@falcor>
	<1323191093.31919.1475.camel@chandra-lucid.austin.ibm.com>
Message-ID: <1323200753.2165.69.camel@falcor>
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
To: sekharan@us.ibm.com
Cc: Christoph Hellwig <hch@infradead.org>, Eric Paris <eparis@parisplace.org>, linux-security-module@vger.kernel.org, sekharan@linux.vnet.ibm.com, XFS Mailing List <xfs@oss.sgi.com>

On Tue, 2011-12-06 at 11:04 -0600, Chandra Seetharaman wrote:
> On Tue, 2011-12-06 at 11:30 -0500, Mimi Zohar wrote:
> > On Tue, 2011-12-06 at 10:14 -0500, Christoph Hellwig wrote:
> > > On Mon, Dec 05, 2011 at 12:42:21PM -0600, Chandra Seetharaman wrote:
> > > > while running test case 234 from xfstests test suite, I was getting an
> > > > occational memory fault in inode_has_perm() with the following stack
> > > 
> > > Interesting.  Given that have no good way to free other data with the
> > > normal inode callback it looks like we indeed need to do this
> > > separately.
> > > 
> > > What about IMA or similar monsters?  Posix ACLs already are covered at
> > > least.
> > 
> > Looks like a similar problem exists with the 'iint'.
> 
> I walked thru the code and saw integrity_iint_find() is the one that
> would be used to see if a iint data structure is associated. And, all
> all the invocations of integrity_iint_find() check for NULL and handle
> it properly.
> 
> I might be wrong since I am not familiar with the code. Can you please
> double check and let me know if I am wrong. 
> 
> Chandra

The assumption up to this point has been that the iint will be freed
only after the last call to ima_file_free(). The lack of an iint's
existence indicates that the file is not in the measurement policy.

As the iint is being freed, updating the iint flag is unnecessary for
base IMA.  However, in addition to updating the iint flags, the
IMA-appraisal patches (yet to be upstreamed) update the 'security.ima'
xattr.  Without an iint, the xattr will not be updated.

Mimi

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
