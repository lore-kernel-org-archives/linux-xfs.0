Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 0EC3D7F51
	for <xfs@oss.sgi.com>; Thu, 29 Aug 2013 20:44:28 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E3FA6304039
	for <xfs@oss.sgi.com>; Thu, 29 Aug 2013 18:44:24 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id 3ghVrtdF9NNmIBVQ
	for <xfs@oss.sgi.com>; Thu, 29 Aug 2013 18:44:24 -0700 (PDT)
Message-ID: <521FF8F4.9040009@hardwarefreak.com>
Date: Thu, 29 Aug 2013 20:44:20 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: higher agcount on LVM2 thinp volumes
References: <321D1F95-5603-4571-A445-A267DA5F670F@colorremedies.com>
In-Reply-To: <321D1F95-5603-4571-A445-A267DA5F670F@colorremedies.com>
Reply-To: stan@hardwarefreak.com
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
To: Chris Murphy <lists@colorremedies.com>
Cc: xfs@oss.sgi.com

On 8/29/2013 1:09 AM, Chris Murphy wrote:
> 
> Is it expected when formatting, using defaults, that a thinp volume compared to either a conventional LV or partition of the same size, should have a higher agcount?
> 
> 
> HDD, GPT partitioned, 100GB partition size:
> 
> [root@f19s ~]# mkfs.xfs /dev/sda7
> meta-data=/dev/sda7              isize=256    agcount=4, agsize=6553600 blks
>          =                       sectsz=512   attr=2, projid32bit=0
> data     =                       bsize=4096   blocks=26214400, imaxpct=25
>          =                       sunit=0      swidth=0 blks
> naming   =version 2              bsize=4096   ascii-ci=0
> log      =internal log           bsize=4096   blocks=12800, version=2
>          =                       sectsz=512   sunit=0 blks, lazy-count=1
> realtime =none                   extsz=4096   blocks=0, rtextents=0
> 
> 
> A 400GB partition, made into PV, PV added to VG, and all extents put into a thinpool volume, a 100GB virtual sized LV:
> 
> [root@f19s ~]# mkfs.xfs /dev/mapper/vg1-data
> meta-data=/dev/mapper/vg1-data   isize=256    agcount=16, agsize=1638400 blks
>          =                       sectsz=512   attr=2, projid32bit=0
> data     =                       bsize=4096   blocks=26214400, imaxpct=25
>          =                       sunit=0      swidth=0 blks
> naming   =version 2              bsize=4096   ascii-ci=0
> log      =internal log           bsize=4096   blocks=12800, version=2
>          =                       sectsz=512   sunit=0 blks, lazy-count=1
> realtime =none                   extsz=4096   blocks=0, rtextents=0
> 
> 
> 
> I get agcount=4 on a conventional LV as well. Why agcount=16 on thinp?

More information would be helpful, specifically WRT the device stack
underlying mkfs.xfs.  I.e. we need to know more about the LVM configuration.

See:

http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_reporting_a_problem.3F

-- 
Stan


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
