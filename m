Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B486F7CA1
	for <xfs@oss.sgi.com>; Tue,  6 Sep 2016 12:35:13 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 7CB808F8035
	for <xfs@oss.sgi.com>; Tue,  6 Sep 2016 10:35:13 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id dEyhkdwurNcCvQxw (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 06 Sep 2016 10:35:11 -0700 (PDT)
Date: Tue, 6 Sep 2016 10:34:28 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 4/6] fs: add iomap_file_dirty
Message-ID: <20160906173428.GG16696@birch.djwong.org>
References: <147216784041.525.7722906502172299465.stgit@birch.djwong.org>
	<147216786712.525.5901639662288553230.stgit@birch.djwong.org>
	<20160905145751.GC7662@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160905145751.GC7662@infradead.org>
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
Cc: linux-api@vger.kernel.org, xfs@oss.sgi.com, linux-xfs@vger.kernel.org, viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@lst.de>

On Mon, Sep 05, 2016 at 07:57:51AM -0700, Christoph Hellwig wrote:
> On Thu, Aug 25, 2016 at 04:31:07PM -0700, Christoph Hellwig wrote:
> > Originally-from: Christoph Hellwig <hch@lst.de>
> 
> This should be a
> 
> From: Christoph Hellwig <hch@lst.de>
> 
> so that git picks up authorship information correctly.
> 
> > XXX: might want a bigger name, and possible a better implementation
> > that doesn't require two lookups in the radix tree.
> 
> And these need to be looked into.  I can take a stab at it, but I need
> to get a few other things off my plate first.

Yeah.  It works well enough for unsharing blocks, if inefficiently.

Not sure what "a bigger name" means, though.  I tried feeding the
function prototype through figlet but gcc didn't like that. ;)

--D

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
