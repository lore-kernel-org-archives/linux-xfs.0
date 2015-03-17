Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 7116A7F56
	for <xfs@oss.sgi.com>; Tue, 17 Mar 2015 05:18:43 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 0B822AC003
	for <xfs@oss.sgi.com>; Tue, 17 Mar 2015 03:18:39 -0700 (PDT)
Received: from mail-pa0-f41.google.com (mail-pa0-f41.google.com
	[209.85.220.41]) by cuda.sgi.com with ESMTP id SaVDSu9LK7hRhZM4
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 17 Mar 2015 03:18:38 -0700 (PDT)
Received: by pacwe9 with SMTP id we9so5823354pac.1
	for <xfs@oss.sgi.com>; Tue, 17 Mar 2015 03:18:37 -0700 (PDT)
Date: Tue, 17 Mar 2015 03:18:35 -0700
From: Omar Sandoval <osandov@osandov.com>
Subject: Re: [RFC PATCH 1/5] new helper: iov_iter_rw()
Message-ID: <20150317101835.GA31649@mew>
References: <cover.1426502566.git.osandov@osandov.com>
	<34dc78b262546e9343e0ed872232a97f5eaa5f15.1426502566.git.osandov@osandov.com>
	<20150316173605.GX29656@ZenIV.linux.org.uk>
	<20150317093151.GS20767@twin.jikos.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150317093151.GS20767@twin.jikos.cz>
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
To: David Sterba <dsterba@suse.cz>
Cc: linux-cifs@vger.kernel.org, jfs-discussion@lists.sourceforge.net, linux-nilfs@vger.kernel.org, reiserfs-devel@vger.kernel.org, fuse-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, linux-nfs@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, cluster-devel@redhat.com, HPDD-discuss@ml01.01.org, ocfs2-devel@oss.oracle.com, Al Viro <viro@ZenIV.linux.org.uk>, linux-fsdevel@vger.kernel.org, v9fs-developer@lists.sourceforge.net, ceph-devel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org, osd-dev@open-osd.org

On Tue, Mar 17, 2015 at 10:31:51AM +0100, David Sterba wrote:
> On Mon, Mar 16, 2015 at 05:36:05PM +0000, Al Viro wrote:
> > On Mon, Mar 16, 2015 at 04:33:49AM -0700, Omar Sandoval wrote:
> > > Get either READ or WRITE out of iter->type.
> > 
> > Umm...  
> > 
> > > + * Get one of READ or WRITE out of iter->type without any other flags OR'd in
> > > + * with it.
> > > + */
> > > +static inline int iov_iter_rw(const struct iov_iter *i)
> > > +{
> > > +	return i->type & RW_MASK;
> > > +}
> > 
> > TBH, I would turn that into a macro.  Reason: indirect includes.
> 
> Agreed, but the proposed define is rather cryptic and I was not able to
> understand the meaning on the first glance.
> 
> > #define iov_iter_rw(i) ((0 ? (struct iov_iter *)0 : (i))->type & RW_MASK)
> 
> This worked for me, does not compile with anything else than
> 'struct iov_iter*' as i:
> 
> #define iov_iter_rw(i)	({			\
> 	struct iov_iter __iter = *(i);		\
> 	(i)->type & RW_MASK;			\
> 	})
> 
> The assignment is optimized out.

[-cc individual fs maintainers to avoid all of these email bounces,
should've looked a bit closer at that get_maintainer.pl output...]

I agree that this is a bit more readable, but it evaluates i twice.
That's an easy fix, just do __iter.type instead of (i)->type, but
there's still the possibility of someone passing in something called
__iter as i, and the fix for that tends to be "add more underscores". At
the very least, Al's macro could probably use a comment explaining
what's going on there, though.

-- 
Omar

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
