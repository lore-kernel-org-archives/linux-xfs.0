Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 19 Dec 2007 21:42:19 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id lBK5gCK9032630
	for <xfs@oss.sgi.com>; Wed, 19 Dec 2007 21:42:14 -0800
Message-ID: <476A017D.2020106@sgi.com>
Date: Thu, 20 Dec 2007 16:45:33 +1100
From: Timothy Shimmin <tes@sgi.com>
MIME-Version: 1.0
Subject: Re: mount prob: "log inconsistent or not a log"
References: <20071220000144.GQ19770@msoe.edu> <4769BD13.5040303@sgi.com> <20071220011601.GU19770@msoe.edu> <4769F343.9040405@sgi.com> <20071220050445.GA3212@msoe.edu>
In-Reply-To: <20071220050445.GA3212@msoe.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "Jonathan C. Detert" <Jonathan.Detert@msoe.edu>
Cc: xfs@oss.sgi.com

Jonathan C. Detert wrote:
> 
>> If there's corruption that was not between the tail to the head,
>> then it could be a goer I guess but one would wonder about corruption
> 
> what do you mean by 'goer' - hardware failure?
>

I was just thinking that if there was corruption just confined to the
log but not in the interval between the tail and head then
I can't see why theoretically the log can't be replayed.
The replay of the log is done from the tail to the head - the
other log data is mostly irrelevant in this case AFAICT
(I think the failure came with code which is trying to deal
  with the case with a new filesystem where part of the log
  is not written to yet so has zero cycle#s - but here we have
  wrapped 598 times or whatever it was).

--Tim
