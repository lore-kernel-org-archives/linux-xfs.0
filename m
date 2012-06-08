Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q58LiLu1003526 for <xfs@oss.sgi.com>; Fri, 8 Jun 2012 16:44:21 -0500
Received: from mail-wi0-f179.google.com (mail-wi0-f179.google.com
	[209.85.212.179]) by cuda.sgi.com with ESMTP id
	MWFS3mtdKm6pMk9N (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Fri, 08 Jun 2012 14:44:19 -0700 (PDT)
Received: by wibhr14 with SMTP id hr14so881581wib.14
	for <xfs@oss.sgi.com>; Fri, 08 Jun 2012 14:44:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1339190930-17233-1-git-send-email-kirill.shutemov@linux.intel.com>
References: <1339190930-17233-1-git-send-email-kirill.shutemov@linux.intel.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 8 Jun 2012 14:43:58 -0700
Message-ID: <CA+55aFz_RpR+T3Yx-hMf3veW55xAu3GgtmefKs1ZUydp4hRu8w@mail.gmail.com>
Subject: Re: [RFC, PATCH] fs: push rcu_barrier() from deactivate_locked_super()
	to filesystems
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
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Pekka Enberg <penberg@kernel.org>
Cc: Latchesar Ionkov <lucho@ionkov.net>, Dave Kleikamp <shaggy@kernel.org>, jfs-discussion@lists.sourceforge.net, Phillip Lougher <phillip@squashfs.org.uk>, Jan Kara <jack@suse.cz>, Kai Bankett <chaosman@ontika.net>, logfs@logfs.org, Frederic Weisbecker <fweisbec@gmail.com>, Anders Larsen <al@alarsen.net>, Trond Myklebust <Trond.Myklebust@netapp.com>, William Irwin <wli@holomorphy.com>, "Dmitry V. Levin" <ldv@altlinux.org>, David Howells <dhowells@redhat.com>, Dustin Kirkland <dustin.kirkland@gazzang.com>, Andreas Dilger <adilger.kernel@dilger.ca>, Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>, KONISHI Ryusuke <konishi.ryusuke@lab.ntt.co.jp>, Petr Vandrovec <petr@vandrovec.name>, linux-afs@lists.infradead.org, Alexey Khoroshilov <khoroshilov@ispras.ru>, linux-cifs@vger.kernel.org, Namjae Jeon <linkinjeon@gmail.com>, linux-nilfs@vger.kernel.org, fuse-devel@lists.sourceforge.net, Miklos Szeredi <miklos@szeredi.hu>, linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, coda@cs.cmu.edu, Chris Mason <chris.mason@oracle.com>, Boaz Harrosh <bharrosh@panasas.com>, linux-mtd@lists.infradead.org, v9fs-developer@lists.sourceforge.net, linux-ext4@vger.kernel.org, Prasad Joshi <prasadjoshi.linux@gmail.com>, osd-dev@open-osd.org, Evgeniy Dushistov <dushistov@mail.ru>, Nick Piggin <npiggin@kernel.dk>, Eric Van Hensbergen <ericvh@gmail.com>, Tao Ma <boyu.mt@taobao.com>, Joern Engel <joern@logfs.org>, ecryptfs@vger.kernel.org, reiserfs-devel@vger.kernel.org, xfs@oss.sgi.com, Seth Forshee <seth.forshee@canonical.com>, Ben Myers <bpm@sgi.com>, Josh Boyer <jwboyer@redhat.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Timo Warns <warns@pre-sense.de>, Ron Minnich <rminnich@sandia.gov>, ceph-devel@vger.kernel.org, Anton Altaparmakov <anton@tuxera.com>, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, codalist@TELEMANN.coda.cs.cmu.edu, Jan Harkes <jaharkes@cs.cmu.edu>, linux-nfs@vger.kernel.org, Alex Elder <elder@kernel.org>, Theodore Ts'o <tytso@mit.edu>, Artem Bityutskiy <dedekind1@gmail.com>, linux-ntfs-dev@lists.sourceforge.net, Mark Fasheh <mfasheh@suse.com>, "Tigran A. Aivazian" <tigran@aivazian.fsnet.co.uk>, samba-technical@lists.samba.org, Adrian Hunter <adrian.hunter@intel.com>, Tyler Hicks <tyhicks@canonical.com>, Steve French <sfrench@samba.org>, Benny Halevy <bhalevy@tonian.com>, ocfs2-devel@oss.oracle.com, linux-fsdevel@vger.kernel.org, Sage Weil <sage@newdream.net>, Andrew Morton <akpm@linux-foundation.org>, Fengguang Wu <fengguang.wu@intel.com>, David Woodhouse <dwmw2@infradead.org>, linux-btrfs@vger.kernel.org, Joel Becker <jlbec@evilplan.org>

On Fri, Jun 8, 2012 at 2:28 PM, Kirill A. Shutemov
<kirill.shutemov@linux.intel.com> wrote:
> From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
>
> There's no reason to call rcu_barrier() on every deactivate_locked_super().
> We only need to make sure that all delayed rcu free inodes are flushed
> before we destroy related cache.
>
> Removing rcu_barrier() from deactivate_locked_super() affects some
> fas paths. E.g. on my machine exit_group() of a last process in IPC
> namespace takes 0.07538s. rcu_barrier() takes 0.05188s of that time.

I think we should just delete it.

kmem_cache_destroy() (at least for SLUB) already has:

                if (s->flags & SLAB_DESTROY_BY_RCU)
                        rcu_barrier();

in it. But I think it's too late - it gets called *after* we do
kmem_cache_close(), and I get the feeling that we should do it before.

Shouldn't that be sufficient? And if other slab allocators don't have
this, we should add it to them too.

Hmm?

              Linus

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
