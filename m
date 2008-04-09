Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 08 Apr 2008 21:37:44 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m394bX9o015812
	for <xfs@oss.sgi.com>; Tue, 8 Apr 2008 21:37:36 -0700
Message-ID: <47FC482F.7090408@sgi.com>
Date: Wed, 09 Apr 2008 14:38:07 +1000
From: Timothy Shimmin <tes@sgi.com>
MIME-Version: 1.0
Subject: Re: inconsistent xfs log record
References: <47FAD04D.5080308@agami.com>
In-Reply-To: <47FAD04D.5080308@agami.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Michael Nishimoto <miken@agami.com>
Cc: XFS Mailing List <xfs@oss.sgi.com>

Michael Nishimoto wrote:
> I've just finished analyzing an xfs filesystem which won't recover.
> An inconsistent log record has 332 log operations but the num_logop field
> in the record header says 333 log operations.  The result is that xfs 
> recovery
> complains with "bad clientid" because recovery eventually attempts to 
> decode
> garbage.
> 
> The log record really has 332 log ops (I counted!).
> 
> Looking through xlog_write(), I don't see any way that record_cnt can be 
> bumped
> without also writing out a log operation.
> 
> Does this issue ring a bell with anyone?
> 
>    Michael
> 

Having a bit of a look at other bugs than the snapshot one...
nothing really helpful.

I've seen a few "bad clientid" but that, as you say, just reflects that
at some point we have crap in the log op header which we
notice when doing recovery.
I had one (pv#945899) where it seemed to have got the head of the log wrong -
you could see using "xfs_logprint -d" at the change of cycle#s - it didn't
match.
Yours appears different.
I also had another one (pv#971596) but I didn't narrow it down to the
wrong# of log ops but maybe I wasn't looking carefully enough at the time.
Okay, for that one there were 2 bugs in one, one for bad clientid and
one for bad transaction - for the bad transaction,
there was something like a 2nd startop without an intervening commit op
for the tid - I moved onto something else before getting anywhere further.


--Tim
