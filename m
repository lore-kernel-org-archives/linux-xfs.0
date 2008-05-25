Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 24 May 2008 20:24:31 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m4P3OPFe032221
	for <linux-xfs@oss.sgi.com>; Sat, 24 May 2008 20:24:26 -0700
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7EF8B1AE786
	for <linux-xfs@oss.sgi.com>; Sat, 24 May 2008 20:25:15 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id yhZQABhIL4MXKHnn for <linux-xfs@oss.sgi.com>; Sat, 24 May 2008 20:25:15 -0700 (PDT)
Message-ID: <4838DC1A.5010206@sandeen.net>
Date: Sat, 24 May 2008 22:25:14 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: XFS for lots of small files
References: <4820832B.3070903@dubielvitrum.pl> (sfid-20080506_185726_779300_46423265) <200805062055.36755.Martin@lichtvoll.de>
In-Reply-To: <200805062055.36755.Martin@lichtvoll.de>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Martin Steigerwald <Martin@lichtvoll.de>
Cc: linux-xfs@oss.sgi.com

Martin Steigerwald wrote:

> And there is quite some fragmentation on it:
> 
> xfs_db> frag
> actual 653519, ideal 587066, fragmentation factor 10.17%


No, there's not.

You have 653519 extents out of an "ideal" 587066.

That is 653519/587066 = 1.113 extents per file.

It is not "quite some" fragmentation, it is near perfect (although this
is subjective, and also depends on the size of your files... if they are
all 8k then 1.113 extents per file might be a bit high; if they average
1G then 1.113 extents on average is pretty darned good.)

-Eric
