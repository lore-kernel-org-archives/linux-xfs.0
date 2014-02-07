Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id A89EC29DF8
	for <xfs@oss.sgi.com>; Fri,  7 Feb 2014 11:10:44 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 8D25A30408C
	for <xfs@oss.sgi.com>; Fri,  7 Feb 2014 09:10:41 -0800 (PST)
Received: from ZenIV.linux.org.uk (zeniv.linux.org.uk [195.92.253.2]) by
	cuda.sgi.com with ESMTP id LeeIIYH19bw878EM (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 07 Feb 2014 09:10:39 -0800 (PST)
Date: Fri, 7 Feb 2014 17:10:23 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH 0/5] splice: locking changes and code refactoring
Message-ID: <20140207171023.GU10323@ZenIV.linux.org.uk>
References: <CA+55aFw4LgyYEkygxHUnpKZg3jMACGzsyENc9a9rWFmLcaRefQ@mail.gmail.com>
	<20140118074649.GF10323@ZenIV.linux.org.uk>
	<20140118082730.GH10323@ZenIV.linux.org.uk>
	<20140118.004453.1800341321580114709.davem@davemloft.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140118.004453.1800341321580114709.davem@davemloft.net>
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
To: David Miller <davem@davemloft.net>
Cc: axboe@kernel.dk, sfrench@samba.org, sage@inktank.com, mfasheh@suse.com, xfs@oss.sgi.com, hch@infradead.org, jlbec@evilplan.org, linux-fsdevel@vger.kernel.org, torvalds@linux-foundation.org

On Sat, Jan 18, 2014 at 12:44:53AM -0800, David Miller wrote:
> From: Al Viro <viro@ZenIV.linux.org.uk>
> Date: Sat, 18 Jan 2014 08:27:30 +0000
> 
> > BTW, would sockets benefit from having ->sendpages() that would take an
> > array of (page, offset, len) triples?  It would be trivial to do and
> > some of the helpers that are falling out of writing that writev-based
> > default_file_splice_write() look like they could be reused for
> > calling that one...  Dave?
> 
> That's originally how the sendpage method was implemented, but back then
> Linus asked us to only pass one page at a time.
> 
> I don't remember the details beyond that.

FWIW, I wonder if what we are doing with ->msg_iov is the right thing.
We modify the iovecs in array as we drain it.  And that's inconvenient
for at least some callers (see e.g. complaints in fs/ncpfs about the
need to copy the array, etc.).

What if we embed iov_iter into the sucker and replace memcpy_{to,from}iovec*
with variants taking iov_iter *?  If nothing else, it'll be marginally more
efficient (no more skipping the already-emptied iovecs) and it seems to be
more convenient for callers.  If we are lucky, that might even eliminate
the need of ->sendpage() - just set the iov_iter over <page,offset,size>
array instead of iovec one and let ->sendmsg() do the smart thing if it
knows how.  I hadn't done comparison of {tcp,udp}_send{page,msg}, though -
there might be dragons...  Even if that will turn out to be infeasible,
it will at least drive the kmap/kunmap done by sock_no_sendpage() down
into memcpy_from_iter(), turning them into kmap_atomic/kunmap_atomic.

The obvious price is that kernel-side msghdr diverges from the userland
one, so copy_msghdr_from_user() needs to deal with that, but I really
doubt that you'll find a load where the price of copying it in two
chunks instead of one would be measurable.  

What else am I missing?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
