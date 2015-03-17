Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id DB09E7F56
	for <xfs@oss.sgi.com>; Tue, 17 Mar 2015 04:32:03 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C9D72304032
	for <xfs@oss.sgi.com>; Tue, 17 Mar 2015 02:32:00 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id YAcXkV5AYNxC9Kxo (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 17 Mar 2015 02:31:59 -0700 (PDT)
Date: Tue, 17 Mar 2015 10:31:51 +0100
From: David Sterba <dsterba@suse.cz>
Subject: Re: [RFC PATCH 1/5] new helper: iov_iter_rw()
Message-ID: <20150317093151.GS20767@twin.jikos.cz>
References: <cover.1426502566.git.osandov@osandov.com>
	<34dc78b262546e9343e0ed872232a97f5eaa5f15.1426502566.git.osandov@osandov.com>
	<20150316173605.GX29656@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150316173605.GX29656@ZenIV.linux.org.uk>
Reply-To: dsterba@suse.cz
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
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Latchesar Ionkov <lucho@ionkov.net>, Dave Kleikamp <shaggy@kernel.org>, jfs-discussion@lists.sourceforge.net, Jan Kara <jack@suse.cz>, Trond Myklebust <trond.myklebust@primarydata.com>, David Sterba <dsterba@suse.cz>, Chris Mason <clm@fb.com>, Andreas Dilger <adilger.kernel@dilger.ca>, Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>, linux-cifs@vger.kernel.org, linux-nilfs@vger.kernel.org, Sage Weil <sage@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>, cluster-devel@redhat.com, Steve French <sfrench@samba.org>, v9fs-developer@lists.sourceforge.net, linux-ext4@vger.kernel.org, Changman Lee <cm224.lee@samsung.com>, Boaz Harrosh <ooo@electrozaur.com>, fuse-devel@lists.sourceforge.net, Mark Fasheh <mfasheh@suse.com>, reiserfs-devel@vger.kernel.org, xfs@oss.sgi.com, Oleg Drokin <oleg.drokin@intel.com>, osd-dev@open-osd.org, HPDD-discuss@ml01.01.org, Jaegeuk Kim <jaegeuk@kernel.org>, ceph-devel@vger.kernel.org, Steven Whitehouse <swhiteho@redhat.com>, linux-nfs@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, Benny Halevy <bhalevy@primarydata.com>, Josef Bacik <jbacik@fb.com>, linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, Yan Zheng <zyan@redhat.com>, Eric Van Hensbergen <ericvh@gmail.com>, linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, Ron Minnich <rminnich@sandia.gov>, Omar Sandoval <osandov@osandov.com>, Anna Schumaker <anna.schumaker@netapp.com>, ocfs2-devel@oss.oracle.com, Joel Becker <jlbec@evilplan.org>

On Mon, Mar 16, 2015 at 05:36:05PM +0000, Al Viro wrote:
> On Mon, Mar 16, 2015 at 04:33:49AM -0700, Omar Sandoval wrote:
> > Get either READ or WRITE out of iter->type.
> 
> Umm...  
> 
> > + * Get one of READ or WRITE out of iter->type without any other flags OR'd in
> > + * with it.
> > + */
> > +static inline int iov_iter_rw(const struct iov_iter *i)
> > +{
> > +	return i->type & RW_MASK;
> > +}
> 
> TBH, I would turn that into a macro.  Reason: indirect includes.

Agreed, but the proposed define is rather cryptic and I was not able to
understand the meaning on the first glance.

> #define iov_iter_rw(i) ((0 ? (struct iov_iter *)0 : (i))->type & RW_MASK)

This worked for me, does not compile with anything else than
'struct iov_iter*' as i:

#define iov_iter_rw(i)	({			\
	struct iov_iter __iter = *(i);		\
	(i)->type & RW_MASK;			\
	})

The assignment is optimized out.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
