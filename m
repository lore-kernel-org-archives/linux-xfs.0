Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pB78HSFY056169 for <xfs@oss.sgi.com>; Wed, 7 Dec 2011 02:17:29 -0600
Received: from song.cn.fujitsu.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4A2FF1497290
	for <xfs@oss.sgi.com>; Wed,  7 Dec 2011 00:17:26 -0800 (PST)
Received: from song.cn.fujitsu.com (cn.fujitsu.com [222.73.24.84]) by
	cuda.sgi.com with ESMTP id YayBPjQVE1hr4J11 for
	<xfs@oss.sgi.com>; Wed, 07 Dec 2011 00:17:26 -0800 (PST)
Message-ID: <4EDF2133.7030702@cn.fujitsu.com>
Date: Wed, 07 Dec 2011 16:17:55 +0800
From: Peng Haitao <penght@cn.fujitsu.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests/071 FAIL with pwrite64: Invalid argument
References: <4EDD8F16.4050402@cn.fujitsu.com> <20111206110533.GD28326@dastard>
In-Reply-To: <20111206110533.GD28326@dastard>
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
To: david@fromorbit.com
Cc: hch@infradead.org, xfs@oss.sgi.com

Hi, 

Dave Chinner said the following on 2011-12-6 19:05:
>> When offset + length is overflow of xfs_io builtin pread and pwrite in linux,
>> the error message should be "Invalid argument".
> 
> Fixing this just requires an additional filter. The write outpu is
> already passed through 2 filters to remove ariable numbers from the
> output, so one more to standardise the error isn't a problem.
> 
> Further, filtering of the error stream on the reads to only appear
> in $seq.full solves the extra error output on reads as well.
> 

Thanks for your comments.

When offset + length is overflow, the case expect:
  - pwrite output error messages: pwrite64: File too large
  - pread output right message:   read 0/512 bytes at offset <OFFSET>

but in linux, the actual results:
  - pwrite output error messages: pwrite64: Invalid argument
  - pread output right message:   pread64: Invalid argument

I can add an additional filter to remove variable messages, 
but if I remove variable messages, the 071.out will remain echo content:
Writing 512 bytes, offset is +0 (direct=false)
Reading 512 bytes (direct=false)
...

This will make the case meaningless.

-- 
Best Regards,
Peng Haitao

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
