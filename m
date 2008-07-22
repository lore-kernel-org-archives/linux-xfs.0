Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 21 Jul 2008 21:37:45 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6M4bg7f015750
	for <xfs@oss.sgi.com>; Mon, 21 Jul 2008 21:37:43 -0700
Date: Tue, 22 Jul 2008 00:38:51 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [UPDATED RFC] Create with EA initial work
Message-ID: <20080722043851.GA7244@infradead.org>
References: <1214196150-5427-1-git-send-email-xaiki@sgi.com> <1215675545-2707-1-git-send-email-xaiki@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1215675545-2707-1-git-send-email-xaiki@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Niv Sardi <xaiki@sgi.com>
Cc: xfs@oss.sgi.com

On Thu, Jul 10, 2008 at 05:39:01PM +1000, Niv Sardi wrote:
> There is a bug in this, that I can see with the Parent Pointers code
> going on top of it (that will be posted soon), it is basically calling
> xfs_attr_set_int_trans() in xfs_create() just before the last
> commit. For some reason, the first call to xfs_roll_trans (after
> xfs_bmap_add_attrfork_trans()) will complain about the inode being
> unlocked after xfs_trans_commit(). I understand I need to call
> xfs_trans_ihold(ip) on it, but we already do in xfs_create() so I
> think I must be missing something else??? any ideas ?

There are multiple ways to deal with inodes linked to transactions.

In all cases it needs to be linked into the transaction by
xfs_trans_ijoin, or the opencoded equivalent for a new inode in
xfs_trans_iget.  Then you can use xfs_trans_ihold to make sure on
transaction commit the inode reference count is not dropped and the
inode is not unlocked, or simply grab a reference to the inode and let
the transaction commit handler unlock it and decrement the reference
count.  The latter is what's used by xfs_create and the former is what
the attr code does, and as far as I can see the only things what works
with xfs_attr_rolltrans.
