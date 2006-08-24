Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 23 Aug 2006 22:47:42 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k7O5lEDW025875
	for <xfs@oss.sgi.com>; Wed, 23 Aug 2006 22:47:25 -0700
Date: Thu, 24 Aug 2006 15:46:18 +1000
From: Nathan Scott <nathans@sgi.com>
Subject: Re: [PATCH 1/2] Add new spin_lock for i_flags of xfs_inode [try #2]
Message-ID: <20060824154618.E3001216@wobbly.melbourne.sgi.com>
References: <20060823201251m-saito@mail.aom.tnes.nec.co.jp> <20060823213817.16cdfe8a.akpm@osdl.org> <20060824154245.D3001216@wobbly.melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20060824154245.D3001216@wobbly.melbourne.sgi.com>; from nathans@sgi.com on Thu, Aug 24, 2006 at 03:42:45PM +1000
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Masayuki Saito <m-saito@tnes.nec.co.jp>, Andrew Morton <akpm@osdl.org>
Cc: David Chinner <dgc@sgi.com>, xfs@oss.sgi.com, linux-kernel@vger.kernel.org

On Thu, Aug 24, 2006 at 03:42:45PM +1000, Nathan Scott wrote:
> On Wed, Aug 23, 2006 at 09:38:17PM -0700, Andrew Morton wrote:
> > On Wed, 23 Aug 2006 20:12:51 +0900
> > Masayuki Saito <m-saito@tnes.nec.co.jp> wrote:
> > 
> > > It is the problem that i_flags of xfs_inode has no consistent
> > > locking protection.
> > > 
> > > For the reason, I define a new spin_lock(i_flags_lock) for i_flags
> > > of xfs_inode.  And I add this spin_lock for appropriate places.
> > 
> > You could simply use inode.i_lock for this.  i_lock is a general-purpose
> > per-inode lock.  Its mandate is "use it for whatever you like, but it must
> > always be `innermost'"
> 
> Sounds spot on for our needs here, and has the added benefit of
> not increasing the size of the inode (as well as not adding to
> our locking complexity).  Thanks!

Oh, except that the generic inode has a different lifecycle to the
xfs_inode_t, which is going to prevent using this.  Doh.  I had also
looked at the other xfs_inode locks before, but not seen an easy way
to piggyback on those... perhaps a way could be found though.

cheers.

-- 
Nathan
