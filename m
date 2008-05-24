Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 24 May 2008 06:32:52 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m4ODWnrC026858
	for <xfs@oss.sgi.com>; Sat, 24 May 2008 06:32:49 -0700
Received: from mail.ukfsn.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8A7321AD0DC
	for <xfs@oss.sgi.com>; Sat, 24 May 2008 06:33:39 -0700 (PDT)
Received: from mail.ukfsn.org (mx1.ukfsn.org [77.75.108.10]) by cuda.sgi.com with ESMTP id Lwfk0W8VhfuYVHxv for <xfs@oss.sgi.com>; Sat, 24 May 2008 06:33:39 -0700 (PDT)
Message-ID: <4838192F.3050004@dgreaves.com>
Date: Sat, 24 May 2008 14:33:35 +0100
From: David Greaves <david@dgreaves.com>
MIME-Version: 1.0
Subject: RFI for 2.6.25.5 : Re: Regression- XFS won't mount on partitioned
 md array
References: <482DC043.5000307@dgreaves.com> <482DD981.5070004@sandeen.net> <482EEFDA.50101@dgreaves.com> <482EF6A7.2020909@sandeen.net> <482F67D9.70400@sandeen.net> <482FBD4C.20608@sandeen.net> <482FED60.7060405@dgreaves.com>
In-Reply-To: <482FED60.7060405@dgreaves.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Greg KH <greg@kroah.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, David Chinner <dgc@sgi.com>, xfs@oss.sgi.com, "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>, LinuxRaid <linux-raid@vger.kernel.org>

Hi Greg
Perusing:
  http://git.kernel.org/?p=linux/kernel/git/stable/stable-queue.git
doesn't show the patch referenced below as in the queue for 2.6.25.5

David

David Greaves wrote:
> Eric Sandeen wrote:
>> Eric Sandeen wrote:
>>> Eric Sandeen wrote:
>>>
>>>> I'll see if I have a little time today to track down the problem.
>>> Does this patch fix it for you?  Does for me though I can't yet explain
>>> why ;)
>>>
>>> http://www.linux.sgi.com/archives/xfs/2008-05/msg00190.html
>>>
>>> -Eric
> Yes, this fixes it for me - thanks :)
> 
>> So what's happening is that xfs is trying to read a page-sized IO from
>> the last sector of the log... which goes off the end of the device.
>> This looks like another regression introduced by
>> a9759f2de38a3443d5107bddde03b4f3f550060e, but fixed by Christoph's patch
>> in the URL above, which should be headed towards -stable.
> Damn, I guess I misread my bisect readings when things crashed then.
> Still, I said 'around' :)
> 
>> (aside: it seems that this breaks any external log setup where the log
>> consists of the entire device... but I'd have expected the xfsqa suite
>> to catch this...?)
>>
>> The patch avoids the problem by looking for some extra locking but it
>> seems to me that the root cause is that the buffer being read at this
>> point doesn't have it's b_offset, the offset in it's page, set.  Might
>> be another little buglet but harmless it seems.
