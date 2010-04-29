Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3TLcH1o102835 for <xfs@oss.sgi.com>; Thu, 29 Apr 2010 16:38:18 -0500
Received: from smtp1.linux-foundation.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A1E3D1491B1A
	for <xfs@oss.sgi.com>; Thu, 29 Apr 2010 14:40:19 -0700 (PDT)
Received: from smtp1.linux-foundation.org (smtp1.linux-foundation.org
	[140.211.169.13]) by cuda.sgi.com with ESMTP id
	HK8arsmk9VoLJdf8 for <xfs@oss.sgi.com>;
	Thu, 29 Apr 2010 14:40:19 -0700 (PDT)
Date: Thu, 29 Apr 2010 14:39:31 -0700
From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 3/4] writeback: pay attention to wbc->nr_to_write in
	write_cache_pages
Message-Id: <20100429143931.331c2bab.akpm@linux-foundation.org>
In-Reply-To: <1271731314-5893-4-git-send-email-david@fromorbit.com>
References: <1271731314-5893-1-git-send-email-david@fromorbit.com>
	<1271731314-5893-4-git-send-email-david@fromorbit.com>
Mime-Version: 1.0
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
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, linux-kernel@vger.kernel.org, "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>, xfs@oss.sgi.com

On Tue, 20 Apr 2010 12:41:53 +1000
Dave Chinner <david@fromorbit.com> wrote:

> If a filesystem writes more than one page in ->writepage, write_cache_pages
> fails to notice this and continues to attempt writeback when wbc->nr_to_write
> has gone negative - this trace was captured from XFS:
> 
> 
>     wbc_writeback_start: towrt=1024
>     wbc_writepage: towrt=1024
>     wbc_writepage: towrt=0
>     wbc_writepage: towrt=-1
>     wbc_writepage: towrt=-5
>     wbc_writepage: towrt=-21
>     wbc_writepage: towrt=-85
> 

Bug.

AFAIT it's a regression introduced by

: commit 17bc6c30cf6bfffd816bdc53682dd46fc34a2cf4
: Author:     Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
: AuthorDate: Thu Oct 16 10:09:17 2008 -0400
: Commit:     Theodore Ts'o <tytso@mit.edu>
: CommitDate: Thu Oct 16 10:09:17 2008 -0400
: 
:     vfs: Add no_nrwrite_index_update writeback control flag

I suggest that what you do here is remove the local `nr_to_write' from
write_cache_pages() and go back to directly using wbc->nr_to_write
within the loop.

And thus we restore the convention that if the fs writes back more than
a single page, it subtracts (nr_written - 1) from wbc->nr_to_write.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
