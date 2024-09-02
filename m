Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64BCB13E8A5
	for <linux-xfs@vger.kernel.org>; Mon,  2 Sep 2024 13:24:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725283446; cv=none; b=I1I43tmsQPV3SQimA3kkPrP8tbhqmr/iQcZnpXXlsgPe2JUOww4qMvWbsJYQIpJKZIWZ0sQHf2wUHB8XHuX9DGYf9WNuof7kmApd1bh4n4VYhNiI75ddULDivHA2JqkvXIUgq5X+7hFnsdDhNDk7BggKlCxK9O7gNER0SFjbiKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725283446; c=relaxed/simple;
	bh=4LDVn3Bfs/Hi0hxD4qlICgj3CT+fVX4gwkz4VfvjM58=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OccidBuAkBxvoqlEJAtFBrNqmBpm2kBBrDRDrnWODOzJC8QOXkpfnKd+54fqxko5J6kBqwRhTnLqL/ibaGMKPzeUusXRUiqNJWli3wvTDwH688tCwc5msZUT99Z8mRrNxZ6obSt/bi8Y2WLopltD9EUXrGV9h/G7RemwRQrbvS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=elrTwaup; arc=none smtp.client-ip=209.85.215.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="elrTwaup"
Received: by mail-pg1-f169.google.com with SMTP id 41be03b00d2f7-7cd835872ceso2851256a12.3
        for <linux-xfs@vger.kernel.org>; Mon, 02 Sep 2024 06:24:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1725283444; x=1725888244; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Pspem6P5ZJTDhqkFuDQ6C2ukgD+zWGkfPmAo59YZ/68=;
        b=elrTwaup/2duJfHtFmiMj1RFCl4R1NjUgVBHkdIDxbDaiYl6wDJTA7GGhhslki4zlA
         4L5vPzXNL0X5Zq1E4KELS2izDpKaZp5pSDb+0DMcAwUZD8NibDAwCyC08IElrFFPCB5H
         D8BLjrWUjAgFigtXA4VSvJiT5x0VnkLs7R1g50mgUQCrZIafznl8/P62vSK2uMSi4/Ul
         KXjXIgXHbgodw8KeC+IML8nquhRtZbgfmPDmeqhicDYBbBsvfsHlzkuIuY9vM7Rvoq/2
         dqXRq8EePeZ8XHpLgAwwAzTTUJH8Su6obm2AceBa/VxIhn8ljPNoeJzRfndk8mDmwaIC
         ofGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725283444; x=1725888244;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Pspem6P5ZJTDhqkFuDQ6C2ukgD+zWGkfPmAo59YZ/68=;
        b=S2c2tFCrNdlSetwepbiZWYKOZTTg+d7hFIzC8QY6V7dvzsOERX07dmsoe8XBB1ipOs
         CwGvVv8L5vpYoHVC5l0EcuuxxbDJNaATzqyuSMGEZRt6Bs7qgR1IyVUo6lbCMmOwbA/x
         HGnKO3u/UNRzLe9vOT+0C3jGj7JU1PZpX9xCSb2bx58c/h8UWknrjpP2cxRFAyskZoFK
         L3EMImfOm3e3kfd29UmHhRoPWljQuuYTMGtBMO4mhKDHGRYD81I06URGAPCp3vTvlg0v
         4DwKBJ+OEAGfyeBnp9lk29KaQU19dmbhDL+TYG8R/d3VBcaXYHS680BacH2XmMPPN5tJ
         /kOA==
X-Gm-Message-State: AOJu0Yy+ftqP5ZgBjVHbiqu8udV36owALTPucVV4TnvSx/1cDq4xx7Fl
	UsH6/XI2h0ziPpVDf7OtA6624BH17IUOSnfKpzoEyi0DADh0jCrppKJNhK9+Ois=
