Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id F110B7CBF
	for <xfs@oss.sgi.com>; Wed,  8 Apr 2015 11:21:07 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id DAB1D8F8035
	for <xfs@oss.sgi.com>; Wed,  8 Apr 2015 09:21:07 -0700 (PDT)
Received: from newverein.lst.de (verein.lst.de [213.95.11.211]) by
	cuda.sgi.com with ESMTP id FVrlGhN0JJUvi3VK (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 08 Apr 2015 09:21:06 -0700 (PDT)
Date: Wed, 8 Apr 2015 18:21:04 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] xfs: unlock i_mutex in xfs_break_layouts
Message-ID: <20150408162104.GC16052@lst.de>
References: <1428420944-20965-1-git-send-email-hch@lst.de>
	<20150407210747.GD3363@fieldses.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150407210747.GD3363@fieldses.org>
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
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: linux-nfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>, viro@zeniv.linux.org.uk, xfs@oss.sgi.com

On Tue, Apr 07, 2015 at 05:07:47PM -0400, J. Bruce Fields wrote:
> On Tue, Apr 07, 2015 at 05:35:44PM +0200, Christoph Hellwig wrote:
> > We want to drop all I/O path locks when recalling layouts, and that includes
> > i_mutex for the write path.  Without this we get stuck processe when recalls
> > take too long.
> 
> Also if the writer is an nfsd thread than we'd rather just error out
> than wait.

We have no way to know we are called by nfsd here unfortunately.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
