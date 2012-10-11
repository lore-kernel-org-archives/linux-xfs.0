Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9B7gqcc063111 for <xfs@oss.sgi.com>; Thu, 11 Oct 2012 02:42:52 -0500
Received: from e06smtp12.uk.ibm.com (e06smtp12.uk.ibm.com [195.75.94.108]) by
	cuda.sgi.com with ESMTP id bEWkdRrgmI1kEAjJ (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 11 Oct 2012 00:44:23 -0700 (PDT)
Received: from /spool/local
	by e06smtp12.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use
	Only! Violators will be prosecuted
	for <xfs@oss.sgi.com> from <schwidefsky@de.ibm.com>;
	Thu, 11 Oct 2012 08:44:22 +0100
Received: from d06av03.portsmouth.uk.ibm.com (d06av03.portsmouth.uk.ibm.com
	[9.149.37.213])
	by b06cxnps4076.portsmouth.uk.ibm.com (8.13.8/8.13.8/NCO v10.0) with
	ESMTP id q9B7i1RS56361170
	for <xfs@oss.sgi.com>; Thu, 11 Oct 2012 07:44:01 GMT
Received: from d06av03.portsmouth.uk.ibm.com (localhost.localdomain
	[127.0.0.1])
	by d06av03.portsmouth.uk.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with
	ESMTP id q9B7i7Ck024917
	for <xfs@oss.sgi.com>; Thu, 11 Oct 2012 01:44:07 -0600
Date: Thu, 11 Oct 2012 09:44:05 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [PATCH] mm: Fix XFS oops due to dirty pages without buffers on
	s390
Message-ID: <20121011094405.1c5990c9@mschwide>
In-Reply-To: <20121010215600.GX23644@dastard>
References: <1349108796-32161-1-git-send-email-jack@suse.cz>
	<alpine.LSU.2.00.1210082029190.2237@eggly.anvils>
	<20121009162107.GE15790@quack.suse.cz>
	<alpine.LSU.2.00.1210091824390.30802@eggly.anvils>
	<20121010215600.GX23644@dastard>
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
Cc: linux-s390@vger.kernel.org, Jan Kara <jack@suse.cz>, Hugh Dickins <hughd@google.com>, LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, linux-mm@kvack.org, Mel Gorman <mgorman@suse.de>

On Thu, 11 Oct 2012 08:56:00 +1100
Dave Chinner <david@fromorbit.com> wrote:

> On Tue, Oct 09, 2012 at 07:19:09PM -0700, Hugh Dickins wrote:
> > On Tue, 9 Oct 2012, Jan Kara wrote:
> > > On Mon 08-10-12 21:24:40, Hugh Dickins wrote:
> > > > On Mon, 1 Oct 2012, Jan Kara wrote:
> > > > 
> > > > > On s390 any write to a page (even from kernel itself) sets architecture
> > > > > specific page dirty bit. Thus when a page is written to via standard write, HW
> > > > > dirty bit gets set and when we later map and unmap the page, page_remove_rmap()
> > > > > finds the dirty bit and calls set_page_dirty().
> > > > > 
> > > > > Dirtying of a page which shouldn't be dirty can cause all sorts of problems to
> > > > > filesystems. The bug we observed in practice is that buffers from the page get
> > > > > freed, so when the page gets later marked as dirty and writeback writes it, XFS
> > > > > crashes due to an assertion BUG_ON(!PagePrivate(page)) in page_buffers() called
> > > > > from xfs_count_page_state().
> > > > 
> > > > What changed recently?  Was XFS hardly used on s390 until now?
> > >   The problem was originally hit on SLE11-SP2 which is 3.0 based after
> > > migration of our s390 build machines from SLE11-SP1 (2.6.32 based). I think
> > > XFS just started to be more peevish about what pages it gets between these
> > > two releases ;) (e.g. ext3 or ext4 just says "oh, well" and fixes things
> > > up).
> > 
> > Right, in 2.6.32 xfs_vm_writepage() had a !page_has_buffers(page) case,
> > whereas by 3.0 that had become ASSERT(page_has_buffers(page)), with the
> > ASSERT usually compiled out, stumbling later in page_buffers() as you say.
> 
> What that says is that no-one is running xfstests-based QA on s390
> with CONFIG_XFS_DEBUG enabled, otherwise this would have been found.
> I've never tested XFS on s390 before, and I doubt any of the
> upstream developers have, either, because not many peopl ehave s390
> machines in their basement. So this is probably just an oversight
> in the distro QA environment more than anything....

Our internal builds indeed have CONFIG_XFS_DEBUG=n, I'll change that and
watch for the fallout.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
