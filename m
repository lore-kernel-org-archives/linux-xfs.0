Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2861C3CA4B6
	for <linux-xfs@vger.kernel.org>; Tue, 13 Oct 2026 23:50:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.216.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791935407; cv=pass; b=mByfEsEqUeqxsKPp6cHPxGoJh9WjxpQNiCfYlHejvMNflycT1byPTkbBJPPTWK5PU2HJx39vf27Kr+aSwTdfHt5xe4cWBAAWD3aPLzscpNjiZNNs8B8LlZvimDkWnAw+0h9uDyk5dkdr6yL18C7AHibMjoQKNlS0HIoeY2auDqM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791935407; c=relaxed/simple;
	bh=2QMBu1yL0X7hLnuOffeiXXAvxgZZMCjmZRTMz43Ksmw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mAapHV2mqgeHFZ8RHL7Pyh8SV2oBKyDJ2Tqa3VXJSJsKqBsb/aCAdqAcJ91ggSVNct2+KWOejbGo9/4caRzMGIlCjhGCda0ObJ7p/5YAazmEtBwLRyNiEct3gOkUMLu9U3Ch193r3usjntS3uq8Q9WpnlTSdhIbXa+lKNvgcAec=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cUx7QHMe; arc=pass smtp.client-ip=209.85.216.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cUx7QHMe"
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-3a80d1c98f5so254076a91.0
        for <linux-xfs@vger.kernel.org>; Tue, 13 Oct 2026 16:50:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791935405; cv=none;
        d=google.com; s=arc-20260327;
        b=JyigSxqfGXDenbR9nCSvk0zxLrR/dRyS2IpW2vMGY0bmNd/hJtwKp8QIh5cGs0DFJn
         t1vtfElSNFS87QOkYaPKZvJeLhJOJCihwbk2eBY61+uTt/f0etOJNRH8tyWUJYDK/lta
         E514f8uOs7k91NSfuJbSg4Z8rXEo661d6HasiNvUgQCOYRGICV9Hkb7zcftgh2QmorWx
         4os4FgJccpzIeUJde3RALJ3dw3+XqcIlaWMDhC5Ht9I607Bw4rF16mqmN2eGweWLV+it
         oU0CICyTvsqgYhB/9+ipqFCZMolSAEc7G8gU5bOv5VYbKhE70/n7folcgHHKy/82GirW
         h5zQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=lfT86B9wMdHDFwo1g5jeSr6xn3v3BEg43SCPBXBLZ8E=;
        fh=Ubq8TFiXC7KjvK4hOzQAhEVmIR5KxnbNmU0i16shvwk=;
        b=SyuUAcDEoINjmmltSTjmbD/HN////e6k3VVEj0ELjDjMNSVtH/UTKQIzXsQxQnWgfu
         2MBRy0xzrVh8o+sf+8NHwhVoDV/0bf883nJybUCvMACVM+GFAjk8DLtPXo6f8rfXV/bb
         pDcbpsD+g4G+SEIoaRb/czxzldJ31sxB/iU/oh3AA/DhfS0F8Tju8FrdO59utyVvS1a8
         Z0eT4IQMM5gQalxfUWTzCgLBWwnzH6ihikXuXbUBuRq9JvCmlFcXft22Y1E5OeRetiKp
         BU4qu8WAwFN2PiYvaHz3dWIgaYKwjgBgVp0FfVLiAs6ejz5XBNYU9XuNps0uKWDWlM2y
         XLog==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791935405; x=1792540205; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=lfT86B9wMdHDFwo1g5jeSr6xn3v3BEg43SCPBXBLZ8E=;
        b=cUx7QHMewAPvhtxuz7zUtgcVbQTJ/htpp8BAqUG6d2ZHF4Imrd6415ilkjjn+8wGLw
         wMYBYM2t6OWnRaxs70TO9TbWzkL8s9VlTKGWfhQ999tHjcdc6FupJj5ZK+prvfk3JMIi
         yLy1BJFRJXJJXl0vWk9ibQnOk1gTBjSdxflmnyGYwI27RtZ1rIRji9mNYSOkSXhpJS2Z
         55rGWS9YgzOQrIHMSrdmJ7GMtCpuqbtdl6e8WHNi99LDfeUPClYe+dHRY5lQM+6M+vyk
         DrF9hVGPPQ1l4M8x35LOrzPKO1tv2YsyYUt83T+WWyXPnqt7AGuy8dNyza5W7SqpH756
         dGkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791935405; x=1792540205;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=lfT86B9wMdHDFwo1g5jeSr6xn3v3BEg43SCPBXBLZ8E=;
        b=jjO6/E5Xz2mnhM43knEcoRy96ew4SuO58kmKL+aM60dRbOJUh2aLwpmttAAMeXQSvD
         eJhHX2iZXI4XlNy2mA40NXiUHQA7ghKtL5Pib8U4gmToAk7/C5g4L97SSrqjJJzRsrWG
         oruXouEylvsJEqnNA6OaSaaGJWHL9cfVi63R7QtaJB/KYHTmEiN8hiC58e3SImBfUOif
         3Wa9FOFFGjzie2lCYNNHYJszC93xA4lP12PcrrkgJggl8dKqLT7+noMbC8MByEYxF66m
         kqDgrycmsZJyK2Tfae0PhhsrT8UUNx/WvzFVl2085cTXdVofhwdaCDvS8q0bGnVZUbZ/
         wk/g==
