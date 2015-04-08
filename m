Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 07DA47F5A
	for <xfs@oss.sgi.com>; Wed,  8 Apr 2015 13:16:58 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 88972AC009
	for <xfs@oss.sgi.com>; Wed,  8 Apr 2015 11:16:54 -0700 (PDT)
Received: from fieldses.org (fieldses.org [173.255.197.46]) by cuda.sgi.com
	with ESMTP id hfEfZIMmKpAYCN5Z for <xfs@oss.sgi.com>;
	Wed, 08 Apr 2015 11:16:52 -0700 (PDT)
Date: Wed, 8 Apr 2015 14:16:51 -0400
From: "J. Bruce Fields" <bfields@fieldses.org>
Subject: Re: [PATCH] xfs: unlock i_mutex in xfs_break_layouts
Message-ID: <20150408181651.GA3916@fieldses.org>
References: <1428420944-20965-1-git-send-email-hch@lst.de>
	<20150407210747.GD3363@fieldses.org>
	<20150408162104.GC16052@lst.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150408162104.GC16052@lst.de>
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
To: Christoph Hellwig <hch@lst.de>
Cc: linux-nfs@vger.kernel.org, viro@zeniv.linux.org.uk, xfs@oss.sgi.com

On Wed, Apr 08, 2015 at 06:21:04PM +0200, Christoph Hellwig wrote:
> On Tue, Apr 07, 2015 at 05:07:47PM -0400, J. Bruce Fields wrote:
> > On Tue, Apr 07, 2015 at 05:35:44PM +0200, Christoph Hellwig wrote:
> > > We want to drop all I/O path locks when recalling layouts, and that includes
> > > i_mutex for the write path.  Without this we get stuck processe when recalls
> > > take too long.
> > 
> > Also if the writer is an nfsd thread than we'd rather just error out
> > than wait.

(To be clear: ACK to this patch as far as I'm concerned, I've got
another concern but we need this fix regardless.)

> We have no way to know we are called by nfsd here unfortunately.

I was imagining the possible deadlock here as mostly theoretical, but
now that I think of it it doesn't sound unlikely at all:

	- file is under heavy write load
	- conflicting operation breaks layout
	- nfsd threads all block in writes to that file
	- no nfsd threads available to service layout return
	- recall times out, client fenced.

Ugh.

--b.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
