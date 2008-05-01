Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 01 May 2008 08:25:10 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m41FOk1p009340
	for <xfs@oss.sgi.com>; Thu, 1 May 2008 08:24:52 -0700
Received: from py-out-1112.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id F253E1B8E55B
	for <xfs@oss.sgi.com>; Thu,  1 May 2008 08:25:30 -0700 (PDT)
Received: from py-out-1112.google.com (py-out-1112.google.com [64.233.166.181]) by cuda.sgi.com with ESMTP id UU1Qvs2DVaNIWn75 for <xfs@oss.sgi.com>; Thu, 01 May 2008 08:25:30 -0700 (PDT)
Received: by py-out-1112.google.com with SMTP id j37so1039332pyc.4
        for <xfs@oss.sgi.com>; Thu, 01 May 2008 08:25:30 -0700 (PDT)
Message-ID: <1d3e8bf0805010825o7a6a0765ofeb63b730fef3c4e@mail.gmail.com>
Date: Thu, 1 May 2008 16:25:29 +0100
From: "Dovydas Sankauskas" <laisve@gmail.com>
Subject: Re: disk I/O error
In-Reply-To: <480E17C7.7070606@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1d3e8bf0804220842r26411f51vc714da371255aa90@mail.gmail.com>
	 <480E17C7.7070606@sandeen.net>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
Cc: xfs@oss.sgi.com

2008/4/22 Eric Sandeen <sandeen@sandeen.net>:
>
>  In any case to recover as best you can from the dying disk, try
>  dd_rescue to image every readable sector, then run xfs_repair on that
>  image and mount it loopback to get to what's left.

I did exactly as you said. It took a while, but I managed to recover
all data I have lost. ddrescue is a great tool!

Thank you for your help.


-- 

Dovydas Sankauskas
