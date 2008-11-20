Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mAK1t01m030052 for <xfs@oss.sgi.com>; Wed, 19 Nov 2008 19:55:00 -0600
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C9BB51B29646
	for <xfs@oss.sgi.com>; Wed, 19 Nov 2008 17:54:53 -0800 (PST)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com
	with ESMTP id AAz6BDc1LuOUTHdE for <xfs@oss.sgi.com>;
	Wed, 19 Nov 2008 17:54:53 -0800 (PST)
Message-ID: <4924C36B.6090700@sandeen.net>
Date: Wed, 19 Nov 2008 19:54:51 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [patch 01/11] Move compat ioctl structs &
	numbers	into	xfs_ioctl32.h
References: <20081119044401.573365619@sandeen.net>	<20081119044907.776640320@sandeen.net>	<20081119145941.GA13050@infradead.org>
	<49242FAC.2060208@sandeen.net>
In-Reply-To: <49242FAC.2060208@sandeen.net>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
Cc: xfs@oss.sgi.com

Eric Sandeen wrote:

>> I must also say that I don't really like these _copying helpers at all,
>> just adding an explicit call to the underlying ioctl from them seems
>> much clener than dispatching control back to the main routine with a
>> changed argument and ioc number.
> 
> Ok, either way is fine by me, was just following what was there already.

So I went off to do it this way, and while I certainly can, (I'm almost
done rewriting it this way) after a bit more thought I really don't see
much wrong with just translating in the 32-bit args for any ioctl which
is _IOW only... it doesn't seem that bad... any particular reason you're
against it?

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
