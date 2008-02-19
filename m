Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 19 Feb 2008 05:53:48 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m1JDrgqu010758
	for <xfs@oss.sgi.com>; Tue, 19 Feb 2008 05:53:45 -0800
Received: from mail2.syneticon.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4CC9AE5E20F
	for <xfs@oss.sgi.com>; Tue, 19 Feb 2008 05:54:04 -0800 (PST)
Received: from mail2.syneticon.net (mail.syneticon.net [213.239.212.131]) by cuda.sgi.com with ESMTP id jhQXLN8XrzLFXnJm for <xfs@oss.sgi.com>; Tue, 19 Feb 2008 05:54:04 -0800 (PST)
Received: from postfix1.syneticon.net (postfix1.syneticon.net [192.168.112.6])
	by mail2.syneticon.net (Postfix) with ESMTP id 23EEF62A83
	for <xfs@oss.sgi.com>; Tue, 19 Feb 2008 14:54:04 +0100 (CET)
Received: from localhost (filter1.syneticon.net [192.168.113.3])
	by postfix1.syneticon.net (Postfix) with ESMTP id A51719456
	for <xfs@oss.sgi.com>; Tue, 19 Feb 2008 14:54:01 +0100 (CET)
Received: from postfix1.syneticon.net ([192.168.113.4])
	by localhost (mx03.syneticon.net [192.168.113.3]) (amavisd-new, port 10025)
	with ESMTP id YOPqlnrNI7yf for <xfs@oss.sgi.com>;
	Tue, 19 Feb 2008 14:53:59 +0100 (CET)
Received: from [192.168.10.145] (koln-d932d00b.pool.mediaWays.net [217.50.208.11])
	by postfix1.syneticon.net (Postfix) with ESMTP
	for <xfs@oss.sgi.com>; Tue, 19 Feb 2008 14:53:58 +0100 (CET)
Message-ID: <47BADF75.2070004@wpkg.org>
Date: Tue, 19 Feb 2008 14:53:57 +0100
From: Tomasz Chmielewski <mangoo@wpkg.org>
MIME-Version: 1.0
Subject: is xfs good if I have millions of files and thousands of hardlinks?
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

I have a ext3 filesystem with almost 200 million files (1.2 TB fs, ~65% 
full); most of the files are hardlinked multiple times, some of them are 
hardlinked thousands of times.

I described my problem yesterday on linux-fsdev list:

http://marc.info/?t=120333985100003


In general, because new files and hardlinks are being added all the time 
and the old ones are being removed, this leads to a very, very poor 
performance.

When I want to remove a lot of directories/files (which will be 
hardlinks, mostly), I see disk write speed is down to
50 kB/s - 200 kB/s (fifty - two hundred kilobytes/s) - this is the 
"bandwidth" used during the deletion.


Also, the filesystem is very fragmented ("dd if=/dev/zero of=some_file 
bs=64k" writes only about 1 MB/s).


Will xfs handle a large number of files, including lots of hardlinks, 
any better than ext3?



-- 
Tomasz Chmielewski
http://wpkg.org
