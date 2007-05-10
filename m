Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 10 May 2007 15:58:52 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l4AMwhfB019892
	for <xfs@oss.sgi.com>; Thu, 10 May 2007 15:58:45 -0700
Date: Fri, 11 May 2007 08:58:34 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: 2.6.21-git10/11: files getting truncated on xfs? or maybe an nlink problem?
Message-ID: <20070510225834.GF86004887@sgi.com>
References: <4642389E.4080804@goop.org> <20070509231643.GM85884050@sgi.com> <4642598E.3000607@goop.org> <20070510000119.GO85884050@sgi.com> <46426194.3040403@goop.org> <46439185.5060207@redhat.com> <464392B4.3070009@goop.org> <464393E1.3050705@redhat.com> <46439491.9010604@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46439491.9010604@goop.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Chuck Ebbert <cebbert@redhat.com>, David Chinner <dgc@sgi.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Matt Mackall <mpm@selenic.com>, xfs@oss.sgi.com

On Thu, May 10, 2007 at 02:54:25PM -0700, Jeremy Fitzhardinge wrote:
> Chuck Ebbert wrote:
> > Jeremy Fitzhardinge wrote:
> >   
> >> Chuck Ebbert wrote:
> >>     
> >>> What CPU architecture is this happening on? Not i686 with PAE by
> >>> any chance?
> >>>       
> >> Yes.  Why?
> >>     
> >
> > I have a bug report where NFS files are corrupted only with PAE clients.
> > Corruption is at the end of the (newly untarred) files. Doesn't happen
> > without PAE.
> >   
> 
> Hm, suggestive, but I'm not convinced.  Two differences to this situation:
> 
>    1. Immediately after the clone ("untar"), the contents are completely
>       OK; it's only after a umount/mount cycle to problems appear
>    2. There's no corruption as such; the files are just too short.  And
>       it seems they're at a previously OK length, not some random size.

Just to confirm this isn't a result of a recent change, can you reproduce
this on a 2.6.20 or 2.6.21 kernel? (sorry if you've already done this - I've juggling
some many things at once it's easy to forget little things).

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
