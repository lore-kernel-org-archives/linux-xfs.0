Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 04 Apr 2008 11:07:10 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m34I711I019468
	for <xfs@oss.sgi.com>; Fri, 4 Apr 2008 11:07:03 -0700
Received: from ti-out-0910.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5A65791F904
	for <xfs@oss.sgi.com>; Fri,  4 Apr 2008 11:07:37 -0700 (PDT)
Received: from ti-out-0910.google.com (ti-out-0910.google.com [209.85.142.184]) by cuda.sgi.com with ESMTP id LvpUkKj7v8QeRse9 for <xfs@oss.sgi.com>; Fri, 04 Apr 2008 11:07:37 -0700 (PDT)
Received: by ti-out-0910.google.com with SMTP id d10so171407tib.18
        for <xfs@oss.sgi.com>; Fri, 04 Apr 2008 11:07:37 -0700 (PDT)
Message-ID: <4f52331f0804041100g696ba02er47c3642c56a24cf7@mail.gmail.com>
Date: Fri, 4 Apr 2008 11:00:27 -0700
From: "Fong Vang" <sudoyang@gmail.com>
Subject: suggested tuning for XFS on RAID system
MIME-Version: 1.0
Content-Type: text/plain
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Anyone has any suggestion on tuning XFS for more stability and reliability
on a 1TB and 7TB XFS file system that holds potentially millions of small
files?  The file system is built on a RAID-10 file system with caching
turned on in the raid controller (can't switch it off or we loose too much
performance).

about 80% of the IO operations are write for about 2 months then this
switches to 20% write and 80% reads after the two month period.

Any thoughts?

Thank you for your help.


[[HTML alternate version deleted]]
