Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 387117F5D
	for <xfs@oss.sgi.com>; Mon, 16 Mar 2015 13:15:54 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 18413304043
	for <xfs@oss.sgi.com>; Mon, 16 Mar 2015 11:15:50 -0700 (PDT)
Received: from ZenIV.linux.org.uk (zeniv.linux.org.uk [195.92.253.2]) by
	cuda.sgi.com with ESMTP id FVHW7rWHP5UPbMGA (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 16 Mar 2015 11:15:48 -0700 (PDT)
Date: Mon, 16 Mar 2015 18:15:21 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [RFC PATCH 0/5] Remove rw parameter from direct_IO()
Message-ID: <20150316181521.GY29656@ZenIV.linux.org.uk>
References: <cover.1426502566.git.osandov@osandov.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <cover.1426502566.git.osandov@osandov.com>
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
To: Omar Sandoval <osandov@osandov.com>
Cc: Latchesar Ionkov <lucho@ionkov.net>, Dave Kleikamp <shaggy@kernel.org>, jfs-discussion@lists.sourceforge.net, Jan Kara <jack@suse.cz>, Trond Myklebust <trond.myklebust@primarydata.com>, David Sterba <dsterba@suse.cz>, Chris Mason <clm@fb.com>, Andreas Dilger <adilger.kernel@dilger.ca>, Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>, linux-cifs@vger.kernel.org, linux-nilfs@vger.kernel.org, Sage Weil <sage@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>, cluster-devel@redhat.com, Steve French <sfrench@samba.org>, v9fs-developer@lists.sourceforge.net, linux-ext4@vger.kernel.org, Changman Lee <cm224.lee@samsung.com>, Boaz Harrosh <ooo@electrozaur.com>, fuse-devel@lists.sourceforge.net, Mark Fasheh <mfasheh@suse.com>, reiserfs-devel@vger.kernel.org, xfs@oss.sgi.com, Oleg Drokin <oleg.drokin@intel.com>, osd-dev@open-osd.org, HPDD-discuss@ml01.01.org, Jaegeuk Kim <jaegeuk@kernel.org>, ceph-devel@vger.kernel.org, Steven Whitehouse <swhiteho@redhat.com>, linux-nfs@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, Benny Halevy <bhalevy@primarydata.com>, Josef Bacik <jbacik@fb.com>, linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, Yan Zheng <zyan@redhat.com>, Eric Van Hensbergen <ericvh@gmail.com>, linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, Ron Minnich <rminnich@sandia.gov>, Anna Schumaker <anna.schumaker@netapp.com>, ocfs2-devel@oss.oracle.com, Joel Becker <jlbec@evilplan.org>

On Mon, Mar 16, 2015 at 04:33:48AM -0700, Omar Sandoval wrote:
> Hi,
> 
> Al, here's some cleanup that you mentioned back in December that I got
> around to (https://lkml.org/lkml/2014/12/15/28).
> 
> In summary, the rw parameter to a_ops->direct_IO() is redundant with
> .type in struct iov_iter. Additionally, rw is inconsistently checked for
> being a WRITE; some filesystems do rw == WRITE, others do rw & WRITE,
> and others do both within the same function :) The distinction is that
> swapout may OR in the ITER_BVEC flag in the rw passed to ->direct_IO(),
> so the two are not equivalent (although this really only happens for
> swap-over-NFS, but it's scary nonetheless). After looking through all of
> these, it definitely looks like every check means for ANY write, not
> just non-kernel writes.
> 
> So, the solution presented here is:
> 
> - Add a helper, iov_iter_rw(), which always returns either READ or
>   WRITE, no ITER_.* or REQ_.* nonsense mixed in. For consistency, the
>   return value is always checked for equality

TBH, I'm not sure I like such calling conventions, but I guess we can
live with that.

> I decided to squish all of the filesystems together in patch 4 to avoid
> inundating the mailing lists with 20+ mostly two-line patches, but I can
> split those out if that's any better. Additionally, patch 1 pulls fs.h
> into uio.h, which seems undesirable.

... and easily avoided if you use a macro instead of inline, without losing
type safety or getting double evaluation, etc.

Look: 0 ? (struct T *)0 : (x) always evaluates to x.  Now look at 6.5.15p3 in
C99: the second and the third arguments are both pointers, so we are left with
p3.4 (both arguments are pointers to qualified or unqualified versions of
compatible types), p3.5 (one operand is a pointer and another null pointer
constant) and p3.6 (one operand is a pointer to an object or incomplete type,
and the other is a pointer to qualified or unqualied version of void.

The first variant means that x is a pointer to qualified or unqualified
struct T; the type of result is, per 6.5.15p6, the same as that of x.

The second variant means that x is a null pointer constant ((struct T *)0 isn't
one) and result is a null pointer to T.

The third one means that x is a pointer to qualified or unqualified void.
The type of result is the same as that of x.

Now note that your variant is no better wrt type safety; worse, actually, since
it does accept any pointer to void.  (0 ? (struct iov_iter *)0 : (x))->type
will reject those.  And we obviously don't have double evaluation here either.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
