Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 03 Oct 2008 13:59:38 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m93KxZEN029556
	for <xfs@oss.sgi.com>; Fri, 3 Oct 2008 13:59:36 -0700
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7F9EB137EFCB
	for <xfs@oss.sgi.com>; Fri,  3 Oct 2008 14:01:13 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id XaqCzbQC8J97vZw1 for <xfs@oss.sgi.com>; Fri, 03 Oct 2008 14:01:13 -0700 (PDT)
Message-ID: <48E68818.308@sandeen.net>
Date: Fri, 03 Oct 2008 16:01:12 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: how to determine version of XFS
References: <4f52331f0810031358y6702581ft8b255df1305e5368@mail.gmail.com>
In-Reply-To: <4f52331f0810031358y6702581ft8b255df1305e5368@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Fong Vang <sudoyang@gmail.com>
Cc: xfs@oss.sgi.com

Fong Vang wrote:
> How does one determine the version of XFS being used in a kernel.  I'm
> running the CentOS 4.7 plus kernel, but I'm not sure what version of XFS
> that is.  modinfo only provide info about the kernel version.  I don't see
> anything in dmesg and in /proc.
> 
> thanks

"uname -r"  :)

There really isn't a "version" of xfs anymore; it just lives upstream.

The xfs module in centos is roughly xfs from the 2.6.9 era, IIRC.

-Eric
