Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id B70087F50
	for <xfs@oss.sgi.com>; Mon, 13 May 2013 03:59:52 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 95A52304066
	for <xfs@oss.sgi.com>; Mon, 13 May 2013 01:59:49 -0700 (PDT)
Received: from emea01-db3-obe.outbound.protection.outlook.com
	(mail-db3lp0082.outbound.protection.outlook.com
	[213.199.154.82]) by cuda.sgi.com with ESMTP id
	U3dS9m9Mu3WDIzz6 (version=TLSv1 cipher=AES128-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 13 May 2013 01:59:47 -0700 (PDT)
Message-ID: <5190AB76.5050108@zynstra.com>
Date: Mon, 13 May 2013 09:59:34 +0100
From: James Dingwall <james.dingwall@zynstra.com>
MIME-Version: 1.0
Subject: Re: Cleancache support in XFS
References: <51810CED.4080003@zynstra.com>
In-Reply-To: <51810CED.4080003@zynstra.com>
Content-Type: multipart/mixed; boundary="------------060404000606020908030506"
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--------------060404000606020908030506
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit

James Dingwall wrote:
> --- xfs_super.c 2013-04-29 10:28:22.000000000 +0100
> +++ xfs_super.cleancache.c      2013-05-01 13:22:44.367763564 +0100
> @@ -61,6 +61,7 @@
>  #include <linux/kthread.h>
>  #include <linux/freezer.h>
>  #include <linux/parser.h>
> +#include <linux/cleancache.h>
>
>  static const struct super_operations xfs_super_operations;
>  static kmem_zone_t *xfs_ioend_zone;
> @@ -1489,6 +1490,8 @@
>                 goto out_unmount;
>         }
>
> +       cleancache_init_fs(sb);
> +
>         return 0;
>
>   out_filestream_unmount: 
I have tested this patch with xfstests 
(dd3b5268312e0518ae695e8ee2a618f13805c425) and the output is attached.  
I had four reported failures with and without, one seems due to my 
locale settings but I don't know what to make of the others.  These were 
the commands that I ran to prepare my system and execute the tests.  If 
it would be worth performing more runs or using a different group of 
tests please suggest what it would be worth doing.  I have also 
published the patch in git at:

https://github.com/JKDingwall/linux.git xfs-enable-cleancache

Thanks,
James

# mkfs -t xfs /dev/xvdc1
meta-data=/dev/xvdc1             isize=256    agcount=4, agsize=1048512 blks
          =                       sectsz=512   attr=2, projid32bit=0
data     =                       bsize=4096   blocks=4194048, imaxpct=25
          =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0
log      =internal log           bsize=4096   blocks=2560, version=2
          =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0

# mkdir /tmp/test
# mkdir /tmp/scratch
# TEST_DEV="/dev/xvdc1" ; export TEST_DEV
# TEST_DIR="/tmp/test" ; export TEST_DIR
# SCRATCH_DEV="/dev/xvdd1" ; export SCRATCH_DEV
# SCRATCH_MNT="/tmp/scratch" ; export SCRATCH_MNT
# mount /dev/xvdc1 /tmp/test


# ./check -xfs -g rw # run 1 - 3.9.0 with cleancache patch
# ./check -xfs -g rw # run 3 - 3.9.1 no patch


--------------060404000606020908030506
Content-Type: application/gzip; name="xfstests.1.out.gz"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="xfstests.1.out.gz"

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
--------------060404000606020908030506
Content-Type: application/gzip; name="xfstests.3.out.gz"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="xfstests.3.out.gz"

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
--------------060404000606020908030506
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--------------060404000606020908030506--
