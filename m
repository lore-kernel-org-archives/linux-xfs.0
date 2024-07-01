Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7315915ECCF
	for <linux-xfs@vger.kernel.org>; Mon,  1 Jul 2024 13:49:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719841781; cv=none; b=U99aUDzWvpnrx328h1tjNlkAObRjdbpqEO/GE9pNd1vypqn1w2oLhOJdRydmxfH13779rMNVrqpyqWuFvi/Xj3rnhlaxQZ4lytm3oRcN6uoXqZNBGuDCddRHWDe1A3JbeC1r1byImLowplXeNP+e+x5uEdiqDevZrwM2CEhsYr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719841781; c=relaxed/simple;
	bh=JRmjt6M1zrDefWhinxPjwL+BigzvExn5UQ3vGAyMhOU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=f4ImJa1K8YfC51SxtPq3WGt4WLc90lt7S/QKU+01rlX2HfGoh5ZDPAKELU1OSUl85jwD+cBO49BL5aM//bmqfvDm4mQTRHZtcYZZK7rixkjpRu2H7D/9fhMSG98NkRzBZ/RnZT/JFmJcVPu8Y+ftQdN1J/ZmfXhhW/89/w0cNzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com; spf=none smtp.mailfrom=toxicpanda.com; dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b=dj9VQCdG; arc=none smtp.client-ip=209.85.160.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b="dj9VQCdG"
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-4464284029dso33213271cf.1
        for <linux-xfs@vger.kernel.org>; Mon, 01 Jul 2024 06:49:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1719841777; x=1720446577; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=4/JXsQY1meprtTaQCBMH/rREZnhH9nYDIg327XZYrLM=;
        b=dj9VQCdGjly1zcriAcksl99UgVyIMkjXTC3I5cIMHOmmR9vqMnOTl85tgmTbuEeiWz
         OIOxthDp12zK9owBVARDxiJbsJfUsq8E7q8DvLR4MiviovimCZ5TK67F+KqeVA72ww/U
         qsXXlHkoTkVWfsOzAu6S56edTIp6vFLLat6Mgy7uKfJApDsw8hAdmaw2vruVwvqQ4V63
         0NgleIyzSSgQ+X07Qo5BgdArSt2FYwIPaHQMEhNUE0CEle3gN54vHQgq0E5sycuZpd1w
         vO7xhAOjwJwMG58Az+D8LVw8KvcZP0j2Cm29+ij52gCmRUzqZ7DsLUzyOXoSWQJXmYJt
         Mefw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719841777; x=1720446577;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4/JXsQY1meprtTaQCBMH/rREZnhH9nYDIg327XZYrLM=;
        b=Iwk9FmTEgy3Iiul/7YNY3ofoF8H8o5s45rn9aWe3jpQndFAb52elHJyC8PwiAyHX94
         R8cwbVomjTqwEfpPHH8n+v8RRiVSUouXhoFUIpxqdid6r1ILpZpRUTX+/D3slLOhRmnv
         YOk5ZWoUm8tmt9etb0NeIhgbnrgmZQgeiVRi+UvUHZxbTVM3lGlSs2NAV5cNDHQavrPo
         Riny0UtUW+U1fmiklIYJNN9BQI8kkOTR+q2bvHdgJcv3dHpD1T5E3h/0tUyRXP/onjoP
         kXrxZbyG2T9gxqehprycDFEPdq3/5QzTy1isuPfDKO4ZHoj98YE0IdpH91A258jFMEKm
         PaNQ==
X-Forwarded-Encrypted: i=1; AJvYcCXUiXDKlpFZtAJc4/uwv7av4HlGBE0V3nEUVhJAGw7tYrIt5HF8vhm9E9Ly5/MWD6mzIpOZbqcwxP6IBpeRy6NfNtDnY8e3T/q3
X-Gm-Message-State: AOJu0Yz4s4u/THZKu6WmePmavX8VA9csL0628OzzwOqdkmFV3b832qcI
	3Tbzijh5BKFGuS//vnVGkn2lE2ejpexoNXYAEnXy+SYzCTdw8JWK2NU8gGZVbCw=
