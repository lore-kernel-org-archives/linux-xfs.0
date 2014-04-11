Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 4F6A47F6D
	for <xfs@oss.sgi.com>; Thu, 10 Apr 2014 23:27:06 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 269E38F8037
	for <xfs@oss.sgi.com>; Thu, 10 Apr 2014 21:27:05 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	YyyBR1Jg2m9EkiRG for <xfs@oss.sgi.com>;
	Thu, 10 Apr 2014 21:27:00 -0700 (PDT)
Date: Fri, 11 Apr 2014 14:26:25 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: 10GB memorys occupied by XFS
Message-ID: <20140411042625.GG15995@dastard>
References: <1396596386220-35015.post@n7.nabble.com>
	<1397184044761-35016.post@n7.nabble.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1397184044761-35016.post@n7.nabble.com>
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
To: daiguochao <dx-wl@163.com>
Cc: xfs@oss.sgi.com

On Thu, Apr 10, 2014 at 07:40:44PM -0700, daiguochao wrote:
> Dear Stan, I can't send email to you.So I leave a message here.I hope not to
> bother you.
> Thank you for your kind assistance.
> 
> In accordance with your suggestion, we executed "echo 3 >
> /proc/sysm/drop_caches" for trying to release vfs dentries and inodes.
> Really,
> our lost memory came back. But we learned that the memory of vfs dentries
> and inodes is distributed from slab. Please check our system "Slab:  509708
> kB" from /proc/meminfo, and it seems only be took up 500MB and xfs_buf take
> up 450MB among.

That's where your memory is - in metadata buffers. The xfs_buf slab
entries are just the handles - the metadata pages in the buffers
usually take much more space and it's not accounted to the slab
cache nor the page cache.

Can you post the output of /proc/slabinfo, and what is the output of
xfs_info on the filesystem in question? Also, a description of your
workload that is resulting in large amounts of cached metadata
buffers but no inodes or dentries would be helpful.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
