Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 8D6C07F37
	for <xfs@oss.sgi.com>; Sun,  5 Apr 2015 11:29:21 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 690DE8F8033
	for <xfs@oss.sgi.com>; Sun,  5 Apr 2015 09:29:18 -0700 (PDT)
Received: from ZenIV.linux.org.uk (zeniv.linux.org.uk [195.92.253.2]) by
	cuda.sgi.com with ESMTP id 8U9hiykHvxPpYRS0 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 05 Apr 2015 09:29:15 -0700 (PDT)
Date: Sun, 5 Apr 2015 17:27:59 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [RFC PATCH 0/5] Remove rw parameter from direct_IO()
Message-ID: <20150405162758.GI889@ZenIV.linux.org.uk>
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

Applied.  See #for-next

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
