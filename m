Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C3B207CA3
	for <xfs@oss.sgi.com>; Thu,  2 Jun 2016 18:08:30 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 84279304032
	for <xfs@oss.sgi.com>; Thu,  2 Jun 2016 16:08:27 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	uzex0dmIMRie33UA for <xfs@oss.sgi.com>;
	Thu, 02 Jun 2016 16:08:25 -0700 (PDT)
Date: Fri, 3 Jun 2016 09:08:13 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: shrink_active_list/try_to_release_page bug? (was Re: xfs trace
	in 4.4.2 / also in 4.3.3 WARNING fs/xfs/xfs_aops.c:1232
	xfs_vm_releasepage)
Message-ID: <20160602230813.GQ12670@dastard>
References: <574BEA84.3010206@profihost.ag> <20160530223657.GP26977@dastard>
	<20160531010724.GA9616@bbox> <20160531025509.GA12670@dastard>
	<20160531035904.GA17371@bbox> <20160531060712.GC12670@dastard>
	<574D2B1E.2040002@profihost.ag> <20160531073119.GD12670@dastard>
	<575022D2.7030502@profihost.ag>
	<57502A2E.60702@applied-asynchrony.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <57502A2E.60702@applied-asynchrony.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Holger =?iso-8859-1?Q?Hoffst=E4tte?= <holger@applied-asynchrony.com>
Cc: Minchan Kim <minchan@kernel.org>, Brian Foster <bfoster@redhat.com>, Stefan Priebe - Profihost AG <s.priebe@profihost.ag>, linux-kernel@vger.kernel.org, "xfs@oss.sgi.com" <xfs@oss.sgi.com>, linux-mm@kvack.org

On Thu, Jun 02, 2016 at 02:44:30PM +0200, Holger Hoffst=E4tte wrote:
> On 06/02/16 14:13, Stefan Priebe - Profihost AG wrote:
> > =

> > Am 31.05.2016 um 09:31 schrieb Dave Chinner:
> >> On Tue, May 31, 2016 at 08:11:42AM +0200, Stefan Priebe - Profihost AG=
 wrote:
> >>>> I'm half tempted at this point to mostly ignore this mm/ behavour
> >>>> because we are moving down the path of removing buffer heads from
> >>>> XFS. That will require us to do different things in ->releasepage
> >>>> and so just skipping dirty pages in the XFS code is the best thing
> >>>> to do....
> >>>
> >>> does this change anything i should test? Or is 4.6 still the way to g=
o?
> >>
> >> Doesn't matter now - the warning will still be there on 4.6. I think
> >> you can simply ignore it as the XFS code appears to be handling the
> >> dirty page that is being passed to it correctly. We'll work out what
> >> needs to be done to get rid of the warning for this case, wether it
> >> be a mm/ change or an XFS change.
> > =

> > Any idea what i could do with 4.4.X? Can i safely remove the WARN_ONCE
> > statement?
> =

> By definition it won't break anything since it's just a heads-up message,
> so yes, it should be "safe". However if my understanding of the situation
> is correct, mainline commit f0281a00fe "mm: workingset: only do workingset
> activations on reads" (+ friends) in 4.7 should effectively prevent this
> from happenning. Can someone confirm or deny this?

I don't think it will.  The above commits will avoid putting
/write-only/ dirty pages on the active list from the write() syscall
vector, but it won't prevent pages that are read first then dirtied
from ending up on the active list. e.g. a mmap write will first read
the page from disk to populate the page (hence it ends up on the
active list), then the page gets dirtied and ->page_mkwrite is
called to tell the filesystem....

Cheers,

Dave.
-- =

Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
