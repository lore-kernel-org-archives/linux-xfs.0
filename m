Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n0IJRPPj020616 for <xfs@oss.sgi.com>; Sun, 18 Jan 2009 13:27:25 -0600
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 96C5D9AC96
	for <xfs@oss.sgi.com>; Sun, 18 Jan 2009 11:27:24 -0800 (PST)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id 7Cf7SZ43Ux2BoqTD for
	<xfs@oss.sgi.com>; Sun, 18 Jan 2009 11:27:24 -0800 (PST)
Message-ID: <4973829B.6000008@sandeen.net>
Date: Sun, 18 Jan 2009 13:27:23 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: only run 197 on 32-bit machines
References: <496E9A84.2060304@sandeen.net>
	<20090118171723.GA12645@infradead.org>
In-Reply-To: <20090118171723.GA12645@infradead.org>
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
Cc: xfs-oss <xfs@oss.sgi.com>

Christoph Hellwig wrote:
> On Wed, Jan 14, 2009 at 08:08:04PM -0600, Eric Sandeen wrote:
>> Don't run test 197 on 64-bit machines
>>
>> If it always passes on 64 bits, this gives a false
>> sense of security.  Make it obvious.
> 
> I don't think it matters, but your patch looks correct and if it helps
> you in some way..
> 
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 

thanks

I only wanted to put it in because I was looking at fedora, wanted to
test it against this bug, ran it, it passed, and *then* I remembered
that it'd only fail on 32-bit, and my test (on that hardware) wasn't
really valid.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
