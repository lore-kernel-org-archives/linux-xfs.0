Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 07 Mar 2007 06:34:59 -0800 (PST)
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l27EYq6p009623
	for <xfs@oss.sgi.com>; Wed, 7 Mar 2007 06:34:53 -0800
Message-ID: <45EECD8A.7000503@sandeen.net>
Date: Wed, 07 Mar 2007 08:34:50 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] get rid of fname[] for tracing functions
References: <45EE2EF3.8090707@sandeen.net> <20070307082753.GA5469@infradead.org>
In-Reply-To: <20070307082753.GA5469@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

Christoph Hellwig wrote:
>> the vn tracing could probably get a similar treatment, so that every 
>> call to vn_trace_foo wouldn't have to include a function name and a 
>> __builtin_return_address, but could be done via macros... it's currently 
>> a mishmash of __FUNCTION__ and "function" *shrug* what do you think?
> 
> It should probably use __FUNCTION__ and hide use of both __FUNCTION__
> and __builtin_return_address behind a macro.
> 

Yep, that's exactly what I meant, I've started a patch to do that too.

-Eric
