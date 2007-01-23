Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 23 Jan 2007 02:57:30 -0800 (PST)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66] (may be forged))
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l0NAvNqw022005
	for <xfs@oss.sgi.com>; Tue, 23 Jan 2007 02:57:24 -0800
Date: Tue, 23 Jan 2007 05:56:28 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Kernel 2.6.19.2 New RAID 5 Bug (oops when writing Samba -> RAID5)
In-Reply-To: <17845.13256.284461.992275@notabene.brown>
Message-ID: <Pine.LNX.4.64.0701230556050.8978@p34.internal.lan>
References: <Pine.LNX.4.64.0701200718290.29223@p34.internal.lan>
 <45B5261B.1050104@redhat.com> <17845.13256.284461.992275@notabene.brown>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Neil Brown <neilb@suse.de>
Cc: Chuck Ebbert <cebbert@redhat.com>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, xfs@oss.sgi.com



On Tue, 23 Jan 2007, Neil Brown wrote:

> On Monday January 22, cebbert@redhat.com wrote:
> > Justin Piszcz wrote:
> > > My .config is attached, please let me know if any other information is 
> > > needed and please CC (lkml) as I am not on the list, thanks!
> > >
> > > Running Kernel 2.6.19.2 on a MD RAID5 volume.  Copying files over Samba to 
> > > the RAID5 running XFS.
> > >
> > > Any idea what happened here?
> ....
> > >   
> > Without digging too deeply, I'd say you've hit the same bug Sami Farin 
> > and others
> > have reported starting with 2.6.19: pages mapped with kmap_atomic() 
> > become unmapped
> > during memcpy() or similar operations.  Try disabling preempt -- that 
> > seems to be the
> > common factor.
> 
> That is exactly the conclusion I had just come to (a kmap_atomic page
> must be being unmapped during memcpy).  I wasn't aware that others had
> reported it - thanks for that.
> 
> Turning off CONFIG_PREEMPT certainly seems like a good idea.
> 
> NeilBrown
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

Is this a bug that can or will be fixed or should I disable pre-emption on 
critical and/or server machines?

Justin.
