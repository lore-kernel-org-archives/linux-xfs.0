Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 469EC2594
	for <linux-xfs@vger.kernel.org>; Thu, 19 Sep 2024 01:09:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726708187; cv=none; b=SR1DRvhZ8sOqpHfBY945+Jam+juYue+r7togeuINSjaiVLOb6MWdlEET57n4OE/G+HiPrvB1LmJFiuyspb6dXEtu5+76/nEvtW/ICmsj1zfRHJLV6xJBtHif0S0UcuDMr7UQ9m2nhlXTXgv4bKIg0e7W7ytaTEcZKa7B/N6mR80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726708187; c=relaxed/simple;
	bh=OTIv3FYiCIKI4C9BBf7c3x9fNMkPVEVXbvX5VB10dNc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=f227fna5jWbXaMxh9Dz0FAe3YMMGmVBqckRe2zZHvTlQeqdAP434CuWa7oRbD1niLV8KPZ1Kpd2yc9ci6zUhdgpoinaLWxXEPQH8gAQBJzLgbdn/QrK17zbQQqbseLbs8yoiJIFCqrrsMjal3WSBcrIMAB1s3yRtpMHERZZqLww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=1+uIFkOP; arc=none smtp.client-ip=209.85.215.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="1+uIFkOP"
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-7db299608e7so170451a12.1
        for <linux-xfs@vger.kernel.org>; Wed, 18 Sep 2024 18:09:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1726708184; x=1727312984; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=1Nay4qHIlTHvHCivOqitUXDgZRhfldRmAw4zYGRzdmE=;
        b=1+uIFkOPh6KENfCoMZ5U4Ja/2WTWXdvok+ae/LbQx7GsIFDt7jNqZJwLizvTAt/7Ie
         VhHhyWChhi2CDCJYJtwmX6ZO4z0ucHisnPbj9eDwnr2DOOVDrc+EzlOULi7GgiSbGEQu
         GUWGAaxqod4owmbJ5B5vVhmjWoJEzjNJvafJq2ux5Cg/OdszprtVhDm4QicQbQodw0uc
         drpcBZ3v2whhUgrYBzVG7+vYbmtB5tQAOP5fZ1FUKZecRRihXA97YVWwRATFlZGMWEeT
         Y9Xjq71BiChax6uyt8TUf2BTTZLaQmpJOIWm1vXyTzY/juQSSyrl/JA7Wfg+vkGQSDO1
         aRLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726708184; x=1727312984;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1Nay4qHIlTHvHCivOqitUXDgZRhfldRmAw4zYGRzdmE=;
        b=SoUbNpE8cUaacJdRb80Qb44x3dBxIFsooanaCzPwbtALZmRTCt/Mh8+u6T4Mek41Mz
         2H0kbEg5iN8LmhGhWV/NcJiZm6Nd4x0IGw09ygTxRlDkp2yo+P2+rVWd06AXnOb3S6eq
         lVLeTsommLidW50Fs4XwOUysaw9c4RSp+DN/pXf2IT6Vf2TaZVjTp8EDCp8Aatu21/fP
         FKLb8GSKOCspiJ5vCD8sCWF4TbONwuP42fYHNIhHXUSJtROQ+nyJoj3S6kPVTPXz+H6z
         6WAV+ZJuF24wgyYsgoxYYbXav0k8q2DMHysakXdpB3kIUC4FI6StLQGeY1kcQVz5Hlj/
         gdtg==
X-Forwarded-Encrypted: i=1; AJvYcCWVLOrsV+9U7uNaTtdAkj3QbiPG+zNHFu1cq9QeH0vvyrnUN8jtiNRnlexixL1iMq7i1vrvWdepVC8=@vger.kernel.org
X-Gm-Message-State: AOJu0YznxiV83Zk28nGSq8A+qqk/Lpuz6ZoGYNdaU+iuoLnUS/TsPpUT
	678jhb5fYzGWQdaNHmgTeXPA9nyj5gtOWlx9m+ii5cVW9ck/TOXTLGvK8sm9ZLQ=
