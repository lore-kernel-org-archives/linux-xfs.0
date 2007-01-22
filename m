Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 22 Jan 2007 14:16:17 -0800 (PST)
Received: from mx1.suse.de (ns.suse.de [195.135.220.2])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l0MMFwqw030509
	for <xfs@oss.sgi.com>; Mon, 22 Jan 2007 14:16:00 -0800
From: Neil Brown <neilb@suse.de>
Date: Tue, 23 Jan 2007 08:59:36 +1100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17845.13256.284461.992275@notabene.brown>
Subject: Re: Kernel 2.6.19.2 New RAID 5 Bug (oops when writing Samba -> RAID5)
In-Reply-To: message from Chuck Ebbert on Monday January 22
References: <Pine.LNX.4.64.0701200718290.29223@p34.internal.lan>
	<45B5261B.1050104@redhat.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Chuck Ebbert <cebbert@redhat.com>
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, xfs@oss.sgi.com

On Monday January 22, cebbert@redhat.com wrote:
> Justin Piszcz wrote:
> > My .config is attached, please let me know if any other information is 
> > needed and please CC (lkml) as I am not on the list, thanks!
> >
> > Running Kernel 2.6.19.2 on a MD RAID5 volume.  Copying files over Samba to 
> > the RAID5 running XFS.
> >
> > Any idea what happened here?
....
> >   
> Without digging too deeply, I'd say you've hit the same bug Sami Farin 
> and others
> have reported starting with 2.6.19: pages mapped with kmap_atomic() 
> become unmapped
> during memcpy() or similar operations.  Try disabling preempt -- that 
> seems to be the
> common factor.

That is exactly the conclusion I had just come to (a kmap_atomic page
must be being unmapped during memcpy).  I wasn't aware that others had
reported it - thanks for that.

Turning off CONFIG_PREEMPT certainly seems like a good idea.

NeilBrown
