Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8CGkeA2005876 for <xfs@oss.sgi.com>; Mon, 12 Sep 2011 11:46:41 -0500
Received: from server655-han.de-nserver.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B1C5854D496
	for <xfs@oss.sgi.com>; Mon, 12 Sep 2011 09:46:37 -0700 (PDT)
Received: from server655-han.de-nserver.de (server655-han.de-nserver.de
	[85.158.177.45]) by cuda.sgi.com with ESMTP id dnNh0sHsKpA8LxDS
	for <xfs@oss.sgi.com>; Mon, 12 Sep 2011 09:46:37 -0700 (PDT)
References: <1D2B34A7-7BB9-4E4E-9CA2-382C210E125F@profihost.ag>
	<20110912152133.GA8345@infradead.org>
In-Reply-To: <20110912152133.GA8345@infradead.org>
Mime-Version: 1.0 (iPhone Mail 8H7)
Message-Id: <C6515E45-5724-43DD-95A8-1F89AFE29601@profihost.ag>
From: Stefan Priebe <s.priebe@profihost.ag>
Subject: Re: xfs deadlock in stable kernel 3.0.4
Date: Mon, 12 Sep 2011 18:46:26 +0200
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
To: Christoph Hellwig <hch@infradead.org>
Cc: "xfs-masters@oss.sgi.com" <xfs-masters@oss.sgi.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

Hi,

>> Hello List,
>> 
>> on some of our heavy loaded servers using xfs we're seeing a deadlock where reading/writing to the xfs filesystem suddenly stops working.
>> 
>> Here you can find sysrq w triggered log messages of the locked processes.
>> 
>> http://pastebin.com/JWjrbrh4
> 
> What kind of workload are you running?  Also did the workload run fine
> with an older kernel, and if yes which one?

Mysql, Web, Mail, ftp ;-) yes it was with 2.6.32. I upgraded from that version.

Stefan
_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
