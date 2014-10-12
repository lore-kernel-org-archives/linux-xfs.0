Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 256357F4E
	for <xfs@oss.sgi.com>; Sun, 12 Oct 2014 13:54:24 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E9F1E8F8049
	for <xfs@oss.sgi.com>; Sun, 12 Oct 2014 11:54:20 -0700 (PDT)
Received: from ZenIV.linux.org.uk (zeniv.linux.org.uk [195.92.253.2]) by
	cuda.sgi.com with ESMTP id abE3onNqQnXqlBIK (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 12 Oct 2014 11:54:15 -0700 (PDT)
Date: Sun, 12 Oct 2014 19:53:16 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH 0/12 v2] Moving i_dquot out of struct inode
Message-ID: <20141012185316.GQ7996@ZenIV.linux.org.uk>
References: <1412952910-7142-1-git-send-email-jack@suse.cz>
	<20141011133452.GA29004@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20141011133452.GA29004@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: Dave Kleikamp <shaggy@kernel.org>, jfs-discussion@lists.sourceforge.net, Jan Kara <jack@suse.cz>, Jeff Mahoney <jeffm@suse.de>, Mark Fasheh <mfasheh@suse.com>, reiserfs-devel@vger.kernel.org, xfs@oss.sgi.com, cluster-devel@redhat.com, Joel Becker <jlbec@evilplan.org>, linux-fsdevel@vger.kernel.org, tytso@mit.edu, linux-ext4@vger.kernel.org, Steven Whitehouse <swhiteho@redhat.com>, ocfs2-devel@oss.oracle.com

On Sat, Oct 11, 2014 at 06:34:52AM -0700, Christoph Hellwig wrote:
> I still very much disagree with the s_inode_fields indirection.  Please
> find a patch below to remove it, and use a get_dquots super_block
> operation instead.  This leads to less and better readable code,
> and serves 4 bytes in every inode in the system.  Additionally the
> indirection could easily be optimized away by directly passing the
> dquot array in various functions, but for now I'd like to keep it
> simple.

Indeed.  This "array of offsets" approach is asking for trouble.  Please,
don't go there - playing that way with type safety is a bad idea.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
