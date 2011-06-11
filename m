Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5B6xa9j045155 for <xfs@oss.sgi.com>; Sat, 11 Jun 2011 01:59:37 -0500
Received: from ipmail06.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 13A9C14EBD1D
	for <xfs@oss.sgi.com>; Fri, 10 Jun 2011 23:59:33 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	9XI2s3TKrliiCFTq for <xfs@oss.sgi.com>;
	Fri, 10 Jun 2011 23:59:33 -0700 (PDT)
Date: Sat, 11 Jun 2011 16:59:30 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Failure of xfstests test case 202
Message-ID: <20110611065930.GA32466@dastard>
References: <1307738387.7661.450.camel@chandra-lucid.beaverton.ibm.com>
	<20110610214143.GZ32466@dastard>
	<1307748358.7661.459.camel@chandra-lucid.beaverton.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1307748358.7661.459.camel@chandra-lucid.beaverton.ibm.com>
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
Cc: XFS Mailing List <xfs@oss.sgi.com>

On Fri, Jun 10, 2011 at 04:25:58PM -0700, Chandra Seetharaman wrote:
> On Sat, 2011-06-11 at 07:41 +1000, Dave Chinner wrote:
> > On Fri, Jun 10, 2011 at 01:39:47PM -0700, Chandra Seetharaman wrote:
> > > Hi all,
> > > 
> > > Test case 202 tries to create a single AG filesystem and runs xfs_repair
> > > on it expecting it to fail.
> > > 
> > > But, when I run the test with a filesystem that is bigger than 1TB it
> > > fails (not pleasantly) since the max AG size is 1TB.
> > > 
> > > I am thinking of the following solution, please let me know if there is
> > > any other elegant fix.
> > > 
> > > chandra
> > > ------------------------
> > > diff --git a/202 b/202
> > > index cbdcb57..b871d8b 100755
> > > --- a/202
> > > +++ b/202
> > > @@ -42,10 +42,12 @@ _supported_os Linux
> > >  _require_scratch
> > >  
> > >  echo "== Creating single-AG filesystem =="
> > > -_scratch_mkfs_xfs -d agcount=1 >/dev/null 2>&1
> > > +_scratch_mkfs_xfs -d agcount=1 >/dev/null 2>&1 \
> > > + || _scratch_mkfs_xfs -d agcount=1 -d size=268435455b >/dev/null 2>&1 
> > > + || _fail "!!! failed to make filesystem"
> > 
> > Why the second mkfs attempt with a fixed block size?
> 
> to see if the mkfs failed because the default filesystem size is too
> big.

The reason for the failure will be in the test output.  If the tests
fail, you should be looking at the test output to find out why
anyway, right?

> >   That will
> > still fail for block size > 4k. 
> 
> Realized that. It should have been absolute.
>  
> >  All you need to do is detect the
> > first attempt failed.
> 
> But, I didn't want the test to fail, instead want it to proceed if big
> filesystem was the reason for failure.
> 
> By now you might have seen my response to Christoph's email. What do you
> think of that ?

I haven't seen it yet.

> > >  echo "== Trying to repair it (should fail) =="
> > > -_scratch_xfs_repair
> > > +_scratch_xfs_repair && _fail "!!! xfs_repair of single AG filesystem
> > > succeeded"
> > 
> > This is not necessary - the golden image compare at the end of the
> > test will detect this succeeding when it shoul dbe failing.
> 
> But it is not very informative about "why" the test failed. This message
> will make it clear to the user.

It's perfectly clear - the output says "should fail" and so if the
test is failed due to golden output mismatches due to repair
succeeding, it's pretty clear why the test failed.

http://users.on.net/~david_chinner/blog/xfstests_and_golden_output.html

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
