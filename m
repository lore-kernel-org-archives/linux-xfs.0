Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 9B56E7F50
	for <xfs@oss.sgi.com>; Fri, 24 Apr 2015 03:21:21 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 9EC428F8064
	for <xfs@oss.sgi.com>; Fri, 24 Apr 2015 01:21:21 -0700 (PDT)
Received: from newverein.lst.de (verein.lst.de [213.95.11.211]) by
	cuda.sgi.com with ESMTP id 3ux9GJNANJeWjxLL (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 24 Apr 2015 01:21:14 -0700 (PDT)
Date: Fri, 24 Apr 2015 10:21:12 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 5/6] xfs: move non-inline symlinks to the pagecache
Message-ID: <20150424082112.GB18962@lst.de>
References: <1429816064-10033-1-git-send-email-hch@lst.de>
	<1429816064-10033-6-git-send-email-hch@lst.de>
	<20150423222942.GK15810@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150423222942.GK15810@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@lst.de>, viro@zeniv.linux.org.uk, xfs@oss.sgi.com

On Fri, Apr 24, 2015 at 08:29:42AM +1000, Dave Chinner wrote:
> On Thu, Apr 23, 2015 at 09:07:43PM +0200, Christoph Hellwig wrote:
> > We can use the generic symlink in pagecache code for XFS non-inline
> > symlinks.  Because links are always shorter than a page we will
> > get the zero termination for the link for free.
> 
> Doesn't work for v5 filesystems where headers and CRCs are embedded
> into the same blocks as the symlink data. i.e. this now falls down
> to ->readpage to read the link data into the page cache, and that
> just reads the entire blocks into the page cache. So what we can end
> up within the page cache is this:

Uh, ok.  Guess the pagecache symlink support isn't too useful then.
I'll respin to only optimize the inline symlinks, which should
still we worthwhile.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
