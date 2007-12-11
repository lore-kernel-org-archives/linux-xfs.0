Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 11 Dec 2007 04:47:59 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id lBBClrKr007559
	for <linux-xfs@oss.sgi.com>; Tue, 11 Dec 2007 04:47:54 -0800
Received: from mail.gmx.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with SMTP id 9FD6746A4F1
	for <linux-xfs@oss.sgi.com>; Tue, 11 Dec 2007 04:48:01 -0800 (PST)
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20]) by cuda.sgi.com with SMTP id m9PnsxGhtKCjVmYK for <linux-xfs@oss.sgi.com>; Tue, 11 Dec 2007 04:48:01 -0800 (PST)
From: "Chris" <hsvchris@gmx.de>
References: 
In-Reply-To: 
Subject: Re: Unexpected XFS SB number 0x00000000
Date: Tue, 11 Dec 2007 13:47:44 +0100
Message-ID: <000001c83bf4$06a8bd80$13fa3880$@de>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Language: de
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: 'Chris' <hsvchris@gmx.de>
Cc: linux-xfs@oss.sgi.com

Seems like using parted to write a new partition table did the job for me.
Used 17.4kB as start and 3000GB as end.
Now being able to mount the partition successfully I ran xfs_growfs.
Afterwards, I still had to do an xfs_repair though, because there were a lot
of (seemingly) random errors when accessing certain files.
Everthing normal now... 
