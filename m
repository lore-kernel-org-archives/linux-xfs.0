Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A3A857F47
	for <xfs@oss.sgi.com>; Tue, 17 Mar 2015 13:22:01 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 3F4EBAC001
	for <xfs@oss.sgi.com>; Tue, 17 Mar 2015 11:21:58 -0700 (PDT)
Received: from ZenIV.linux.org.uk (zeniv.linux.org.uk [195.92.253.2]) by
	cuda.sgi.com with ESMTP id lmE0Fkv1nKI3rnQF (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 17 Mar 2015 11:21:56 -0700 (PDT)
Date: Tue, 17 Mar 2015 18:19:15 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [RFC PATCH 1/5] new helper: iov_iter_rw()
Message-ID: <20150317181910.GK29656@ZenIV.linux.org.uk>
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
To: dsterba@suse.cz, Omar Sandoval <osandov@osandov.com>, linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org, ceph-devel@vger.kernel.org, linux-cifs@vger.kernel.org, osd-dev@open-osd.org, linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, fuse-devel@lists.sourceforge.net, cluster-devel@redhat.com, jfs-discussion@lists.sourceforge.net, HPDD-discuss@ml01.01.org, linux-nfs@vger.kernel.org, linux-nilfs@vger.kernel.org, ocfs2-devel@oss.oracle.com, reiserfs-devel@vger.kernel.org, v9fs-developer@lists.sourceforge.net, xfs@oss.sgi.com, linux-kernel@vger.kernel.org, Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>, Yan Zheng <zyan@redhat.com>, Sage Weil <sage@redhat.com>, Steve French <sfrench@samba.org>, Boaz Harrosh <ooo@electrozaur.com>, Benny Halevy <bhalevy@primarydata.com>, Jan Kara <jack@suse.cz>, Theodore Ts'o <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>, Jaegeuk Kim <jaegeuk@kernel.org>, Changman Lee <cm224.lee@samsung.com>, Miklos Szeredi <miklos@szeredi.hu>, Steven Whitehouse <swhiteho@redhat.com>, Dave Kleikamp <shaggy@kernel.org>, Oleg Drokin <oleg.drokin@intel.com>, Trond Myklebust <trond.myklebust@primarydata.com>, Anna Schumaker <anna.schumaker@netapp.com>, Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>, Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>, Eric Van Hensbergen <ericvh@gmail.com>, Ron Minnich <rminnich@sandia.gov>, Latchesar Ionkov <lucho@ionkov.net>, Dave Chinner <david@fromorbit.com>

On Tue, Mar 17, 2015 at 10:31:51AM +0100, David Sterba wrote:

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

... and you are getting
	a) use of rather lousy gccism when plain C would do
	b) double evaluation since you've got it wrong (should've been
__iter.type & RW_MASK, if you do it that way).  As it is, if argument has
any side effects, your variant will trigger those twice - even if the
destination of the assignment is never used, the side effects remain.

I agree that it could use /* use ?: for typechecking */, but let's not go into
({...}) land unless we absolutely have to.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
