Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 0D7017F5F
	for <xfs@oss.sgi.com>; Wed,  2 Sep 2015 00:12:20 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 94D3BAC012
	for <xfs@oss.sgi.com>; Tue,  1 Sep 2015 22:12:19 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id H6Vafm0QL2b2BNH0 (version=TLSv1 cipher=AES128-SHA
	bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 01 Sep 2015 22:12:18 -0700 (PDT)
Date: Tue, 1 Sep 2015 22:12:17 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: add ->pfn_mkwrite support for DAX
Message-ID: <20150902051217.GA18906@infradead.org>
References: <1441157100-1658-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1441157100-1658-1-git-send-email-david@fromorbit.com>
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
Cc: boaz@plexistor.com, kirill.shutemov@linux.intel.com, xfs@oss.sgi.com

On Wed, Sep 02, 2015 at 11:25:00AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> ->pfn_mkwrite support is needed so that when a page with allocated
> backing store first takes a write fault the timestamps on the
> file are updated. THis fixes a generic/080 failure.

Shouldn't you be able to drop the call to xfs_filemap_page_mkwrite from
xfs_filemap_fault now?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
