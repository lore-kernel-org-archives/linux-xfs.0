Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 30 Mar 2008 18:44:44 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m2V1iZ0Z009001
	for <xfs@oss.sgi.com>; Sun, 30 Mar 2008 18:44:37 -0700
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A71008AC28F
	for <xfs@oss.sgi.com>; Sun, 30 Mar 2008 18:45:11 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id oobFsbHEdVKLpDgk for <xfs@oss.sgi.com>; Sun, 30 Mar 2008 18:45:11 -0700 (PDT)
Message-ID: <47F04225.4030405@sandeen.net>
Date: Sun, 30 Mar 2008 20:45:09 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH, RFC] fix attr fit checking for filesystems which have
 lost their attr2
References: <47EDCBF9.4070102@sandeen.net> <47F035E3.1030004@sgi.com>
In-Reply-To: <47F035E3.1030004@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Timothy Shimmin <tes@sgi.com>
Cc: xfs-oss <xfs@oss.sgi.com>

Timothy Shimmin wrote:
> Hi Eric,
> 
> Eric Sandeen wrote:
...


>> My understanding of this is that if di_forkoff is non-zero,
>> we should always be using it for space calculations, regardless
>> of whether we are mounted with attr2 or not...
>>
> That was my understanding as well.
> I'll have a look at the code soon and see if I can
> see any problems with the change and the consistency
> of it all.
> 
> Thanks a bunch,
> Tim.

Thanks.  FWIW, if I install F8 with bona-fide attr2 in effect, with
selinux (so attrs on everything) and then update it while mounted as an
attr1 filesystem, with this patch in place, it does not result in
anything bad as far as xfs_repair can see.   (and it's a big update,
probably touching most files...)

-Eric
