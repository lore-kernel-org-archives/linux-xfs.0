Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 645E515EFB8
	for <linux-xfs@vger.kernel.org>; Mon,  1 Jul 2024 13:52:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719841979; cv=none; b=lgPKX2k08Y/z6x5gVM4tbhkBhaZxQhuvpVBQMpIVsWztgqLNNUtAPCIUXvBXfX8PVJXcNqkDFOxD7hr2K/3gL55RIXHQb20U5vSsqYzXm+WbRBelsq1p9A2Q3ixu4XZ0sOlysgGF0yC9Ll5iN8v5i8mLFCUUAv7JtUgFQbgzW7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719841979; c=relaxed/simple;
	bh=+u+pc3mw7MNX9ssnTjjenF2CQwjyjcXJmawou8D+PRc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nbfmGSiEaLJKJkh3uy+aWKyl58uzBzk4muV6xfYVPV6htQQfccCXxSrpF9PsJu/zSbePYKjVYE8QXMRPAqBjB9S65sI7hpA3oNkG+rr/DoNnKzjQFej/j9JWAP7Xybbqq1BukP6nJ77v043RKObjRuAOroQT+k6TR2o5UwuSF4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com; spf=none smtp.mailfrom=toxicpanda.com; dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b=3W0Lp/0Q; arc=none smtp.client-ip=209.85.160.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b="3W0Lp/0Q"
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-4450292a50bso24772301cf.1
        for <linux-xfs@vger.kernel.org>; Mon, 01 Jul 2024 06:52:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1719841976; x=1720446776; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=jKuw/nIkwEFc0H9vWonO0UW2rpxls958cLbHkMvMg2w=;
        b=3W0Lp/0QyGZbV+4fF2oi7qRSJJMtIlvoI1Rab4qAbeCcwSNxwUVsMA8+UnR73QoF2w
         9kRIIo35dmDI5wfqSPVjlHMmHP8TiSubCBr1cGqzk6GCXgsfJTi+lkNnHduxJxkGyDRT
         W7J0D81D/+gSQp+wPPwwgrTlr2uwKaikQ5YqAQq/0kSWer0a7G7njsu5u0CkM1Icc6M6
         Vv1brla3xbh604cKowMOPQ0mRNmu8MFHmf5v9MMyrYevi2Y5M2pqV0XfQ3/RLlA9swL5
         OckPAx0TA2iOZ4TkklBk+rWD2pytZjONVH5aXzVmBpMOCP+9C7bRwYp9c6QxoDCAUAvG
         43Cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719841976; x=1720446776;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jKuw/nIkwEFc0H9vWonO0UW2rpxls958cLbHkMvMg2w=;
        b=RI5IA9izBJFuvUs8jcK8XvUoyd36Cc3/jbYbi4cPlxgmEgrSWdkCKpOje8f2/6s08I
         9Sh2c8KekwbThzXMj7OWWhKw2bvZ5kDq4GF8B1sZoBw00Fz/qHlzAjrGwRAMnOVLb3j+
         8xf/TgY5MA9k/jPrJocwjXRzwINzHTL51iJAkYQrXWocdT/r16NrwM8YHxEvXn2+ARjg
         mVyPZ0EsxtfjNPp5zi6jIl6hOYcru/2Gm8DycEAqwmnCE/lahomUV0hndD82vmuQbEbG
         7eSQfpySkAwjfjwMD9IrN0ZkwrckNfhol/1aqMypwSpkQr0sa8c03heBQOfThaw21H7x
         OXag==
X-Forwarded-Encrypted: i=1; AJvYcCWhZt7TIHxwPDMPhPTa+Q/FAoCQ6ZIZp/ALE8jJCXoem36JYezGD+IzqYyTHvGQ+4fXtfGoroNW9vRprC53Dn7HLNkQ3HP0q25f
X-Gm-Message-State: AOJu0YwoTo3CkzHeh9Aw5q43Q7yQvIg7aZhfju45Zl7/uLn1s3nX9Z1c
	ODnhUI7QbIiv3d+y6Glvdj4qvSmmRMfXDl2l274cMGNSaMjAUlf1Xq7NqZmI5zU=
X-Google-Smtp-Source: AGHT+IG0odLHf0JhbhZb8Muk3vgjQvMvDZGGoTkntSJ6AQwPL3He86crHRASswudCYGbceV8muYfdQ==
X-Received: by 2002:ac8:7f12:0:b0:441:55dd:b4f3 with SMTP id d75a77b69052e-44662eb927emr81392241cf.63.1719841976260;
        Mon, 01 Jul 2024 06:52:56 -0700 (PDT)
