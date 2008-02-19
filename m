Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 19 Feb 2008 14:43:11 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m1JMh7oE017860
	for <xfs@oss.sgi.com>; Tue, 19 Feb 2008 14:43:09 -0800
Received: from mail2.syneticon.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 38E7EE6A2B2
	for <xfs@oss.sgi.com>; Tue, 19 Feb 2008 14:43:30 -0800 (PST)
Received: from mail2.syneticon.net (mail.syneticon.net [213.239.212.131]) by cuda.sgi.com with ESMTP id g5wNwqdo5k7EFKWU for <xfs@oss.sgi.com>; Tue, 19 Feb 2008 14:43:30 -0800 (PST)
Message-ID: <47BB5B8D.2060500@wpkg.org>
Date: Tue, 19 Feb 2008 23:43:25 +0100
From: Tomasz Chmielewski <mangoo@wpkg.org>
MIME-Version: 1.0
Subject: Re: is xfs good if I have millions of files and thousands of hardlinks?
References: <47BADF75.2070004@wpkg.org> <47BB5873.6040703@sgi.com>
In-Reply-To: <47BB5873.6040703@sgi.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: markgw@sgi.com
Cc: xfs@oss.sgi.com

Mark Goodwin schrieb:

> defragmenting by copying from the ext3 filesystem to a new filesystem
> should help, for a while at least. Whether xfs would have an on-going
> performance problem compared to ext3 depends on your usage patterns ..
> does "all the time" mean you are continuously adding new files and links
> and removing files at a high rate/second? Are multiple threads doing this?

Yes. Multiple threads adding new files (or hardlinks, if there are such 
files already) all the time (24h/day).
Normally, there is only one thread removing the files. Because of this 
performance problem I described, it also does its job 24h/day - it just 
can't finish removing the unneeded files in a couple of hours, not to 
say one day.


> Are all the files the same size? Block-size been tuned?

No, file sizes are mostly random stuff you will normally find on any 
rootfs, home, etc. directory.
It's a backup system which uses hardlinks so that files which are 
already in backup do not take additional place.

I didn't do any block-size tuning, as I don't really know where to bite.


-- 
Tomasz Chmielewski
http://wpkg.org
