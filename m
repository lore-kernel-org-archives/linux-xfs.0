Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p14IrCZq030479
	for <linux-xfs@oss.sgi.com>; Fri, 4 Feb 2011 12:53:13 -0600
Received: from e34.co.us.ibm.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 522212B1711
	for <linux-xfs@oss.sgi.com>; Fri,  4 Feb 2011 10:55:42 -0800 (PST)
Received: from e34.co.us.ibm.com (e34.co.us.ibm.com [32.97.110.152]) by
	cuda.sgi.com with ESMTP id 2HnzD5x8ZHWHSja1 for
	<linux-xfs@oss.sgi.com>; Fri, 04 Feb 2011 10:55:42 -0800 (PST)
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com
	[9.17.195.106])
	by e34.co.us.ibm.com (8.14.4/8.13.1) with ESMTP id p14IiLi8022093
	for <linux-xfs@oss.sgi.com>; Fri, 4 Feb 2011 11:44:21 -0700
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	p14Itad3118510
	for <linux-xfs@oss.sgi.com>; Fri, 4 Feb 2011 11:55:36 -0700
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP
	id p14Itadw017650
	for <linux-xfs@oss.sgi.com>; Fri, 4 Feb 2011 11:55:36 -0700
Subject: Re: Oops while running xfstests on Power architecture
From: Chandra Seetharaman <sekharan@us.ibm.com>
In-Reply-To: <20110204105646.GY11040@dastard>
References: <1296778668.32230.18.camel@chandra-lucid.beaverton.ibm.com>
	<20110204105646.GY11040@dastard>
Date: Fri, 04 Feb 2011 10:56:03 -0800
Message-ID: <1296845763.32230.20.camel@chandra-lucid.beaverton.ibm.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@oss.sgi.com

On Fri, 2011-02-04 at 21:56 +1100, Dave Chinner wrote:
> On Thu, Feb 03, 2011 at 04:17:48PM -0800, Chandra Seetharaman wrote:
> > Hello All,
> > 
> > I see the following Oops when I run the test 070 on power Architecture.
> > Looking at the code, I do not see anything that is popping out as a
> > problem.
> > 
> > I do not see the same failures in x86_64, so, I thought it may be due to
> > the pagesize, so changed the pagesize to be 4k, but that didn't help.
> > 
> > Is this assertion a false-positive ?
> > 
> > If not, Any suggestions on where to start looking at the code.
> > 
> > I see the same Oops with 2.6.37, 2.6.38-rc2 and 2.6.38-rc3.
> 
> It's an assert failure, not an oops:

Sorry for the misfiling :) (it does print an oops thouth)..
> 
> > Feb  3 14:01:30 mytestmachine kernel: Assertion failed: args->op_flags & XFS_DA_OP_OKNOENT, file: fs/xfs/xfs_da_btree.c, line: 1428
> 
> XFS_DA_OP_OKNOENT is set when an operation on the
> directory/attribute can be expected to get an ENOENT error.
> If it is not set, then the attribute/dirent is expected to be
> present in the tree, and there's something wrong if it is not.
> 
> e.g. if you are removing an attribute, it is expected to be in the
> tree.
> 
> PowerPC used to get regular QA coverage but hasn't for the past
> couple of years, so it probably is a relatively recent problem.
> I'd suggest the first thing to do is to try older kernels to
> determine if the problem is specific to newer kernels, and if so, a
> git bisect is probably your best bet to finding the commit that
> introduced the problem.

Thanks for the suggestion. I will follow through.
> 
> Cheers,
> 
> Dave.


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
