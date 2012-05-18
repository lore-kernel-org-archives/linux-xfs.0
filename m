Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q4IDXCx7174329 for <xfs@oss.sgi.com>; Fri, 18 May 2012 08:33:12 -0500
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id 7RteIcyLacyKAM2s (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 18 May 2012 06:33:11 -0700 (PDT)
Date: Fri, 18 May 2012 15:32:50 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: Hole punching and mmap races
Message-ID: <20120518133250.GC5589@quack.suse.cz>
References: <20120515224805.GA25577@quack.suse.cz>
	<20120516021423.GO25351@dastard>
	<20120516130445.GA27661@quack.suse.cz>
	<20120517074308.GQ25351@dastard>
	<20120517232829.GA31028@quack.suse.cz>
	<20120518101210.GX25351@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120518101210.GX25351@dastard>
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
Cc: Jan Kara <jack@suse.cz>, Hugh Dickins <hughd@google.com>, xfs@oss.sgi.com, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org

On Fri 18-05-12 20:12:10, Dave Chinner wrote:
> On Fri, May 18, 2012 at 01:28:29AM +0200, Jan Kara wrote:
> > On Thu 17-05-12 17:43:08, Dave Chinner wrote:
> > > On Wed, May 16, 2012 at 03:04:45PM +0200, Jan Kara wrote:
> > > > On Wed 16-05-12 12:14:23, Dave Chinner wrote:
> > > IIRC, it's a rare case (that I consider insane, BTW):  read from a
> > > file with into a buffer that is a mmap()d region of the same file
> > > that has not been faulted in yet.....
> >   With punch hole, the race is less insane - just punching hole in the area
> > which is accessed via mmap could race in a bad way AFAICS.
> 
> Seems the simple answer to me is to prevent page faults while hole
> punching, then....
  Yes, that's what I was suggesting in the beginning :) And I was asking
whether people are OK with another lock in the page fault path (in
particular in ->page_mkwrite) or whether someone has a better idea (e.g.
taking mmap_sem in the hole punching path seems possible but I'm not sure
whether that would be considered acceptable abuse).

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
