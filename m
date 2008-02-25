Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 24 Feb 2008 17:11:30 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m1P1BJK8012037
	for <xfs@oss.sgi.com>; Sun, 24 Feb 2008 17:11:22 -0800
Message-ID: <47C21585.8030504@sgi.com>
Date: Mon, 25 Feb 2008 12:10:29 +1100
From: Mark Goodwin <markgw@sgi.com>
Reply-To: markgw@sgi.com
MIME-Version: 1.0
Subject: Re: [RFC, patch 1/2] Allow up to 1GB logs in mkfs.xfs
References: <20080221230833.GG155407@sgi.com> <ncctzk11zhl.fsf@sgi.com> <20080222050301.GP155407@sgi.com> <47BE6122.5040007@sgi.com> <20080222065338.GQ155407@sgi.com>
In-Reply-To: <20080222065338.GQ155407@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Lachlan McIlroy <lachlan@sgi.com>, Niv Sardi <xaiki@cxhome.ath.cx>, xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>


David Chinner wrote:
> On Fri, Feb 22, 2008 at 04:44:02PM +1100, Lachlan McIlroy wrote:
>> David Chinner wrote:
>>> On Fri, Feb 22, 2008 at 01:44:38PM +1100, Niv Sardi wrote:
>>>> David Chinner <dgc@sgi.com> writes:
>>>>> Increase the maximum log size supported by mkfs.
>>> ....
>>>>> Hence logs larger than 2^30 will not work without kernel
>>>>> modifications.
> Therefore this change is limited to increasing the
>>>>> log size to what we can currently support in kernel space with
>>>>> needing kernel modifications.

Does anyone know of any work in mainline to address this?

>>>> I'm glad you got time to get around this, I didn't include it in the
>>>> first batch as I was told it 'broke things'.
>>> Right. There's all sorts of nasties lurking if we go over 1GB in
>>> size, but AFAICT up to 1GB is OK. There's still lots of validation
>>> needing to be done - that's why this is an "RFC" and not something
>>> ready for checkin yet. That's where more eye's and testers are
>>> handy...
>> Dave, have you run any tests to see if we get any speed-ups with
>> this change?
>
> Not yet - I've been running it through QA with different log sizes
> first to see if there's anything obviously broken with the kernel
> w.r.t. larger log sizes (nothing wrong so far).

What sort of improvements are we expecting? Log bound benchmarks will
tail-push later than they do now, wont they? Which particular benchmarks
are you thinking of running?

Thanks

-- 

  Mark Goodwin                                  markgw@sgi.com
  Engineering Manager for XFS and PCP    Phone: +61-3-99631937
  SGI Australian Software Group           Cell: +61-4-18969583
-------------------------------------------------------------
