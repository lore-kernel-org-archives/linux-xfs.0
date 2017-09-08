Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from smtp-fw-9101.amazon.com ([207.171.184.25]:61842 "EHLO
        smtp-fw-9101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756895AbdIHXXV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 8 Sep 2017 19:23:21 -0400
Date: Fri, 8 Sep 2017 16:21:52 -0700
From: Hao Chen <haochen@amazon.com>
Subject: Re: XFS mounted with 'discard' option - deleting fio test files slow
Message-ID: <20170908232152.GA44231@amazon.com>
References: <42228B9C-D2D3-4B9C-BFCF-BC9AED4A9678@amazon.com>
 <506FE85F-21F5-444C-876D-8C25DBB442EE@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <506FE85F-21F5-444C-876D-8C25DBB442EE@amazon.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Lu, Qian" <luqia@amazon.com>
Cc: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, "darrick.wong@oracle.com" <darrick.wong@oracle.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, amazon-linux-kernel <amazon-linux-kernel@amazon.com>

This is expected.  To get a better performance of XFS on NVMe drive, it
is advised not use use the realtime discard option.

https://www.intel.com/content/dam/support/us/en/documents/ssdc/data-center-ssds/Intel_Linux_NVMe_Guide_330602-002.pdf

Hao

==== Lu, Qian <luqia@amazon.com> [2017-09-08 17:17:07 +0000] ====

> Adding amazon-linux-kernel@amazon.com
> 
> On 9/7/17, 11:22 AM, "Lu, Qian" <luqia@amazon.com> wrote:
> 
>     Hi XFS mailing list,
>      
>     Recently we received a bug report in the XFS filesystem with 'discard' option. I have been able to reproduce this issue. I used XFS filesystem to format NVMe SSD and mounted with 'discard' option. When I tried to delete the test fio files, the session took long time. This issue is based on Linux 4.9 stable tree. I have also repeated this test with Linux 4.13, 4.12, and we are facing the same issue. Tests were repeated several times and it was consistent.
>      
>     Please see details below.
>      
>     1. Kernel version: Linux ip-172-31-6-243 4.9.32-15.41.amzn1.x86_64 #1 SMP Thu Jun 22 06:20:54 UTC 2017 x86_64 x86_64 x86_64 GNU/Linux
>      
>     # fio --name fio_test_file --direct=1 --rw=randwrite --bs=4k --size=5G --numjobs=8 --group_reporting
>     --> Interrupt with Ctrl+C
>     # time rm -rf fio_test_file.*
>     --> The session hangs and in 'blocked' state
>     $ dmesg
>     ...
>     [  492.329896] INFO: task rm:9231 blocked for more than 120 seconds.
>     ...
>      
>     Then I tried to backport some patches and repeated the test. The issue has been improved. Eventually 'rm' command completed but took long time(2min).
>      
>       *  Backported patch: 4560e78 xfs: don't block the log commit handler for discards
>      
>      # fio --name fio_test_file --direct=1 --rw=randwrite --bs=4k --size=5G --numjobs=8 --group_reporting
>      --> Interrupt with Ctrl+C
>      # time rm -rf fio_test_file.*
>      real  2m2.242s
>      user  0m0.000s
>      sys   0m25.524s
>      
>      
>     2.    With Linux 4.12 and 4.13.0-rc1, the issue has been improved and the command is not stuck. But 'rm' command still takes long time (more than 1min). Please see details below.
>      
>     Kernel version: Linux version 4.13.0-rc1+ (ec2-user@ip-172-31-21-25) (gcc version 4.8.3 20140911 (Red Hat 4.8.3-9) (GCC)) #1 SMP Fri Jul 21 17:31:06 UTC 2017
>      
>     # fio --name fio_test_file --direct=1 --rw=randwrite --bs=4k --size=5G --numjobs=8 --group_reporting
>     --> Interrupt at about 37%
>     # time rm -rf fio_test_file.*
>     real  1m57.912s
>     user  0m0.000s
>     sys   0m28.810s
>      
>     Compare this result with:
>         a)  XFS mounted with 'nodiscard' option: It took less than 1min to run 'rm' command.
>          
>          # fio --name fio_test_file --direct=1 --rw=randwrite --bs=4k --size=5G --numjobs=8 --group_reporting
>         --> Interrupt at about 39%
>          # time rm -rf fio_test_file.*
>         real     0m31.176s
>          user     0m0.000s
>          sys      0m30.005s
>      
>          b)    EXT4 file system mounted with 'discard' option: It only took about several seconds to run 'rm' command.
>           
>           # fio --name fio_test_file --direct=1 --rw=randwrite --bs=4k --size=5G --numjobs=8 --group_reporting
>          --> Interrupt at about 36.2%
>          # time rm -rf fio_test_file.*
>          real     0m4.661s
>          user     0m0.000s
>          sys      0m4.657s
>      
>     Please note if I wait for 'fio' command 100% done, 'rm' command took less than 1s (0m0.001s).
>      
>      
>     3.   Shell script which triggers the problem
>      
>       sudo su -
>       yum install xfsprogs fio -y
>       mkfs.xfs -K -f -s size=4096 /dev/nvme0n1
>       mkdir -p /media/disk1
>       mount -o discard /dev/nvme0n1 /media/disk1
>       cd /media/disk1/
>       fio --name fio_test_file --direct=1 --rw=randwrite --bs=4k --size=5G --numjobs=8 --group_reporting
>        # Interrupt with Ctrl+C
>       time rm -rf fio_test_file.*
>      
>      
>     Best Regards,
>     Qian Lu
>     
>     
>     
> 

-- 
Hao Chen
Cordite SDM@Cupertino
408-480-6632
