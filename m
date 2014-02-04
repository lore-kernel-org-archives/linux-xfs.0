Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 757137F52
	for <xfs@oss.sgi.com>; Tue,  4 Feb 2014 12:36:25 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 6363A30408F
	for <xfs@oss.sgi.com>; Tue,  4 Feb 2014 10:36:25 -0800 (PST)
Received: from ZenIV.linux.org.uk (zeniv.linux.org.uk [195.92.253.2]) by
	cuda.sgi.com with ESMTP id AYAizahoJakCghoW (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 04 Feb 2014 10:36:24 -0800 (PST)
Date: Tue, 4 Feb 2014 18:36:09 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [RFC] unifying write variants for filesystems
Message-ID: <20140204183609.GK10323@ZenIV.linux.org.uk>
References: <20140120135514.GA21567@infradead.org>
	<CA+55aFzEA-eM9v2PvsWx4v4ANaKXuRGYyGCkegJg++rhtHvnig@mail.gmail.com>
	<20140201224301.GS10323@ZenIV.linux.org.uk>
	<52EFC271.3090205@oracle.com>
	<20140204124409.GG10323@ZenIV.linux.org.uk>
	<20140204125220.GB12440@kmo-pixel>
	<20140204151728.GH10323@ZenIV.linux.org.uk>
	<20140204172723.GA11325@lenny.home.zabbo.net>
	<20140204180040.GI10323@ZenIV.linux.org.uk>
	<20140204183356.GB11325@lenny.home.zabbo.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140204183356.GB11325@lenny.home.zabbo.net>
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
To: Zach Brown <zab@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, Steve French <sfrench@samba.org>, Sage Weil <sage@inktank.com>, Mark Fasheh <mfasheh@suse.com>, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, Kent Overstreet <kmo@daterainc.com>, Dave Kleikamp <dave.kleikamp@oracle.com>, Joel Becker <jlbec@evilplan.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, Anton Altaparmakov <anton@tuxera.com>

On Tue, Feb 04, 2014 at 10:33:56AM -0800, Zach Brown wrote:
> > > > BTW, folks, any suggestions about the name of that "memory stream" thing?
> > > > struct iov_iter really implies iterator for iovec and more generic name
> > > > would probably be better...  struct mem_stream would probably do if nobody
> > > > comes up with better variant, but it's long and somewhat clumsy...
> > > 
> > > I don't like 'stream'.  To me that sounds more strictly advancing than I
> > > think this'd be capable of.  Maybe something dirt simple like 'mem_vec'?
> > > With 'mvec_' call prefixes?
> > 
> > Umm...  Frankly, I would rather discourage attempts to read the same data
> > twice, if only on the naming level...
> 
> Ahh, OK, sure.  mem_iter?

Works for me...  Any other suggestions/objections/etc.?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
