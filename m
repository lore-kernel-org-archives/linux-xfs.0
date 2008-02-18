Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 18 Feb 2008 02:21:54 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m1IALmGX016298
	for <xfs@oss.sgi.com>; Mon, 18 Feb 2008 02:21:50 -0800
Date: Mon, 18 Feb 2008 21:21:50 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: xfsaild causing 30+ wakeups/s on an idle system since 2.6.25-rcX
Message-ID: <20080218102150.GL155407@sgi.com>
References: <47B863A9.5070206@gmail.com> <6101e8c40802170851w73db8130t9bcfdc5cf053f0dc@mail.gmail.com> <20080217224736.GX155407@sgi.com> <47B952D3.2030900@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <47B952D3.2030900@gmail.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: =?iso-8859-1?B?VPZy9ms=?= Edwin <edwintorok@gmail.com>
Cc: David Chinner <dgc@sgi.com>, Oliver Pinter <oliver.pntr@gmail.com>, xfs@oss.sgi.com, Linux Kernel <linux-kernel@vger.kernel.org>, Arjan van de Ven <arjan@linux.intel.com>, Christoph Lameter <clameter@sgi.com>, Christoph Hellwig <hch@infradead.org>

On Mon, Feb 18, 2008 at 11:41:39AM +0200, Török Edwin wrote:
> David Chinner wrote:
> > On Sun, Feb 17, 2008 at 05:51:08PM +0100, Oliver Pinter wrote:
> >   
> >> On 2/17/08, Török Edwin <edwintorok@gmail.com> wrote:
> >>     
> >>> Hi,
> >>>
> >>> xfsaild is causing many wakeups, a quick investigation shows
> >>> xfsaild_push is always
> >>> returning 30 msecs timeout value.
> >>>       
> >
> > That's a bug
> 
> Ok. Your patches fixes the 30+ wakeups :)

Good. I'll push it out for review then.

> > , and has nothing to do with power consumption. ;)
> >   
> 
> I suggest using a sysctl value (such as
> /proc/sys/vm/dirty_writeback_centisecs), instead of a hardcoded default
> 1000.

No, too magic. I dislike adding knobs to workaround issues that
really should be fixed by having sane default behaviour.  Further
down the track as we correct know issues with the AIL push code
we'll be able to increase this idle timeout or even make it purely
wakeup driven once we get back to an idle state. However, right now
it still needs that once a second wakeup to work around a nasty
corner case that can hang the filesystem....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
