Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p4CA27Io169290 for <xfs@oss.sgi.com>; Thu, 12 May 2011 05:02:08 -0500
Received: from enyo.dsw2k3.info (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 790AD44ACB2
	for <xfs@oss.sgi.com>; Thu, 12 May 2011 03:02:06 -0700 (PDT)
Received: from enyo.dsw2k3.info (enyo.dsw2k3.info [195.71.86.239]) by
	cuda.sgi.com with ESMTP id jZdWAnMgDaKxSz85 for
	<xfs@oss.sgi.com>; Thu, 12 May 2011 03:02:06 -0700 (PDT)
Date: Thu, 12 May 2011 12:01:53 +0200
From: Matthias Schniedermeyer <ms@citd.de>
Subject: Re: Files appear too big in `du`
Message-ID: <20110512100153.GA19381@citd.de>
References: <20110510105700.GA20307@citd.de> <20110510131705.GE19446@dastard>
	<20110510153300.GA5764@citd.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110510153300.GA5764@citd.de>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 10.05.2011 17:33, Matthias Schniedermeyer wrote:
> 
> > > Any idea how to debug this, or is this a known bug and waiting a few 
> > > days for 2.6.39 should fix this?
> > 
> > It doesn't appear to be doing anything wrong from your description.
> > Remember that XFS is optimised for high end storage and server
> > configurations and workloads, not typical desktop usage...
> 
> I would call it a regression.
> I reguarly follow copying/downloading with `du`, the speculative
> preallocation makes that more or less useless. Especially downloading 
> someting big from the internet which @ 231kb/s isn't exactly fast and 
> shows identical `du`s for increasingly longer periods of time.
> (Or "--apparent-size" should be made default, but that falls short with 
> sparse-files)
> 
> IMHO `du`/`ls -l` should not be able to 'see' the speculative 
> preallocation.


After digging into the log of v2.6.37..v2.6.38 i stumbled upon:

- snip -
    The allocsize mount option turns off the dynamic behaviour and fixes
    the prealloc size to whatever the mount option specifies. i.e. the
    behaviour is unchanged.
- snip -

I think Documentation/filesystems/xfs.txt is in need of an update. All 
that information in the commit-log is a little "out-of-reach" for most 
people.






Bis denn

-- 
Real Programmers consider "what you see is what you get" to be just as 
bad a concept in Text Editors as it is in women. No, the Real Programmer
wants a "you asked for it, you got it" text editor -- complicated, 
cryptic, powerful, unforgiving, dangerous.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