X-Gm-Message-State: AFq9FYLQSmK49rLt26b18fjq+tocwmSH+h9NAJRjmGV7dBfC/1i+r5Iq
	2Z7Rx/ohol5wsKUpkJbCe3eiNvihJ8o4uMoZPnJ/lMmdOB5brYJWw9nDR6NSL54tidlgWAvppzl
	6H4Zx+8nwIxIH6Po/stnUXbpffmwxpgbHOlbd
X-Gm-Gg: AYBFou39urpfLt0/7Bi0LKFrQr1zqdd4PlJNxOYpMCv2RyTPQVQxLmTgIEPqYTWS4oL
	BVWFO3rsW0+xQCjY9g1mhExo3+0vD91FTLlzv7kIGaY0BzNxOlriHVFHkEy+di/zoDlQTnFXIGg
	pq0om1GtX945ac/TtUxZQjNDNlAFGI2JUwmZlxqgCjkC8KS5aX2u505r8Bf59of2Cys9OvDuK0I
	mrBGZDxJZ75PQQKe6AHFb0150L9x+PV5iZ8juRmGSSDRiFVdk96XwXw619FH6m+5xT+EDSIEp11
	Mk7TN9WJxQY06+wud+LT7FzsRVr1rb8qvJDgVslQoaC2uKrGijS1gu3kxKfbA1pbyvnahmYncoF
	Fdr5uJMjmfxYtCA==
X-Received: by 2002:a17:90b:3912:b0:3a7:f64f:6473 with SMTP id
 98e67ed59e1d1-3ab3ac6e6camr11677967a91.50.1791935405221; Tue, 13 Oct 2026
 16:50:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAF8PYMjkpEkoop-Wbk=2oBMdqer-pWh1osPvhSv90D2fwLSv0w@mail.gmail.com>
 <as1HVVUXdMlpXQGT@dread>
