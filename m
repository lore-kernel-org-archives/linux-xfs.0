Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 74B077F52
	for <xfs@oss.sgi.com>; Fri, 29 Nov 2013 17:55:52 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 637A0304051
	for <xfs@oss.sgi.com>; Fri, 29 Nov 2013 15:55:49 -0800 (PST)
Received: from ZenIV.linux.org.uk (zeniv.linux.org.uk [195.92.253.2]) by
	cuda.sgi.com with ESMTP id C4CDMEepNiLTx3KA (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 29 Nov 2013 15:55:45 -0800 (PST)
Date: Fri, 29 Nov 2013 23:55:37 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: inode_permission NULL pointer dereference in 3.13-rc1
Message-ID: <20131129235537.GX10323@ZenIV.linux.org.uk>
References: <20131128225102.GS10988@dastard>
	<20131128234441.GQ10323@ZenIV.linux.org.uk>
	<CA+55aFxLZxy75fO4ZXO4Stiu1sMx1q=eJ7HSk-UTCX61jPrirA@mail.gmail.com>
	<20131129024121.GS10323@ZenIV.linux.org.uk>
	<20131129035939.GT10323@ZenIV.linux.org.uk>
	<20131129040658.GU10323@ZenIV.linux.org.uk>
	<20131129041416.GV10323@ZenIV.linux.org.uk>
	<20131129065941.GW10323@ZenIV.linux.org.uk>
	<20131129194438.GA11052@kroah.com>
	<CA+55aFxgPQq_1n8Pv6gmMk+=yX9YkA10y6EpS1ECY8OB8-wFig@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CA+55aFxgPQq_1n8Pv6gmMk+=yX9YkA10y6EpS1ECY8OB8-wFig@mail.gmail.com>
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
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Christoph Hellwig <hch@infradead.org>, Greg KH <gregkh@linuxfoundation.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, xfs@oss.sgi.com

On Fri, Nov 29, 2013 at 12:17:23PM -0800, Linus Torvalds wrote:

> Al - even in your scenario I don't see a NULL nd->inode, because when
> we do an rmdir we remove the dentry, we don't turn it into a negative
> one. Afaik, it would be a violation of all our dentry rules to change
> the dentry->d_inode field while the dentry is live. The only way to
> get a negative dentry (ie d_inode == NULL) should be from lookup (and
> from a rename that switches the dentries around, but even then the
> d_inode _stays_ NULL, it's just that we move the dentry itself
> around).

Look at the end of vfs_rmdir(); d_delete() in there will turn dentry
negative if nobody else hold references to it.  So yes, dentry of
directory *can* go negative under you, unless you've grabbed a reference.
Which we do not do in RCU mode, obviously.

What would be a violation of all rules is dentry held by somebody else
becoming negative.  And d_delete() avoids that, but the whole point of
RCU-mode pathwalk is to _not_ hold intermediates.  So nd->inode is
needed.  Sure, it'll get ->d_seq bumped, but that won't do you much good
when it comes to attempt to dereference nd->inode.  Sure, we can turn
all places that access nd->inode into
	struct dentry *dentry = nd->path.dentry;
	struct inode *inode = dentry->d_inode;
	if (read_seqcount_retry(&dentry->d_seq, nd->seq))
		/* too fucking bad, we'd lost the race */
	else
		/* use inode */
but it will be just as messy as maintaining nd->inode _and_ quite a bit
slower.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
