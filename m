Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 11 Jul 2008 18:30:45 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6C1UY30004857
	for <xfs@oss.sgi.com>; Fri, 11 Jul 2008 18:30:34 -0700
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 84AF912E0051
	for <xfs@oss.sgi.com>; Fri, 11 Jul 2008 18:31:39 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id a82izg9XFjn5sUz1 for <xfs@oss.sgi.com>; Fri, 11 Jul 2008 18:31:39 -0700 (PDT)
Message-ID: <4878097B.7040604@sandeen.net>
Date: Fri, 11 Jul 2008 20:31:39 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: xfs leaking?
References: <4877928A.1020008@sandeen.net> <20080711233832.GH11558@disturbed>
In-Reply-To: <20080711233832.GH11558@disturbed>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>, xfs-oss <xfs@oss.sgi.com>

Dave Chinner wrote:
> On Fri, Jul 11, 2008 at 12:04:10PM -0500, Eric Sandeen wrote:
>> after my  fill-the-1T-fs-with-20k-files test I tried an xfs_repair, and
>> it was sorrowfully slow compared to e2fsck of ext4 - I stopped it after
>> almost 2 hours, and only half complete.
>>
>> I noticed that during the run, I was about out of memory (8G) and
>> swapping badly.
>>
>> So I unmounted the fs, dropped caches, and was astounded to find
>> 10492540 buffer heads still in the slab caches.

Hm that sounds like I unmounted after xfs_repair.  That didn't come out
right - no, I did not repair a mounted filesystem ;)

-Eric
