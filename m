Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 08 Apr 2008 14:36:03 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m38LZsBn014378
	for <xfs@oss.sgi.com>; Tue, 8 Apr 2008 14:35:56 -0700
Received: from ext.agami.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0FC4F10790D1
	for <xfs@oss.sgi.com>; Tue,  8 Apr 2008 14:36:31 -0700 (PDT)
Received: from ext.agami.com (64.221.212.177.ptr.us.xo.net [64.221.212.177]) by cuda.sgi.com with ESMTP id AH6PC1sWAOHqaOV0 for <xfs@oss.sgi.com>; Tue, 08 Apr 2008 14:36:31 -0700 (PDT)
Received: from agami.com (mail [192.168.168.5])
	by ext.agami.com (8.12.5/8.12.5) with ESMTP id m38La79d020176
	for <xfs@oss.sgi.com>; Tue, 8 Apr 2008 14:36:08 -0700
Received: from mx1.agami.com (mx1.agami.com [10.123.10.30])
	by agami.com (8.12.11/8.12.11) with ESMTP id m38La1jn029545
	for <xfs@oss.sgi.com>; Tue, 8 Apr 2008 14:36:03 -0700
Message-ID: <47FBE558.1020106@agami.com>
Date: Tue, 08 Apr 2008 14:36:24 -0700
From: Michael Nishimoto <miken@agami.com>
MIME-Version: 1.0
Subject: Re: inconsistent xfs log record
References: <47FAD04D.5080308@agami.com> <20080408155043.GZ108924158@sgi.com>
In-Reply-To: <20080408155043.GZ108924158@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: XFS Mailing List <xfs@oss.sgi.com>


David Chinner wrote:
> On Mon, Apr 07, 2008 at 06:54:21PM -0700, Michael Nishimoto wrote:
>  > I've just finished analyzing an xfs filesystem which won't recover.
>  > An inconsistent log record has 332 log operations but the num_logop field
>  > in the record header says 333 log operations.  The result is that xfs
>  > recovery
>  > complains with "bad clientid" because recovery eventually attempts to 
> decode
>  > garbage.
>  >
>  > The log record really has 332 log ops (I counted!).
>  >
>  > Looking through xlog_write(), I don't see any way that record_cnt can be
>  > bumped
>  > without also writing out a log operation.
> 
> Yeah, i remember going through this a while back tracking done the same
> error on snapshot images (was a freeze problem) and I couldn't see how
> it would happen, either.
> 
> Still, it's a single bit error so that's always suspicious - can you
> reproduce this error reliably?
> 
>  > Does this issue ring a bell with anyone?
> 
> FWIW, I have had 2-3 failures with a "bad clientid" on a 64k page size ia64
> box since I switched from 16k page size about a month ago. I haven't 
> seen any
> consistent pattern to the failure yet, nor had a chance to perform any
> sort of triage on the problem so I can't say whether I'm seeing the same
> issue...
> 
> Cheers,
> 
> Dave.
> --
> Dave Chinner
> Principal Engineer
> SGI Australian Software Group

When you saw the problem, did you also have an off-by-one or one-bit difference
between num_logops and the real count?

     Michael
