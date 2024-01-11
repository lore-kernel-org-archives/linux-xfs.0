Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 500A44D114
	for <linux-xfs@vger.kernel.org>; Thu, 11 Jan 2024 14:53:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AeRebPen"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1704984797;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9THL3jyOLUVyvjz1keRRqeaJQ/aHfiZ+kRtZV/Wf3Cc=;
	b=AeRebPenHt9xgkY86CrzSr2IGXi3dJr+x/sDg0xenyub3/ATZ2j1RlFf1vHikkayNU9Xp+
	x94S0YYoukgaod/h+v4vLj1zZvysmSUq9dbf2+pkgv9/yNDMoCUEcT/sIq4Ru8PwjyxpOr
	ddDEF2whWKELNajxW/22fCwzWltrOB4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-580-O_NxaxkoNyiUpzeKpZGPMw-1; Thu, 11 Jan 2024 09:53:11 -0500
X-MC-Unique: O_NxaxkoNyiUpzeKpZGPMw-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B39E686EB4F;
	Thu, 11 Jan 2024 14:53:02 +0000 (UTC)
Received: from bfoster (unknown [10.22.8.97])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 09D24492BCD;
	Thu, 11 Jan 2024 14:53:01 +0000 (UTC)
Date: Thu, 11 Jan 2024 09:54:20 -0500
From: Brian Foster <bfoster@redhat.com>
To: Dave Chinner <david@fromorbit.com>
Cc: Long Li <leo.lilong@huawei.com>, djwong@kernel.org,
	chandanbabu@kernel.org, linux-xfs@vger.kernel.org,
	yi.zhang@huawei.com, houtao1@huawei.com, yangerkun@huawei.com
Subject: Re: [PATCH] xfs: ensure submit buffers on LSN boundaries in error
 handlers
Message-ID: <ZaABHLQtysMr0hxs@bfoster>
References: <20231228124646.142757-1-leo.lilong@huawei.com>
 <ZZsiHu15pAMl+7aY@dread.disaster.area>
 <20240108122819.GA3770304@ceph-admin>
 <ZZyH85ghaJUO3xHE@dread.disaster.area>
 <ZZ1dtV1psURJnTOy@bfoster>
 <ZZ2+AwX3i7zze9iK@dread.disaster.area>
 <20240110070324.GA2070855@ceph-admin>
 <ZZ8jg1lhIlditBlt@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZZ8jg1lhIlditBlt@dread.disaster.area>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.9

On Thu, Jan 11, 2024 at 10:08:51AM +1100, Dave Chinner wrote:
> On Wed, Jan 10, 2024 at 03:03:24PM +0800, Long Li wrote:
> > On Wed, Jan 10, 2024 at 08:43:31AM +1100, Dave Chinner wrote:
> > > The issue is that the code as it stands doesn't handle object
> > > recovery from multiple checkpoints with the same start lsn. The
> > > easiest way to understand this is to look at the buffer submit logic
> > > on completion of a checkpoint:
> > > 
> > > 	if (log->l_recovery_lsn != trans->r_lsn &&
> > >             ohead->oh_flags & XLOG_COMMIT_TRANS) {
> > >                 error = xfs_buf_delwri_submit(buffer_list);
> > >                 if (error)
> > >                         return error;
> > >                 log->l_recovery_lsn = trans->r_lsn;
> > >         }
> > > 
> > > This submits the buffer list on the first checkpoint that completes
> > > with a new start LSN, not when all the checkpoints with the same
> > > start LSN complete. i.e.:
> > > 
> > > checkpoint  start LSN	commit lsn	submission on commit record
> > > A		32	  63		buffer list for A
> > > B		64	  68		buffer list for B
> > > C		64	  92		nothing, start lsn unchanged
> > > D		64	 127		nothing, start lsn unchanged
> > > E		128	 192		buffer list for C, D and E
> > > 
> > 
> > I have different understanding about this code. In the first checkpoint's
> > handle on commit record, buffer_list is empty and l_recovery_lsn update to
> > the first checkpoint's lsn, the result is that each checkpoint's submit
> > logic try to submit the buffers which was added to buffer list in checkpoint
> > recovery of previous LSN.
> > 
> >   xlog_do_recovery_pass
> >     LIST_HEAD (buffer_list);
> >     xlog_recover_process
> >       xlog_recover_process_data
> >         xlog_recover_process_ophdr
> >           xlog_recovery_process_trans
> >             if (log->l_recovery_lsn != trans->r_lsn &&
> >                 ohead->oh_flags & XLOG_COMMIT_TRANS) { 
> >               xfs_buf_delwri_submit(buffer_list); //submit buffer list
> >               log->l_recovery_lsn = trans->r_lsn;
> >             }
> >             xlog_recovery_process_trans
> >               xlog_recover_commit_trans
> >                 xlog_recover_items_pass2
> >                   item->ri_ops->commit_pass2
> >                     xlog_recover_buf_commit_pass2
> >                       xfs_buf_delwri_queue(bp, buffer_list) //add bp to buffer list
> >     if (!list_empty(&buffer_list)) 
> >       /* submit buffers that was added in checkpoint recovery of last LSN */
> >       xfs_buf_delwri_submit(&buffer_list)
> > 
> > So, I think it should be:
> >     
> > checkpoint  start LSN	commit lsn	submission on commit record
> > A		32	  63		nothing, buffer list is empty
> > B		64	  68		buffer list for A
> > C		64	  92		nothing, start lsn unchanged
> > D		64	 127		nothing, start lsn unchanged
> > E		128	 192		buffer list for B, C and D

Yeah, I managed to look through some of this code yesterday but hadn't
got back to this. I suspect the disconnect here is that the buffer list
isn't populated until we process the commit record for the associated
log transaction, and that occurs after the check to submit the buffer
list.

So when the commit record of A is seen, the recovery LSN is updated to
32 and the buffer list is still empty, and then is subsequently
populated based on the content of the transaction. From there, not until
we see a commit record for a transaction with a start LSN != 32 is the
buffer list submitted. This is how recovery knows there are no more
metadata lsn == 32 items, and the buffer list may include any number of
checkpoints that start at the current recovery lsn.

In general, this relies on proper commit record ordering which AFAIA
remains a pretty fundamental rule of XFS logging. It seems the confusion
has been resolved in any event, but something that comes to mind as
possibly beneficial to future readers is to perhaps consider turning
this submit check into a small helper with a proper name and any tweaks
that might help clarify the existing comment.

I think Dave's followup comments to invoke shutdown rather than play
games with cancellation make sense, so I'm particularly wondering if we
could just create an xlog_recovery_process_buffers() or some such helper
that could be reused in both places by conditionally doing the
shutdown/submit on error, and then documents everything nicely in once
place. Just a thought, however. It may not be worth it depending on how
ugly it looks.

Brian

> 
> You are right, I made a mistake in determining the order of buffer
> list submission vs checkpoint recovery taht builds a given buffer
> list. Mistakes happen when you only look at complex code once every
> few years. I will go back and look at the original patch again with
> this in mind.
> 
> -Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 

