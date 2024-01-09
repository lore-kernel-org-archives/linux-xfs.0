Received: from mail-oi1-f169.google.com (mail-oi1-f169.google.com [209.85.167.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B9C739AC6
	for <linux-xfs@vger.kernel.org>; Tue,  9 Jan 2024 21:43:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="CAo5tay0"
Received: by mail-oi1-f169.google.com with SMTP id 5614622812f47-3bc1414b48eso3823719b6e.2
        for <linux-xfs@vger.kernel.org>; Tue, 09 Jan 2024 13:43:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1704836615; x=1705441415; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=TXBFOPWGuTkMTIAcYPL2OtqhFE6cEn7M1Pu8f/BtQzI=;
        b=CAo5tay0B2vAjD6XBuV9t5vfTB9z/3op6srq6J+/EOSvSJ3qpfx77OLesYxbTzrV7d
         ha4wEncOfiIOsdO4aaLkp9mUgTVf9ZsFkEvhoo8gM8GJlA9EMEI3g0eW2i9IKMUXU+bi
         BvrmpaWUrBBJk02u1h3TZRo0VvLwbrHvN5YrmpsqL7itJkMHP2nC/y0BWNz/XAS0uYYf
         MyIynDK2fRV7dmAUz52+aP3U4/oVRYdP/Va3Da9UpVy65dII6ie7X41KwNGgzCwpqwNG
         TGadeW1bort94PMp2QzVusCAD5V70CBIGvt98kIM/m4b/8rYCVuXWVO7LwQkD8Ws0MWF
         IFOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704836615; x=1705441415;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TXBFOPWGuTkMTIAcYPL2OtqhFE6cEn7M1Pu8f/BtQzI=;
        b=GzB/LWGXIhC+pmEcJ68SCBWa6jD06m8MKQHh0KEdZZcgj+AzykNj3Vc9BAfWiYAxZS
         Mj8UqqTQRr++Z2nHszVsZcg7na3poKQzhHJDA/FMZ93dJVbcTbPUrr+hvYqGWbcHxWct
         KBhg3SrDQbFMS4wm9e9rQE9MpzZLkrzlHT6F2sO+sNxKOVKuUQG3FmtRXhjFwjSAQ70U
         bSmKVNfPHGF8p5HFYorhylkv2oX7cEpGX3QY0Ug05kyw4ln2IPZF8D3txaerfU/Q6QcG
         o0jGwPug1vQixCZCVlJMPXmI1Srj0AuvAfsB5yfF3y6LsoJ7vDL0+TNodDgsS1CyYtkJ
         D1iw==
X-Gm-Message-State: AOJu0YxFqB+/KlweLSwQ8z1UkbPblaty133L6BCkO7M4yOn3Fplqh2Es
	XgbZdwu3ZoIPCQ0O37FjFCSd3kPFh0YleQ==
X-Google-Smtp-Source: AGHT+IEpX+cO44NpxBkaVewd3DM0l9CnGkZdYcSdz7Cso7wKxV5wRZnU4TxulSSlc+qjwkyi0SW2tw==
X-Received: by 2002:a05:6358:8829:b0:170:17eb:9c45 with SMTP id hv41-20020a056358882900b0017017eb9c45mr8314rwb.38.1704836614892;
        Tue, 09 Jan 2024 13:43:34 -0800 (PST)
Received: from dread.disaster.area (pa49-180-249-6.pa.nsw.optusnet.com.au. [49.180.249.6])
        by smtp.gmail.com with ESMTPSA id p10-20020a170902780a00b001d493ff1fcdsm2317737pll.120.2024.01.09.13.43.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Jan 2024 13:43:34 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1rNJsh-008EyA-2o;
	Wed, 10 Jan 2024 08:43:31 +1100
Date: Wed, 10 Jan 2024 08:43:31 +1100
From: Dave Chinner <david@fromorbit.com>
To: Brian Foster <bfoster@redhat.com>
Cc: Long Li <leo.lilong@huawei.com>, djwong@kernel.org,
	chandanbabu@kernel.org, linux-xfs@vger.kernel.org,
	yi.zhang@huawei.com, houtao1@huawei.com, yangerkun@huawei.com
Subject: Re: [PATCH] xfs: ensure submit buffers on LSN boundaries in error
 handlers
Message-ID: <ZZ2+AwX3i7zze9iK@dread.disaster.area>
References: <20231228124646.142757-1-leo.lilong@huawei.com>
 <ZZsiHu15pAMl+7aY@dread.disaster.area>
 <20240108122819.GA3770304@ceph-admin>
 <ZZyH85ghaJUO3xHE@dread.disaster.area>
 <ZZ1dtV1psURJnTOy@bfoster>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZZ1dtV1psURJnTOy@bfoster>

On Tue, Jan 09, 2024 at 09:52:37AM -0500, Brian Foster wrote:
> > 
> > The problem we need to solve is how we preserve the necessary
> > anti-recovery behaviour when we have multiple checkpoints that can
> > have the same LSN and objects are updated immediately on recovery?
> > 
> > I suspect that we need to track that the checkpoint being recovered
> > has a duplicate start LSN (i.e. in the struct xlog_recover) and
> > modify the anti-recovery LSN check to take this into account. i.e.
> > we can really only skip recovery of the first checkpoint at any
> > given LSN because we cannot disambiguate an LSN updated by the first
> > checkpoint at that LSN and the metadata already being up to date on
> > disk in the second and subsequent checkpoints at the same start
> > LSN.
> > 
> > There are likely to be other solutions - anyone have a different
> > idea on how we might address this?
> > 
> 
> It's been a while since I've looked at any of this and I haven't waded
> through all of the details, so I could easily be missing something, but
> what exactly is wrong with the approach of the patch as posted?

That it fails to address the fact that the code as implemented
violates the "only submit buffers on LSN change" invariant. Hence we
have silent failure to recover of the second set of changes
to a log item  recorded in the multiple checkpoints that have the
same start LSN.

The original problem described in the commit - a shutdown due to a
freespace btree record corruption - has been something we've seen
semi-regularly for a few years now. We've never got to the
bottom of the problem because we've lacked a reliable reproducer for
the issue.

The analysis and debug information provided by out by Long indicates
that when multiple checkpoints start at the same LSN, the objects in
the later checkpoints (based on commit record ordering) won't get
replayed because the LSN in the object has already been updated by
the first checkpoint. Hence they skip recovery in the second (and
subsequent) checkpoints at the same start LSN.

In a lot of these cases, the object will be logged again later in
the recovery process, thereby overwriting the corruption caused by
skipping a checkpointed update. Hence this will only be exposed in
normal situations if the silent recovery failure occurs on the last
modification of the object in the journal.

This is why it's a rare failure to be seen in production systems,
but it is something that hindsight tells us has been occurring given
the repeated reports of unexplainable single record free space btree
corruption we've had over the past few years.

> Commit 12818d24db ("xfs: rework log recovery to submit buffers on LSN
> boundaries") basically created a new invariant for log recovery where
> buffers are allowed to be written only once per LSN. The risk otherwise
> is that a subsequent update with a matching LSN would not be correctly
> applied due to the v5 LSN ordering rules. Since log recovery processes
> transactions (using terminology/granularity as defined by the
> implementation of xlog_recover_commit_trans()), this required changes to
> accommodate any of the various possible runtime logging scenarios that
> could cause a buffer to have multiple entries in the log associated with
> a single LSN, the details of which were orthogonal to the fix.
> 
> The functional change therefore was that rather than to process and
> submit "transactions" in sequence during recovery, the pending buffer
> list was lifted to a higher level in the code, a tracking field was
> added for the "current LSN" of log recovery, and only once we cross a
> current LSN boundary are we allowed to submit the set of buffers
> processed for the prior LSN. The reason for this logic is that seeing
> the next LSN was really the only way we know we're done processing items
> for a particular LSN.

Yes, and therein lies one of the problems with the current
implementation - this "lsn has changed" logic is incorrect.

> If I understand the problem description correctly, the issue here is
> that if an error is encountered in the middle of processing items for
> some LSN A, we bail out of recovery and submit the pending buffers on
> the way out.  If we haven't completed processing all items for LSN A
> before failing, however, then we've just possibly violated the "write
> once per LSN" invariant that protects from corrupting the fs.

The error handling and/or repeated runs of log recovery simply
exposes the problem - these symptoms are not the problem that needs
to be fixed.

The issue is that the code as it stands doesn't handle object
recovery from multiple checkpoints with the same start lsn. The
easiest way to understand this is to look at the buffer submit logic
on completion of a checkpoint:

	if (log->l_recovery_lsn != trans->r_lsn &&
            ohead->oh_flags & XLOG_COMMIT_TRANS) {
                error = xfs_buf_delwri_submit(buffer_list);
                if (error)
                        return error;
                log->l_recovery_lsn = trans->r_lsn;
        }

This submits the buffer list on the first checkpoint that completes
with a new start LSN, not when all the checkpoints with the same
start LSN complete. i.e.:

checkpoint  start LSN	commit lsn	submission on commit record
A		32	  63		buffer list for A
B		64	  68		buffer list for B
C		64	  92		nothing, start lsn unchanged
D		64	 127		nothing, start lsn unchanged
E		128	 192		buffer list for C, D and E

IOWs, the invariant "don't submit buffers until LSN changes" is not
actually implemented correctly by this code. This is the obvious
aspect of the problem, but addressing buffer submission doesn't
actually fix the problem.

That is, changing buffer submission to be correct doesn't address
the fact that we've already done things like updated the LSN in
inodes and dquots during recovery of those objects. Hence,
regardless of whether we submit the buffers or not, changes to
non-buffer objects in checkpoints C and D will never get recovered
directly if they were originally modified in checkpoint B.

This is the problem we need to address: if we have multiple
checkpoints at the same start LSN, we need to ensure that all the
changes to any object in any of the checkpoints at that start LSN
are recovered. This is what we are not doing, and this is the root
cause of the problem....

-Dave.
-- 
Dave Chinner
david@fromorbit.com
