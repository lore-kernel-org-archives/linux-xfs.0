Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 11 Nov 2006 09:13:32 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id kABHDOaG031710
	for <xfs@oss.sgi.com>; Sat, 11 Nov 2006 09:13:25 -0800
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 38A8B517FDC
	for <xfs@oss.sgi.com>; Sat, 11 Nov 2006 09:12:37 -0800 (PST)
Message-ID: <45560483.5000303@sandeen.net>
Date: Sat, 11 Nov 2006 11:12:35 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] remove unused filp from ioctl functions
References: <4555437B.4040904@sandeen.net> <20061111105627.GB3356@infradead.org>
In-Reply-To: <20061111105627.GB3356@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

Christoph Hellwig wrote:
> On Fri, Nov 10, 2006 at 09:28:59PM -0600, Eric Sandeen wrote:
>> There's a stuct file * passed around the ioctl code that is never
>> used... just takes up precious stack space near as I can tell :)
> 
> While you're at it kill the inode paramater anyway, it can be retrieved
> from the vnode by trivial address arithmetics.

Hadn't noticed, let me look into that.

-Eric
