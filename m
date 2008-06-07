Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 07 Jun 2008 16:02:07 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m57N21R7031052
	for <xfs@oss.sgi.com>; Sat, 7 Jun 2008 16:02:03 -0700
Received: from smtp.sauce.co.nz (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DAFC1C4F4F2
	for <xfs@oss.sgi.com>; Sat,  7 Jun 2008 16:02:55 -0700 (PDT)
Received: from smtp.sauce.co.nz (smtp.sauce.co.nz [210.48.49.72]) by cuda.sgi.com with ESMTP id RsNjyUSUWOwLgSPF for <xfs@oss.sgi.com>; Sat, 07 Jun 2008 16:02:55 -0700 (PDT)
Message-ID: <484B15A3.4030505@sauce.co.nz>
Date: Sun, 08 Jun 2008 11:11:31 +1200
From: Richard Scobie <richard@sauce.co.nz>
MIME-Version: 1.0
Subject: Filestreams
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Is my understanding of filestreams correct, in that files written to a 
particular filestreams enabled directory are all allocated to 1 ag as 
long as the filestreams timeout is not exceeded - which I believe is 30s?

In other words, if I copy 100 files into a directory, (cp -a 
dir_containing_100_files dest_dir), wait 60 seconds and do (cp -a 
dir_containing_100_different_files dest_dir), each directory and 
contents in dest_dir will be stored in a single, different ag?

Also, would it be possible for the filestreams parameter to be added to 
man pages/kernel docs?

Thanks,

Richard
