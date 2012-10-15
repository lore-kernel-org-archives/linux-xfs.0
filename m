Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9FGxtiW182381 for <xfs@oss.sgi.com>; Mon, 15 Oct 2012 11:59:56 -0500
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id Xhzdu1sK9RNkHBRt for
	<xfs@oss.sgi.com>; Mon, 15 Oct 2012 10:01:31 -0700 (PDT)
Received: from int-mx12.intmail.prod.int.phx2.redhat.com
	(int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q9FH1Vge014209
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Mon, 15 Oct 2012 13:01:31 -0400
Received: from andromeda.usersys.redhat.com (ovpn-113-111.phx2.redhat.com
	[10.3.113.111])
	by int-mx12.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id q9FH1PC5025987
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <xfs@oss.sgi.com>; Mon, 15 Oct 2012 13:01:28 -0400
Date: Mon, 15 Oct 2012 14:01:25 -0300
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [RFC PATCH] xfs: enables file data inlining in inodes
Message-ID: <20121015170124.GA8376@andromeda.usersys.redhat.com>
References: <1349985158-9952-1-git-send-email-cmaiolino@redhat.com>
	<20121012123014.GB3632@Archie>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20121012123014.GB3632@Archie>
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
To: xfs@oss.sgi.com

On Fri, Oct 12, 2012 at 06:00:14PM +0530, Raghavendra D Prabhu wrote:
> Hi,
> 
> 
> * On Thu, Oct 11, 2012 at 04:52:38PM -0300, Carlos Maiolino <cmaiolino@redhat.com> wrote:
> >Hi,
> >
> >this is a first RFC patch of my work on data inlining, i.e. use the xfs inode's
> >literal area to store user's data.
> >
> >This first patch just cares about write and read new files into inode's literal
> >area, it does not make any conversion from inline to extent or vice-versa.
> >
> >The idea to send this patch to list is just to get comments about this first
> >work and see if anybody has some ideas/suggestions about it, mainly related
> >with page cache and journal handling, since it's the first time I deal with
> >journal and page cache handling, I'm not pretty sure if I did things right
> >or not.
> >
> >Every comment is very appreciated.
> >
> >Thanks
> >---
> >fs/xfs/xfs_aops.c  | 134 ++++++++++++++++++++++++++++++++++++++++++++++++++---
> >+	if (ip->i_d.di_format == XFS_DINODE_FMT_LOCAL) {
> >+		struct page	*page = list_first_entry(pages, struct page, lru);
> >+
> >+		ASSERT(i_size_read(VFS_I(ip) <= PAGE_CACHE_SIZE));
> 
> Looks good.
> 
> But, I guess should be --- ASSERT(i_size_read(VFS_I(ip)) <= PAGE_CACHE_SIZE);  here?
> 
Yes, you're right, thanks for catch this

> >+
> >+		list_del(&page->lru);
> >+		if(!(add_to_page_cache_lru(page, mapping,
> >+					    page->index, GFP_KERNEL)))
> >+			return xfs_inline_read(ip, page, page->mapping);
> >+
> >+		page_cache_release(page);
> >+		return 0;
> >+	} else {
> >+		return mpage_readpages(mapping, pages, nr_pages, xfs_get_blocks);
> >+	}
> >}
> >
> >const struct address_space_operations xfs_address_space_operations = {
> >diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> >index 2778258..5e56e5c 100644
> >--- a/fs/xfs/xfs_inode.c
> >+++ b/fs/xfs/xfs_inode.c
> >@@ -287,18 +287,6 @@ xfs_iformat(
> >	case S_IFDIR:
> >-- 
> >1.7.11.7
> >
> >_______________________________________________
> >xfs mailing list
> >xfs@oss.sgi.com
> >http://oss.sgi.com/mailman/listinfo/xfs
> 
> 
> 
> 
> Regards,
> -- 
> Raghavendra Prabhu
> GPG Id : 0xD72BE977
> Fingerprint: B93F EBCB 8E05 7039 CD3C A4B8 A616 DCA1 D72B E977
> www: wnohang.net



> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs


-- 
--Carlos

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
