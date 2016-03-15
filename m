Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 62B847CA4
	for <xfs@oss.sgi.com>; Tue, 15 Mar 2016 02:13:29 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 2A2748F8033
	for <xfs@oss.sgi.com>; Tue, 15 Mar 2016 00:13:29 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id qCQXYNVXTIYjXpLn (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 15 Mar 2016 00:13:26 -0700 (PDT)
Date: Tue, 15 Mar 2016 00:12:56 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v18 11/22] vfs: Cache base_acl objects in inodes
Message-ID: <20160315071256.GD19747@infradead.org>
References: <1456733847-17982-1-git-send-email-agruenba@redhat.com>
	<1456733847-17982-12-git-send-email-agruenba@redhat.com>
	<20160311140746.GC14808@infradead.org>
	<CAHc6FU7hSDBa51mJZZZ=q3agzWXk=DZicnyuPriKHnC2Nxr8rw@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAHc6FU7hSDBa51mJZZZ=q3agzWXk=DZicnyuPriKHnC2Nxr8rw@mail.gmail.com>
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
To: Andreas Gruenbacher <agruenba@redhat.com>
Cc: "J. Bruce Fields" <bfields@fieldses.org>, Linux NFS Mailing List <linux-nfs@vger.kernel.org>, Theodore Ts'o <tytso@mit.edu>, linux-cifs@vger.kernel.org, Linux API <linux-api@vger.kernel.org>, Trond Myklebust <trond.myklebust@primarydata.com>, LKML <linux-kernel@vger.kernel.org>, XFS Developers <xfs@oss.sgi.com>, Christoph Hellwig <hch@infradead.org>, chao2.yu@samsung.com, Andreas Dilger <adilger.kernel@dilger.ca>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, jaegeuk@kernel.org, Jeff Layton <jlayton@poochiereds.net>, linux-ext4 <linux-ext4@vger.kernel.org>, Anna Schumaker <anna.schumaker@netapp.com>

On Fri, Mar 11, 2016 at 05:24:45PM +0100, Andreas Gruenbacher wrote:
> POSIX ACLs and RichACLs are different objects, with different members
> and different algorithms operating on them. The only commonality is
> that they are both kmalloc()ed, reference counted objects, and when an
> inode is destroyed, both kinds of ACLs can be put in the same way,
> avoiding an unnecessary if. What kind of common-code container beyond
> that are you still dreaming about?

We still have a main object that is simply a list of ACEs.  But if that
doesn't work out (I suspect it should) I don't think the common base
object is a good idea.  It just leads to a lot of crazy container_of
calls.  If the common object abstraction doesn't work out we'll need
a procedural one instead that has common acl_* calls that decide what
do to based on the file system acl flag.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
