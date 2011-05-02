Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p42H6sCB241351 for <xfs@oss.sgi.com>; Mon, 2 May 2011 12:06:54 -0500
Received: from mga11.intel.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BA54716495A4
	for <xfs@oss.sgi.com>; Mon,  2 May 2011 10:10:30 -0700 (PDT)
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93]) by
	cuda.sgi.com with ESMTP id 4eAYCE0NYf5PXvjO for
	<xfs@oss.sgi.com>; Mon, 02 May 2011 10:10:30 -0700 (PDT)
From: Andi Kleen <andi@firstfloor.org>
Subject: Re: XFS/Linux Sanity check
References: <BANLkTik4YjSr7-VA+f9Sh+UxvKfFKMy=+w@mail.gmail.com>
Date: Mon, 02 May 2011 10:09:59 -0700
In-Reply-To: <BANLkTik4YjSr7-VA+f9Sh+UxvKfFKMy=+w@mail.gmail.com> (Paul
	Anderson's message of "Mon, 2 May 2011 11:47:48 -0400")
Message-ID: <m2zkn5yqoo.fsf@firstfloor.org>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Paul Anderson <pha@umich.edu>
Cc: xfs@oss.sgi.com

Paul Anderson <pha@umich.edu> writes:
>
> md apparently does not support barriers, so we are badly exposed in

MD barriers for RAID-0 were added in 2.6.33, but very recent kernels
have much improved barriers again.

> Secondly, I welcome suggestions about which version of the linux
> kernel you'd prefer to hear bug reports about, as well as what kinds

Kernel developers usually want reports about the newest versions,
ideally with enough information to debug the problem
(that is backtraces etc.) 

When you have a hang but the console is still active you can also just 
dump the threads with sysrq-t 

Often when things hang it's the underlying IO subsystem (driver, IO device).

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
