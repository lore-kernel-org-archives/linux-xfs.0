Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o24HDJ0L182600 for <xfs@oss.sgi.com>; Thu, 4 Mar 2010 11:13:19 -0600
Received: from firestarter.dermichi.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9383C13F6BB0
	for <xfs@oss.sgi.com>; Thu,  4 Mar 2010 09:14:47 -0800 (PST)
Received: from firestarter.dermichi.com (firestarter.dermichi.com
	[78.41.115.230]) by cuda.sgi.com with ESMTP id b4XQ5UCVjKVYyovf
	for <xfs@oss.sgi.com>; Thu, 04 Mar 2010 09:14:47 -0800 (PST)
Message-ID: <4B8FEA85.8040201@dermichi.com>
Date: Thu, 04 Mar 2010 18:14:45 +0100
From: Michael Weissenbacher <mw@dermichi.com>
MIME-Version: 1.0
Subject: Re: XFS hang during xfs_fsr run
References: <4B8F871C.60802@dermichi.com>	<20100304112018.GG14317@discord.disaster>	<4B8FA2CD.6010904@dermichi.com>	<20100304131511.GH14317@discord.disaster>	<20100304134641.GA26871@infradead.org>	<4B8FC1B7.3070505@dermichi.com>
	<20100304143018.GA417@infradead.org>
In-Reply-To: <20100304143018.GA417@infradead.org>
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

Hi!
> 
> There's an old userspace ksymoops tool which we used before kallysyms
> was around.  I don't remember the exact usage, just that it was a real
> pain.
> 
After some research on how to do a proper ksymoops i found the following 
information in Documentation/oops-tracing.txt:
NOTE: ksymoops is useless on 2.6.  Please use the Oops in its original 
format
(from dmesg, etc).  Ignore any references in this or other docs to "decoding
the Oops" or "running it through ksymoops".  If you post an Oops from 
2.6 that
has been run through ksymoops, people will just tell you to repost it.

What should i do now? I've already enabled CONFIG_KALLSYMS and rebooted.

> 
> What no-defrag flag?
> 
# xfs_io /var/log/
xfs_io> chattr -R +f
xfs_io> lsattr
------------f- /var/log/

cheers,
Michael

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
