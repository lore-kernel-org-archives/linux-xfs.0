Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C51587CCB
	for <xfs@oss.sgi.com>; Tue, 31 May 2016 07:10:18 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 84C0C30404E
	for <xfs@oss.sgi.com>; Tue, 31 May 2016 05:10:15 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 07a35DB5EktSxD9b (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 31 May 2016 05:10:11 -0700 (PDT)
Date: Tue, 31 May 2016 07:10:07 -0500
From: "Bill O'Donnell" <billodo@redhat.com>
Subject: Re: [PATCH] xfs_repair: further improvement on secondary superblock
	search method
Message-ID: <20160531121007.GA7513@redhat.com>
References: <1463085496-17919-1-git-send-email-billodo@redhat.com>
	<20160530053710.GO26977@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160530053710.GO26977@dastard>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Mon, May 30, 2016 at 03:37:10PM +1000, Dave Chinner wrote:
> On Thu, May 12, 2016 at 03:38:16PM -0500, Bill O'Donnell wrote:
> > This patch is a further optimization of secondary sb search, in order to
> > handle non-default geometries. Once again, use a similar method to find
> > fs geometry as that of xfs_mkfs. Refactor verify_sb(), creating new
> > sub-function that checks sanity of agblocks and agcount: verify_sb_blocksize().
> > 
> > If verify_sb_blocksize verifies sane paramters, use found values for the sb
> > search. Otherwise, try search with default values. If these faster methods
> > both fail, fall back to original brute force slower search.
> > 
> > NOTE: patch series "xfs_repair: improved secondary sb search" must be
> > applied before applying this patch.
> > (http://oss.sgi.com/archives/xfs/2016-05/msg00269.html)
> 
> Either this or one of the above patches is causing xfs/030 on
> my xfstests runs to fail with extra output:
> 
> xfs/030 4s ... - output mismatch (see /home/dave/src/xfstests-dev/results//xfs/xfs/030.out.bad)
>     --- tests/xfs/030.out       2016-04-06 11:30:45.348477421 +1000
>     +++ /home/dave/src/xfstests-dev/results//xfs/xfs/030.out.bad        2016-05-30 13:06:29.955682633 +1000
>     @@ -11,6 +11,8 @@
>      bad primary superblock - bad magic number !!!
>      
>      attempting to find secondary superblock...
>     +....
>     +attempting to find secondary superblock...
>      found candidate secondary superblock...
>      verified secondary superblock...
>     ...
>     (Run 'diff -u tests/xfs/030.out /home/dave/src/xfstests-dev/results//xfs/xfs/030.out.bad'  to see the entire diff)
> 
> Bill, can you please work up a filter or equivalent for xfstests
> so that this extra output doesn't cause unnecessary failures?
> Something like simply filtering all the "attempting to find
> secondary superblock..." and "...." lines from the output would work
> just fine - all we really care about is that a secondary sb is found
> and verified, not how many steps it takes to find it...

Yep. Will do.
Thanks-
Bill

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
