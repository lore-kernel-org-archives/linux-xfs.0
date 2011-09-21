Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8LE9tHF147802 for <xfs@oss.sgi.com>; Wed, 21 Sep 2011 09:09:55 -0500
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6031C17E761
	for <xfs@oss.sgi.com>; Wed, 21 Sep 2011 07:09:54 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id lLVEoT5OwVIFpQ87 for
	<xfs@oss.sgi.com>; Wed, 21 Sep 2011 07:09:54 -0700 (PDT)
Date: Wed, 21 Sep 2011 16:09:35 +0200
From: Johannes Weiner <jweiner@redhat.com>
Subject: Re: [patch 3/4] mm: filemap: pass __GFP_WRITE from
	grab_cache_page_write_begin()
Message-ID: <20110921140935.GF22516@redhat.com>
References: <1316526315-16801-1-git-send-email-jweiner@redhat.com>
	<1316526315-16801-4-git-send-email-jweiner@redhat.com>
	<20110920142553.GA2593@infradead.org> <4E78DD8B.1020605@redhat.com>
	<20110920184034.GA27353@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110920184034.GA27353@infradead.org>
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
Cc: Rik van Riel <riel@redhat.com>, linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>, linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, linux-mm@kvack.org, Andreas Dilger <adilger.kernel@dilger.ca>, Mel Gorman <mgorman@suse.de>, linux-fsdevel@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, Andrew Morton <akpm@linux-foundation.org>, Wu Fengguang <fengguang.wu@intel.com>, Chris Mason <chris.mason@oracle.com>, Minchan Kim <minchan.kim@gmail.com>

On Tue, Sep 20, 2011 at 02:40:34PM -0400, Christoph Hellwig wrote:
> On Tue, Sep 20, 2011 at 02:38:03PM -0400, Rik van Riel wrote:
> > On 09/20/2011 10:25 AM, Christoph Hellwig wrote:
> > >In addition to regular write shouldn't __do_fault and do_wp_page also
> > >calls this if they are called on file backed mappings?
> > 
> > Probably not do_wp_page since it always creates an
> > anonymous page, which are not very relevant to the
> > dirty page cache accounting.
> 
> Well, it doesn't always - but for the case where it doesn't we
> do not allocate a new page at all so you're right in the end :)

I think it could be useful to annotate write-fault allocations in
filemap_fault(), but these pages are mostly allocated in the readahead
code, so this could turn into a more invasive project.

It can be done incrementally, however, the series as it stands does
not require it to be useful.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
