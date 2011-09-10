Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8A0T0Ra067937 for <xfs@oss.sgi.com>; Fri, 9 Sep 2011 19:29:01 -0500
Received: from mx2.fusionio.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2C40B14D487
	for <xfs@oss.sgi.com>; Fri,  9 Sep 2011 17:23:58 -0700 (PDT)
Received: from mx2.fusionio.com (mx2.fusionio.com [66.114.96.31]) by
	cuda.sgi.com with ESMTP id VHcSTZ5FDV60nONZ for
	<xfs@oss.sgi.com>; Fri, 09 Sep 2011 17:23:58 -0700 (PDT)
From: Joshua Aune <luken@fusionio.com>
Date: Fri, 9 Sep 2011 18:23:54 -0600
Subject: Performance regression between 2.6.32 and 2.6.38
Message-ID: <F70D1B6A-0387-4646-B97B-98ED895F7759@fusionio.com>
Content-Language: en-US
MIME-Version: 1.0
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
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>
Cc: Paul Saab <ps@fb.com>

Hi,

We have been doing some performance testing on a handful of kernels and are seeing a significant performance regression with lower number of outstanding I/Os somewhere between 2.6.32 and 2.6.38.  The test case shows a significant drop in random read IOPS (45k -> 8k) and a significantly dirtier latency profile.  

We also tested against the raw block device and against ext4.  The performance profiles of those tests were fairly consistent between the .32 and 3.0 based kernels where most of the testing was done.

Also worth noting, the test case below has 24 thread with one I/O each (~24 outstanding total).  We did do a small number of tests that used 4 threads with libaio and 64 I/Os each (~256 total outstanding) which showed performance across the various kernel versions to be fairly stable.


-- Results

2.6.32-71.el6.x86_64
   iops=45,694
   bw=731,107 KB/s
   lat (usec): min=149 , max=2465 , avg=523.58, stdev=106.68
   lat (usec): 250=0.01%, 500=48.93%, 750=48.30%, 1000=2.70%
   lat (msec): 2=0.07%, 4=0.01%

2.6.40.3-0.fc15.x86_64 (aka 3.0)
  iops=8043
  bw=128,702 KB/s
  lat (usec): min=77 , max=147441 , avg=452.33, stdev=2773.88
  lat (usec): 100=0.01%, 250=61.30%, 500=37.59%, 750=0.01%, 1000=0.01%
  lat (msec): 2=0.05%, 4=0.04%, 10=0.30%, 20=0.33%, 50=0.30%
  lat (msec): 100=0.07%, 250=0.01%


-- Testing Configuration

Most testing was performed on various 2 socket intel x5600 class server systems using various models of ioDrive.  The results above are from a 160GB ioDrive with a 2.3.1 driver.

The fio benchmark tool was used for most of the testing, but another benchmark showed similar results.


-- Testing  Process

# load the ioDrive driver
modprobe iomemory-vs

# Reset the ioDrive back to a known state
fio-detach /dev/fct0
fio-format -y /dev/fct0
fio-attach /dev/fct0

# Setup XFS for testing and create the sample file
mkfs.xfs -i size=2048 /dev/fioa
mkdir -p /mnt/tmp
mount -t xfs /dev/fioa /mnt/tmp
dd if=/dev/zero of=/mnt/tmp/bigfile bs=1M oflag=direct count=$((10*1024))

# Run fio test
fio --direct=1 --rw=randread --bs=16k --numjobs=24 --runtime=60 --group_reporting --norandommap --time_based --ioengine=sync --name=file1 --filename=/mnt/tmp/bigfile


-- Other

Are there any mount options or other tests that can be run in the failing configuration that would be helpful to isolate this further?

Thanks,
Josh


Please cc Paul and I, we are not subscribed to the list.



Confidentiality Notice: This e-mail message, its contents and any attachments to it are confidential to the intended recipient, and may contain information that is privileged and/or exempt from disclosure under applicable law. If you are not the intended recipient, please immediately notify the sender and destroy the original e-mail message and any attachments (and any copies that may have been made) from your system or otherwise. Any unauthorized use, copying, disclosure or distribution of this information is strictly prohibited.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