In-Reply-To: <as1HVVUXdMlpXQGT@dread>
From: Vitali Lovich <vlovich@gmail.com>
Date: Tue, 13 Oct 2026 16:49:53 -0700
X-Gm-Features: AclHuK-pMKE0sPv6k6sqE7vM10vt9Ih01bvHuDxZh9s1rUD3RJtQoEYGd7GY1AI
Message-ID: <CAF8PYMiMZ5uFGsLnms4pNtMHc=TKgzcKvoLtydGXEFS7KM_r5g@mail.gmail.com>
Subject: Re: Really bad I/O lock contention between non-overlapping reader and writer
To: Dave Chinner <dgc@kernel.org>
Cc: linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 12, 2026 at 1:47=E2=80=AFPM Dave Chinner <dgc@kernel.org> wrote=
:
>
> On Mon, Oct 12, 2026 at 10:47:56AM -0700, Vitali Lovich wrote:
> > I think I encountered suboptimal locking behavior with concurrent
> > readers and writers on a file, which resulted in huge latency spikes
> > for the reader even though the writers and readers are touching
> > unrelated ranges within the file. The writer/hole puncher hold an
> > exclusive lock on the inode while forcing a flush of outstanding
> > writes to disk which creates huge latency spikes for reads.
> >
> > I've observed read's taking >> 500ms even though none of the writes
> > could be overlapping and traces seem to indicate it's the shared inode
> > lock contending with the exclusive inode lock that writes / hole
> > punching is holding. In my real-world test case traces indicated that
> > the cause might be inode_dio_wait while holding the exclusive inode
> > lock.
> >
> > I've observed this behavior on XFS, EXT4 and BTRFS so it seems like a
> > general VFS challenge. Generally, Btrfs seems to have less read
> > latencies created than Ext4 (~2.5x more at the 0-1ms read than EXT4),
> > which in turn has smaller and fewer tail latencies than XFS  (~2x more
> > at 0-1ms and extreme is smaller) although all filesystems exhibit the
> > issue. Starting with the XFS list in case I'm way off base that this
> > is a problem.
> >
> > Attaching a simplified reproduction of what I'm doing with one writer
> > appending data to the file,
>
> The repro is using DIO writes. Speaking for XFS, these need needs
> exclusive locking to serialise extending the file without causing
> data corruption or stale data exposure. Once extended, the locking
> demotes to shared, so the IO itself runs concurrently with reads.
>
> Appending DIO writes are basically a fast combined 'truncate up,
> write' operation, and so has the same initial serialisation
> constraints as 'truncate up' (i.e. exclusive locking).
I think that's true if the write continues at the last byte of the
previous one. If the write leaves a gap for whatever reason (e.g.
writes are 4kib aligned but we only had 3.5kib of data before the file
end) the fast-path isn't taken and you do have to wait for a full
flush because XFS doesn't realize there's nothing overlapping. This
scenario isn't present in the test case I published but I think it
acts very similarly to hole punching.

>
> > a separate writer punching holes in
> > unrelated ranges,
>
> fallocate() is like truncate - it also needs exclusive locking and
> no IO in flight to avoid a UAF of the data extent being punched out.
It needs exclusive locking and draining around the range in flight,
not necessarily the entire i_node.


> > and an O_DIRECT reader that's reading data.
>
> Shared locking only.
If I wasn't clear, the problem is that the shared lock has a head of
line blocking behind the exclusive lock that's draining the I/O even
though userspace knows it's never touching that range.

> > Reads
> > are doing random 4kib I/O in [0, 64MiB), hole punching is punching
> > 4kib holes in [64MiB, 576Mib] and writing is always appending after
> > 577MiB of the file.
>
> Educate me: what application workload has this IO pattern? Is this a
> real world problem. i.e. why should we care about this contrived
> scenario?
I'm trying to implement an LSM database that stores everything in one
file instead of taking the RocksDB approach of 1 file per SST. One
file per SST has scaling problems of its own in other ways, but for
concurrent reads and writes they acquire locks on different inodes
(file and directory, respectively), which is why RocksDB doesn't have
the problem highlighted in this test-case - it always reads and writes
to separate i_nodes with the downside being that it ends up having to
open an insane amount of files on startup and juggle them if there's
more than the kernel limit allows.

>
> Also, have you tried to implement highly concurrent range locks that
> don't have far worse contention on the range lock tracking
> structures themselves than a simple rwsem? Some of us here have
> actually tried to do this, and the fact that we still use rwsems
> should tell you a lot...

I'm not pretending it's an easy problem to solve. I've come up with a
few approaches and would love your feedback on what's the best path:

1. DIO tracking so that the inode keeps track of all outstanding
DIO's. Rather than the barrier, we scan the list to find if there's
any conflicts. I've prototyped this and it clearly solves the false
synchronization barrier from this in my database (unrelated writes
prolonging reads). This has a negative impact on normal workloads so I
imagine this would be hidden behind an explicit ioctl if acceptable.
2. Introduce generational barriers where hole punching / writing past
the end of the file still waits for DIOs but outside the exclusive
lock. Inside the exclusive lock all it does is register that the range
that it's doing the operation on and the wait happens outside the
exclusive lock. Operations that overlap will either wait for all
outstanding DIO or perhaps satisfy if they can (e.g. a read of an
fallocate technically could just supply the 0s without waiting for
DIO).

Option 1 is the "safest" in that it introduces no new concepts but it
does carry overhead both in terms of memory and performance. Option 2
is probably the highest performance option and might even be safe as
an always-on default.

Is either or both of these a non-starter idea in terms of acceptance
(assuming I can actually make it safe)?



>
> -Dave.
> --
> Dave Chinner
> dgc@kernel.org
