Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 31 Mar 2008 10:43:01 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m2VHgrhZ008814
	for <xfs@oss.sgi.com>; Mon, 31 Mar 2008 10:42:54 -0700
From: =?iso-8859-2?Q?Husz=E1r_Viktor_D=E9nes?= <hvd@dwo.hu>
Subject: RE: free space problem
Date: Mon, 31 Mar 2008 19:43:24 +0200
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-2"
In-Reply-To: <20080331003847.GF103491721@sgi.com>
Message-Id: <20080331174328.158428D4E9B@cuda.sgi.com>
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: 'David Chinner' <dgc@sgi.com>
Cc: xfs@oss.sgi.com



-----Original Message-----
From: David Chinner [mailto:dgc@sgi.com] 
Sent: Monday, March 31, 2008 2:39 AM
To: Huszár Viktor Dénes
Cc: xfs@oss.sgi.com
Subject: Re: free space problem

> What is the error you are getting? Does 'dd if=/dev/zero of=/mntpt/file
> bs=512 count=1' work? If not, what's the error?  What's the output of 'df
> -h' and 'df -ih'? Output of 'xfs_info <mntpt>'?
Cheers,

Dave
--

Actually, from yesterday it started working again. So the xfs_info of
yesterday I can't send when it was not working. When it was not working, in
dd there is nothing extra. A simple no space left on device. And kernel does
not log anything (dmesg). The problem appeared suddenly and mysteriously,
and it disappeared in the same way... If it happens again, I'll send you the
info immediately. 

The problem was there for couple of days, we umounted and ran xfs_repair
several times, and we mounted it back and not even mkdir worked, or in 5-10
minutes we wrote few Gb space on the disk and still plenty of Gbs were free,
but it said: no space left on device. So if it appears again, I'll get back
to you guys. 

Im really thankful for your help! 

Viktor from Hungary, Budapest
 

__________ Information from ESET NOD32 Antivirus, version of virus signature
database 2987 (20080331) __________

The message was checked by ESET NOD32 Antivirus.

http://www.eset.com
 
