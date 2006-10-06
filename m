Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 06 Oct 2006 00:14:25 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k967EFaG031521
	for <xfs@oss.sgi.com>; Fri, 6 Oct 2006 00:14:17 -0700
Date: Fri, 06 Oct 2006 17:15:24 +1000
From: Timothy Shimmin <tes@sgi.com>
Subject: Re: review: xfs_copy fix
Message-ID: <EB8491DF9680CB28E09D1EA4@timothy-shimmins-power-mac-g5.local>
In-Reply-To: <20061006063643.GD11034@melbourne.sgi.com>
References: <5635EC4CFB723E7E36B51235@timothy-shimmins-power-mac-g5.local>
 <20061006063643.GD11034@melbourne.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs-dev@sgi.com, xfs@oss.sgi.com

Hi Dave,

--On 6 October 2006 4:36:43 PM +1000 David Chinner <dgc@sgi.com> wrote:

> On Fri, Oct 06, 2006 at 04:18:10PM +1000, Timothy Shimmin wrote:
>> Request for review.
>>
>> xfs_copy was seg faulting for me on my x86_64 box.
>> This fixes up the variable arg handling for multiple
>> vfprintf calls by putting va_start and va_end calls
>> around them (never done this before:).
>
> I take it that it was crashing because the LOG flag and one
> of ERR or OUT was set so it was trying to do 2 varargs
> traversals with only one init?

Exactly.
In the case I tried, it had LOG and OUT flags on, from memory.

>
> Looks sane to me.
Ta.

--Tim
