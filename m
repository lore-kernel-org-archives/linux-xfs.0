Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o1CK2EJC020796 for <xfs@oss.sgi.com>; Fri, 12 Feb 2010 14:02:14 -0600
Date: Fri, 12 Feb 2010 15:03:59 -0500
From: "J. Bruce Fields" <bfields@fieldses.org>
Subject: Re: [PATCH 2/2] xfs_export_operations.commit_metadata
Message-ID: <20100212200359.GA23361@fieldses.org>
References: <20100211220454.26466.37578.stgit@case>
	<20100211220505.26466.99037.stgit@case>
	<1265986006.3201.112.camel@doink1>
	<20100212174706.GB22633@infradead.org>
	<20100212195647.GQ23654@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100212195647.GQ23654@sgi.com>
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
To: bpm@sgi.com
Cc: Christoph Hellwig <hch@infradead.org>, linux-nfs@vger.kernel.org, xfs@oss.sgi.com, Alex Elder <aelder@sgi.com>

On Fri, Feb 12, 2010 at 01:56:47PM -0600, bpm@sgi.com wrote:
> On Fri, Feb 12, 2010 at 12:47:07PM -0500, Christoph Hellwig wrote:
> > if we care enough about the returned error.  But Ben is working against
> > the NFS tree which doesn't have that change yet.
> > 
> > We can deal with that by either commiting the old variant to the nfs
> > tree and then leaving sending Stephen a patch to fix it up in -next,
> > or just not apply the xfs commit_metadata implementation yet, and wait
> > for it until both the xfs and nfs trees have hit mainline.

Assuming the xfs tree's something stable, I could also just go ahead and
pull it into the nfsd tree.

(Or we could do it the other way around--as long as when the merge
window opens we try to send the pull requests in the same order.)

--b.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
