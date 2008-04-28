Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 27 Apr 2008 17:39:49 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m3S0dKI3010997
	for <xfs@oss.sgi.com>; Sun, 27 Apr 2008 17:39:23 -0700
Message-ID: <48151CDD.3070203@sgi.com>
Date: Mon, 28 Apr 2008 10:39:57 +1000
From: Timothy Shimmin <tes@sgi.com>
MIME-Version: 1.0
Subject: Re: REVIEW: 980021 - fix up noattr2 mount option
References: <480EC93D.9090103@sgi.com> <20080426063551.GA7193@infradead.org>
In-Reply-To: <20080426063551.GA7193@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs-oss <xfs@oss.sgi.com>, xfs-dev <xfs-dev@sgi.com>

Christoph Hellwig wrote:
> On Wed, Apr 23, 2008 at 03:29:33PM +1000, Timothy Shimmin wrote:
>> Hi there,
>>
>> Mounting noattr2 in xfs fails to achieve anything AFAICT -
>> and it certainly doesn't do anything useful.
> 
> The patch looks correct in that it turns off attr2 when using the mount
> option now.  But the real question is why do we even need this option at
> all?

Good question.
I guess I just feel with the problems we've had with attr2 so far,
I feel it would be good to have an easy way to to go back if needed
at this point (and the option is there though busted).
Ideally, there would be no attr1 and no option to go back required.

--Tim
