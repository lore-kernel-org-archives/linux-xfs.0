Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 05 May 2008 06:07:37 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m45D7EWP005275
	for <xfs@oss.sgi.com>; Mon, 5 May 2008 06:07:18 -0700
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C95A278D567
	for <xfs@oss.sgi.com>; Mon,  5 May 2008 06:07:57 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id xQuBHq13UJhEQDJJ for <xfs@oss.sgi.com>; Mon, 05 May 2008 06:07:57 -0700 (PDT)
Message-ID: <481F06AA.4060301@sandeen.net>
Date: Mon, 05 May 2008 08:07:54 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] fix dir2 shortform structures on ARM old ABI
References: <47DB4181.7040603@sandeen.net> <480E89B5.8070006@sandeen.net> <481B7FD1.3030107@sandeen.net> <20080505070847.GH155679365@sgi.com>
In-Reply-To: <20080505070847.GH155679365@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs-oss <xfs@oss.sgi.com>

David Chinner wrote:
> On Fri, May 02, 2008 at 03:55:45PM -0500, Eric Sandeen wrote:
>> Eric Sandeen wrote:
>>> Eric Sandeen wrote:
>>>> This should fix the longstanding issues with xfs and old ABI
>>>> arm boxes, which lead to various asserts and xfs shutdowns,
>>>> and for which an (incorrect) patch has been floating around
>>>> for years.  (Said patch made ARM internally consistent, but
>>>> altered the normal xfs on-disk format such that it looked
>>>> corrupted on other architectures):
>>>> http://lists.arm.linux.org.uk/lurker/message/20040311.002034.5ecf21a2.html
>>> ping again...
>> ping #3...
> 
> <sigh>
> 
> Looks like if I don't pick it up then nobody is going to answer.
> I'll run it through my ia64 and x86_64 test boxes and if it's ok
> then I'll commit it.
> 
> Did you ever send an equivalent userspace patch?

I did ... I can resend too.

-Eric
