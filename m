Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sender-pp-092.zoho.com ([135.84.80.237]:25420 "EHLO
        sender-pp-092.zoho.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752439AbdHUKsO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 21 Aug 2017 06:48:14 -0400
Subject: Re: xfs errors
References: <42ebd50b-a327-0afb-a53a-e2dedd003415@zoho.com>
 <da41ec6e-0009-6515-7c60-a48c3b07369b@sandeen.net>
 <2fd2a278-4c78-3072-e10d-d9745f5183fb@zoho.com>
 <c9ee564c-8627-ad00-cc86-5548c9688298@sandeen.net>
From: ToddAndMargo <ToddAndMargo@zoho.com>
Message-ID: <eacdbe57-7833-4b7f-c14a-47948b0b2113@zoho.com>
Date: Mon, 21 Aug 2017 03:48:12 -0700
MIME-Version: 1.0
In-Reply-To: <c9ee564c-8627-ad00-cc86-5548c9688298@sandeen.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

On 08/20/2017 08:01 PM, Eric Sandeen wrote:
>> The difference between my office and the customer is
>> that I use a hardware raid (raid 1) card and the customer
>> uses RSTe ("e" for enterprise) RAID 1, which is a pseudo
>> software raid.  Maybe a lot of stuff is floating around
>> in the either (cache) that is not sync'ed to the drive pair
>> and xfsdump is not happy about it.

> The underlying storage will not affect this.

>> I am wonder if it would be possible for xfsdump to can
>> "sync; sync" itself before starting.  That would insure
>> a clean slate.

> No; that's a guess, not a root cause analysis - we won't
> be putting hacks like that in based on hunches.

You have a point.  It is still in the hunch phase.

> If you want to investigate more, find out where in the code
> the error spits out, and do more error reporting there; find out
> what error code is actually being returned.  actually I suppose
> strace would work for this as well.  Knowing which error code
> the ioctl fails with would offer a clue about why.
> 
> -Eric
> 

I have no idea how to do that.  :'(

-Todd

