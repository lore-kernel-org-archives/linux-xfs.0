Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6JG0gXL024828 for <xfs@oss.sgi.com>; Thu, 19 Jul 2012 11:00:42 -0500
Received: from mail.sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com
	with ESMTP id IGFHduAVF5etNuKD for <xfs@oss.sgi.com>;
	Thu, 19 Jul 2012 09:00:41 -0700 (PDT)
Message-ID: <50082F28.8090905@sandeen.net>
Date: Thu, 19 Jul 2012 11:00:40 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Superblock restore takes too long
References: <5C7FE4A5ADF52D46989166B4083DFF8F21ECE1C6@ilmbx02.IL.NDS.com>
In-Reply-To: <5C7FE4A5ADF52D46989166B4083DFF8F21ECE1C6@ilmbx02.IL.NDS.com>
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
To: "Zak, Semion" <SZak@nds.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On 7/19/12 4:30 AM, Zak, Semion wrote:
> Hi,
> 
> Corrupted Superblock restore takes too long because xfs_restore searches the disc for reserved Superblock.
> 
> Is it possible accelerate the search, for example by giving to xfs_restore some hint (reserved Superblock LBA)?
> 

Often when I've seen this it's because the block device wasn't really even an xfs filesystem, and the search went on forever.

Can you offer more details of what you've encountered?

(btw, s/xfs_restore/xfs_repair/ I assume)

-Eric
  
> 
> Thanks,
> 
>  
> 
> Semion.  



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
