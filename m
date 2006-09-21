Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 21 Sep 2006 17:07:57 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k8M07laG029790
	for <xfs@oss.sgi.com>; Thu, 21 Sep 2006 17:07:48 -0700
Received: from excu-mxob-1.symantec.com (excu-mxob-1.symantec.com [198.6.49.12])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1ED5BD10E76D
	for <xfs@oss.sgi.com>; Thu, 21 Sep 2006 15:52:22 -0700 (PDT)
Received: from tus1opsmtapin01.ges.symantec.com (tus1opsmtapin01.ges.symantec.com [192.168.214.43])
	by excu-mxob-1.symantec.com (8.13.7/8.13.7) with ESMTP id k8LMqJoB016263
	for <xfs@oss.sgi.com>; Thu, 21 Sep 2006 15:52:20 -0700 (PDT)
Received: from [10.137.18.172] (helo=SVLXCHCON2.enterprise.veritas.com)
	by tus1opsmtapin01.ges.symantec.com with esmtp (Exim 4.52)
	id 1GQXOz-000820-36
	for xfs@oss.sgi.com; Thu, 21 Sep 2006 15:52:17 -0700
MIME-Version: 1.0
Subject: xfs_read_buf error 5.
Date: Thu, 21 Sep 2006 15:52:18 -0700
Message-ID: <43FB1967D03EC7449A77FA91322E364802A9AA07@SVL1XCHCLUPIN01.enterprise.veritas.com>
From: "Nikhil Kulkarni" <nikhil_kulkarni@symantec.com>
Content-Type: text/plain
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Hi,

 

We are running the latest stable kernel 2.6.18 on RedHat Enterprise 4
Update 4.

When I create an xfs partition and assign it a size > 2GB, I get the
following errors during bootup:

 

Sep 21 15:44:06 ssimppi7 kernel:  sda: sda1

Sep 21 15:44:06 ssimppi7 kernel: sda1: rw=0, want=7167993856,
limit=2873026796

Sep 21 15:44:06 ssimppi7 kernel: I/O error in filesystem ("sda1")
meta-data dev sda1 block 0x1ab3ee7ff       ("xfs_read_buf") error 5 buf
count 512

Sep 21 15:43:51 ssimppi7 mount: mount: /dev/sda1: can't read superblock

 

If the partition size is < 2GB then everything works smoothly. The
filesystem mounts successfully.

 

I searched the archives but could not find anything that would help me
in debugging this issue.

 

I was wondering if anyone else has reported the same issue or if I am
missing a step or if this is a defect in the code or

something??

 

Your response is greatly appreciated.

 

Thanks,

Nikhil



[[HTML alternate version deleted]]
