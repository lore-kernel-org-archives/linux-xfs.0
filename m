Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3EA01EC4CD
	for <linux-xfs@vger.kernel.org>; Wed, 11 Dec 2024 22:24:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733955862; cv=none; b=rBvBHX+sB2CbHnu0LQ9Q2aVCRBIHlQk+bcJcG2F6TmbMo7y23fjXCwFWNQdjFAyPz0wHubQ8eEWjG6cqN3liF4XAUvipA/69CeD2YEhqSW8G1XS9jP01vDHZa1UMm1LMfa4I2kxGEkItrTlCMVIuW4b1Bgooioi1yUjPNda2gpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733955862; c=relaxed/simple;
	bh=6+0kY2SnMkoSJMLU/PnQ6SLTQBkIa9/sfq35CpMuVh8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EXVT+a7/GSjT7LwzyF4smpafjAPDp7mbfE3ze9/npuOgkpPoL1g8s9xiQ9sAF5pCjSBsm24dyt2GjHaZD2EEY0kzeFYCVIr3Ue03+mlGH2lTpAigdRSreQq7jEfIFm6tKX78tot2kP+5cLNQEYr6WYR/MchrA5ZXPxKdvSiiPBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=Ov4S7O17; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="Ov4S7O17"
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-728e3826211so1917408b3a.0
        for <linux-xfs@vger.kernel.org>; Wed, 11 Dec 2024 14:24:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1733955859; x=1734560659; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=i/OXOSS59KpXWLSRiTlhErK28NZ3P3T+cMliyOEXlN8=;
        b=Ov4S7O17arU3Tu8pW481v89lqTtWF4ePIKMhC7FGRIqf4VNWlgPGgi/Kt88FCo8ZGp
         f8dEIPd0GFFGCgaXNmzGnNPmvrlf2SbddU0srYcnj4x/mXv3z6HxJJDxPtATi9c7Va61
         RmA46HiG3SARQfNuUG81hZ4cC9mZcUGl6m+SRlPaZiHhOGCbFXap0BoKmAfwM0yq5Wum
         Fmg6c68SqbsttHQwSknMLrYnrNw5sw9k4mIK1VzpUlM9L0PR4me8AZ/JQZTMCOm8bOa7
         h97hqnIdeHQQuKaBbaQlemSuozuSihTGTDsX+gcUVv1FvWgFu16phNp6eHnVMKC5kHP0
         vebw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733955859; x=1734560659;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=i/OXOSS59KpXWLSRiTlhErK28NZ3P3T+cMliyOEXlN8=;
        b=rXLR7QEh3R6F/k4Oc5NcjWx2cK/ok9RpXck5jF8Bzo208Iso4m+atT2ZjBF0o2q8Ah
         gOa+pjfbxC2hglfhwzziS8bEzuCll+aeY5Bm1tHfTSsz619XQWIMyEUH7B7VjCYvEViU
         1RTtmOhTfSTCgRg6KyXPgug1nWrDW2URqQ0fudqKeoGuV7h1Dp+CbO5CHKQgQxL8vzb5
         vmY4hebsi9Q79IylDusWBmeQIaCIVhQOAK5ih6BEsZFU3Ir0acPfknwIVSaRmGKngOdb
         4en6XM2tlr8a3euA5Ry/HgPTagd6UrNV4S36/gHh/sJC4KnJuPZoMOp17rjPP8vIx4Ya
         qmIQ==
X-Gm-Message-State: AOJu0Yw8HxYg7uf1ashx4qmj8KddYIKqeMfqF6UlUBWhLwcZyxbwDADM
	UrNfEkM68CT5wYZRo446UmYQFZdcqghCwAQzUx3XaqqR0cl2XqDKkujniHtJ3r9FbXduJD/jUhg
	s
X-Gm-Gg: ASbGncv0V09MjLRXpm5ZYXVEQM4miOkMkKzDj5oBlXZps+ErsFDTi4gd1o4/rqa0TWB
	Jk2/rlWDiP9vadEihTliNg9zjsGYu3GnPgn5BMh2W6F9dMumnNZi4NmjdaQmP7SGX7XT9bVsUph
	YcGAXksGKh1pvWkB4TqwJGfTer4vJzCdxJzcOvBgvTt8dmIT0UnfG7f6A4nlR1KXOK1vcWA0oKX
	cn3YiwNH6IxsOJxqOCKzFCQcmw3yJyp5GXqpQ8sPS2jJtRjDj29mKP4LcWXkTN4p4aQvzSkKifL
	5MSSUwH5rFCQfwdvRpeDGc+AjQM=
