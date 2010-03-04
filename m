Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o24EJOth172656 for <xfs@oss.sgi.com>; Thu, 4 Mar 2010 08:19:24 -0600
Received: from firestarter.dermichi.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 65B64218461
	for <xfs@oss.sgi.com>; Thu,  4 Mar 2010 06:20:51 -0800 (PST)
Received: from firestarter.dermichi.com (firestarter.dermichi.com
	[78.41.115.230]) by cuda.sgi.com with ESMTP id zT0QrEg795CBSRP7
	for <xfs@oss.sgi.com>; Thu, 04 Mar 2010 06:20:51 -0800 (PST)
Message-ID: <4B8FC1B7.3070505@dermichi.com>
Date: Thu, 04 Mar 2010 15:20:39 +0100
From: Michael Weissenbacher <mw@dermichi.com>
MIME-Version: 1.0
Subject: Re: XFS hang during xfs_fsr run
References: <4B8F871C.60802@dermichi.com>
	<20100304112018.GG14317@discord.disaster>
	<4B8FA2CD.6010904@dermichi.com>
	<20100304131511.GH14317@discord.disaster>
	<20100304134641.GA26871@infradead.org>
In-Reply-To: <20100304134641.GA26871@infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

Hi Christoph/Dave!
> Also when you next rebuilt the kernel please make sure to include
> CONFIG_KALLSYMS in the configuration, possibly CONFIG_KALLSYMS_ALL too.
> This will help greatly with decoding any kind of warning / oops.
Thanks for this information. Unfortunately my current kernel was built 
without CONFIG_KALLSYMS. I'm now recompiling with CONFIG_KALLSYMS and 
CONFIG_KALLSYMS_ALL set. I reckon that my old traces can't be 
ksymoops'ed even if i enable that kernel option now? I will see if i can 
get a fresh trace then (even though i hope it won't happen again).

> Was there anything else in the logs prior to the oops messages
> that might indicate errors were occurring?
Unfortunately everything in the logs is dandy until the error happens. 
It seems that xfs_fsr randomly stops at some files and then locks up the 
whole /var partition. I searched for the inode numbers where xfs_fsr 
stopped and one time it was "/var/log/xfs_fsr.log" and the other time it 
was "/var/spool/imap/x/user/xxxx/cyrus.cache" (username obfuscated). 
Whats's interesting is that i have the no-defrag flag set on the whole 
/var/log directory and still it seemed to hang on that log file.

cheers,
Michael

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
