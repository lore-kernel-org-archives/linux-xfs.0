Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8S62dsT090664 for <xfs@oss.sgi.com>; Wed, 28 Sep 2011 01:02:40 -0500
Received: from mail-yw0-f53.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0E052142628A
	for <xfs@oss.sgi.com>; Tue, 27 Sep 2011 23:08:39 -0700 (PDT)
Received: from mail-yw0-f53.google.com (mail-yw0-f53.google.com
	[209.85.213.53]) by cuda.sgi.com with ESMTP id yVHpCqzX7hurqGYo
	for <xfs@oss.sgi.com>; Tue, 27 Sep 2011 23:08:39 -0700 (PDT)
Received: by ywt2 with SMTP id 2so8296403ywt.26
	for <xfs@oss.sgi.com>; Tue, 27 Sep 2011 23:02:38 -0700 (PDT)
Date: Wed, 28 Sep 2011 15:02:25 +0900
From: Minchan Kim <minchan.kim@gmail.com>
Subject: Re: [patch 3/4] mm: filemap: pass __GFP_WRITE from
	grab_cache_page_write_begin()
Message-ID: <20110928060225.GD14561@barrios-desktop>
References: <1316526315-16801-1-git-send-email-jweiner@redhat.com>
	<1316526315-16801-4-git-send-email-jweiner@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1316526315-16801-4-git-send-email-jweiner@redhat.com>
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
To: Johannes Weiner <jweiner@redhat.com>
Cc: Rik van Riel <riel@redhat.com>, linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>, linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, linux-mm@kvack.org, Andreas Dilger <adilger.kernel@dilger.ca>, Mel Gorman <mgorman@suse.de>, linux-fsdevel@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, Andrew Morton <akpm@linux-foundation.org>, Wu Fengguang <fengguang.wu@intel.com>, Chris Mason <chris.mason@oracle.com>

On Tue, Sep 20, 2011 at 03:45:14PM +0200, Johannes Weiner wrote:
> Tell the page allocator that pages allocated through
> grab_cache_page_write_begin() are expected to become dirty soon.
> 
> Signed-off-by: Johannes Weiner <jweiner@redhat.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>

-- 
Kinds regards,
Minchan Kim

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
