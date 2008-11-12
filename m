Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 12 Nov 2008 05:52:41 -0800 (PST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id mACDqYgV019154
	for <xfs@oss.sgi.com>; Wed, 12 Nov 2008 05:52:34 -0800
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DFDB51B7D9D1
	for <xfs@oss.sgi.com>; Wed, 12 Nov 2008 05:52:33 -0800 (PST)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id ZCqQkSpyRBBqEVFn for <xfs@oss.sgi.com>; Wed, 12 Nov 2008 05:52:33 -0800 (PST)
Message-ID: <491ADB45.9070301@sandeen.net>
Date: Wed, 12 Nov 2008 07:33:57 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 0/3 v4]  hook xfs to fiemap ioctl
References: <49089596.80006@sandeen.net> <20081112092340.GE8896@infradead.org>
In-Reply-To: <20081112092340.GE8896@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs mailing list <xfs@oss.sgi.com>

Christoph Hellwig wrote:
> On Wed, Oct 29, 2008 at 11:55:50AM -0500, Eric Sandeen wrote:
>> Also, here's a very hacky (don't laugh!) test app.  I'll clean it
>> up at some point   :)  
>>
>> (v4: test app slightly more cleaned up)
> 
> Can you wire up the test program to xfsqa?  Also instead of having your
> own #defines for the constants just use a copy of fiemap.h?
> 

Sure, that makes sense.

I'm not sure how to best exercise fiemap in xfsqa... I guess I should
look to see if there are any xfs_bmap checkers in there and model on that.

-Eric
