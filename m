Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 07 Aug 2007 22:17:02 -0700 (PDT)
Received: from relay.sgi.com (netops-testserver-3.corp.sgi.com [192.26.57.72])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l785Gvbm003434
	for <xfs@oss.sgi.com>; Tue, 7 Aug 2007 22:16:58 -0700
Received: from mtv-amer002e--3.americas.sgi.com (unknown [192.26.64.114])
	by netops-testserver-3.corp.sgi.com (Postfix) with ESMTP id 14F6190898
	for <xfs@oss.sgi.com>; Tue,  7 Aug 2007 22:01:33 -0700 (PDT)
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Subject: RE: qa 166 failure on f8 kernel
Date: Tue, 7 Aug 2007 21:13:15 -0700
Message-ID: <D59801BCA402F5418C040937230AF7E00B9A8E@mtv-amer002e--3.americas.sgi.com>
In-Reply-To: <20070808025615.GH52011508@sgi.com>
From: "Alex Elder" <aelder@sgi.com>
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>, Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-oss <xfs@oss.sgi.com>

> From: xfs-bounce@oss.sgi.com 
> [mailto:xfs-bounce@oss.sgi.com]On Behalf Of
> David Chinner
> Sent: Tuesday, August 07, 2007 9:56 PM
> To: Eric Sandeen
> Cc: xfs-oss
> Subject: Re: qa 166 failure on f8 kernel
...
> mmap dirties entire pages. page size differs between platforms -
> ia64 = 16k, x86 = 4k - so the size of the extent allocated is
> different. Guess what platform I wrote the test on and use as my
> primary platform?
> 
> The output needs better filtering, methinks.

Could the test be changed so the output is pagesize independent
rather than filtering the output?  Or maybe the test should
use a buffer size that's the LCM of all supported page sizes.

I'm not actually familiar with the test, so forgive me if I'm
way off...

					-Alex
