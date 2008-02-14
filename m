Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 14 Feb 2008 15:52:41 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m1ENqVD8003674
	for <xfs@oss.sgi.com>; Thu, 14 Feb 2008 15:52:36 -0800
Message-ID: <47B4D454.4010600@sgi.com>
Date: Fri, 15 Feb 2008 10:52:52 +1100
From: Timothy Shimmin <tes@sgi.com>
MIME-Version: 1.0
Subject: Re: [patch] Prevent AIL lock contention during transaction completion
References: <20080121052330.GG155259@sgi.com> <4796E8C8.3030702@sgi.com> <20080123073446.GU155259@sgi.com> <479986F5.7070800@sgi.com> <20080125074235.GI155407@sgi.com> <20080214234559.GO155259@sgi.com>
In-Reply-To: <20080214234559.GO155259@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

David Chinner wrote:
> On Fri, Jan 25, 2008 at 06:42:35PM +1100, David Chinner wrote:
>> On Fri, Jan 25, 2008 at 05:51:33PM +1100, Timothy Shimmin wrote:
>>> So do we really need to call xlog_assign_tail_lsn() then?
>>> Or are we just being conservative in case we missed something?
>> Conservative - the last thing I want is to introduce a subtle
>> difference to the tail lsn in the log record because we didn't
>> update it immediately before writing it to disk. I think we are
>> probably safe removing it, but lets leave that until we got some
>> wider test coverage on this change first....
> 
> Tim - did you finish the review of this? Testing on the 2048p
> machine appears to have been successful, so I'm just waiting
> on review ACKs now....
> 
> Cheers,
> 
> Dave.

Yep, that was an ACK.

--Tim
