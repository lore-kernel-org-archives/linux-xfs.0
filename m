Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 24 Sep 2007 18:32:59 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l8P1WtQ3020978
	for <xfs@oss.sgi.com>; Mon, 24 Sep 2007 18:32:57 -0700
Message-ID: <46F8654B.9010203@sandeen.net>
Date: Mon, 24 Sep 2007 20:32:59 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: something very strange w/ filestreams...
References: <46F49C80.60007@sandeen.net> <20070923092444.GQ995458@sgi.com> <op.ty4867zj3jf8g2@pc-bnaujok.melbourne.sgi.com> <46F7B04D.70809@sandeen.net> <op.ty6ofbsm3jf8g2@pc-bnaujok.melbourne.sgi.com>
In-Reply-To: <op.ty6ofbsm3jf8g2@pc-bnaujok.melbourne.sgi.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Barry Naujok <bnaujok@sgi.com>
Cc: David Chinner <dgc@sgi.com>, xfs-oss <xfs@oss.sgi.com>

Barry Naujok wrote:

>>> So, before running this test, you should make sure your test
>>> partitions are completely zeroed from mkfs's that occurred
>>> before that recent version of mkfs.xfs was installed.
>> I dd'd over the whole test partition, ran the sequence, and hit the  
>> problem.
> 
> Yeah, worked it out yesterday but never got around to doing another
> email. It's a combination of the two filestreams tests which do
> small filesystems and mkfs.xfs doesn't wipe beyond the new
> filesystem size. Zero the disk, try the attached patch and see
> if that fixes the problem.
> 
> Barry.

Ok, but what about that double free?

-Eric
