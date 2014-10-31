Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 7DAFB7F3F
	for <xfs@oss.sgi.com>; Thu, 30 Oct 2014 23:55:55 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 6AC068F8033
	for <xfs@oss.sgi.com>; Thu, 30 Oct 2014 21:55:55 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id tVTsMtWJFtXXnASR for <xfs@oss.sgi.com>;
	Thu, 30 Oct 2014 21:55:53 -0700 (PDT)
Message-ID: <54531657.3080307@sandeen.net>
Date: Thu, 30 Oct 2014 23:55:51 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: xfsrestore report SUCCESS but not restore all files in kernel 3.17
References: <CAGdb-8cnmCs=L0RPvE8+5jn3nmZoviiZtQBbo9S-BThA+3cBKg@mail.gmail.com>	<20141029212556.GH13323@dastard>	<CAGdb-8dbGRu_GWB4qoeNP8Kso2hzkLcuFS9Pwtnm2xOkP2T0rQ@mail.gmail.com>	<20141030050306.GI13323@dastard>	<CAGdb-8dt23oO7nncZdtri1BeNyWkR-6UF_4QRZx2X-5+tFYSRw@mail.gmail.com>	<20141030230457.GK13323@dastard>
	<20141031000954.GL13323@dastard>	<CAGdb-8dP7nah4QuXYk_S8KbEu4Y6ZiT7tXz7dMLkwZ=VTkKQXA@mail.gmail.com>	<20141031034925.GM13323@dastard>
	<20141031042511.GN13323@dastard>
	<CAGdb-8cK=YjYwz8+_f-WpV01RhYsaCNoMUVMMmk2DpSCzE9dLw@mail.gmail.com>
In-Reply-To: <CAGdb-8cK=YjYwz8+_f-WpV01RhYsaCNoMUVMMmk2DpSCzE9dLw@mail.gmail.com>
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
To: Tommy Wu <wu.tommy@gmail.com>, Dave Chinner <david@fromorbit.com>
Cc: xfs <xfs@oss.sgi.com>

On 10/30/14 11:42 PM, Tommy Wu wrote:
> dump whole filesystem?
> I'll try dd later.

no, use xfs_metadump -o, compress & send it (or a link to it) to Dave
on a private channel.

-Eric

> 2014-10-31 12:25 GMT+08:00 Dave Chinner <david@fromorbit.com <mailto:david@fromorbit.com>>:
> 
>     On Fri, Oct 31, 2014 at 02:49:25PM +1100, Dave Chinner wrote:
>     > On Fri, Oct 31, 2014 at 09:51:27AM +0800, Tommy Wu wrote:
>     > > After apply this patch, xfsdump will hang again.
>     > >
>     > > the log for xfsdump:
>     > > https://mega.co.nz/#!tUgz3QrC!q7Ix53sl9lYCg0iKRHjgOqF0tZJAVKHBNz0OHWof-ds
>     > >
>     > > But 'echo w > /proc/sysrq-trigger' no any blocked task in dmesg.
>     >
>     > echo l > /proc/sysrq-trigger
>     > echo t > /proc/sysrq-trigger
> 
>     Also, I just cannot reproduce a hung dump or a broken restore,
>     so can you take an unobfuscated metadump of the source filesystem
>     (i.e. the one you are running dump on) so I can try on an exact
>     image of the filesystem you are having troubles on?
> 
>     Cheers,
> 
>     Dave.
>     --
>     Dave Chinner
>     david@fromorbit.com <mailto:david@fromorbit.com>
> 
> 
> 
> 
> -- 
> 
> Tommy Wu
> 
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