X-Google-Smtp-Source: AGHT+IGSG5yV4WYTD3jKrpAA1YdO9HrP5nHKxT/ZVsTj8zhh2TKzKu2DW4NxE8tW7De0UOym/nmDog==
X-Received: by 2002:a17:90a:c784:b0:2c8:e888:26a2 with SMTP id 98e67ed59e1d1-2dbb9df174dmr24745674a91.13.1726708184360;
        Wed, 18 Sep 2024 18:09:44 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-78-197.pa.nsw.optusnet.com.au. [49.179.78.197])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2dd6eecf0a0sm374988a91.31.2024.09.18.18.09.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Sep 2024 18:09:43 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1sr5fw-00720Z-18;
	Thu, 19 Sep 2024 11:09:40 +1000
Date: Thu, 19 Sep 2024 11:09:40 +1000
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/4] xfs: create perag structures as soon as possible
 during log recovery
Message-ID: <Zut51Ftv/46Oj386@dread.disaster.area>
References: <20240910042855.3480387-1-hch@lst.de>
 <20240910042855.3480387-4-hch@lst.de>
 <ZueJusTG7CJ4jcp5@dread.disaster.area>
 <20240918061105.GA31947@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240918061105.GA31947@lst.de>

On Wed, Sep 18, 2024 at 08:11:05AM +0200, Christoph Hellwig wrote:
> On Mon, Sep 16, 2024 at 11:28:26AM +1000, Dave Chinner wrote:
> > I'm missing something - the intents aren't processed until the log
> > has been recovered - queuing an intent to be processed does
> > not require the per-ag to be present. We don't take per-ag
> > references until we are recovering the intent. i.e. we've completed
> > journal recovery and haven't found the corresponding EFD.
> > 
> > That leaves the EFI in the log->r_dfops, and we then run
> > ->recover_work in the second phase of recovery. It is
> > xfs_extent_free_recover_work() that creates the
> > new transaction and runs the EFI processing that requires the
> > perag references, isn't it?
> > 
> > IOWs, I don't see where the initial EFI/EFD recovery during the
> > checkpoint processing requires the newly created perags to be
> > present in memory for processing incomplete EFIs before the journal
> > recovery phase has completed.
> 
> So my new test actually blows up before creating intents:
> 
> [   81.695529] XFS (nvme1n1): Mounting V5 Filesystem 07057234-4bec-4f17-97c5-420c71c83292
> [   81.704541] XFS (nvme1n1): Starting recovery (logdev: internal)
> [   81.707260] XFS (nvme1n1): xfs_buf_map_verify: daddr 0x40003 out of range, EOFS 0x40000
> [   81.707974] ------------[ cut here ]------------
> [   81.708376] WARNING: CPU: 1 PID: 5004 at fs/xfs/xfs_buf.c:553 xfs_buf_get_map+0x8b4/0xb70
> 
> Because sb_dblocks hasn't been updated yet.

Hmmmmm. Ok, I can see how this would be an issue, but it's not the
issue the commit message describes :)

....

Oh, this is a -much worse- problem that I thought.

This is a replay for a modification to a new AGFL, and that *must*
only be replayed after the superblock modifications have been
replayed.

Ideally, we should not be using the new AGs until *after* the growfs
transaction has hit stable storage (i.e. the journal has fully
commmitted the growfs transaction), not just committed to the CIL.

If anything can access the new AGs beyond the old EOFS *before* the
growfs transaction is stable in the journal, then we have a nasty
set of race condtions where we can be making modifications to
metadata that is beyond EOFS in the journal *before* we've replayed
the superblock growfs modification.

For example:

growfs task		allocating task			log worker

xfs_trans_set_sync
xfs_trans_commit
  xlog_cil_commit
    <items added to CIL>
    xfs_trans_unreserve_and_mod_sb
      mp->m_sb.sb_agcount += tp->t_agcount_delta;
    ->iop_committing()
      xfs_buf_item_committing
        xfs_buf_item_release
          <superblock buffer unlocked>

<preempt>

			xfs_bmap_btalloc
			  xfs_bmap_btalloc_best_length
			    for_each_perag_wrap(...)
			      <sees new, uncommitted mp->m_sb.sb_agcount>
			      <selects new AG beyond EOFS in journal>
			  <does allocation in new AG beyond EOFS in journal>
			  xfs_trans_commit()
			    xlog_cil_commit()
			      <items added to CIL>
			  ....

							<log state in XLOG_STATE_COVER_NEED>
							xfs_sync_sb(wait)
							  locks sb buffer
							  xfs_trans_set_sync
							  xfs_trans_commit
							    xlog_cil_commit
							      <sb already in CIL>
							      <updates sb item order id>
							    xfs_log_force(SYNC)
							    <pushes CIL>

