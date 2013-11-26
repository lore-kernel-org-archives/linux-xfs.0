Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B041E7F3F
	for <xfs@oss.sgi.com>; Tue, 26 Nov 2013 07:11:41 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 3A5CFAC008
	for <xfs@oss.sgi.com>; Tue, 26 Nov 2013 05:11:38 -0800 (PST)
Received: from ZenIV.linux.org.uk (zeniv.linux.org.uk [195.92.253.2]) by
	cuda.sgi.com with ESMTP id OA9xEzLvzboaFZGS (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 26 Nov 2013 05:11:36 -0800 (PST)
Date: Tue, 26 Nov 2013 13:11:34 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: inode_permission NULL pointer dereference in 3.13-rc1
Message-ID: <20131126131134.GM10323@ZenIV.linux.org.uk>
References: <20131124140413.GA19271@infradead.org>
	<20131124152758.GL10323@ZenIV.linux.org.uk>
	<20131125160648.GA4933@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131125160648.GA4933@infradead.org>
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
Cc: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com

On Mon, Nov 25, 2013 at 08:06:48AM -0800, Christoph Hellwig wrote:
> On Sun, Nov 24, 2013 at 03:27:58PM +0000, Al Viro wrote:
> > which seems to leave two candidates - follow_dotdot_rcu() and path_init(),
> > both setting nd->inode to nd->path.dentry->d_inode...
> > 
> > Could you try to reproduce it with something like
> > 	if (read_seqretry(&mount_lock, nd->m_seq))
> > 		goto failed;
> > slapped before the success exit in follow_dotdot_rcu(), just to see if
> > we are hitting some races with umount here?
> 
> Still reproducable with the diff below.  Fixed by reverting the RCU'd
> vfsmounts.

.config, please - all I'm seeing on mine is a bloody awful leak somewhere
in VM that I'd been hunting for last week, so the damn thing gets OOMed
halfway through xfstests run ;-/

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
