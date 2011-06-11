Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5B7749c045439 for <xfs@oss.sgi.com>; Sat, 11 Jun 2011 02:07:04 -0500
Received: from ipmail06.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D82D014EBD57
	for <xfs@oss.sgi.com>; Sat, 11 Jun 2011 00:07:02 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	wxIKWemM2I66RHmk for <xfs@oss.sgi.com>;
	Sat, 11 Jun 2011 00:07:02 -0700 (PDT)
Date: Sat, 11 Jun 2011 17:07:00 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Failure of xfstests test case 202
Message-ID: <20110611070700.GB32466@dastard>
References: <1307738387.7661.450.camel@chandra-lucid.beaverton.ibm.com>
	<20110610211911.GA11509@infradead.org>
	<1307741624.7661.453.camel@chandra-lucid.beaverton.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1307741624.7661.453.camel@chandra-lucid.beaverton.ibm.com>
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
Cc: Christoph Hellwig <hch@infradead.org>, XFS Mailing List <xfs@oss.sgi.com>

On Fri, Jun 10, 2011 at 02:33:44PM -0700, Chandra Seetharaman wrote:
> 
> On Fri, 2011-06-10 at 17:19 -0400, Christoph Hellwig wrote:
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
> > 
> > What about:
> > 
> > #
> > # The AG size is limited to 1TB (or even less with historic xfsprogs),
> > # so chose a small enough filesystem to make sure we can actually create
> > # a single AG filesystem.
> > #
> > _scratch_mkfs_sized `expr 1024 \* 1024 \* 1024`
> > 
> > instead?
> 
> Good point. Here is a solution based on your suggestion, but not using
> _scratch_mkfs_sized (sincein the current context we need it to take
> extra option, whereas _scratch_mkfs_sized takes fixed options).
> 
> What do you think ?
> 
> ----------------
> diff --git a/202 b/202
> index cbdcb57..b982956 100755
> --- a/202
> +++ b/202
> @@ -41,11 +41,18 @@ _supported_os Linux
>  
>  _require_scratch
>  
> +#
> +# The AG size is limited to 1TB (or even less with historic xfsprogs),
> +# so chose a small enough filesystem to make sure we can actually create
> +# a single AG filesystem.
> +#
>  echo "== Creating single-AG filesystem =="
> -_scratch_mkfs_xfs -d agcount=1 >/dev/null 2>&1
> +_scratch_mkfs_xfs -d agcount=1 -d size=$((1024*1024*1024)) >/dev/null 2>&1 \
> + || _fail "!!! failed to make filesystem with single AG"

Should work for most test setups.

>  
>  echo "== Trying to repair it (should fail) =="
> -_scratch_xfs_repair
> +_scratch_xfs_repair \
> + && _fail "!!! xfs_repair of single AG filesystem succeeded. Expected to fail."

But as I said before, this change is not necessary.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
