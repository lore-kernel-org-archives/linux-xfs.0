Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 16 Aug 2006 18:34:43 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k7H1YFDW018676
	for <xfs@oss.sgi.com>; Wed, 16 Aug 2006 18:34:28 -0700
Message-ID: <44E3C6D5.2080704@sgi.com>
Date: Thu, 17 Aug 2006 11:31:01 +1000
From: Timothy Shimmin <tes@sgi.com>
MIME-Version: 1.0
Subject: Re: xfsdump -s unacceptable performances
References: <200608161515.00543.daniele@interline.it> <44E32DE6.9090602@gmx.net> <200608162001.10342.daniele@interline.it>
In-Reply-To: <200608162001.10342.daniele@interline.it>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "Daniele P." <daniele@interline.it>
Cc: xfs@oss.sgi.com

Daniele P. wrote:
> But xfsdump still doesn't scale down well with a small subtree on a
> large filesystem.

That is very true.
It is really designed for dumping whole filesystems (or at least,
large parts of them).
For dumping small subtrees, I'd be looking at using something else.
That was one of the 1st things I noticed when looking at the xfsdump
code on IRIX a while back, was all the scans it does and how for a subtree
it will do another scan and prune the data - i.e. implemented
like an afterthought :)
It is built around bulkstat which walks all the inodes which is great
for dumping them all out.
But if you want a small directory walk then you need something else IMHO.

Cheers,
--Tim
