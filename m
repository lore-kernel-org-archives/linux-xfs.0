Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 04 Oct 2007 10:00:06 -0700 (PDT)
Received: from sargon.lncsa.com (sargon.lncsa.com [212.99.8.251])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id l94H02LB000768
	for <xfs@oss.sgi.com>; Thu, 4 Oct 2007 10:00:03 -0700
Message-ID: <470515E8.4020807@lncsa.com>
Date: Thu, 04 Oct 2007 18:33:44 +0200
From: Laurent CARON <lcaron@lncsa.com>
MIME-Version: 1.0
Subject: Re: Crash on 2.6.21.7 Vanilla + DRBD 0.7
References: <20071004133302.GA5058@apartia.fr> <4704FA19.2080101@theendofthetunnel.de>
In-Reply-To: <4704FA19.2080101@theendofthetunnel.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com
Cc: Hannes Dorbath <light@theendofthetunnel.de>

Hannes Dorbath wrote:
> On 04.10.2007 15:33, vindex+lists-xfs@apartia.org wrote:
>> What do you think about it ?
> 
> Another thing, is there a special reason why you use DRBD 0.7.x branch?
> AFAIK it will still deadlock with kernel 2.6.22. You are not running
> .22, but if you upgrade you might have serious problems. You should
> really go with DRBD 8.0.6 if you can.
> 
> 

Hi,

We use 0.7.X since we had a major problem with 8.0.x.

The initial sync did never complete.

I tried to solve this problem with Lars Ellenberg to no avail, and
decided to go back to 0.7 which is a well tested version.
