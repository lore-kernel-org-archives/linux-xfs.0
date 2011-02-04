Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p14AsM3e008870
	for <linux-xfs@oss.sgi.com>; Fri, 4 Feb 2011 04:54:23 -0600
Received: from ipmail06.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E9D7A155122F
	for <linux-xfs@oss.sgi.com>; Fri,  4 Feb 2011 02:56:51 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	23wwebG85OXtLvdz for <linux-xfs@oss.sgi.com>;
	Fri, 04 Feb 2011 02:56:51 -0800 (PST)
Date: Fri, 4 Feb 2011 21:56:46 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Oops while running xfstests on Power architecture
Message-ID: <20110204105646.GY11040@dastard>
References: <1296778668.32230.18.camel@chandra-lucid.beaverton.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1296778668.32230.18.camel@chandra-lucid.beaverton.ibm.com>
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
To: Chandra Seetharaman <sekharan@us.ibm.com>
Cc: linux-xfs@oss.sgi.com

On Thu, Feb 03, 2011 at 04:17:48PM -0800, Chandra Seetharaman wrote:
> Hello All,
> 
> I see the following Oops when I run the test 070 on power Architecture.
> Looking at the code, I do not see anything that is popping out as a
> problem.
> 
> I do not see the same failures in x86_64, so, I thought it may be due to
> the pagesize, so changed the pagesize to be 4k, but that didn't help.
> 
> Is this assertion a false-positive ?
> 
> If not, Any suggestions on where to start looking at the code.
> 
> I see the same Oops with 2.6.37, 2.6.38-rc2 and 2.6.38-rc3.

It's an assert failure, not an oops:

> Feb  3 14:01:30 mytestmachine kernel: Assertion failed: args->op_flags & XFS_DA_OP_OKNOENT, file: fs/xfs/xfs_da_btree.c, line: 1428

XFS_DA_OP_OKNOENT is set when an operation on the
directory/attribute can be expected to get an ENOENT error.
If it is not set, then the attribute/dirent is expected to be
present in the tree, and there's something wrong if it is not.

e.g. if you are removing an attribute, it is expected to be in the
tree.

PowerPC used to get regular QA coverage but hasn't for the past
couple of years, so it probably is a relatively recent problem.
I'd suggest the first thing to do is to try older kernels to
determine if the problem is specific to newer kernels, and if so, a
git bisect is probably your best bet to finding the commit that
introduced the problem.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
