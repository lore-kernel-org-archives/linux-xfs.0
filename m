Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id D827F29DF8
	for <xfs@oss.sgi.com>; Wed, 22 May 2013 22:51:21 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B4D4F30404E
	for <xfs@oss.sgi.com>; Wed, 22 May 2013 20:51:21 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	LEqellCI6uTi4Fkc for <xfs@oss.sgi.com>;
	Wed, 22 May 2013 20:51:17 -0700 (PDT)
Date: Thu, 23 May 2013 13:51:15 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: 3.9.3: Oops running xfstests
Message-ID: <20130523035115.GY24543@dastard>
References: <510292845.4997401.1369279175460.JavaMail.root@redhat.com>
	<1985929268.4997720.1369279277543.JavaMail.root@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1985929268.4997720.1369279277543.JavaMail.root@redhat.com>
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
To: CAI Qian <caiqian@redhat.com>
Cc: stable@vger.kernel.org, xfs@oss.sgi.com

On Wed, May 22, 2013 at 11:21:17PM -0400, CAI Qian wrote:
> Fedora-19 based distro and LVM partitions.

Cai: As I've asked previously please include all the relevant
information about your test system and the workload it is running
when the problem occurs.  Stack traces aren't any good to us in
isolation, and just dumping them on us causes unnecessary round
trips.

http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_reporting_a_problem.3F


> [  304.898489] ============================================================================= 
> [  304.898489] BUG kmalloc-4096 (Tainted: G      D     ): Padding overwritten. 0xffff8801fbeb7c28-0xffff8801fbeb7fff 
> [  304.898490] ----------------------------------------------------------------------------- 
> [  304.898490]  
> [  304.898491] INFO: Slab 0xffffea0007efac00 objects=7 used=7 fp=0x          (null) flags=0x20000000004080 
> [  304.898492] Pid: 357, comm: systemd-udevd Tainted: G    B D      3.9.3 #1 
> [  304.898492] Call Trace: 
> [  304.898495]  [<ffffffff81181ed2>] slab_err+0xc2/0xf0 
> [  304.898497]  [<ffffffff8118176d>] ? init_object+0x3d/0x70 
> [  304.898498]  [<ffffffff81181ff5>] slab_pad_check.part.41+0xf5/0x170 
> [  304.898500]  [<ffffffff811bda63>] ? seq_read+0x2e3/0x3b0 
> [  304.898501]  [<ffffffff811820e3>] check_slab+0x73/0x100 
> [  304.898503]  [<ffffffff81606b50>] alloc_debug_processing+0x21/0x118 
> [  304.898504]  [<ffffffff8160772f>] __slab_alloc+0x3b8/0x4a2 
> [  304.898506]  [<ffffffff81161b57>] ? vma_link+0xb7/0xc0 
> [  304.898508]  [<ffffffff811bda63>] ? seq_read+0x2e3/0x3b0 
> [  304.898509]  [<ffffffff81184dd1>] kmem_cache_alloc_trace+0x1b1/0x200 
> [  304.898510]  [<ffffffff811bda63>] seq_read+0x2e3/0x3b0 
> [  304.898512]  [<ffffffff8119c56c>] vfs_read+0x9c/0x170 
> [  304.898513]  [<ffffffff8119c939>] sys_read+0x49/0xa0 
> [  304.898514]  [<ffffffff81619359>] system_call_fastpath+0x16/0x1b 

That's something different, and indicates memory corruption is being
seen as a result of something that is occuring through the /proc or
/sys filesystems. Unrelated to XFS, I think...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
