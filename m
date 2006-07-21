Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 21 Jul 2006 09:08:03 -0700 (PDT)
Received: from smtp111.sbc.mail.mud.yahoo.com (smtp111.sbc.mail.mud.yahoo.com [68.142.198.210])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k6LG7ZDW027050
	for <linux-xfs@oss.sgi.com>; Fri, 21 Jul 2006 09:07:39 -0700
Date: Fri, 21 Jul 2006 09:07:09 -0700
From: Chris Wedgwood <cw@f00f.org>
Subject: Re: stable xfs
Message-ID: <20060721160709.GB12347@tuatara.stupidest.org>
References: <17598.2129.999932.67127@base.ty.sabi.co.UK> <1153314670.2691.14.camel@localhost.localdomain> <20060720061527.GB18135@tuatara.stupidest.org> <1153404502.2768.50.camel@localhost.localdomain> <20060720161707.GB26748@tuatara.stupidest.org> <1153413481.2768.65.camel@localhost.localdomain> <20060720190401.GA28836@tuatara.stupidest.org> <1153441178.2768.158.camel@localhost.localdomain> <20060721032632.GA4138@tuatara.stupidest.org> <1153487431.2841.8.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1153487431.2841.8.camel@localhost.localdomain>
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Ming Zhang <mingz@ele.uri.edu>
Cc: Peter Grandi <pg_xfs@xfs.for.sabi.co.UK>, Linux XFS <linux-xfs@oss.sgi.com>

On Fri, Jul 21, 2006 at 09:10:31AM -0400, Ming Zhang wrote:

> then what is the benefit? because files under same dir can be accessed
> with locality so put close will reduce disk head seek?

yes

> other than this, what else benefit?

that alone has a measurable benefit to me (i have an overlay
filesystem over many smaller 400 to 500GB filesystems so i don't get
the benefit of many spindles to reduce average seek times)

> so if i have 500GB file, will it be copied to another 500GB temp
> file?

yes, which in many cases isn't always derisable because:

  * if the file had a small number of extents in the first place,
    reducing them slightly more isn't much of a gain (ie. going from
    say 11 to 10 is argubly pointless) (i have a patch to specifiy
    the miniumum gains before doing the copy somewhere)

  * if the file changes during the copy, then it will be skipped until
    next time, for larger files this is problematic,  you could
    argue attemtping to fsr a file that is less than <n> seconds old
    is pointless as it has a high chance of being active (i have a
    patch for that too))

  * fsr has no global overview of what it's doing, so it never does
    things like 'move this file out of the way to make room for this
    one' (it can't do this w/o assistance right now), and of course it
    can't move inodes w/o changing them so there are limits to what
    can be done anyhow
