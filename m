Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 10 Mar 2008 06:31:35 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m2ADVFZ0030880
	for <xfs@oss.sgi.com>; Mon, 10 Mar 2008 06:31:17 -0700
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 307A95C3BC8
	for <xfs@oss.sgi.com>; Mon, 10 Mar 2008 06:31:45 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id AkdC6s8Fj2hw8imd for <xfs@oss.sgi.com>; Mon, 10 Mar 2008 06:31:45 -0700 (PDT)
Message-ID: <47D5383E.50201@sandeen.net>
Date: Mon, 10 Mar 2008 08:31:42 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: an occational trouble with xfs file system which xfs_repair 2.7.14
 has been able to fix
References: <47D52BE5.6010706@iki.fi>
In-Reply-To: <47D52BE5.6010706@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: erkki.lintunen@iki.fi
Cc: xfs@oss.sgi.com

Erkki Lintunen wrote:
...

> commands in a script. When the trouble begins cp -al command starts to 
> take several hours and hundreds of megs memory. rm -fr of a subtree also 
> takes considerably longer than rm a subtree in another bigger tree in 
> the same filesystem, but the rm commands have always finnished, which 
> the cp -al commands haven't. Most of the time the cp -al process has D 
> status.

...

> What else information I could provide in addition to those requested in FAQ?

When you get a process in the D state, do echo t > /proc/sysrq-trigger
to get backtraces of all processes; or echo w to get all blocked processes.

-Eric
