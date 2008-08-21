Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 20 Aug 2008 20:09:25 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m7L39MRe024923
	for <xfs@oss.sgi.com>; Wed, 20 Aug 2008 20:09:22 -0700
Received: from ns3.baby-dragons.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D207D1A1CEE4
	for <xfs@oss.sgi.com>; Wed, 20 Aug 2008 20:10:41 -0700 (PDT)
Received: from ns3.baby-dragons.com (ns3.baby-dragons.com [204.91.156.41]) by cuda.sgi.com with ESMTP id FhDaHA24gFh56Wsy for <xfs@oss.sgi.com>; Wed, 20 Aug 2008 20:10:41 -0700 (PDT)
Date: Wed, 20 Aug 2008 19:10:38 -0800 (AKDT)
From: "Mr. James W. Laferriere" <babydr@baby-dragons.com>
Subject: 5 concurrent bonnie runs failing after first pass .
Message-ID: <Pine.LNX.4.64.0808201853480.26204@filesrv1.baby-dragons.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com
Cc: linux-raid maillist <linux-raid@vger.kernel.org>, Dan Williams <dan.j.williams@intel.com>

 	Hello Dave (& Dan & All) ,
 	Even with your patch to xfs (49641f1acfdfd437ed9b0a70b86bf36626c02afe) 
Under some conditions multiple concurrent bonnie runs just halt .  No log to 
dmesg or serial console .  But there is a message from something when bonnie 
halts .  Also note the really low I/O .


--- Bad Bonnie --- (multiple concurrent processes)
filesrv2,136G,,,14389,16,10165,13,,,64722,9,134.3,0,16,212,2,+++++,+++,206,2,226,1,+++++,+++,177,2
semop: semop failed.
: Resource temporarily unavailable


=== Good Bonnie === (single process)
filesrv2,256G,,,108938,59,92128,56,,,402852,70,407.6,2,16,1477,10,+++++,+++,1164,10,1518,10,+++++,+++,1166,6


 	# uname -a
Linux filesrv2 2.6.26 #2 SMP Sun Aug 17 05:36:58 UTC 2008 i686 pentium4 i386 GNU/Linux


 	- serial console before , during & after the multiple concurrent bonnie run .

Welcome to Linux 2.6.26 (ttyS0)

filesrv2 login: dd used greatest stack depth: 3604 bytes left
Aug 19 03:51:01 filesrv2 kernel: dd used greatest stack depth: 3604 bytes left



 	Bonnie output Here ...

 	http://www.baby-dragons.com/131072MB-bonnie++-run-md3-xfs-15runs.log-200808200242-2.6.26

 	Below shows the amount of I/O during that run to all memebers of the array being tested ...

 	http://www.baby-dragons.com/device-thruput-200808200242-2.6.26.log


 	The culprit ...

# cat ~/bin/bonniemd3.sh
N=5
/root/bonnie++-1.03c/bonnie++ -u0:0 -p${N}

   SIZE="`echo -en "scale=0\n((717698048-4096)/((1024^2)*${N}))*1024\nquit\n" | bc`k"
   echo "\${SIZE}=${SIZE}"

# Note: add or subtract a line of the below for ${N} > 5 or ${N} < 5

   time /root/bonnie++-1.03c/bonnie++ -u 0:0 -y -d /md3 -x 15 -s ${SIZE} -f -y &
   time /root/bonnie++-1.03c/bonnie++ -u 0:0 -y -d /md3 -x 15 -s ${SIZE} -f -y &
   time /root/bonnie++-1.03c/bonnie++ -u 0:0 -y -d /md3 -x 15 -s ${SIZE} -f -y &
   time /root/bonnie++-1.03c/bonnie++ -u 0:0 -y -d /md3 -x 15 -s ${SIZE} -f -y &
   time /root/bonnie++-1.03c/bonnie++ -u 0:0 -y -d /md3 -x 15 -s ${SIZE} -f -y &


 	The victim ...

# mdadm -D /dev/md3
mdadm: metadata format 00.90 unknown, ignored.
mdadm: metadata format 00.90 unknown, ignored.
mdadm: metadata format 00.90 unknown, ignored.
/dev/md3:
         Version : 00.90
   Creation Time : Mon Jul  7 21:42:12 2008
      Raid Level : raid6
      Array Size : 717829120 (684.58 GiB 735.06 GB)
   Used Dev Size : 143565824 (136.92 GiB 147.01 GB)
    Raid Devices : 7
   Total Devices : 8
Preferred Minor : 3
     Persistence : Superblock is persistent

   Intent Bitmap : Internal

     Update Time : Wed Aug 20 10:06:44 2008
           State : active
  Active Devices : 7
Working Devices : 8
  Failed Devices : 0
   Spare Devices : 1

      Chunk Size : 1024K

            UUID : 7617aeb3:65870440:a619e7ca:f8a16963
          Events : 0.12

     Number   Major   Minor   RaidDevice State
        0       8       32        0      active sync   /dev/sdc
        1       8       48        1      active sync   /dev/sdd
        2       8       64        2      active sync   /dev/sde
        3       8       80        3      active sync   /dev/sdf
        4       8       96        4      active sync   /dev/sdg
        5       8      112        5      active sync   /dev/sdh
        6       8      128        6      active sync   /dev/sdi

        7       8      144        -      spare   /dev/sdj


 	More of the victim ...

# cat /proc/mounts | grep md3
/dev/md3 /md3 xfs rw,nobarrier,sunit=2048,swidth=12288,noquota 0 0


-- 
+------------------------------------------------------------------+
| James   W.   Laferriere | System    Techniques | Give me VMS     |
| Network&System Engineer | 2133    McCullam Ave |  Give me Linux  |
| babydr@baby-dragons.com | Fairbanks, AK. 99701 |   only  on  AXP |
+------------------------------------------------------------------+
