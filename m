Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nBOC6IxE072137 for <xfs@oss.sgi.com>; Thu, 24 Dec 2009 06:06:19 -0600
Received: from sh.osrg.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7F00A125C81
	for <xfs@oss.sgi.com>; Thu, 24 Dec 2009 04:06:59 -0800 (PST)
Received: from sh.osrg.net (sh.osrg.net [192.16.179.4]) by cuda.sgi.com with
	ESMTP id 2z5GGLHOYI7gDLT2 for <xfs@oss.sgi.com>;
	Thu, 24 Dec 2009 04:06:59 -0800 (PST)
Date: Thu, 24 Dec 2009 21:06:45 +0900 (JST)
Message-Id: <20091224.210645.57462112.ryusuke@osrg.net>
Subject: Re: benchmark results
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
In-Reply-To: <alpine.DEB.2.01.0912240205510.3483@bogon.housecafe.de>
References: <alpine.DEB.2.01.0912240205510.3483@bogon.housecafe.de>
Mime-Version: 1.0
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
To: lists@nerdbynature.de
Cc: jfs-discussion@lists.sourceforge.net, linux-nilfs@vger.kernel.org, reiserfs-devel@vger.kernel.org, xfs@oss.sgi.com, ext3-users@redhat.com, linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org

Hi,
On Thu, 24 Dec 2009 02:31:10 -0800 (PST), Christian Kujau wrote:
> I've had the chance to use a testsystem here and couldn't resist running a 
> few benchmark programs on them: bonnie++, tiobench, dbench and a few 
> generic ones (cp/rm/tar/etc...) on ext{234}, btrfs, jfs, ufs, xfs, zfs.
> 
> All with standard mkfs/mount options and +noatime for all of them.
> 
> Here are the results, no graphs - sorry:
>    http://nerdbynature.de/benchmarks/v40z/2009-12-22/
> 
> Reiserfs is locking up during dbench, so I removed it from the 
> config, here are some earlier results:
> 
>    http://nerdbynature.de/benchmarks/v40z/2009-12-21/bonnie.html
> 
> Bonnie++ couldn't complete on nilfs2, only the generic tests 
> and tiobench were run.

I looked at the log but couldn't identify the error.
Is that a disk full?

Thanks,
Ryusuke Konishi


> As nilfs2, ufs, zfs aren't supporting xattr, dbench 
> could not be run on these filesystems.
>    
> Short summary, AFAICT:
>     - btrfs, ext4 are the overall winners
>     - xfs to, but creating/deleting many files was *very* slow
>     - if you need only fast but no cool features or journaling, ext2
>       is still a good choice :)
> 
> Thanks,
> Christian.
> -- 
> BOFH excuse #84:
> 
> Someone is standing on the ethernet cable, causing a kink in the cable
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
