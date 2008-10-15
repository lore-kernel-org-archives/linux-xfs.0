Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 14 Oct 2008 23:50:08 -0700 (PDT)
Received: from relay.sgi.com (netops-testserver-3.corp.sgi.com [192.26.57.72])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9F6o5QV016989
	for <xfs@oss.sgi.com>; Tue, 14 Oct 2008 23:50:06 -0700
Message-ID: <48F5A104.5060506@sgi.com>
Date: Wed, 15 Oct 2008 17:51:32 +1000
From: Peter Leckie <pleckie@sgi.com>
MIME-Version: 1.0
Subject: Re: crash with latest code drop.
References: <48F54C20.8060704@sgi.com> <20081015011857.GS10716@disturbed> <20081015022948.GA20966@infradead.org> <20081015031645.GA25906@disturbed> <20081015032431.GA7426@infradead.org> <20081015035116.GB25906@disturbed> <48F584B8.8060907@sgi.com> <20081015061917.GC25906@disturbed>
In-Reply-To: <20081015061917.GC25906@disturbed>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>, xfs@oss.sgi.com

Dave Chinner wrote:
> On Wed, Oct 15, 2008 at 03:50:48PM +1000, Peter Leckie wrote:
>   
>> Dave Chinner wrote:
>>     
>>> Update below.
>>>
>>> Cheers,
>>>
>>> Dave.
>>>   
>>>       
>> The original patch appeared to fix the issue, however the latest one  
>> Oops as follows:
>>     
>
> Well, I think the problem dhould be obvious

Gee thanks Dave.
>  - it's the same as
> the first report - deferencing the linux inode without first having
> a refernce on it.
>   

Yes it resolves the issue.

Pete