X-Google-Smtp-Source: AGHT+IFUDqB3eWfxlLc3jEUXXfXjAoV3eYAo+toJwJKUxsJo8Rofn/za4HvCuhklNja7DweyLAqxhw==
X-Received: by 2002:a17:90a:ce8f:b0:2d1:ca16:554d with SMTP id 98e67ed59e1d1-2d893284d70mr5578928a91.4.1725283443536;
        Mon, 02 Sep 2024 06:24:03 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-0-65.pa.nsw.optusnet.com.au. [49.179.0.65])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2d8ebdf56c0sm1559367a91.23.2024.09.02.06.24.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Sep 2024 06:24:02 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1sl72G-0045tv-1A;
	Mon, 02 Sep 2024 23:24:00 +1000
Date: Mon, 2 Sep 2024 23:24:00 +1000
From: Dave Chinner <david@fromorbit.com>
To: Chandan Babu R <chandanbabu@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [RFC PATCH] xfs: Prevent umount from indefinitely waiting on
 XFS_IFLUSHING flag on stale inodes
Message-ID: <ZtW8cIgjK88RrB77@dread.disaster.area>
References: <20240902075045.1037365-1-chandanbabu@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240902075045.1037365-1-chandanbabu@kernel.org>

On Mon, Sep 02, 2024 at 01:20:41PM +0530, Chandan Babu R wrote:
> Executing xfs/057 can lead to an unmount task to wait indefinitely for
> XFS_IFLUSHING flag on some inodes to be cleared. The following timeline
> describes as to how inodes can get into such a state.
> 
>   Task A               Task B                      Iclog endio processing
>   ----------------------------------------------------------------------------
>   Inodes are freed
> 
>   Inodes items are
>   added to the CIL
> 
>   CIL contents are
>   written to iclog
> 
>   iclog->ic_fail_crc
>   is set to true
> 
>   iclog is submitted
>   for writing to the
>   disk
> 
>                        Last inode in the cluster
>                        buffer is freed
> 
>                        XFS_[ISTALE/IFLUSHING] is
>                        set on all inodes in the
>                        cluster buffer
> 
>                        XFS_STALE is set on
>                        the cluster buffer
>                                                    iclog crc error is detected
>                        ...                         during endio processing
>                        During xfs_trans_commit,    Set XFS_LI_ABORTED on inode
>                        log shutdown is detected    items
>                        on xfs_buf_log_item         - Unpin the inode since it
>                                                    is stale and return -1
>                        xfs_buf_log_item is freed

How do we get the buffer log item freed here? It should be in the
CIL and/or the AIL because the unlinked inode list updates should
have already logged directly to that buffer and committed in in
previous transactions. 

>                                                    Inode log items are not
>                        xfs_buf is not freed here   processed further since
>                        since b_hold has a          xfs_inode_item_committed()
>                        non-zero value              returns -1
>
> During normal operation, the stale inodes are processed by
> xfs_buf_item_unpin() => xfs_buf_inode_iodone(). This ends up calling
> xfs_iflush_abort() which in turn clears the XFS_IFLUSHING flag. However, in
> the case of this bug, the xfs_buf_log_item is freed just before the high level
> transaction is committed to the CIL.
>
> To overcome this bug, this commit removes the check for log shutdown during
> high level transaction commit operation. The log items in the high level
> transaction will now be committed to the CIL despite the log being
> shutdown. This will allow the CIL processing logic (i.e. xlog_cil_push_work())
> to invoke xlog_cil_committed() as part of error handling. This will cause
> xfs_buf log item to to be unpinned and the corresponding inodes to be aborted
> and have their XFS_IFLUSHING flag cleared.

I don't know exactly how the problem arose, but I can say for
certain that the proposed fix is not valid.  Removing that specific
log shutdown check re-opens a race condition which can causes on
disk corruption. The shutdown was specifically placed to close that
race - See commit 3c4cb76bce43 ("xfs: xfs_trans_commit() path must
check for log shutdown") for details.

I have no idea what the right way to fix this is yet, but removing
the shutdown check isn't it...

-Dave.
-- 
Dave Chinner
david@fromorbit.com