X-Google-Smtp-Source: AGHT+IHexhsTVxV3jBeU9dw2jdBS3JYx2d6n7RegQraf93DIDoiRSjCetj6vGrS2VKEPNmNNtcmeew==
X-Received: by 2002:a05:6a20:258a:b0:1e1:a829:bfb6 with SMTP id adf61e73a8af0-1e1cea52239mr1513551637.3.1733955858994;
        Wed, 11 Dec 2024 14:24:18 -0800 (PST)
Received: from dread.disaster.area (pa49-195-9-235.pa.nsw.optusnet.com.au. [49.195.9.235])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7fd3f31e1afsm7425423a12.41.2024.12.11.14.24.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Dec 2024 14:24:18 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.98)
	(envelope-from <david@fromorbit.com>)
	id 1tLV7v-00000009Z0p-0oOH;
	Thu, 12 Dec 2024 09:24:15 +1100
Date: Thu, 12 Dec 2024 09:24:15 +1100
From: Dave Chinner <david@fromorbit.com>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org, hch@lst.de, djwong@kernel.org,
	dchinner@fromorbit.com
Subject: Re: [PATCH] xfs: fix integer overflow in xlog_grant_head_check
Message-ID: <Z1oRD_QgWpAuBM53@dread.disaster.area>
References: <20241210124628.578843-1-cem@kernel.org>
 <Z1jG_4IRUaFmwT_E@dread.disaster.area>
 <xxvk3ckwdnz2h6vyaizsepwp2cv7hig5kspfveg636mj2b4kmu@hupkcvrltvkg>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <xxvk3ckwdnz2h6vyaizsepwp2cv7hig5kspfveg636mj2b4kmu@hupkcvrltvkg>

On Wed, Dec 11, 2024 at 12:55:30PM +0100, Carlos Maiolino wrote:
> > i.e. by definition xlog_grant_space_left() must be returning
> > free_bytes > log->l_logsize to overflow an int. The cause of that
> > behaviour is what we need to find and fix....
> > 
> > We should have enough trace points in the AIL and log head/tail
> > accounting to see where the head, tail or space calculation is going
> > wrong during the mount - do you have a trace from the failed mount
> > that I can look at?  i.e. run 'trace-cmd record -e xfs\* sleep 60'
> > in one terminal, then run the reproducer in another. Then when
> > the trace finishes, run `trace-cmd report > t.txt` and point me at
> > the generated report...
> 
> Yes, indeed I tried to look into the trace, but I couldn't find anything that
> stands out to me, but, as I said, I don't have enough knowledge in the logging
> mechanism yet to get something meaningful out of it.
> 
> One thing that stands out to me, but it doesn't seem to be the cause of it. was
> the size of the grant heads, but IIRC, you mentioned this is correct as they are
> not initialized at the time:
> 
> mount-1504  [009]   146.457545: xfs_log_reserve:      dev 252:18 tic 0xffffa084d7e93900    \
> t_ocnt 1 t_cnt 1 t_curr_res 2740 t_unit_res 2740 t_flags reserveq empty writeq empty tail  \
> space 0 grant_reserve_bytes 18446744072634764800 grant_write_bytes 18446744072634764800    \
> curr_cycle 1 curr_block 7 tail_cycle 1 tail_block 0

Ok, "grant_reserve_bytes 18446744072634764800" is the problem here.
We've had a grant head underflow.

Let's go through the final xfs_log* traces leading up to that - I'll
trim them to the relevant info:

           mount-1504 xfs_log_force:         lsn 0x0 caller xfs_qm_dqflush+0x272
           mount-1504 xfs_log_force:         lsn 0x1 caller xfs_log_force+0x99	

Ok, so we have log force coming from xfs_qm_dqflush(). That has been
translated into a CIL flush with a sequence number of 1 (second
trace).

   kworker/u74:3-686  xfs_log_ticket_ungrant: t_curr_res 49744 t_unit_res 2100 tail space 0 grant_reserve_bytes 53080 curr_cycle 1 curr_block 0 tail_cycle 1 tail_block 0
   kworker/u74:3-686  xfs_log_ticket_ungrant_exit: t_curr_res 49744 tail space 0 grant_reserve_bytes 3336 grant_write_bytes 3336

This is the CIL push worker releasing the CIL context ticket. Note
that the grant head still has a positive reservation of 3336 bytes
when the CIL context log ticket is released. This looks correct -
53080 - 49744 = 3336...

However, the curr_cycle/block and tail cycle/block look suspect - a
lsn of 1/0 implies a fully empty journal and mkfs on Linux does not
do that. Not to mention we supposedly have a dirty journal to
replay. i.e.  the logprint shows that the dirty log region that was
recovered spanned from 1/2 to 1/9. That means all these items should
be being written at a LSN of at least 1/10. I'll come back to this.

