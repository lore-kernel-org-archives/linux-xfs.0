Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 19 Jun 2008 01:42:16 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5J8gDAe009695
	for <xfs@oss.sgi.com>; Thu, 19 Jun 2008 01:42:14 -0700
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 709C2CEE67A
	for <xfs@oss.sgi.com>; Thu, 19 Jun 2008 01:43:12 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34]) by cuda.sgi.com with ESMTP id RpSrxWZbacNHQUc6 for <xfs@oss.sgi.com>; Thu, 19 Jun 2008 01:43:12 -0700 (PDT)
Date: Thu, 19 Jun 2008 04:43:11 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: open sleeps
Message-ID: <20080619084311.GA16736@infradead.org>
References: <4859EE54.6050801@vpac.org> <20080619062118.GY3700@disturbed> <4859FF40.8010206@vpac.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4859FF40.8010206@vpac.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Brian May <brian@vpac.org>
Cc: xfs@oss.sgi.com

On Thu, Jun 19, 2008 at 04:40:00PM +1000, Brian May wrote:
> Does the following help? I still have the logs of the other processes, if 
> required (just in case it is some weird interaction between multiple 
> processes?)
>
> It seems to be pretty consistent with lock_timer_base, every time I look 
> (assuming I haven't read the stack trace upside down...).
>
> Jun 19 16:33:30 hq kernel: grep          S 00000000     0 12793  12567                     (NOTLB)
>
> Jun 19 16:33:30 hq kernel:        f0c23e7c 00200082 000a1089 00000000 
> 00000010 00000008 cd0db550 dfa97550 
> Jun 19 16:33:30 hq kernel:        34f84262 00273db2 0008a1dc 00000001 
> cd0db660 c20140a0 dfe1cbe8 00200286 
> Jun 19 16:33:30 hq kernel:        c0125380 a4dbf26b dfa6a000 00200286 
> 000000ff 00000000 00000000 a4dbf26b 
> Jun 19 16:33:30 hq kernel: Call Trace:
>
> Jun 19 16:33:30 hq kernel:  [<c0125380>] lock_timer_base+0x15/0x2f
>
> Jun 19 16:33:30 hq kernel:  [<c027f960>] schedule_timeout+0x71/0x8c
>
> Jun 19 16:33:30 hq kernel:  [<c0124a81>] process_timeout+0x0/0x5
>
> Jun 19 16:33:30 hq kernel:  [<c016c801>] __break_lease+0x2a8/0x2b9

That's the lease breaking code in the VFS, long before we call
into XFS.  Looks like someone (samba?) has a least on this file and
we're having trouble having it broken.  Try sending a report about
this to linux-fsdevel@vger.kernel.org
