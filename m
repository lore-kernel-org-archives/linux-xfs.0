Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 05 Mar 2007 08:01:59 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [66.187.233.31])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l25G1q6p025206
	for <linux-xfs@oss.sgi.com>; Mon, 5 Mar 2007 08:01:53 -0800
Message-ID: <45EC3DEA.3000105@sandeen.net>
Date: Mon, 05 Mar 2007 09:57:30 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: xfs partial dismount issue
References: <loom.20070305T141214-502@post.gmane.org>
In-Reply-To: <loom.20070305T141214-502@post.gmane.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Chuck Weber <chaweber@gmail.com>
Cc: linux-xfs@oss.sgi.com

Chuck Weber wrote:
> Hi everyone, I have a long running problem perhaps you can help with. I
> will include as much detail as I can. I can set up a spare server-disk
> set for testing if you have any bright ideas.
> 
> We use XFS for samba and nfs on x86_64 Fedora Proliant DL585/385
> servers. Our busiest server has disk partitions go away. 

What do you mean by this, exactly?  The partitions themselves go away,
or are you talking about the problem described below where processes
start hanging?

> The other
> servers do not show this behavior ever. The partitions show as mounted,
> but access to the partition just hangs. Open file count, process count
> and load average rise until the server becomes very unresponsive. Even
> if we catch it before the high load average, because it cannot unmount
> the partition, it must be powered off and back on to restart. Upon
> restart all partitions mount properly and everything is fine for days or
> months. There is nothing in log files that I have noticed. With sar, I
> can track the files open and process count rise. 

Maybe try sysrq-t, to capture all backtraces when it's in this state,
and see where the various threads are at.

-Eric
