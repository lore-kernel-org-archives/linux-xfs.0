Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o24ESp4t173243 for <xfs@oss.sgi.com>; Thu, 4 Mar 2010 08:28:51 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 72CDD218656
	for <xfs@oss.sgi.com>; Thu,  4 Mar 2010 06:30:20 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id sLXoa4cDE3Jm981p for
	<xfs@oss.sgi.com>; Thu, 04 Mar 2010 06:30:20 -0800 (PST)
Date: Thu, 4 Mar 2010 09:30:18 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: XFS hang during xfs_fsr run
Message-ID: <20100304143018.GA417@infradead.org>
References: <4B8F871C.60802@dermichi.com>
	<20100304112018.GG14317@discord.disaster>
	<4B8FA2CD.6010904@dermichi.com>
	<20100304131511.GH14317@discord.disaster>
	<20100304134641.GA26871@infradead.org>
	<4B8FC1B7.3070505@dermichi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4B8FC1B7.3070505@dermichi.com>
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
To: Michael Weissenbacher <mw@dermichi.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Thu, Mar 04, 2010 at 03:20:39PM +0100, Michael Weissenbacher wrote:
> Hi Christoph/Dave!
>> Also when you next rebuilt the kernel please make sure to include
>> CONFIG_KALLSYMS in the configuration, possibly CONFIG_KALLSYMS_ALL too.
>> This will help greatly with decoding any kind of warning / oops.
> Thanks for this information. Unfortunately my current kernel was built  
> without CONFIG_KALLSYMS. I'm now recompiling with CONFIG_KALLSYMS and  
> CONFIG_KALLSYMS_ALL set. I reckon that my old traces can't be  
> ksymoops'ed even if i enable that kernel option now? I will see if i can  
> get a fresh trace then (even though i hope it won't happen again).

There's an old userspace ksymoops tool which we used before kallysyms
was around.  I don't remember the exact usage, just that it was a real
pain.

> Whats's interesting is that i have the no-defrag flag set on the whole  
> /var/log directory and still it seemed to hang on that log file.

What no-defrag flag?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