<runs again>
  xfs_log_force(SYNC)
  <pushes CIL>

This growfs vs allocating task race results in a checkpoint in the
journal where the new AGs are modified in the same checkpoint as the
growfs transaction. This will work if the superblock item is placed
in the journal before the items for the new AGs with your new code.

However...

.... when we add in the log worker (or some other transaction)
updating the superblock again before the CIL is pushed, we now have
a reordering problem. The CIL push will order all the items in the
CIL according to the order id attached to the log item, and this
causes the superblock item to be placed -after- the new AG items.

That will result in the exact recovery error you quoted above,
regardless of the fixes in this series.

<thinks about how to fix it>

I think the first step in avoiding this is ensuring we can't relog
the superblock until the growfs transaction is on disk. We can
do that by explicitly grabbing the superblock buffer and holding it
before we commit the transaction so the superblock buffer remains
locked until xfs_trans_commit() returns. That will prevent races
with other sb updates by blocking them on the sb buffer lock.

The second step is preventing allocations that are running from
seeing the mp->m_sb.sb_agcount update until after the transaction is
stable.

Ok, xfs_trans_mod_sb(XFS_TRANS_SB_AGCOUNT) is only used by the
grwofs code and the first step above means we have explicitly locked
the sb buffer. Hence the whole xfs_trans_mod_sb() -> delta in trans
-> xfs_trans_commit -> xfs_trans_apply_sb_deltas() -> lock sb buffer,
modify sb and log it -> xlog_cil_commit() song and dance routine can
go away.

i.e. We can modify the superblock buffer directly in the growfs
code, and then when xfs_trans_commit() returns we directly update
the in-memory superblock before unlocking the superblock buffer.

This means that nothing can update the superblock before the growfs
transaction is stable in the journal, and nothing at runtime will
see that there are new AGs or space available until after the on
disk state has changed.

This then allows recovery to be able to update the superblock and
perag state after checkpoint processing is complete. All future
checkpoint recoveries will now be guaranteed to see the correct
superblock state, whilst the checkpoint the growfs update is in
is guaranteed to only be dependent on the old superblock state...

I suspect that we might have to move all superblock updates to this
model - we don't update the in-memory state until after the on-disk
update is on stable storage in the journal - that will avoid the
possibility of racing/reordered feature bit update being replayed,
too.

The only issue with this is that I have a nagging memory of holding
the superblock buffer locked across a synchronous transaction could
deadlock the log force in some way. I can't find a reference to that
situation anywhere - maybe it wasn't a real issue, or someone else
remembers that situation better than I do....

> I'd kinda assume we run
> into the intents next, but maybe we don't.

I don't think intents are the problem because they are run after
the superblock and perags are updated.

> > > +	xfs_sb_from_disk(&mp->m_sb, dsb);
> > > +	if (mp->m_sb.sb_agcount < old_agcount) {
> > > +		xfs_alert(mp, "Shrinking AG count in log recovery");
> > > +		return -EFSCORRUPTED;
> > > +	}
> > > +	mp->m_features |= xfs_sb_version_to_features(&mp->m_sb);
> > 
> > I'm not sure this is safe. The item order in the checkpoint recovery
> > isn't guaranteed to be exactly the same as when feature bits are
> > modified at runtime. Hence there could be items in the checkpoint
> > that haven't yet been recovered that are dependent on the original
> > sb feature mask being present.  It may be OK to do this at the end
> > of the checkpoint being recovered.
> > 
> > I'm also not sure why this feature update code is being changed
> > because it's not mentioned at all in the commit message.
> 
> Mostly to keep the features in sync with the in-memory sb fields
> updated above.  I'll switch to keep this as-is, but I fail to see how
> updating features only after the entire reocvery is done will be safe
> for all cases either.
> 
> Where would we depend on the old feature setting?

One possibility is a similar reordering race to what I describe
above; another is simply that the superblock feature update is not
serialised at runtime with anything that checks that feature. Hence
the order of modifications in the journal may not reflect the order
in which the checks and modifications were done at runtime....

Hence I'm not convinced that it is safe to update superblock state
in the middle of a checkpoint - between checkpoints (i.e. after
checkpoint commit record processing) can be made safe (as per
above), but the relogging of items in the CIL makes mid-checkpoint
updates somewhat ... problematic.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
