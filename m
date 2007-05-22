Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 21 May 2007 21:04:49 -0700 (PDT)
Received: from postoffice.aconex.com (mail.app.aconex.com [203.89.192.138])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l4M44hWt017986
	for <xfs@oss.sgi.com>; Mon, 21 May 2007 21:04:45 -0700
Subject: Re: Review: ensure EOF writes into existing extents update filesize
From: Nathan Scott <nscott@aconex.com>
Reply-To: nscott@aconex.com
In-Reply-To: <20070522010326.GN85884050@sgi.com>
References: <20070520233417.GA85884050@sgi.com>
	 <738172E9F9634F7FC01B5B3C@timothy-shimmins-power-mac-g5.local>
	 <20070522004414.GL85884050@sgi.com> <1179795779.6273.510.camel@edge>
	 <20070522010326.GN85884050@sgi.com>
Content-Type: multipart/mixed; boundary="=-Ol4eDZKyAzPXZLgYQsmK"
Date: Tue, 22 May 2007 14:10:14 +1000
Message-Id: <1179807014.6273.519.camel@edge>
Mime-Version: 1.0
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Timothy Shimmin <tes@sgi.com>, xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

--=-Ol4eDZKyAzPXZLgYQsmK
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Tue, 2007-05-22 at 11:03 +1000, David Chinner wrote:
> On Tue, May 22, 2007 at 11:02:59AM +1000, Nathan Scott wrote:
> > On Tue, 2007-05-22 at 10:44 +1000, David Chinner wrote:
> > > On Mon, May 21, 2007 at 04:34:26PM +1000, Timothy Shimmin wrote:
> > > I guess I need to ping Christoph and Nathan on this one....
> > 
> > Could you resend the patch to me please?  I lost the previous copy
> > while ruthlessly ploughing through my mail backlog.  ;)
> 
> Below.

Looks pretty good to me - xfs_convert_page has been overlooked, I
think - attached patch fixes that.  You also initialise iomap_valid
twice inside xfs_page_state_convert now ... I reverted that to just
the once.

cheers.

-- 
Nathan


--=-Ol4eDZKyAzPXZLgYQsmK
Content-Disposition: attachment; filename=nat.patch
Content-Type: text/x-patch; name=nat.patch; charset=UTF-8
Content-Transfer-Encoding: 7bit

Index: linux/fs/xfs/linux-2.6/xfs_aops.c
===================================================================
--- linux.orig/fs/xfs/linux-2.6/xfs_aops.c	2007-05-22 13:47:40.296829500 +1000
+++ linux/fs/xfs/linux-2.6/xfs_aops.c	2007-05-22 13:48:25.987685000 +1000
@@ -810,7 +810,7 @@ xfs_convert_page(
 			page_dirty--;
 			count++;
 		} else {
-			type = 0;
+			type = IOMAP_NEW;
 			if (buffer_mapped(bh) && all_bh && startio) {
 				lock_buffer(bh);
 				xfs_add_to_ioend(inode, bh, offset,
@@ -968,7 +968,6 @@ xfs_page_state_convert(
 
 	bh = head = page_buffers(page);
 	offset = page_offset(page);
-	iomap_valid = 0;
 	flags = BMAPI_READ;
 	type = IOMAP_NEW;
 

--=-Ol4eDZKyAzPXZLgYQsmK--
