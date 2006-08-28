Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 28 Aug 2006 00:00:55 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k7S70VDW011859
	for <xfs@oss.sgi.com>; Mon, 28 Aug 2006 00:00:42 -0700
Message-ID: <44F2948C.4070005@sgi.com>
Date: Mon, 28 Aug 2006 17:00:28 +1000
From: Vlad Apostolov <vapo@sgi.com>
MIME-Version: 1.0
Subject: Re: review: greedy allocator vs kmflags
References: <20060828163004.B3100886@wobbly.melbourne.sgi.com>
In-Reply-To: <20060828163004.B3100886@wobbly.melbourne.sgi.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Nathan Scott <nathans@sgi.com>
Cc: xfs@oss.sgi.com

Nathan Scott wrote:
> Hi Vlad,
>
> This is the last iteration on updating the greedy alloc routine to
> be more generic and properly handle the passed in flags wrt sleep or
> nosleep (following up on Dave's suggestion, and someone else to me
> privately, offlist).  Could you give it a final review for me?
>
> thanks.
>
>   
It is looking good Nathan. One thing I noticed today when I was building 
the modules
was that kmem_zalloc_greedy() is already in use in several places. There
were a few warnings about type mismatch of the first argument "size_t 
*size" and
missing kmem_zalloc_greedy symbol at the end. Not sure if this is 
important but just
thought to mention it.

Regards,
Vlad
