Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 19 Jul 2007 17:52:43 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l6K0qbbm016169
	for <xfs@oss.sgi.com>; Thu, 19 Jul 2007 17:52:39 -0700
Message-ID: <46A00752.4040103@sgi.com>
Date: Fri, 20 Jul 2007 10:52:34 +1000
From: Timothy Shimmin <tes@sgi.com>
MIME-Version: 1.0
Subject: Re: [GIT PULL] XFS update
References: <469F7329.9080603@sgi.com> <alpine.LFD.0.999.0707191528250.27249@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.999.0707191528250.27249@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: akpm@linux-foundation.org, xfs@oss.sgi.com, linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Fri, 20 Jul 2007, Tim Shimmin wrote:
>> Please pull from the for-linus branch:
>>     git pull git://oss.sgi.com:8090/xfs/xfs-2.6.git for-linus
> 
> Ok, this got some conflicts with Nick's VM fault patches, but I fixed them 
> up since they looked trivial, and pushed out the result. Please do verify 
> that it all works and makes sense, though...
> 
> 		Linus

Okay, sorry and thanks.

The window between pulling in and applying changes was obviously
large enough for Nick's changes to get in.
I did pull in, and then had hassles in converting changes between
sgi dev tree and git mainline. Then by the time they were fixed, scripts
updated, had dinner, tree built, had failure with posix_test_lock (fixed that -
then noticed others fixed it - wish I had pulled in at this stage:)
and ran thru some qa, Nick's changes must have gone in.
Ok, next time must remember to repull in latest just before sending out
as a final check.

--Tim
