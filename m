Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 16 Aug 2006 23:59:05 -0700 (PDT)
Received: from mail.interline.it (mail.interline.it [195.182.241.4])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k7H6wnDW007897
	for <xfs@oss.sgi.com>; Wed, 16 Aug 2006 23:58:50 -0700
Received: from localhost (localhost [127.0.0.1])
	by mail.interline.it (Postfix) with ESMTP id ACC618D8
	for <xfs@oss.sgi.com>; Thu, 17 Aug 2006 08:52:04 +0200 (CEST)
Received: from mail.interline.it ([127.0.0.1])
	by localhost (pin [127.0.0.1]) (amavisd-new, port 10024) with ESMTP
	id 22051-23 for <xfs@oss.sgi.com>;
	Thu, 17 Aug 2006 08:52:03 +0200 (CEST)
Received: from [192.168.1.98] (unknown [88.36.237.170])
	by mail.interline.it (Postfix) with ESMTP id EF8408C9
	for <xfs@oss.sgi.com>; Thu, 17 Aug 2006 08:52:02 +0200 (CEST)
From: "Daniele P." <daniele@interline.it>
Subject: Re: xfsdump -s unacceptable performances
Date: Thu, 17 Aug 2006 08:58:11 +0200
References: <200608161515.00543.daniele@interline.it> <200608162001.10342.daniele@interline.it> <44E3C6D5.2080704@sgi.com>
In-Reply-To: <44E3C6D5.2080704@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200608170858.11697.daniele@interline.it>
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

On Thursday 17 August 2006 03:31, you wrote:
> Daniele P. wrote:
> > But xfsdump still doesn't scale down well with a small subtree on a
> > large filesystem.
>
> That is very true.
> It is really designed for dumping whole filesystems (or at least,
> large parts of them).
> For dumping small subtrees, I'd be looking at using something else.

Hi Timothy,
Yes, you are right, but there is another problem on my side.
The /small/ subtree of the filesystem usually contains a lot of hard 
links (our backup software uses hard links to save disk space, so 
expect one hard link per file per day) and using a generic tool like 
tar/star or rsync that uses "stat" to scan the filesysem should be 
significant slower (no test done) than a native tool like xfsdump, as 
Bill in a previous email pointed out.

It seems that there isn't a right tool for this job.

Regards,
Daniele
