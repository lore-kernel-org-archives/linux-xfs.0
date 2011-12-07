Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pB7A7tWq066345 for <xfs@oss.sgi.com>; Wed, 7 Dec 2011 04:07:56 -0600
Received: from ipmail06.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D43DD15673D8
	for <xfs@oss.sgi.com>; Wed,  7 Dec 2011 02:07:54 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	oOGxxR48pl7fHICW for <xfs@oss.sgi.com>;
	Wed, 07 Dec 2011 02:07:54 -0800 (PST)
Date: Wed, 7 Dec 2011 21:07:48 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfstests/071 FAIL with pwrite64: Invalid argument
Message-ID: <20111207100748.GB14273@dastard>
References: <4EDD8F16.4050402@cn.fujitsu.com> <20111206110533.GD28326@dastard>
	<4EDF2133.7030702@cn.fujitsu.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4EDF2133.7030702@cn.fujitsu.com>
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
To: Peng Haitao <penght@cn.fujitsu.com>
Cc: hch@infradead.org, xfs@oss.sgi.com

On Wed, Dec 07, 2011 at 04:17:55PM +0800, Peng Haitao wrote:
> Hi, 
> 
> Dave Chinner said the following on 2011-12-6 19:05:
> >> When offset + length is overflow of xfs_io builtin pread and pwrite in linux,
> >> the error message should be "Invalid argument".
> > 
> > Fixing this just requires an additional filter. The write outpu is
> > already passed through 2 filters to remove ariable numbers from the
> > output, so one more to standardise the error isn't a problem.
> > 
> > Further, filtering of the error stream on the reads to only appear
> > in $seq.full solves the extra error output on reads as well.
> > 
> 
> Thanks for your comments.
> 
> When offset + length is overflow, the case expect:
>   - pwrite output error messages: pwrite64: File too large
>   - pread output right message:   read 0/512 bytes at offset <OFFSET>
> 
> but in linux, the actual results:
>   - pwrite output error messages: pwrite64: Invalid argument
>   - pread output right message:   pread64: Invalid argument
> 
> I can add an additional filter to remove variable messages, 
> but if I remove variable messages, the 071.out will remain echo content:
> Writing 512 bytes, offset is +0 (direct=false)
> Reading 512 bytes (direct=false)
> ...

I think you misunderstand what I was saying - I was not suggesting
removing the error messages at all, just filtering them with sed to
ensure the output is always constant for the error different
messages different platforms dump out.

Have a look at the patch I sent earlier today for test 103 ([PATCH
2/2] xfstests: ln failure output has changed again) as an example of
error message filtering for multi-platform (Irix and Linux are
different) and multiple-version (coreutils v < 6 output is different
to 6 <= v < 8 and the current 8.x is different again) support with a
single golden image.

That is, the output in the golden image does not change, instead we
use a filter to convert the known different error messages to match
the error in the golden image. If the error message is different to
what the filter catches or does not appear, then the test still
fails as desired. Essentially the output filter encodes all the
variants of the valid error messages for the given test....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
