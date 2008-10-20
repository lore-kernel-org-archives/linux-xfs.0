Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 19 Oct 2008 19:23:19 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9K2NF1c025036
	for <xfs@oss.sgi.com>; Sun, 19 Oct 2008 19:23:16 -0700
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 961A1519713
	for <xfs@oss.sgi.com>; Sun, 19 Oct 2008 19:25:00 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id Hs4ujwrNfgBz0F0e for <xfs@oss.sgi.com>; Sun, 19 Oct 2008 19:25:00 -0700 (PDT)
Message-ID: <48FBEBFA.30200@sandeen.net>
Date: Sun, 19 Oct 2008 21:24:58 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: XFS slow performance
References: <48FBDC47.5080700@ramunia.com>
In-Reply-To: <48FBDC47.5080700@ramunia.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Muhammad Fakhrul Rozi Bin Mohd Seth <rozi@ramunia.com>
Cc: xfs@oss.sgi.com

Muhammad Fakhrul Rozi Bin Mohd Seth wrote:
> Hi All,
...


> ** what have i check is; if no snapshot was taken; the files sharing was 
> go on without problem and really fast.
> This problem occurred only when we have a snapshot drives. even a single 
> drive.
> 
> 
> please help me and advise me on this?

There's not a lot to go on here, but it sounds like it's possibly an lvm
snapshot issue, not an xfs issue, to me.  Can you test another
filesystem temporarily to see if you see the same slowdown when a
snapshot is active?

When a snapshot is active, it's doing copy on write, which will slow
things down to some degree.

-Eric
