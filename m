Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B822C7F37
	for <xfs@oss.sgi.com>; Mon,  4 Jan 2016 17:41:04 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 47EB8AC002
	for <xfs@oss.sgi.com>; Mon,  4 Jan 2016 15:41:01 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id U1E0MFanjm06cVVI (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 04 Jan 2016 15:40:59 -0800 (PST)
Date: Mon, 4 Jan 2016 15:40:33 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 34/76] xfs: implement XFS_IOC_SWAPEXT when rmap btree is
	enabled
Message-ID: <20160104234033.GD28330@birch.djwong.org>
References: <20151219085622.12713.88678.stgit@birch.djwong.org>
	<20151219090008.12713.25755.stgit@birch.djwong.org>
	<20160103121728.GC28429@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160103121728.GC28429@infradead.org>
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
Cc: xfs@oss.sgi.com

On Sun, Jan 03, 2016 at 04:17:28AM -0800, Christoph Hellwig wrote:
> On Sat, Dec 19, 2015 at 01:00:08AM -0800, Darrick J. Wong wrote:
> > Implement extent swapping when reverse-mapping is enabled.
> 
> Can you just fold this into the previous patch?  There seem to be a lot
> of patches in the series that would benefit from merging, but this
> is the one that really screams for it :)

The only reason I'm keeping Dave's original rmap patches separate is because
the last time I checked with Dave, he said that he'd made a few bugfixes to his
patchset that hadn't yet been sent out, so I'd like to merge those fixes into
the original patches before starting any combining work.  It also might be more
convenient (for him, anyway) to keep my rmapbt changes separate for review
purposes.

At this point, though, I've made so many changes that I'd like to pull in
Dave's changes and combine them with mine into fewer patches.  (AFAIK, Dave
hasn't sent any further reverse-mapping patches since 3 June 2015.)

--D

> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
