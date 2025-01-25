Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF0D32EB10;
	Sat, 25 Jan 2025 08:43:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737794614; cv=none; b=W1nCry00ak5dGpFNGtTdVK53itl1nU9M3foqmcRgxoizqSsaE9w9Ru69rNjIAAdCweFy+MDVNfABccwcACvyvbt6f2I2LjRZkRumG6bqlpuok24lbw4Lm7diLSIDxjTn2XBdlHJICPE9m5yT0rSntGwNexaaV4aphZyXgmpen9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737794614; c=relaxed/simple;
	bh=kgY/odhb/yEGMOVucC8pJsunR7ynQmJGct1e5jsnVeg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rbPqCBqr4R3vVYoWBpTktyQX6u5LqnzefuLKo5C3QCBfEWMZci3r+dsrBAdbTispMgMQQVuke+efj6CjBh3zPtVGteJu9sARrmzHfeTQEFIDnm9yhYYlWxUGxO80cAS/e1sOufSDbKJzUj/Z3RRLL0VVbx1dlhpkiVVA5+cHHgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=V0SRviF7; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="V0SRviF7"
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2161eb94cceso35661415ad.2;
        Sat, 25 Jan 2025 00:43:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1737794612; x=1738399412; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PRddBr+ksHW+AUbt7rEdGhzIdtiCHaJCww176acEJfY=;
        b=V0SRviF783gq+bFNWtkZP6LFkBIj9tD3VzxG9q5TaGap+KQTnaHciw/4xa9LHPe4iM
         YiPTWa0tL2QFhDL2n6vShDcisL0dASwvCJD3CTWlDESCoLPB6HlmsTmIULNGrT8fqW79
         +Ej7IBVB4hfD0L4X9BZks/WP2CkSdnMPXRojTYwmyu+qUydhHH4KUGUMJfCChZJVf4DU
         d0pbsh27u7bH83qECYclagGcyVL1XsdHiaEiiHKNlYIwpNLA3AfB6Qup1rJMr5+iyUgf
         +wAK2JF2d6O+K36a8wFi6eczx2ERu+OyA02qUVQ21feCCNMeTYMeeDGa2u7ZzdfylcdH
         RJ4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737794612; x=1738399412;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PRddBr+ksHW+AUbt7rEdGhzIdtiCHaJCww176acEJfY=;
        b=bJ3wrClDJob2psrlQ/E8+kudrF6sdc8WpOi8ma4zdN84g+0PELFcbrgwUa2s8pyWOo
         H7a1uJl2J4jMqLkAk5GccsIV+xVmm2gneg8pkrqzNe1i7OXRcMW5lww2jl8ZRE21nIy6
         ktJHxybBa+HskUxAx5Xl11vW+1C0JLxuBOeUgqApmyXTOZQBd36Gb+5HqVRMn+ti1qZm
         stANxEzNSv3R+cxpMxZcKXjnneYihxzKjrgudDbU7vdihV1Ok2BkbHl+Xfx3gK0ffXIA
         fOx7XOztQ+/u429ngXQKgW/5cWLw7EW6LAJsK6idF3mnI21Y500Rn7uMoRqmtdRb0d4i
         3hmg==
X-Forwarded-Encrypted: i=1; AJvYcCUhxBrdFqd5IgaqVsSRAD/0CvJebdnM1hiBs28rsqj4pVYsWpTyH1q2HNbBbpgNBGN/SIuiAAjfkfq+@vger.kernel.org, AJvYcCVgNxn1uyRQjjkTlLgvvCwmFoPSD+8AucGK7IneIc1vq/ADlPYN09o8ue3ir2FISrMBTYCM2ghE1xAPKhw=@vger.kernel.org
X-Gm-Message-State: AOJu0YyhwvRGd4zHFReVFxGIzj+kPX2dGXW7XzxBMvY3Uy+ceV/gzokJ
	hUcRJDo+2IPMFUPQD24nigh4bSuD2FykJm2PDkkD4JTMpcwvxDLL
X-Gm-Gg: ASbGnct1dlA0O2j2hqLojlLoyde/l9D+TeoXKEuDUQbBIXDuGXDWDmyPi/oq7+EDzga
	ufLBEFoOP0LE4ApXs0ArXB4XmGPrwEMYtG2taXpGIcQkjXof56WHxUoa/19oGq0eBzugcYdzXp9
	xTddKVJVl8dclhecDZtSmcitNXwX4402C+DEYbQLtinBxeDaWuSrm1u76brfYpiv/9Udamb0f1V
	d42es32F4uGrsA4F//2w06K4RbP2sG5ibpDuDh19JtFsyyprYy9MMEeVi3aQD+8B+vd8FB8ExLh
	TY01icxTvbD8T92gobml
