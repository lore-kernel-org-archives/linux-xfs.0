Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 02 Jun 2008 06:39:01 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m52DcqsW029194
	for <xfs@oss.sgi.com>; Mon, 2 Jun 2008 06:38:53 -0700
Received: from rv-out-0708.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5C6021B9D2C7
	for <xfs@oss.sgi.com>; Mon,  2 Jun 2008 06:39:45 -0700 (PDT)
Received: from rv-out-0708.google.com (rv-out-0708.google.com [209.85.198.249]) by cuda.sgi.com with ESMTP id fY6lHI58AGLiqU88 for <xfs@oss.sgi.com>; Mon, 02 Jun 2008 06:39:45 -0700 (PDT)
Received: by rv-out-0708.google.com with SMTP id f25so815302rvb.32
        for <xfs@oss.sgi.com>; Mon, 02 Jun 2008 06:39:45 -0700 (PDT)
Message-ID: <7b9198260806020639n7679035s270c0ce3575a894b@mail.gmail.com>
Date: Mon, 2 Jun 2008 14:39:40 +0100
From: "Tom Spink" <tspink@gmail.com>
Subject: Re: [RFC PATCH 0/2] On-demand Filesystem Initialisation
In-Reply-To: <20080602015831.GB2428@disturbed>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1212331915-22856-1-git-send-email-tspink@gmail.com>
	 <20080602015831.GB2428@disturbed>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Tom Spink <tspink@gmail.com>, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com

2008/6/2 Dave Chinner <david@fromorbit.com>:
> On Sun, Jun 01, 2008 at 03:51:53PM +0100, Tom Spink wrote:
>>
>> (resend to include CCs)
>
> What cc's? Still no xfs cc on it. I added it to this reply....
>
>> This (short) patch series is another RFC for the patch that introduces on-demand
>> filesystem initialisation.  In addition to the original infrastructure
>> implementation (with clean-ups), it changes XFS to use this new infrastructure.
>>
>> I wrote a toy filesystem (testfs) to simulate scheduling/allocation delays and
>> to torture the mount/unmount cycles.  I didn't manage to deadlock the system
>> in my tests.  XFS also works as expected aswell, in that the global threads
>> are not created until an XFS filesystem is mounted for the first time.  When the
>> last XFS filesystem is unmounted, the threads go away.
>>
>> Please let me know what you think!
>
> Why even bother? This is why we have /modular/ kernels - if you're
> not using XFS then don't load it and you won't see those pesky
> threads. That'll save on a bunch of memory as well because the xfs
> module ain't small (>480k on i386)....

Yeah, absolutely.  But if the filesystem is built-in, you can't unload it.

> Cheers,
>
> Dave.

Thanks for taking a look, anyway!

-- 
Tom Spink
