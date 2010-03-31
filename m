Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o2VNjFGg067523 for <xfs@oss.sgi.com>; Wed, 31 Mar 2010 18:45:16 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 45D7A1DC91D8
	for <xfs@oss.sgi.com>; Wed, 31 Mar 2010 16:47:02 -0700 (PDT)
Received: from mail.sandeen.net (64-131-60-146.usfamily.net [64.131.60.146])
	by cuda.sgi.com with ESMTP id UVFA8QsvAK96ek7G for
	<xfs@oss.sgi.com>; Wed, 31 Mar 2010 16:47:02 -0700 (PDT)
Message-ID: <4BB3DEF4.5030208@sandeen.net>
Date: Wed, 31 Mar 2010 18:47:00 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: made test 215 backwards compatible with	older
	version of bash.
References: <1270062393-5233-1-git-send-email-akshaylal@google.com>
	<20100331223321.GJ7671@dastard>
In-Reply-To: <20100331223321.GJ7671@dastard>
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
Cc: Akshay Lal <akshaylal@google.com>, xfs@oss.sgi.com

Dave Chinner wrote:
> On Wed, Mar 31, 2010 at 12:06:33PM -0700, Akshay Lal wrote:
>> Test 215 fails on older versions of bash (2.x), mainly due to the use of
>> 'let' for arithemetic operations. Changed to 'expr'.
> 
> If that is a problem for older bash versions, then there's going
> systemic problems throughout the xfstests suite. The let expression
> is used about 80 different places, and I don't see anything special
> about test 215 that makes it any different from other uses. i might
> be missing something, but there's not much context to go on from
> your changelog....
> 
> Perhaps upgrading your version of bash might be a better approach?
> 
> Cheers,
> 
> Dave.

Also, a wholesale switch from expr to let was done not long ago, for
very specific reasons - see below - so I don't think there's much 
interest in going back in the other direction.

Thanks,
-Eric

commit e714acc0ef37031b9a5a522703f2832f139c22e0
Author: Dave Chinner <david@fromorbit.com>
Date:   Wed Mar 25 20:53:36 2009 +0100

    reduce the number of processes forked
    
    One of the big cpu time consumers when running xfsqa on UML
    is forking of new processes. when looping lots of times,
    using 'expr' to calculate the loop counter increment means
    we fork at least once every loop. using shell builtins means
    that we don't fork and many tests run substantially faster.
    
    Some tests are even runnable with this modification. e.g. 110
    went from taking 4500s to run down to 9s with the loop iterators
    changed to avoid forking.
    
    Signed-off-by: Dave Chinner <david@fromorbit.com>
    Signed-off-by: Christoph Hellwig <hch@lst.de>

diff --git a/007 b/007
index e8c6610..290f716 100755
--- a/007
+++ b/007
@@ -50,7 +50,7 @@ num_filenames=100
 i=1
 while [ $i -le $num_filenames ]; do
   echo "nametest.$i" >>$sourcefile
-  i=`expr $i + 1`
+  let i=$i+1
 done
 
 mkdir $testdir/$seq

.... etc ....

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