X-Google-Smtp-Source: AGHT+IEHFhyAHnvk7B878Kivw+JtkI9S38cYegP3e49v5YKZ3UGfcScKWT1NnD8Mv70lXnfjqcjJNw==
X-Received: by 2002:a05:6a20:9149:b0:1e5:ddac:1ed7 with SMTP id adf61e73a8af0-1eb2147ea8dmr49469592637.12.1737794611878;
        Sat, 25 Jan 2025 00:43:31 -0800 (PST)
Received: from localhost.localdomain ([119.28.17.178])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-ac48f89732csm2835194a12.20.2025.01.25.00.43.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Jan 2025 00:43:31 -0800 (PST)
From: Jinliang Zheng <alexjlzheng@gmail.com>
X-Google-Original-From: Jinliang Zheng <alexjlzheng@tencent.com>
To: amir73il@gmail.com
Cc: cem@kernel.org,
	chizhiling@163.com,
	chizhiling@kylinos.cn,
	david@fromorbit.com,
	djwong@kernel.org,
	john.g.garry@oracle.com,
	linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: Remove i_rwsem lock in buffered read
Date: Sat, 25 Jan 2025 16:43:25 +0800
Message-ID: <20250125084327.154410-1-alexjlzheng@tencent.com>
X-Mailer: git-send-email 2.41.1
In-Reply-To: <CAOQ4uxgUZuMXpe3DX1dO58=RJ3LLOO1Y0XJivqzB_4A32tF9vA@mail.gmail.com>
References: <CAOQ4uxgUZuMXpe3DX1dO58=RJ3LLOO1Y0XJivqzB_4A32tF9vA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On Tue, 7 Jan 2025 13:13:17 +0100, Amir Goldstein <amir73il@gmail.com> wrote:
> On Mon, Dec 30, 2024 at 3:43 AM Chi Zhiling <chizhiling@163.com> wrote:
> >
> >
> >
> > On 2024/12/29 06:17, Dave Chinner wrote:
> > > On Sat, Dec 28, 2024 at 03:37:41PM +0800, Chi Zhiling wrote:
> > >>
> > >>
> > >> On 2024/12/27 05:50, Dave Chinner wrote:
> > >>> On Thu, Dec 26, 2024 at 02:16:02PM +0800, Chi Zhiling wrote:
> > >>>> From: Chi Zhiling <chizhiling@kylinos.cn>
> > >>>>
> > >>>> Using an rwsem to protect file data ensures that we can always obtain a
> > >>>> completed modification. But due to the lock, we need to wait for the
> > >>>> write process to release the rwsem before we can read it, even if we are
> > >>>> reading a different region of the file. This could take a lot of time
> > >>>> when many processes need to write and read this file.
> > >>>>
> > >>>> On the other hand, The ext4 filesystem and others do not hold the lock
> > >>>> during buffered reading, which make the ext4 have better performance in
> > >>>> that case. Therefore, I think it will be fine if we remove the lock in
> > >>>> xfs, as most applications can handle this situation.
> > >>>
> > >>> Nope.
> > >>>
> > >>> This means that XFS loses high level serialisation of incoming IO
> > >>> against operations like truncate, fallocate, pnfs operations, etc.
> > >>>
> > >>> We've been through this multiple times before; the solution lies in
> > >>> doing the work to make buffered writes use shared locking, not
> > >>> removing shared locking from buffered reads.
> > >>
> > >> You mean using shared locking for buffered reads and writes, right?
> > >>
> > >> I think it's a great idea. In theory, write operations can be performed
> > >> simultaneously if they write to different ranges.
> > >
> > > Even if they overlap, the folio locks will prevent concurrent writes
> > > to the same range.
> > >
> > > Now that we have atomic write support as native functionality (i.e.
> > > RWF_ATOMIC), we really should not have to care that much about
> > > normal buffered IO being atomic. i.e. if the application wants
> > > atomic writes, it can now specify that it wants atomic writes and so
> > > we can relax the constraints we have on existing IO...
> >
> > Yes, I'm not particularly concerned about whether buffered I/O is
> > atomic. I'm more concerned about the multithreading performance of
> > buffered I/O.
> 
> Hi Chi,
> 
> Sorry for joining late, I was on vacation.
> I am very happy that you have taken on this task and your timing is good,
> because  John Garry just posted his patches for large atomic writes [1].
> 
> I need to explain the relation to atomic buffered I/O, because it is not
> easy to follow it from the old discussions and also some of the discussions
> about the solution were held in-person during LSFMM2024.
> 
> Naturally, your interest is improving multithreading performance of
> buffered I/O, so was mine when I first posted this question [2].
> 
> The issue with atomicity of buffered I/O is the xfs has traditionally
> provided atomicity of write vs. read (a.k.a no torn writes), which is
> not required by POSIX standard (because POSIX was not written with
> threads in mind) and is not respected by any other in-tree filesystem.
> 
> It is obvious that the exclusive rw lock for buffered write hurts performance
> in the case of mixed read/write on xfs, so the question was - if xfs provides
> atomic semantics that portable applications cannot rely on, why bother
> providing these atomic semantics at all?
> 
> Dave's answer to this question was that there are some legacy applications
> (database applications IIRC) on production systems that do rely on the fact
> that xfs provides this semantics and on the prerequisite that they run on xfs.
> 
> However, it was noted that:
> 1. Those application do not require atomicity for any size of IO, they
>     typically work in I/O size that is larger than block size (e.g. 16K or 64K)
>     and they only require no torn writes for this I/O size
> 2. Large folios and iomap can usually provide this semantics via folio lock,
>     but application has currently no way of knowing if the semantics are
>     provided or not
> 3. The upcoming ability of application to opt-in for atomic writes larger
>     than fs block size [1] can be used to facilitate the applications that
>     want to legacy xfs semantics and avoid the need to enforce the legacy
>     semantics all the time for no good reason
> 
> Disclaimer: this is not a standard way to deal with potentially breaking
> legacy semantics, because old applications will not usually be rebuilt
> to opt-in for the old semantics, but the use case in hand is probably
> so specific, of a specific application that relies on xfs specific semantics
> that there are currently no objections for trying this solution.
> 
> [1] https://lore.kernel.org/linux-xfs/20250102140411.14617-1-john.g.garry@oracle.com/
> [2] https://lore.kernel.org/linux-xfs/CAOQ4uxi0pGczXBX7GRAFs88Uw0n1ERJZno3JSeZR71S1dXg+2w@mail.gmail.com/
> 
> >
> > Last week, it was mentioned that removing i_rwsem would have some
> > impacts on truncate, fallocate, and PNFS operations.
> >
> > (I'm not familiar with pNFS, so please correct me if I'm wrong.)
> 
> You are not wrong. pNFS uses a "layout lease", which requires
> that the blockmap of the file will not be modified while the lease is held.
> but I think that block that are not mapped (i.e. holes) can be mapped
> while the lease is held.
> 
> >
> > My understanding is that the current i_rwsem is used to protect both
> > the file's data and its size. Operations like truncate, fallocate,
> > and PNFS use i_rwsem because they modify both the file's data and its
> > size. So, I'm thinking whether it's possible to use i_rwsem to protect
> > only the file's size, without protecting the file's data.
> >
> 
> It also protects the file's blockmap, for example, punch hole
> does not change the size, but it unmaps blocks from the blockmap,
> leading to races that could end up reading stale data from disk
> if the lock wasn't taken.
> 
> > So operations that modify the file's size need to be executed
> > sequentially. For example, buffered writes to the EOF, fallocate
> > operations without the "keep size" requirement, and truncate operations,
> > etc, all need to hold an exclusive lock.
> >
> > Other operations require a shared lock because they only need to access
> > the file's size without modifying it.
> >
> 
> As far as I understand, exclusive lock is not needed for non-extending
> writes, because it is ok to map new blocks.
> I guess the need for exclusive lock for extending writes is related to
> update of file size, but not 100% sure.


> Anyway, exclusive lock on extending write is widely common in other fs,
> while exclusive lock for non-extending write is unique to xfs.

I am sorry but I can't understand, because I found ext4_buffered_write_iter()
take exclusive lock unconditionally.

Did I miss some context of the discussion?

Thank you very much.
Jinliang Zheng

> 
> > >
> > >> So we should track all the ranges we are reading or writing,
> > >> and check whether the new read or write operations can be performed
> > >> concurrently with the current operations.
> > >
> > > That is all discussed in detail in the discussions I linked.
> >
> > Sorry, I overlooked some details from old discussion last time.
> > It seems that you are not satisfied with the effectiveness of
> > range locks.
> >
> 
> Correct. This solution was taken off the table.
> 
> I hope my explanation was correct and clear.
> If anything else is not clear, please feel free to ask.
> 
> Thanks,
> Amir.
