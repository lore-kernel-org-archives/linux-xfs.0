Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 28 Jun 2008 13:07:38 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5SK7afJ014343
	for <xfs@oss.sgi.com>; Sat, 28 Jun 2008 13:07:37 -0700
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C3F5C1237BDF
	for <xfs@oss.sgi.com>; Sat, 28 Jun 2008 13:08:38 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id iROmFbJ3qzLezsdF for <xfs@oss.sgi.com>; Sat, 28 Jun 2008 13:08:38 -0700 (PDT)
Message-ID: <48669A45.1050104@sandeen.net>
Date: Sat, 28 Jun 2008 15:08:37 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] re-remove xfs custom bitops
References: <480EB397.1040304@sandeen.net> <4829C360.5060500@sandeen.net> <482BF841.8050704@sgi.com>
In-Reply-To: <482BF841.8050704@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Donald Douwsma <donaldd@sgi.com>
Cc: xfs-oss <xfs@oss.sgi.com>

Donald Douwsma wrote:
> Eric Sandeen wrote:
>> Eric Sandeen wrote:
>>> Once more, with feeling!
>>>
>>> This re-instates the reverted mod after the ppc panic of
>>> Feb '08.  You guys do have ppc boxes in the test farm now right? :)
>>>
>>> This keeps xfs_lowbit64 as it was since there aren't good
>>> generic helpers there ...
>>>
>>> This should probably keep Dave's signed-off line, there's
>>> a bit of my (userspace) testing here but no original work. 
>>>
>>> This exact patch isn't tested but it's based on a conglomeration
>>> of prior testing...
>> SGI guys, any takers on this one?
>> -Eric
> 
> Sorry Eric, havent had chance to run this on all platforms yet.
> I want to test it on ppc as well as the usual x86_64/ia64 combinations,
> then I'll get it committed.
> 
> Don

Don, how's that all going then? :)

Thanks,
-Eric
