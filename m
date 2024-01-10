Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81B934F898
	for <linux-xfs@vger.kernel.org>; Wed, 10 Jan 2024 23:08:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="SE1PQ52W"
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-1d4df66529bso24299795ad.1
        for <linux-xfs@vger.kernel.org>; Wed, 10 Jan 2024 15:08:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1704928135; x=1705532935; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=8OJ9OJUFrbpzXB3wREadsO0egvzqdW/M39np+VQeLoI=;
        b=SE1PQ52WcLCqjr0JKJ30QGztbj7hSkhMFQit+od2OD+3yRq+87oBEJcZ6FxA4kU1Tx
         v0AWJW/FwYydAH/1knaz+fuMbIiks3QR5IGhbtqDzmV0ThujbB7QYkoBGYeTbTwjGdEK
         EPIOzbbkvdiNTRSeu0ZR2gKbBFT4n0P3VtGZdWK260x46Nrrf30b2uFB17Kbx6rFeh9/
         ilmE/JInM7bu4xP1DaQh+3rSuyUnSr9h6gnJCOw9705IfQgPHwcDDz3/EbkbIJ9g4VMU
         WNR1kcjSuwZ0pTPqvdNpHaTF8t6KzPO/qxIVNDf16O9ClA5A6t1wAtRqXXPHqNoHMIYm
         86sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704928135; x=1705532935;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8OJ9OJUFrbpzXB3wREadsO0egvzqdW/M39np+VQeLoI=;
        b=PZ+qtwA1PF9K5H0Fn9JkA5i5DJFn3XHL4zot9M2FXBEVkO3SnJBtd/kXZNfipuJXTr
         RtwnrKSSBtG/sZCLhv5WXnSknGcNWLnkYeMFbllBAjhTRFiMs5WRuLLteu8JqG4AnFQt
         p4LfMbxS7vEUF1AabGZvCGwlpuDqOdJgEU8wU4ltQZpRQWL5d46Fm3OiVzGp2lUP/yVC
         TtlcAIA0gZiWFhPi/m5eZEW8dkSI74y/1HAI4NeGs+3/qh53SrO4V28w9wq1HclOcih3
         xOdsbLkAawYLU9uQJRlU7D4VhpzCIsNTpBWeQeoq17v0gh7h9yRXh84ckDsL4A8UYixh
         /zEA==
X-Gm-Message-State: AOJu0YyazAWBSbZu820M27RKOz3GiUZdjrXsQUKncn3PbIW/lLCjD8ex
	02XiUnkOYVUV536S5rPeNvkKw/eTsfRnJg==
X-Google-Smtp-Source: AGHT+IHbc4riXQNN9xYMyR0tM0e7oA9TqaHxXU2wl1ncaKlGpaCBz5IUqKzHD8/frqZoJj0dsOvoOw==
X-Received: by 2002:a17:902:e882:b0:1d4:97a:7f4d with SMTP id w2-20020a170902e88200b001d4097a7f4dmr313109plg.37.1704928134813;
        Wed, 10 Jan 2024 15:08:54 -0800 (PST)
Received: from dread.disaster.area (pa49-180-249-6.pa.nsw.optusnet.com.au. [49.180.249.6])
        by smtp.gmail.com with ESMTPSA id s2-20020a17090302c200b001cf6783fd41sm4200290plk.17.2024.01.10.15.08.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Jan 2024 15:08:54 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1rNhgp-008hlR-1g;
	Thu, 11 Jan 2024 10:08:51 +1100
Date: Thu, 11 Jan 2024 10:08:51 +1100
From: Dave Chinner <david@fromorbit.com>
To: Long Li <leo.lilong@huawei.com>
Cc: Brian Foster <bfoster@redhat.com>, djwong@kernel.org,
	chandanbabu@kernel.org, linux-xfs@vger.kernel.org,
	yi.zhang@huawei.com, houtao1@huawei.com, yangerkun@huawei.com
Subject: Re: [PATCH] xfs: ensure submit buffers on LSN boundaries in error
 handlers
Message-ID: <ZZ8jg1lhIlditBlt@dread.disaster.area>
References: <20231228124646.142757-1-leo.lilong@huawei.com>
 <ZZsiHu15pAMl+7aY@dread.disaster.area>
 <20240108122819.GA3770304@ceph-admin>
 <ZZyH85ghaJUO3xHE@dread.disaster.area>
 <ZZ1dtV1psURJnTOy@bfoster>
 <ZZ2+AwX3i7zze9iK@dread.disaster.area>
 <20240110070324.GA2070855@ceph-admin>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240110070324.GA2070855@ceph-admin>

On Wed, Jan 10, 2024 at 03:03:24PM +0800, Long Li wrote:
> On Wed, Jan 10, 2024 at 08:43:31AM +1100, Dave Chinner wrote:
> > The issue is that the code as it stands doesn't handle object
> > recovery from multiple checkpoints with the same start lsn. The
> > easiest way to understand this is to look at the buffer submit logic
> > on completion of a checkpoint:
> > 
> > 	if (log->l_recovery_lsn != trans->r_lsn &&
> >             ohead->oh_flags & XLOG_COMMIT_TRANS) {
> >                 error = xfs_buf_delwri_submit(buffer_list);
> >                 if (error)
> >                         return error;
> >                 log->l_recovery_lsn = trans->r_lsn;
> >         }
> > 
> > This submits the buffer list on the first checkpoint that completes
> > with a new start LSN, not when all the checkpoints with the same
> > start LSN complete. i.e.:
> > 
> > checkpoint  start LSN	commit lsn	submission on commit record
> > A		32	  63		buffer list for A
> > B		64	  68		buffer list for B
> > C		64	  92		nothing, start lsn unchanged
> > D		64	 127		nothing, start lsn unchanged
> > E		128	 192		buffer list for C, D and E
> > 
> 
> I have different understanding about this code. In the first checkpoint's
> handle on commit record, buffer_list is empty and l_recovery_lsn update to
> the first checkpoint's lsn, the result is that each checkpoint's submit
> logic try to submit the buffers which was added to buffer list in checkpoint
> recovery of previous LSN.
> 
>   xlog_do_recovery_pass
>     LIST_HEAD (buffer_list);
>     xlog_recover_process
>       xlog_recover_process_data
>         xlog_recover_process_ophdr
>           xlog_recovery_process_trans
>             if (log->l_recovery_lsn != trans->r_lsn &&
>                 ohead->oh_flags & XLOG_COMMIT_TRANS) { 
>               xfs_buf_delwri_submit(buffer_list); //submit buffer list
>               log->l_recovery_lsn = trans->r_lsn;
>             }
>             xlog_recovery_process_trans
>               xlog_recover_commit_trans
>                 xlog_recover_items_pass2
>                   item->ri_ops->commit_pass2
>                     xlog_recover_buf_commit_pass2
>                       xfs_buf_delwri_queue(bp, buffer_list) //add bp to buffer list
>     if (!list_empty(&buffer_list)) 
>       /* submit buffers that was added in checkpoint recovery of last LSN */
>       xfs_buf_delwri_submit(&buffer_list)
> 
> So, I think it should be:
>     
> checkpoint  start LSN	commit lsn	submission on commit record
> A		32	  63		nothing, buffer list is empty
> B		64	  68		buffer list for A
> C		64	  92		nothing, start lsn unchanged
> D		64	 127		nothing, start lsn unchanged
> E		128	 192		buffer list for B, C and D

You are right, I made a mistake in determining the order of buffer
list submission vs checkpoint recovery taht builds a given buffer
list. Mistakes happen when you only look at complex code once every
few years. I will go back and look at the original patch again with
this in mind.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