Received: from localhost (syn-076-182-020-124.res.spectrum.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-446513dbccfsm31269871cf.19.2024.07.01.06.52.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Jul 2024 06:52:55 -0700 (PDT)
Date: Mon, 1 Jul 2024 09:52:55 -0400
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
Subject: Re: [PATCH v2 11/11] Documentation: add a new file documenting
 multigrain timestamps
Message-ID: <20240701135255.GC504479@perftesting>
References: <20240701-mgtime-v2-0-19d412a940d9@kernel.org>
 <20240701-mgtime-v2-11-19d412a940d9@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240701-mgtime-v2-11-19d412a940d9@kernel.org>

On Mon, Jul 01, 2024 at 06:26:47AM -0400, Jeff Layton wrote:
> Add a high-level document that describes how multigrain timestamps work,
> rationale for them, and some info about implementation and tradeoffs.
> 
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>  Documentation/filesystems/multigrain-ts.rst | 126 ++++++++++++++++++++++++++++
>  1 file changed, 126 insertions(+)
> 
> diff --git a/Documentation/filesystems/multigrain-ts.rst b/Documentation/filesystems/multigrain-ts.rst
> new file mode 100644
> index 000000000000..beef7f79108c
> --- /dev/null
> +++ b/Documentation/filesystems/multigrain-ts.rst
> @@ -0,0 +1,126 @@
> +.. SPDX-License-Identifier: GPL-2.0
> +
> +=====================
> +Multigrain Timestamps
> +=====================
> +
> +Introduction
> +============
> +Historically, the kernel has always used a coarse time values to stamp
> +inodes. This value is updated on every jiffy, so any change that happens
> +within that jiffy will end up with the same timestamp.
> +
> +When the kernel goes to stamp an inode (due to a read or write), it first gets
> +the current time and then compares it to the existing timestamp(s) to see
> +whether anything will change. If nothing changed, then it can avoid updating
> +the inode's metadata.
> +
> +Coarse timestamps are therefore good from a performance standpoint, since they
> +reduce the need for metadata updates, but bad from the standpoint of
> +determining whether anything has changed, since a lot of things can happen in a
> +jiffy.
> +
> +They are particularly troublesome with NFSv3, where unchanging timestamps can
> +make it difficult to tell whether to invalidate caches. NFSv4 provides a
> +dedicated change attribute that should always show a visible change, but not
> +all filesystems implement this properly, and many just populating this with
> +the ctime.
> +
> +Multigrain timestamps aim to remedy this by selectively using fine-grained
> +timestamps when a file has had its timestamps queried recently, and the current
> +coarse-grained time does not cause a change.
> +
> +Inode Timestamps
> +================
> +There are currently 3 timestamps in the inode that are updated to the current
> +wallclock time on different activity:
> +
> +ctime:
> +  The inode change time. This is stamped with the current time whenever
> +  the inode's metadata is changed. Note that this value is not settable
> +  from userland.
> +
> +mtime:
> +  The inode modification time. This is stamped with the current time
> +  any time a file's contents change.
> +
> +atime:
> +  The inode access time. This is stamped whenever an inode's contents are
> +  read. Widely considered to be a terrible mistake. Usually avoided with
> +  options like noatime or relatime.
> +
> +Updating the mtime always implies a change to the ctime, but updating the
> +atime due to a read request does not.
> +
> +Multigrain timestamps are only tracked for the ctime and the mtime. atimes are
> +not affected and always use the coarse-grained value (subject to the floor).
> +
> +Inode Timestamp Ordering
> +========================
> +
> +In addition just providing info about changes to individual files, file
> +timestamps also serve an important purpose in applications like "make". These
> +programs measure timestamps in order to determine whether source files might be
> +newer than cached objects.
> +
> +Userland applications like make can only determine ordering based on
> +operational boundaries. For a syscall those are the syscall entry and exit
> +points. For io_uring or nfsd operations, that's the request submission and
> +response. In the case of concurrent operations, userland can make no
> +determination about the order in which things will occur.
> +
> +For instance, if a single thread modifies one file, and then another file in
> +sequence, the second file must show an equal or later mtime than the first. The
> +same is true if two threads are issuing similar operations that do not overlap
> +in time.
> +
> +If however, two threads have racing syscalls that overlap in time, then there
> +is no such guarantee, and the second file may appear to have been modified
> +before, after or at the same time as the first, regardless of which one was
> +submitted first.
> +
> +Multigrain Timestamps
> +=====================
> +Multigrain timestamps are aimed at ensuring that changes to a single file are
> +always recognizeable, without violating the ordering guarantees when multiple
> +different files are modified. This affects the mtime and the ctime, but the
> +atime will always use coarse-grained timestamps.
> +
> +It uses the lowest-order bit in the timestamp as a flag that indicates whether
> +the mtime or ctime have been queried. If either or both have, then the kernel
> +takes special care to ensure the next timestamp update will display a visible
> +change. This ensures tight cache coherency for use-cases like NFS, without
> +sacrificing the benefits of reduced metadata updates when files aren't being
> +watched.
> +
> +The ctime Floor Value
> +=====================
> +It's not sufficient to simply use fine or coarse-grained timestamps based on
> +whether the mtime or ctime has been queried. A file could get a fine grained
> +timestamp, and then a second file modified later could get a coarse-grained one
> +that appears earlier than the first, which would break the kernel's timestamp
> +ordering guarantees.
> +
> +To mitigate this problem, we maintain a per-time_namespace floor value that

You dropped this bit in the series, so this isn't correct, should just be

"we maintain a floor value"

Thanks,

Josef
