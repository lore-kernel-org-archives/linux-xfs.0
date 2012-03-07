Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q27HGLih129910 for <xfs@oss.sgi.com>; Wed, 7 Mar 2012 11:16:22 -0600
Received: from smtp.pobox.com (b-pb-sasl-quonix.pobox.com [208.72.237.35]) by
	cuda.sgi.com with ESMTP id oBxhA818EE4aiyx5 for
	<xfs@oss.sgi.com>; Wed, 07 Mar 2012 09:16:20 -0800 (PST)
Received: from smtp.pobox.com (unknown [127.0.0.1])
	by b-sasl-quonix.pobox.com (Postfix) with ESMTP id 408E86867
	for <xfs@oss.sgi.com>; Wed,  7 Mar 2012 12:16:20 -0500 (EST)
Received: from b-pb-sasl-quonix.pobox.com (unknown [127.0.0.1])
	by b-sasl-quonix.pobox.com (Postfix) with ESMTP id 37EF76866
	for <xfs@oss.sgi.com>; Wed,  7 Mar 2012 12:16:20 -0500 (EST)
Received: from Brians-MacBook-Air.local (unknown [217.206.150.147]) (using
	TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits)) (No client
	certificate
	requested) by b-sasl-quonix.pobox.com (Postfix) with ESMTPSA id
	D72B16865 for
	<xfs@oss.sgi.com>; Wed,  7 Mar 2012 12:16:19 -0500 (EST)
Received: from brian by Brians-MacBook-Air.local with local (Exim 4.77)
	(envelope-from <b.candler@pobox.com>) id M0IYN7-000I6P-8H for
	xfs@oss.sgi.com; Wed, 07 Mar 2012 17:16:19 +0000
Date: Wed, 7 Mar 2012 17:16:19 +0000
From: Brian Candler <B.Candler@pobox.com>
Subject: Re: df bigger than ls?
Message-ID: <20120307171619.GA23557@nsrc.org>
References: <20120307155439.GA23360@nsrc.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120307155439.GA23360@nsrc.org>
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
To: xfs@oss.sgi.com

On Wed, Mar 07, 2012 at 03:54:39PM +0000, Brian Candler wrote:
> core.size = 1085407232
> core.nblocks = 262370

core.nblocks is correct here: space used = 262370 * 4 = 1049480 KB

(If I add up all the non-hole extents I get 2098944 blocks = 1049472 KB
so there are two extra blocks of something)

This begs the question of where stat() is getting its info from?

Ah... but I've found that after unmounting and remounting the filesystem
(which I had to do for xfs_db), du and stat report the correct info.

In fact, dropping the inode caches is sufficient to fix the problem:

root@storage1:~# du -h /disk*/scratch2/work/PRSRA1/PRSRA1.1.0.bff
2.0G	/disk10/scratch2/work/PRSRA1/PRSRA1.1.0.bff
2.0G	/disk11/scratch2/work/PRSRA1/PRSRA1.1.0.bff
2.0G	/disk12/scratch2/work/PRSRA1/PRSRA1.1.0.bff
1.1G	/disk1/scratch2/work/PRSRA1/PRSRA1.1.0.bff
1.1G	/disk2/scratch2/work/PRSRA1/PRSRA1.1.0.bff
2.0G	/disk3/scratch2/work/PRSRA1/PRSRA1.1.0.bff
2.0G	/disk4/scratch2/work/PRSRA1/PRSRA1.1.0.bff
2.0G	/disk5/scratch2/work/PRSRA1/PRSRA1.1.0.bff
2.0G	/disk6/scratch2/work/PRSRA1/PRSRA1.1.0.bff
2.0G	/disk7/scratch2/work/PRSRA1/PRSRA1.1.0.bff
2.0G	/disk8/scratch2/work/PRSRA1/PRSRA1.1.0.bff
2.0G	/disk9/scratch2/work/PRSRA1/PRSRA1.1.0.bff
root@storage1:~# echo 3 >/proc/sys/vm/drop_caches 
root@storage1:~# du -h /disk*/scratch2/work/PRSRA1/PRSRA1.1.0.bff
1.1G	/disk10/scratch2/work/PRSRA1/PRSRA1.1.0.bff
1.1G	/disk11/scratch2/work/PRSRA1/PRSRA1.1.0.bff
1.1G	/disk12/scratch2/work/PRSRA1/PRSRA1.1.0.bff
1.1G	/disk1/scratch2/work/PRSRA1/PRSRA1.1.0.bff
1.1G	/disk2/scratch2/work/PRSRA1/PRSRA1.1.0.bff
1.1G	/disk3/scratch2/work/PRSRA1/PRSRA1.1.0.bff
1.1G	/disk4/scratch2/work/PRSRA1/PRSRA1.1.0.bff
1.1G	/disk5/scratch2/work/PRSRA1/PRSRA1.1.0.bff
1.1G	/disk6/scratch2/work/PRSRA1/PRSRA1.1.0.bff
1.1G	/disk7/scratch2/work/PRSRA1/PRSRA1.1.0.bff
1.1G	/disk8/scratch2/work/PRSRA1/PRSRA1.1.0.bff
1.1G	/disk9/scratch2/work/PRSRA1/PRSRA1.1.0.bff
root@storage1:~# 

Very odd, but not really a major problem other than the confusion it causes.

Regards,

Brian.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
