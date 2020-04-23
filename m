Return-Path: <SRS0=GxFA=6H=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5C28C54FCB
	for <linux-xfs@archiver.kernel.org>; Thu, 23 Apr 2020 14:29:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9AE562074F
	for <linux-xfs@archiver.kernel.org>; Thu, 23 Apr 2020 14:29:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QhShjdZm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726068AbgDWO3G (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 23 Apr 2020 10:29:06 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:46479 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726060AbgDWO3F (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 23 Apr 2020 10:29:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587652144;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=htAD+x/pWwf8phBAXCDCQQPG9uePeoICXJLkZiflGrA=;
        b=QhShjdZml9kbe4rUb9akmwM8n5++/cIRdNgaHXgxlfSeKbHhJ43Cdd7/b6kRdVSGe/ps0F
        q1xm4S2x/FlZ4KfX44GPvJuhx+wv5Nnrdt5eJouMzNSB1VST10F17GgDQuBYEvi109pWzA
        NMyFOx/qsOrV/762obuw7GC3/+l8z6M=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-191-7LyxMoOdMde1C8L1AwVooA-1; Thu, 23 Apr 2020 10:29:02 -0400
X-MC-Unique: 7LyxMoOdMde1C8L1AwVooA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3FBE9801E5D;
        Thu, 23 Apr 2020 14:29:01 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id EC26A196AE;
        Thu, 23 Apr 2020 14:29:00 +0000 (UTC)
Date:   Thu, 23 Apr 2020 10:28:59 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2 03/13] xfs: fallthru to buffer attach on error and
 simplify error handling
Message-ID: <20200423142859.GA43557@bfoster>
References: <20200422175429.38957-1-bfoster@redhat.com>
 <20200422175429.38957-4-bfoster@redhat.com>
 <20200423041823.GH27860@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200423041823.GH27860@dread.disaster.area>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Apr 23, 2020 at 02:18:23PM +1000, Dave Chinner wrote:
> On Wed, Apr 22, 2020 at 01:54:19PM -0400, Brian Foster wrote:
> > The inode flush code has several layers of error handling between
> > the inode and cluster flushing code. If the inode flush fails before
> > acquiring the backing buffer, the inode flush is aborted. If the
> > cluster flush fails, the current inode flush is aborted and the
> > cluster buffer is failed to handle the initial inode and any others
> > that might have been attached before the error.
> > 
> > Since xfs_iflush() is the only caller of xfs_iflush_cluster(), the
> > error handling between the two can be condensed in the top-level
> > function. If we update xfs_iflush_int() to always fall through to
> > the log item update and attach the item completion handler to the
> > buffer, any errors that occur after the first call to
> > xfs_iflush_int() can be handled with a buffer I/O failure.
> > 
> > Lift the error handling from xfs_iflush_cluster() into xfs_iflush()
> > and consolidate with the existing error handling. This also replaces
> > the need to release the buffer because failing the buffer with
> > XBF_ASYNC drops the current reference.
> > 
> > Signed-off-by: Brian Foster <bfoster@redhat.com>
> 
> Needs a better subject line, because I had no idea what it meant
> until I got to the last hunks in the patch.  Perhaps: "Simplify
> inode flush error handling" would be a better summary of the
> patch....
> 

Ok, fixed.

> > @@ -3791,6 +3758,7 @@ xfs_iflush_int(
> >  	struct xfs_inode_log_item *iip = ip->i_itemp;
> >  	struct xfs_dinode	*dip;
> >  	struct xfs_mount	*mp = ip->i_mount;
> > +	int			error;
> 
> There needs to be a comment added to this function to explain why we
> always attached the inode to the buffer and update the flush state,
> even on error. This:
> 

Indeed. Updated as follows with a comment before the first corruption
check:

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 6cdb9fbe2d89..6b8266eeae2d 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -3766,9 +3766,14 @@ xfs_iflush_int(
 	       ip->i_d.di_nextents > XFS_IFORK_MAXEXT(ip, XFS_DATA_FORK));
 	ASSERT(iip != NULL && iip->ili_fields != 0);
 
-	/* set *dip = inode's place in the buffer */
 	dip = xfs_buf_offset(bp, ip->i_imap.im_boffset);
 
+	/*
+	 * We don't flush the inode if any of the following checks fail, but we
+	 * do still update the log item and attach to the backing buffer as if
+	 * the flush happened. This is a formality to facilitate predictable
+	 * error handling as the caller will shutdown and fail the buffer.
+	 */
 	error = -EFSCORRUPTED;
 	if (XFS_TEST_ERROR(dip->di_magic != cpu_to_be16(XFS_DINODE_MAGIC),
 			       mp, XFS_ERRTAG_IFLUSH_1)) {

Brian

> > @@ -3914,10 +3885,10 @@ xfs_iflush_int(
> >  				&iip->ili_item.li_lsn);
> >  
> >  	/*
> > -	 * Attach the function xfs_iflush_done to the inode's
> > -	 * buffer.  This will remove the inode from the AIL
> > -	 * and unlock the inode's flush lock when the inode is
> > -	 * completely written to disk.
> > +	 * Attach the inode item callback to the buffer whether the flush
> > +	 * succeeded or not. If not, the caller will shut down and fail I/O
> > +	 * completion on the buffer to remove the inode from the AIL and release
> > +	 * the flush lock.
> >  	 */
> >  	xfs_buf_attach_iodone(bp, xfs_iflush_done, &iip->ili_item);
> 
> isn't obviously associated with the "flush_out" label, and so the
> structure of the function really isn't explained until you get to
> the end of the function. And that's still easy to miss...
> 
> Other than that, the code looks OK.
> 
> CHeers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 

