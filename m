Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 11 Jul 2008 19:01:37 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6C21YYV006764
	for <xfs@oss.sgi.com>; Fri, 11 Jul 2008 19:01:35 -0700
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 52FD12E0701
	for <xfs@oss.sgi.com>; Fri, 11 Jul 2008 19:02:39 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id PoBL5YcIIWeMJ9Le for <xfs@oss.sgi.com>; Fri, 11 Jul 2008 19:02:39 -0700 (PDT)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTP id 53D7DAC6278
	for <xfs@oss.sgi.com>; Fri, 11 Jul 2008 21:02:39 -0500 (CDT)
Message-ID: <487810BE.5050701@sandeen.net>
Date: Fri, 11 Jul 2008 21:02:38 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: xfs leaking?
References: <4877928A.1020008@sandeen.net> <20080711233832.GH11558@disturbed> <4877FC4F.7020906@sandeen.net>
In-Reply-To: <4877FC4F.7020906@sandeen.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-oss <xfs@oss.sgi.com>

Eric Sandeen wrote:
> Dave Chinner wrote:
> 
>> I'd suggest updating to 2.6.26-rc9 and repeating the test.  After
>> unmounting all the filesystems and before you rmmod the kernel
>> module, dump /proc/slabinfo so we can see if there are remaining
>> objects in the XFs slabs....
> 
> Yep I fired up on 2.6.26-rc9 this morning after I sent the mail.  And I
> wish I'd checked the slabs before the explosion last time ... it'll be
> full again in a while and I'll try again.

2.6.26-rc9 passed without incident.

> The complete lack of memory may well explain the horrendous repair
> performance, too.  :)

about 12min, not bad.

(twice that of e2fsck/ext4 though, for this test!)  :)

-Eric

> -Eric
> 
>> Cheers,
>>
>> Dave.
> 
> 
