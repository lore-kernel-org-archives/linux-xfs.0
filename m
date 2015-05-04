Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 85BF37F5A
	for <xfs@oss.sgi.com>; Sun,  3 May 2015 21:02:53 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 7D2858F8035
	for <xfs@oss.sgi.com>; Sun,  3 May 2015 19:02:50 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	DhW2F0sySCbWrqUb for <xfs@oss.sgi.com>;
	Sun, 03 May 2015 19:02:45 -0700 (PDT)
Date: Mon, 4 May 2015 12:02:42 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfstests: what's the difference between generic/043 and
	generic/044
Message-ID: <20150504020242.GB21261@dastard>
References: <tencent_5AC82BAD44B2E3AE054828D2@qq.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <tencent_5AC82BAD44B2E3AE054828D2@qq.com>
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
To: Wang Sheng-Hui <shhuiw@foxmail.com>
Cc: xfs <xfs@oss.sgi.com>

[cc fstests@vger.kernel.org. Please send xfstests questions there. ]

On Mon, May 04, 2015 at 09:49:20AM +0800, Wang Sheng-Hui wrote:
> Hi,
> 
> I'm reading the source code of generic/044 in xfstests, and I cannot figure out the
> difference compared with 043 testcase:
> -------------------------------------------------------------------------------
> $ diff -Nu 043 044
> --- 043 2015-03-09 10:03:48.013887582 +0800
> +++ 044 2015-03-09 10:03:48.013887582 +0800
> @@ -1,5 +1,5 @@
>  #! /bin/bash
> -# FSQA Test No. 043
> +# FSQA Test No. 044
>  #
>  # Test for NULL files problem
>  #
> @@ -56,6 +56,12 @@
>                 echo error creating/writing file $file
>                 exit
>         fi
> +       xfs_io -c "truncate 64k" $file &gt; /dev/null
> +       if [ $? -ne 0 ]
> +       then
> +               echo error truncating file $file
> +               exit
> +       fi
>         let i=$i+1
>  done
> 
> 
> But before the 'truncate 64K', only 64K sized files are created:
>                  xfs_io -f -c "pwrite -b 64k -S 0xff 0 64k" $file &gt; /dev/null
> So I think it's useless here, or some typo e.g smaller truncate needed?

It's testing a corner case in the truncate code, where new_size ==
old_size. Go back years ago (i.e. before ~2007) when the "NULL
files" problem existed, this would result in XFS writing a size of
64k to the inode, but none of the data written into the kernel would
exist on disk.  Hence you'd get a "NULL file" after crash recovery
if you did this.

generic/043 is simply testing write without truncate - the result
there was dependent on timing of writeback, so not guaranteed to
fail. The truncate case pretty much guaranteed NULL files would
exist and so the test always failed....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
