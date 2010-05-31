Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4VM3fJf206754 for <xfs@oss.sgi.com>; Mon, 31 May 2010 17:03:42 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0204514672B8
	for <xfs@oss.sgi.com>; Mon, 31 May 2010 15:06:06 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail15.adl6.internode.on.net
	[150.101.137.100]) by cuda.sgi.com with ESMTP id
	e9HvAXYs1pv4EPiu for <xfs@oss.sgi.com>;
	Mon, 31 May 2010 15:06:06 -0700 (PDT)
Date: Tue, 1 Jun 2010 08:06:03 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs_buf and buffercache/pagecache connection
Message-ID: <20100531220603.GF1395@dastard>
References: <4C03E46B.9040407@ics.forth.gr>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4C03E46B.9040407@ics.forth.gr>
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
To: Yannis Klonatos <klonatos@ics.forth.gr>
Cc: xfs@oss.sgi.com

On Mon, May 31, 2010 at 07:31:39PM +0300, Yannis Klonatos wrote:
> Hello,
> 
>         I was looking to add a kernel hook to my system in order to
> monitor buffer-cache hit and misses. Initially I was
> planning to add my modifications to the __getblk(). However, i
> noticed that XFS does not directly use the buffer-cache
> for its pages but it seems to implement its own buffer.
>         What I am now looking for is 1) the place where XFS checks
> whether a page exists in its buffer or not and 2)
> what are the possible interactions between xfs_buf and the Linux
> kernel buffer-cache.
>         I would appreciate any information regarding the above issues.

There are already stats in place to tell you about this.

http://xfs.org/index.php/Runtime_Stats#buf_-_Buf_Statistics

They aren't documented there, but if you look at
fs/xfs/linux-2.6/xfs_buf.c an search for XFS_STATS_INC you'll find
what they all mean from the code. It isn't as simple as hit or miss
counters - there's different counters for different types of hits
and misses....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