X-Google-Smtp-Source: AGHT+IF5Q8o3oVoprCBhbVVvWMvB1AzB5Fn65AX5L6dAkIaxIGZIh7YN74qptGSpJhUhQ3WfUDtBdQ==
X-Received: by 2002:a05:6214:e6a:b0:6b5:198e:353d with SMTP id 6a1803df08f44-6b5a541bfcbmr122142846d6.10.1719841777433;
        Mon, 01 Jul 2024 06:49:37 -0700 (PDT)
Received: from localhost (syn-076-182-020-124.res.spectrum.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6b59e7436dcsm32788866d6.142.2024.07.01.06.49.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Jul 2024 06:49:37 -0700 (PDT)
Date: Mon, 1 Jul 2024 09:49:36 -0400
From: Josef Bacik <josef@toxicpanda.com>
To: Jeff Layton <jlayton@kernel.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>, Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>, Hugh Dickins <hughd@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andi Kleen <ak@linux.intel.com>, kernel-team@fb.com,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org,
	linux-mm@kvack.org, linux-nfs@vger.kernel.org
Subject: Re: [PATCH v2 09/11] btrfs: convert to multigrain timestamps
Message-ID: <20240701134936.GB504479@perftesting>
References: <20240701-mgtime-v2-0-19d412a940d9@kernel.org>
 <20240701-mgtime-v2-9-19d412a940d9@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240701-mgtime-v2-9-19d412a940d9@kernel.org>

On Mon, Jul 01, 2024 at 06:26:45AM -0400, Jeff Layton wrote:
> Enable multigrain timestamps, which should ensure that there is an
> apparent change to the timestamp whenever it has been written after
> being actively observed via getattr.
> 
> Beyond enabling the FS_MGTIME flag, this patch eliminates
> update_time_for_write, which goes to great pains to avoid in-memory
> stores. Just have it overwrite the timestamps unconditionally.
> 
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>  fs/btrfs/file.c  | 25 ++++---------------------
>  fs/btrfs/super.c |  3 ++-
>  2 files changed, 6 insertions(+), 22 deletions(-)
> 
> diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
> index d90138683a0a..409628c0c3cc 100644
> --- a/fs/btrfs/file.c
> +++ b/fs/btrfs/file.c
> @@ -1120,26 +1120,6 @@ void btrfs_check_nocow_unlock(struct btrfs_inode *inode)
>  	btrfs_drew_write_unlock(&inode->root->snapshot_lock);
>  }
>  
> -static void update_time_for_write(struct inode *inode)
> -{
> -	struct timespec64 now, ts;
> -
> -	if (IS_NOCMTIME(inode))
> -		return;
> -
> -	now = current_time(inode);
> -	ts = inode_get_mtime(inode);
> -	if (!timespec64_equal(&ts, &now))
> -		inode_set_mtime_to_ts(inode, now);
> -
> -	ts = inode_get_ctime(inode);
> -	if (!timespec64_equal(&ts, &now))
> -		inode_set_ctime_to_ts(inode, now);
> -
> -	if (IS_I_VERSION(inode))
> -		inode_inc_iversion(inode);
> -}
> -
>  static int btrfs_write_check(struct kiocb *iocb, struct iov_iter *from,
>  			     size_t count)
>  {
> @@ -1171,7 +1151,10 @@ static int btrfs_write_check(struct kiocb *iocb, struct iov_iter *from,
>  	 * need to start yet another transaction to update the inode as we will
>  	 * update the inode when we finish writing whatever data we write.
>  	 */
> -	update_time_for_write(inode);
> +	if (!IS_NOCMTIME(inode)) {
> +		inode_set_mtime_to_ts(inode, inode_set_ctime_current(inode));
> +		inode_inc_iversion(inode);

You've dropped the

if (IS_I_VERSION(inode))

check here, and it doesn't appear to be in inode_inc_iversion.  Is there a
reason for this?  Thanks,

Josef
