Return-Path: <SRS0=vNgo=5K=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0B19C43331
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Mar 2020 11:25:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 84EE220771
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Mar 2020 11:25:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gRPU1LIp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726906AbgCYLZI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 25 Mar 2020 07:25:08 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:24476 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727158AbgCYLZI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Mar 2020 07:25:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585135506;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9oXze1UOUB/n7wWuJGJynBFTn/tfgR8Zs5Z33pqNfXo=;
        b=gRPU1LIp2X3rlNM+7HT1rb6b0KF+h9VBy2QgKg97I0gTkcLoCnRdhSCmEt3t0Ar6mvF0jO
        ixz+JYAx3ASZkHcj4GkN0dy0QsU0znVeis1M4HohWSavAfCFzIDRJRDPUxUqizrzAzr1H4
        U4/q0MlqS1oYEgr5jyYsfzhrbxyawpo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-466-GoclT0YcMCag29g4HaODcw-1; Wed, 25 Mar 2020 07:25:05 -0400
X-MC-Unique: GoclT0YcMCag29g4HaODcw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 41E45800D50;
        Wed, 25 Mar 2020 11:25:04 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id EE0D65D9C5;
        Wed, 25 Mar 2020 11:25:03 +0000 (UTC)
Date:   Wed, 25 Mar 2020 07:25:02 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: shutdown on failure to add page to log bio
Message-ID: <20200325112502.GB10922@bfoster>
References: <20200324165700.7575-1-bfoster@redhat.com>
 <20200325071225.GA17629@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200325071225.GA17629@infradead.org>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 25, 2020 at 12:12:25AM -0700, Christoph Hellwig wrote:
> On Tue, Mar 24, 2020 at 12:57:00PM -0400, Brian Foster wrote:
> > Rather than warn about writing out a corrupted log buffer, shutdown
> > the fs as is done for any log I/O related error. This preserves the
> > consistency of the physical log such that log recovery succeeds on a
> > subsequent mount. Note that this was observed on a 64k page debug
> > kernel without upstream commit 59bb47985c1d ("mm, sl[aou]b:
> > guarantee natural alignment for kmalloc(power-of-two)"), which
> > demonstrated frequent iclog bio overflows due to unaligned (slab
> > allocated) iclog data buffers.
> 
> Weird..
> 
> >  static void
> >  xlog_map_iclog_data(
> > -	struct bio		*bio,
> > -	void			*data,
> > +	struct xlog_in_core	*iclog,
> >  	size_t			count)
> >  {
> > +	struct xfs_mount	*mp = iclog->ic_log->l_mp;
> > +	struct bio		*bio = &iclog->ic_bio;
> > +	void			*data = iclog->ic_data;
> > +
> >  	do {
> >  		struct page	*page = kmem_to_page(data);
> >  		unsigned int	off = offset_in_page(data);
> >  		size_t		len = min_t(size_t, count, PAGE_SIZE - off);
> >  
> > -		WARN_ON_ONCE(bio_add_page(bio, page, len, off) != len);
> > +		if (bio_add_page(bio, page, len, off) != len) {
> > +			xfs_force_shutdown(mp, SHUTDOWN_LOG_IO_ERROR);
> > +			break;
> > +		}
> >  
> >  		data += len;
> >  		count -= len;
> > @@ -1762,7 +1768,7 @@ xlog_write_iclog(
> >  	if (need_flush)
> >  		iclog->ic_bio.bi_opf |= REQ_PREFLUSH;
> >  
> > -	xlog_map_iclog_data(&iclog->ic_bio, iclog->ic_data, count);
> > +	xlog_map_iclog_data(iclog, count);
> 
> Can you just return an error from xlog_map_iclog_data and shut down
> in the caller?  Besides keeping the abstraction levels similar I had
> also hoped to lift xlog_map_iclog_data into the block layer eventually.
> 

Sure. That's probably more appropriate now that I look again because it
looks like we still submit the current bio with this patch. Something
like the following..?

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 2a90a483c2d6..92a58a6bc32b 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -1703,7 +1703,7 @@ xlog_bio_end_io(
 		   &iclog->ic_end_io_work);
 }
 
-static void
+static int
 xlog_map_iclog_data(
 	struct bio		*bio,
 	void			*data,
@@ -1714,11 +1714,14 @@ xlog_map_iclog_data(
 		unsigned int	off = offset_in_page(data);
 		size_t		len = min_t(size_t, count, PAGE_SIZE - off);
 
-		WARN_ON_ONCE(bio_add_page(bio, page, len, off) != len);
+		if (bio_add_page(bio, page, len, off) != len)
+			break;
 
 		data += len;
 		count -= len;
 	} while (count);
+
+	return count;
 }
 
 STATIC void
@@ -1762,7 +1765,10 @@ xlog_write_iclog(
 	if (need_flush)
 		iclog->ic_bio.bi_opf |= REQ_PREFLUSH;
 
-	xlog_map_iclog_data(&iclog->ic_bio, iclog->ic_data, count);
+	if (xlog_map_iclog_data(&iclog->ic_bio, iclog->ic_data, count)) {
+		xfs_force_shutdown(log->l_mp, SHUTDOWN_LOG_IO_ERROR);
+		return;
+	}
 	if (is_vmalloc_addr(iclog->ic_data))
 		flush_kernel_vmap_range(iclog->ic_data, count);
 

