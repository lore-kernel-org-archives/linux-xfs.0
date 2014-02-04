Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 92BEC7F51
	for <xfs@oss.sgi.com>; Tue,  4 Feb 2014 12:08:53 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 6B7878F8039
	for <xfs@oss.sgi.com>; Tue,  4 Feb 2014 10:08:50 -0800 (PST)
Received: from ZenIV.linux.org.uk (zeniv.linux.org.uk [195.92.253.2]) by
	cuda.sgi.com with ESMTP id lxgesUtO2YmVsbAd (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 04 Feb 2014 10:08:48 -0800 (PST)
Date: Tue, 4 Feb 2014 18:08:37 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [RFC] unifying write variants for filesystems
Message-ID: <20140204180837.GJ10323@ZenIV.linux.org.uk>
References: <20140119051335.GN10323@ZenIV.linux.org.uk>
	<20140120135514.GA21567@infradead.org>
	<CA+55aFzEA-eM9v2PvsWx4v4ANaKXuRGYyGCkegJg++rhtHvnig@mail.gmail.com>
	<20140201224301.GS10323@ZenIV.linux.org.uk>
	<52EFC271.3090205@oracle.com>
	<20140204124409.GG10323@ZenIV.linux.org.uk>
	<20140204125220.GB12440@kmo-pixel>
	<20140204151728.GH10323@ZenIV.linux.org.uk>
	<20140204172723.GA11325@lenny.home.zabbo.net>
	<CALJ65z=HhYnc1eD-Kpk0s=Eod6sHJq1jnJirUNc7-9s1rFV1HQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CALJ65z=HhYnc1eD-Kpk0s=Eod6sHJq1jnJirUNc7-9s1rFV1HQ@mail.gmail.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Kent Overstreet <kmo@daterainc.com>
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>, Sage Weil <sage@inktank.com>, Zach Brown <zab@redhat.com>, Mark Fasheh <mfasheh@suse.com>, xfs@oss.sgi.com, Steve French <sfrench@samba.org>, Dave Kleikamp <dave.kleikamp@oracle.com>, Joel Becker <jlbec@evilplan.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, Anton Altaparmakov <anton@tuxera.com>

On Tue, Feb 04, 2014 at 09:35:06AM -0800, Kent Overstreet wrote:
> > I think Kent is talking about what happens after the user addresses are
> > consumed.  Turning dio into more of a bio mapping and redirection engine
> > would use more of the bio machinery instead of the bits that dio has
> > implemented itself with state in struct dio that hangs off the bios.  I
> > imagine it'd still make sense to clean up the addresses/pages arguments
> > that feed that engine.  (And give another entry point that already has
> > bios for callers like loop, etc.)
> 
> Yeah, precisely. I think we can push the point at which pages are pinned at
> least a fair but higher than it is now, and if we can do that we definitely
> should be working with a generic "bag of pinned pages" struct - and much
> better to use struct bio than add another one. Bios may not be perfect but
> at least some of the block layer specific cruft can be gotten rid of (and
> is on my todo list)

How far up?  I've no problem with having that done in ->direct_IO()
(especially if it would take this mem_vec/mem_stream/whatever and
keep the code doing actual pinning and building an array of pages
outside of direct-io.c, allowing it to do different things for iovec-backed
and page-array-backed variants), but I really don't like the idea of
lifting that to callers of ->direct_IO(), let alone past them.

If nothing else, we do *not* want to pin the entire write request, so
lifting that to e.g. generic_file_aio_write() (or, worse, its callers)
wouldn't make sense.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
