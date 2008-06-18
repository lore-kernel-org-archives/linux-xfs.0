Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 17 Jun 2008 23:35:41 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m5I6Zams009281
	for <xfs@oss.sgi.com>; Tue, 17 Jun 2008 23:35:37 -0700
Message-ID: <4858ADC3.4060609@sgi.com>
Date: Wed, 18 Jun 2008 16:40:03 +1000
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
MIME-Version: 1.0
Subject: Re: [PATCH V2] make inode reclaim wait for log I/O to complete
References: <48364E43.3030108@sgi.com> <48588E6B.3010006@sgi.com> <20080618043002.GS3700@disturbed>
In-Reply-To: <20080618043002.GS3700@disturbed>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>, xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

Dave Chinner wrote:
> On Wed, Jun 18, 2008 at 02:26:19PM +1000, Lachlan McIlroy wrote:
>> ping.
>>
>> Lachlan McIlroy wrote:
>>> During a forced shutdown a xfs inode can be destroyed before log
>>> I/O involving that inode is complete.  We need to wait for the
>>> inode to be unpinned before tearing it down.  Version 2 cleans up
>>> the code a bit by relying on xfs_iflush() to do the unpinning and
>>> forced shutdown check.
> 
> Sorry I missed this when you first posted it. This one looks ok.
> 

Thanks Dave.
