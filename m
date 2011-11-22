Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pAMMZrqK175875 for <xfs@oss.sgi.com>; Tue, 22 Nov 2011 16:35:53 -0600
Received: from out2.smtp.messagingengine.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B3E8516DC8A0
	for <xfs@oss.sgi.com>; Tue, 22 Nov 2011 14:35:52 -0800 (PST)
Received: from out2.smtp.messagingengine.com (out2.smtp.messagingengine.com
	[66.111.4.26]) by cuda.sgi.com with ESMTP id SHcj616YI8fnLAfb
	for <xfs@oss.sgi.com>; Tue, 22 Nov 2011 14:35:52 -0800 (PST)
Received: from compute4.internal (compute4.nyi.mail.srv.osa [10.202.2.44])
	by gateway1.nyi.mail.srv.osa (Postfix) with ESMTP id ED9C620C10
	for <xfs@oss.sgi.com>; Tue, 22 Nov 2011 17:35:51 -0500 (EST)
Date: Tue, 22 Nov 2011 13:35:44 -0800
From: Greg KH <greg@kroah.com>
Subject: Re: [PATCH 4/9] [PATCH 4/9] xfs: dont serialise direct IO reads on
	page cache
Message-ID: <20111122213544.GB29127@kroah.com>
References: <20111119181336.964593075@bombadil.infradead.org>
	<20111119181544.111984285@bombadil.infradead.org>
	<20111122213425.GA29127@kroah.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111122213425.GA29127@kroah.com>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: Alex Elder <aelder@sgi.com>, Dave Chinner <dchinner@redhat.com>, stable@vger.kernel.org, xfs@oss.sgi.com

On Tue, Nov 22, 2011 at 01:34:25PM -0800, Greg KH wrote:
> On Sat, Nov 19, 2011 at 01:13:40PM -0500, Christoph Hellwig wrote:
> > There is no need to grab the i_mutex of the IO lock in exclusive
> > mode if we don't need to invalidate the page cache. Taking these
> > locks on every direct IO effective serialises them as taking the IO
> > lock in exclusive mode has to wait for all shared holders to drop
> > the lock. That only happens when IO is complete, so effective it
> > prevents dispatch of concurrent direct IO reads to the same inode.
> > 
> > Fix this by taking the IO lock shared to check the page cache state,
> > and only then drop it and take the IO lock exclusively if there is
> > work to be done. Hence for the normal direct IO case, no exclusive
> > locking will occur.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > Tested-by: Joern Engel <joern@logfs.org>
> > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > Signed-off-by: Alex Elder <aelder@sgi.com>
> 
> What is the git commit id that matches this patch in Linus's tree?

Nevermind, I found it, 0c38a2512df272b14ef4238b476a2e4f70da1479, right?

Next time, please include the git commit id of the patch in Linus's tree
so I don't have to dig it out like I did for this series.

thanks,

greg k-h

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
