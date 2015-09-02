Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 198287F66
	for <xfs@oss.sgi.com>; Wed,  2 Sep 2015 16:35:30 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id EFB14304032
	for <xfs@oss.sgi.com>; Wed,  2 Sep 2015 14:35:26 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	V8yOPmxuiNqAhdDX for <xfs@oss.sgi.com>;
	Wed, 02 Sep 2015 14:35:21 -0700 (PDT)
Date: Thu, 3 Sep 2015 07:34:37 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: add ->pfn_mkwrite support for DAX
Message-ID: <20150902213437.GT3902@dastard>
References: <1441157100-1658-1-git-send-email-david@fromorbit.com>
	<20150902051217.GA18906@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150902051217.GA18906@infradead.org>
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
Cc: boaz@plexistor.com, kirill.shutemov@linux.intel.com, xfs@oss.sgi.com

On Tue, Sep 01, 2015 at 10:12:17PM -0700, Christoph Hellwig wrote:
> On Wed, Sep 02, 2015 at 11:25:00AM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > ->pfn_mkwrite support is needed so that when a page with allocated
> > backing store first takes a write fault the timestamps on the
> > file are updated. THis fixes a generic/080 failure.
> 
> Shouldn't you be able to drop the call to xfs_filemap_page_mkwrite from
> xfs_filemap_fault now?

No idea. It hasn't been removed from dax_fault, so I'm not going to
remove it from xfs_filemap_page_mkwrite()...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
