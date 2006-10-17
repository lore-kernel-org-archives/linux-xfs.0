Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 16 Oct 2006 18:04:57 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k9H14laG026232
	for <xfs@oss.sgi.com>; Mon, 16 Oct 2006 18:04:48 -0700
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2D456D19B91E
	for <xfs@oss.sgi.com>; Mon, 16 Oct 2006 18:04:03 -0700 (PDT)
Message-ID: <45342BF3.8020609@sandeen.net>
Date: Mon, 16 Oct 2006 20:03:47 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 1/2] Make stuff static
References: <20060929032856.8DA9C18001A5E@sandeen.net> <23F15D6AE8566A54B81188AC@timothy-shimmins-power-mac-g5.local> <45338DDE.8020903@sandeen.net> <4533FAEA.2080500@sandeen.net> <20061016232250.GM11034@melbourne.sgi.com> <1161042943.5723.117.camel@xenon.msp.redhat.com> <20061017005038.GN11034@melbourne.sgi.com>
In-Reply-To: <20061017005038.GN11034@melbourne.sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Russell Cattelan <cattelan@thebarn.com>, Timothy Shimmin <tes@sgi.com>, xfs@oss.sgi.com

David Chinner wrote:

>> So you are proposing?
>> /* non-debug */
>> #define STATIC static inline
>> /* debug */
>> #define STATIC noinline
> 
> No.
> 
> Currently STATIC is defined in fs/xfs/support/debug.h as:
> 
> #ifndef STATIC
> #define STATIC static
> #endif
> 
> I'm proposing that gets changed to:
> 
>> #define STATIC static noinline
> 
> This.

This sounds reasonable to me, David.

-Eric
