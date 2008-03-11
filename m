Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 11 Mar 2008 09:24:01 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m2BGNeae017364
	for <xfs@oss.sgi.com>; Tue, 11 Mar 2008 09:23:42 -0700
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6F2CCF64334
	for <xfs@oss.sgi.com>; Tue, 11 Mar 2008 09:24:10 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [66.187.233.31]) by cuda.sgi.com with ESMTP id Ulxe0MgD8n3NKmYi for <xfs@oss.sgi.com>; Tue, 11 Mar 2008 09:24:10 -0700 (PDT)
Message-ID: <47D6B228.5070300@sandeen.net>
Date: Tue, 11 Mar 2008 11:24:08 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Problem with xfs devices
References: <47D6982D.7030305@t-online.de>
In-Reply-To: <47D6982D.7030305@t-online.de>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: =?ISO-8859-15?Q?J=FCrgen_Fischer?= <jfi.pcs@t-online.de>
Cc: xfs@oss.sgi.com

Jürgen Fischer wrote:
> Hi,
> 
> I have some problems with xfs devices which I can't mount and hope you 
> can help me.
> 
> I have the devices md1, md5, md6, md7, md8 on a Root-Server by a german 
> provider with SuSE linux 10.2. I've made yesterday evening an online 
> update which updates the kernel and wants a reboot after that. Since 
> that no rebbot is possible, no help available from provider.
> The devices md1, md5 and md8 I can mount without problems. But if i try 
> to mount md6 or md7 I got the following messages on the screen:
> 
> rescue:~# mount /dev/md6 /mnt
> Killed
> rescue:~#
> Message from syslogd@rescue at Tue Mar 11 00:48:37 2008 ...
> rescue kernel: Oops: 0000 [2] SMP
> 
> Message from syslogd@rescue at Tue Mar 11 00:48:37 2008 ...
> rescue kernel: CR2: 0000000000000008

type "dmesg" to get the whole oops.

-Eric
