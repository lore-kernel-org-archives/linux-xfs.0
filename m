Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8KIcH8w076600 for <xfs@oss.sgi.com>; Tue, 20 Sep 2011 13:38:17 -0500
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 412AF1403C0C
	for <xfs@oss.sgi.com>; Tue, 20 Sep 2011 11:43:36 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id DxEUICaHQ4L3bNSG for
	<xfs@oss.sgi.com>; Tue, 20 Sep 2011 11:43:36 -0700 (PDT)
Message-ID: <4E78DD8B.1020605@redhat.com>
Date: Tue, 20 Sep 2011 14:38:03 -0400
From: Rik van Riel <riel@redhat.com>
MIME-Version: 1.0
Subject: Re: [patch 3/4] mm: filemap: pass __GFP_WRITE from
	grab_cache_page_write_begin()
References: <1316526315-16801-1-git-send-email-jweiner@redhat.com>
	<1316526315-16801-4-git-send-email-jweiner@redhat.com>
	<20110920142553.GA2593@infradead.org>
In-Reply-To: <20110920142553.GA2593@infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>, linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, linux-mm@kvack.org, Andreas Dilger <adilger.kernel@dilger.ca>, Mel Gorman <mgorman@suse.de>, linux-fsdevel@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, Andrew Morton <akpm@linux-foundation.org>, Wu Fengguang <fengguang.wu@intel.com>, Johannes Weiner <jweiner@redhat.com>, Chris Mason <chris.mason@oracle.com>, Minchan Kim <minchan.kim@gmail.com>

On 09/20/2011 10:25 AM, Christoph Hellwig wrote:
> In addition to regular write shouldn't __do_fault and do_wp_page also
> calls this if they are called on file backed mappings?
>

Probably not do_wp_page since it always creates an
anonymous page, which are not very relevant to the
dirty page cache accounting.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
