Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 12FF17F37
	for <xfs@oss.sgi.com>; Wed, 20 Jan 2016 11:59:12 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 01AE48F8052
	for <xfs@oss.sgi.com>; Wed, 20 Jan 2016 09:59:11 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id 8ZZY4V4GJpVu0AWd for <xfs@oss.sgi.com>;
	Wed, 20 Jan 2016 09:59:10 -0800 (PST)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 3551263CBD0E
	for <xfs@oss.sgi.com>; Wed, 20 Jan 2016 11:59:10 -0600 (CST)
From: Eric Sandeen <sandeen@sandeen.net>
Subject: Pass mp to kmem_alloc and friends?
Message-ID: <569FCAED.4050306@sandeen.net>
Date: Wed, 20 Jan 2016 11:59:09 -0600
MIME-Version: 1.0
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

I had a request for the kmem_alloc deadlock warning to print the
filesystem involved.

Any objections to passing mp into kmem_alloc() and friends whenever
it's reasonably available from the caller?

It'd be a big mechanical change, don't want to embark on that unless
it seems acceptable & useful.

I think we generally know the root causes of the most common deadlock
warnings, but it's a warm fuzzy to give as much info as possible.

Heck, I almost wonder if passing a descriptive string in, for at
least the problematic cases we know about, i.e. "extent map realloc"
so we'd get something like:

XFS (sdb1): myprocess(123) possible memory allocation deadlock size 12345 during extent map realloc in kmem_alloc (mode:0x250)

I dunno ... too much? :)

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
