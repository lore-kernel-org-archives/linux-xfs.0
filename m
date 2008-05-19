Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 18 May 2008 20:46:36 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m4J3kTe1010654
	for <xfs@oss.sgi.com>; Sun, 18 May 2008 20:46:32 -0700
Message-ID: <4830F831.40102@sgi.com>
Date: Mon, 19 May 2008 13:46:57 +1000
From: Timothy Shimmin <tes@sgi.com>
MIME-Version: 1.0
Subject: Re: Regression- XFS won't mount on partitioned md array
References: <482DC043.5000307@dgreaves.com> <482DD981.5070004@sandeen.net> <482EEFDA.50101@dgreaves.com> <482EF6A7.2020909@sandeen.net> <482F67D9.70400@sandeen.net> <482FBD4C.20608@sandeen.net>
In-Reply-To: <482FBD4C.20608@sandeen.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: David Greaves <david@dgreaves.com>, David Chinner <dgc@sgi.com>, xfs@oss.sgi.com, "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>, asg-qa <asgqa@sgi.com>

Eric Sandeen wrote:
> Eric Sandeen wrote:
>> Eric Sandeen wrote:
>>
>>> I'll see if I have a little time today to track down the problem.
>>
>> Does this patch fix it for you?  Does for me though I can't yet explain
>> why ;)
>>
>> http://www.linux.sgi.com/archives/xfs/2008-05/msg00190.html
>>
>> -Eric
> 
> So what's happening is that xfs is trying to read a page-sized IO from
> the last sector of the log... which goes off the end of the device.
> This looks like another regression introduced by
> a9759f2de38a3443d5107bddde03b4f3f550060e, but fixed by Christoph's patch
> in the URL above, which should be headed towards -stable.
> 
> (aside: it seems that this breaks any external log setup where the log
> consists of the entire device... but I'd have expected the xfsqa suite
> to catch this...?)
> 
The only way I can see that we'd catch this (by testing external logs)
in the current qa setup is
if one sets up SCRATCH_LOGDEV and/or TEST_LOGDEV and USE_EXTERNAL.
There are no specific tests to test out external logs (there is 044 but
it requires the env vars set anyway) such as using a loop back device
for the log. Perhaps we should do this.
I should check that our QA group are setting the vars in some runs.

--Tim
