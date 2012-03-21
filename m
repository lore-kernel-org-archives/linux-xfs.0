Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2L403mW045694 for <xfs@oss.sgi.com>; Tue, 20 Mar 2012 23:00:03 -0500
Received: from mail-pz0-f53.google.com (mail-pz0-f53.google.com
	[209.85.210.53]) by cuda.sgi.com with ESMTP id bfEmH2LY3x2e4FvG
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 20 Mar 2012 21:00:02 -0700 (PDT)
Received: by dady25 with SMTP id y25so1112730dad.26
	for <xfs@oss.sgi.com>; Tue, 20 Mar 2012 21:00:02 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 21 Mar 2012 17:00:02 +1300
Message-ID: <CAJzjPKkUm-uWuGs2xPLF9yZ71uUV8QwPApjGAf6EKDoGqQYqBA@mail.gmail.com>
Subject: kernel: XFS (dm-7): xlog_space_left: head behind tail
From: Gregory Machin <gdm@linuxpro.co.za>
Reply-To: gdm@linuxpro.co.za
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

I have a CentOS 6.2 virtual machine in a vmware ESXi 4.0 host 4G Ram 4
virtaul cpus and with about 4 TB of disk space formatted with XFS .
I'm seeing a lot of :

Mar 21 10:49:42 nzhmlfpr05 kernel: XFS (dm-4): xlog_space_left: head behind tail
Mar 21 10:49:42 nzhmlfpr05 kernel:  tail_cycle = 129, tail_bytes = 20163072
Mar 21 10:49:42 nzhmlfpr05 kernel:  GH   cycle = 129, GH   bytes = 20162880
Mar 21 10:49:42 nzhmlfpr05 kernel: XFS (dm-7): xlog_space_left: head behind tail
Mar 21 10:49:42 nzhmlfpr05 kernel:  tail_cycle = 5, tail_bytes = 333417984
Mar 21 10:49:42 nzhmlfpr05 kernel:  GH   cycle = 5, GH   bytes = 333417792
Mar 21 10:49:42 nzhmlfpr05 kernel: XFS (dm-7): xlog_space_left: head behind tail
Mar 21 10:49:42 nzhmlfpr05 kernel:  tail_cycle = 5, tail_bytes = 333417984
Mar 21 10:49:42 nzhmlfpr05 kernel:  GH   cycle = 5, GH   bytes = 333417792

What would casue this ? A quick google , I found a post that indicated
I should unmount and mount the file systems. I have live production
data on this machine so I need to be careful. What is the best
solution ?

Thanks

Greg

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
