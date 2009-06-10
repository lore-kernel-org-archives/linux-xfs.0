Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n5ADbD1G094417 for <xfs@oss.sgi.com>; Wed, 10 Jun 2009 08:37:13 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DF4C3126D5BF
	for <xfs@oss.sgi.com>; Wed, 10 Jun 2009 06:44:44 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id jNKtp1w8aS2zTqhm for
	<xfs@oss.sgi.com>; Wed, 10 Jun 2009 06:44:44 -0700 (PDT)
Message-ID: <4A2FB71D.3030606@sandeen.net>
Date: Wed, 10 Jun 2009 08:37:33 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: xfs_growfs doesn't grow on 2TB raid
References: <BAY108-W1262BA63B7F70EB6364C9AF3450@phx.gbl>
In-Reply-To: <BAY108-W1262BA63B7F70EB6364C9AF3450@phx.gbl>
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
To: jack the ripper <evil_metalpeet@hotmail.com>
Cc: xfs@oss.sgi.com

jack the ripper wrote:
> Hey all,

...

> Proof that there is more size available:
> 
> 
> RoSe linux # mdadm -D /dev/mddata1
> /dev/mddata1:
>         Version : 0.90
>   Creation Time : Sat May 30 19:25:26 2009
>      Raid Level : raid5
>      Array Size : 2441919680 (2328.80 GiB 2500.53 GB)


Just to be sure, could you also send the contents of /proc/partitions?

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