Given this is quota mount, there should not be anything else with
an outstanding log ticket reservation at this point.

           mount-1504 xlog_iclog_switch:     state XLOG_STATE_ACTIVE refcnt 1 offset 2824 lsn 0x100000000
           mount-1504 xlog_iclog_release:    state XLOG_STATE_WANT_SYNC refcnt 1 offset 2824 lsn 0x100000000
           mount-1504 xlog_iclog_syncing:    state XLOG_STATE_SYNCING refcnt 0 offset 2824 lsn 0x100000000

iclogs being flushed by the log force. The lsn stamped into the
iclog looks suspect, too, but I think they are derived from
the curr cycle/block values so at least they match.

           mount-1504 xfs_log_force:         lsn 0x0 caller xfs_qm_dqflush+0x272
           mount-1504 xfs_log_force:         lsn 0x2 caller xfs_log_force+0x99

A second log force from dquot flushing, this time for CIL sequence
2. The CIL is empty, as are the iclogs, so nothing happens.

           mount-1504 xfs_log_force:         lsn 0x0 caller xfs_qm_dqflush+0x272
           mount-1504 xfs_log_force:         lsn 0x2 caller xfs_log_force+0x99

Same again - a third log force which is also a no-op.

    kworker/9:1H-456  xfs_log_assign_tail_lsn:  new tail lsn 1/0, old lsn 1/0, head lsn 1/0
    kworker/9:1H-456  xfs_log_assign_tail_lsn:  new tail lsn 1/0, old lsn 1/0, head lsn 1/0

Ok, that looks like metadata IO completion (from AIL pushing) that
has removed the item at the tail of the log.

Those tail/head LSN values definitely aren't right. These are
supposed to reflect the location in the log that they were written
to, but the do reflect the curr cycle/block, so at least they are
consistent

           mount-1504 xfs_log_reserve:      dev 252:18 tic 0xffffa084d7e93900 t_ocnt 1 t_cnt 1 t_curr_res 2740 t_unit_res 2740 t_flags  reserveq empty writeq empty tail space 0 grant_reserve_bytes 18446744072634764800 grant_write_bytes 18446744072634764800 curr_cycle 1 curr_block 7 tail_cycle 1 tail_block 0

And the next transaction sees the initial state of the grant head as
having underflowed.  18446744072634764800 = 0xffffffffbff00e00,
so it has underflowed by a *lot*. i.e. the number as a signed int is
-1074786816.

Also, note that the curr_cycle/block is now 1/7, which reflects
where the head of the log now sits after the log flush. So this part
of the log head update is working, and it points to curr cycle/block
initialisation during log recovery being the problem here - log
recovery is not finding the head and tail of the log correctly.

Now that I go looking for it, I'm having a WTF moment - I can't see
any fragments of log recovery in the trace. I do not see any of the
buffer cache IO normally associated with finding the head and tail
of the log at all.

Something isn't right there. Log recovery apparently didn't run, so
the journal has not been initialised for writing (hence the curr
cycle/block being 1/0), yet we are running transactions?

In talking to Carlos, there's a little detail that was missing.
The reproducer is actually:

mount -o ro,norecovery,usrquota,grpquota,prjquota  /dev/vdb2 /mnt

Which I found from a second trace with "-e printk" added to dump the
kernel console output in the trace:

mount-1600  [007]   387.031578: console:              XFS (vdb2): Mounting V5 filesystem 3e13f429-fb23-4c8a-a3c8-1c90ec7e9a67 in no-recovery mode. Filesystem will be inconsistent.

Yup, that'll do it.

i.e. the problem isn't that there is an integer overflow in the
grant head or space calculation, the problem is that we're running
quotacheck on a ro,norecovery filesystem. quotacheck requires a
consistent filesystem w/ a writable journal because it runs
transactions.

Running transactions on a "ro,norecovery" filesystem is bad.

Real Bad.

That's the bug that needs to be fixed here, and it has probably
been around for a long, long time...

> > > in xlog_grant_head_check() to evaluate to true and cause xfsaild to try
> > > to flush the log indefinitely, which seems to be causing xfs to get
> > > stuck in xlog_grant_head_wait() indefinitely.
> > > 
> > > I'm adding a fixes tag as a suggestion from hch, giving that after the
> > > aforementioned patch, all xlog_grant_space_left() callers should store
> > > the return value on a 64bit type.
> > > 
> > > Fixes: c1220522ef40 ("xfs: grant heads track byte counts, not LSNs")
> > 
> > I'm not sure this is actually the source of the issue, or
> > whether it simply exposed some other underlying problem we aren't
> > yet aware of....

.... which is what I kinda suspected in the first place.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
