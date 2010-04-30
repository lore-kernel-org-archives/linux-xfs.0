Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3U5xuTb133356 for <xfs@oss.sgi.com>; Fri, 30 Apr 2010 00:59:56 -0500
Received: from e23smtp09.au.ibm.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 172A6300A6E
	for <xfs@oss.sgi.com>; Thu, 29 Apr 2010 23:02:00 -0700 (PDT)
Received: from e23smtp09.au.ibm.com (e23smtp09.au.ibm.com [202.81.31.142]) by
	cuda.sgi.com with ESMTP id Dco84zhsUzS6B3BY for
	<xfs@oss.sgi.com>; Thu, 29 Apr 2010 23:02:00 -0700 (PDT)
Received: from d23relay05.au.ibm.com (d23relay05.au.ibm.com [202.81.31.247])
	by e23smtp09.au.ibm.com (8.14.3/8.13.1) with ESMTP id o3U61w0D000401
	for <xfs@oss.sgi.com>; Fri, 30 Apr 2010 16:01:58 +1000
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.235.139])
	by d23relay05.au.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	o3U5t79n766038 for <xfs@oss.sgi.com>; Fri, 30 Apr 2010 15:55:07 +1000
Received: from d23av04.au.ibm.com (loopback [127.0.0.1])
	by d23av04.au.ibm.com (8.14.3/8.13.1/NCO v10.0 AVout) with ESMTP id
	o3U61vtA021673 for <xfs@oss.sgi.com>; Fri, 30 Apr 2010 16:01:58 +1000
From: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH 3/4] writeback: pay attention to wbc->nr_to_write in
	write_cache_pages
In-Reply-To: <20100429143931.331c2bab.akpm@linux-foundation.org>
References: <1271731314-5893-1-git-send-email-david@fromorbit.com>
	<1271731314-5893-4-git-send-email-david@fromorbit.com>
	<20100429143931.331c2bab.akpm@linux-foundation.org>
Date: Fri, 30 Apr 2010 11:31:53 +0530
Message-ID: <87sk6dwka6.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
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
To: Andrew Morton <akpm@linux-foundation.org>, Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Thu, 29 Apr 2010 14:39:31 -0700, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Tue, 20 Apr 2010 12:41:53 +1000
> Dave Chinner <david@fromorbit.com> wrote:
> 
> > If a filesystem writes more than one page in ->writepage, write_cache_pages
> > fails to notice this and continues to attempt writeback when wbc->nr_to_write
> > has gone negative - this trace was captured from XFS:
> > 
> > 
> >     wbc_writeback_start: towrt=1024
> >     wbc_writepage: towrt=1024
> >     wbc_writepage: towrt=0
> >     wbc_writepage: towrt=-1
> >     wbc_writepage: towrt=-5
> >     wbc_writepage: towrt=-21
> >     wbc_writepage: towrt=-85
> > 
> 
> Bug.
> 
> AFAIT it's a regression introduced by
> 
> : commit 17bc6c30cf6bfffd816bdc53682dd46fc34a2cf4
> : Author:     Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> : AuthorDate: Thu Oct 16 10:09:17 2008 -0400
> : Commit:     Theodore Ts'o <tytso@mit.edu>
> : CommitDate: Thu Oct 16 10:09:17 2008 -0400
> : 
> :     vfs: Add no_nrwrite_index_update writeback control flag
> 
> I suggest that what you do here is remove the local `nr_to_write' from
> write_cache_pages() and go back to directly using wbc->nr_to_write
> within the loop.
> 
> And thus we restore the convention that if the fs writes back more than
> a single page, it subtracts (nr_written - 1) from wbc->nr_to_write.
> 

My mistake i never expected writepage to write more than one page. The
interface said 'writepage' so it was natural to expect that it writes only
one page. BTW the reason for the change is to give file system which
accumulate dirty pages using write_cache_pages and attempt to write
them out later a chance to properly manage nr_to_write. Something like

ext4_da_writepages
-- write_cache_pages
---- collect dirty page
---- return
--return
--now try to writeout all the collected dirty pages ( say 100)
----Only able to allocate blocks for 50 pages
    so update nr_to_write -= 50 and mark rest of 50 pages as dirty
    again

So we want wbc->nr_to_write updated only by ext4_da_writepages. 


-aneesh

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
