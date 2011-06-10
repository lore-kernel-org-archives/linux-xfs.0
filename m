Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5ANQ6fg019115 for <xfs@oss.sgi.com>; Fri, 10 Jun 2011 18:26:06 -0500
Received: from e39.co.us.ibm.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7E1AB16EA8CD
	for <xfs@oss.sgi.com>; Fri, 10 Jun 2011 16:26:04 -0700 (PDT)
Received: from e39.co.us.ibm.com (e39.co.us.ibm.com [32.97.110.160]) by
	cuda.sgi.com with ESMTP id 0IOzMdmQz7F763ro for
	<xfs@oss.sgi.com>; Fri, 10 Jun 2011 16:26:04 -0700 (PDT)
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com
	[9.17.195.227])
	by e39.co.us.ibm.com (8.14.4/8.13.1) with ESMTP id p5ANBp7F005518
	for <xfs@oss.sgi.com>; Fri, 10 Jun 2011 17:11:51 -0600
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id
	p5ANQ17d165702 for <xfs@oss.sgi.com>; Fri, 10 Jun 2011 17:26:01 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP
	id p5AHPYTO009062
	for <xfs@oss.sgi.com>; Fri, 10 Jun 2011 11:25:34 -0600
Subject: Re: Failure of xfstests test case 202
From: Chandra Seetharaman <sekharan@us.ibm.com>
In-Reply-To: <20110610214143.GZ32466@dastard>
References: <1307738387.7661.450.camel@chandra-lucid.beaverton.ibm.com>
	<20110610214143.GZ32466@dastard>
Date: Fri, 10 Jun 2011 16:25:58 -0700
Message-ID: <1307748358.7661.459.camel@chandra-lucid.beaverton.ibm.com>
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
Cc: XFS Mailing List <xfs@oss.sgi.com>

On Sat, 2011-06-11 at 07:41 +1000, Dave Chinner wrote:
> On Fri, Jun 10, 2011 at 01:39:47PM -0700, Chandra Seetharaman wrote:
> > Hi all,
> > 
> > Test case 202 tries to create a single AG filesystem and runs xfs_repair
> > on it expecting it to fail.
> > 
> > But, when I run the test with a filesystem that is bigger than 1TB it
> > fails (not pleasantly) since the max AG size is 1TB.
> > 
> > I am thinking of the following solution, please let me know if there is
> > any other elegant fix.
> > 
> > chandra
> > ------------------------
> > diff --git a/202 b/202
> > index cbdcb57..b871d8b 100755
> > --- a/202
> > +++ b/202
> > @@ -42,10 +42,12 @@ _supported_os Linux
> >  _require_scratch
> >  
> >  echo "== Creating single-AG filesystem =="
> > -_scratch_mkfs_xfs -d agcount=1 >/dev/null 2>&1
> > +_scratch_mkfs_xfs -d agcount=1 >/dev/null 2>&1 \
> > + || _scratch_mkfs_xfs -d agcount=1 -d size=268435455b >/dev/null 2>&1 
> > + || _fail "!!! failed to make filesystem"
> 
> Why the second mkfs attempt with a fixed block size?

to see if the mkfs failed because the default filesystem size is too
big.

>   That will
> still fail for block size > 4k. 

Realized that. It should have been absolute.
 
>  All you need to do is detect the
> first attempt failed.

But, I didn't want the test to fail, instead want it to proceed if big
filesystem was the reason for failure.

By now you might have seen my response to Christoph's email. What do you
think of that ?
> 
> >  
> >  echo "== Trying to repair it (should fail) =="
> > -_scratch_xfs_repair
> > +_scratch_xfs_repair && _fail "!!! xfs_repair of single AG filesystem
> > succeeded"
> 
> This is not necessary - the golden image compare at the end of the
> test will detect this succeeding when it shoul dbe failing.

But it is not very informative about "why" the test failed. This message
will make it clear to the user.

> 
> Cheers,
> 
> Dave.


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
