Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 22 Apr 2008 09:52:09 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m3MGpm5L028477
	for <xfs@oss.sgi.com>; Tue, 22 Apr 2008 09:51:51 -0700
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 829AFA933BA
	for <xfs@oss.sgi.com>; Tue, 22 Apr 2008 09:52:24 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id O7lKmCD6kH62M22q for <xfs@oss.sgi.com>; Tue, 22 Apr 2008 09:52:24 -0700 (PDT)
Message-ID: <480E17C7.7070606@sandeen.net>
Date: Tue, 22 Apr 2008 11:52:23 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: disk I/O error
References: <1d3e8bf0804220842r26411f51vc714da371255aa90@mail.gmail.com>
In-Reply-To: <1d3e8bf0804220842r26411f51vc714da371255aa90@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Dovydas Sankauskas <laisve@gmail.com>
Cc: xfs@oss.sgi.com

Dovydas Sankauskas wrote:
> Hi.
> 
> I have an external USB HDD, which I wanted to use as a temporary
> storage for my personal data while I clean up my local hdd. And while
> moving files from local hdd to external hdd, it stopped responding. I
> tried xfs_repair, but no luck.
> 
> Any insight on what has happened 

Look no further than your $SUBJECT :)

> and what are my chances to restore
> data?

Which disk died, original or backup?

In any case to recover as best you can from the dying disk, try
dd_rescue to image every readable sector, then run xfs_repair on that
image and mount it loopback to get to what's left.

-Eric
