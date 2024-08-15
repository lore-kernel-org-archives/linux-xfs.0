Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 672D01714DC
	for <linux-xfs@vger.kernel.org>; Thu, 15 Aug 2024 12:26:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723724800; cv=none; b=ZSQD4FO0eaABV5YSXUVXz8wQxzFhU9IuyZHmNXyVM+nl1hXRo5TaUQGGNmdRJVx+8MkSSVtFf1kSXXH2arFqHHAtHNqokY1mHJlSoSQmzTolMT+BpSc1muI73pXwi6C8cHSCzT916jaE6id3bmz+dGd7VMv2hWytxzaz6xYmhhM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723724800; c=relaxed/simple;
	bh=ORYOrGZR9rhqnRUa1FmNAWNtpWp9O6XiJgTzuuCqTi4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fOgnw68z+NA8Td7idsBz5/dOyVdUMLkPddE947GIE7C4wWI/T7Ar3XQ1xYngcjNJ4mq+MwV+xIVN/al4dFmgrcz074f8mTVFBBXpik0sGqo/uKQU1R6CLuAbwVRxf87kbuGTe58lRa0uotOKt2wPn4TqYFw0Bl73IbKzvS3nXB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DGWJQTKc; arc=none smtp.client-ip=209.85.218.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DGWJQTKc"
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-a7aac70e30dso104981566b.1
        for <linux-xfs@vger.kernel.org>; Thu, 15 Aug 2024 05:26:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1723724797; x=1724329597; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0Ga671Dz+v8d15XLAuiab3cK1X5R+G/DagXaBPp4FC4=;
        b=DGWJQTKcbt2pjE8fjR4RfV026xz/SSG/43qgz3ChzrhdHcnJQQ7tkUs4ui8Nj4/AGY
         RNsU5k69orlPssIf3JSwZciZCYROus1PN5/4v8+3gR0vXabArjQw/JKC1NmSbyJvUV6o
         zk31POp6LHdbEr2TiX0eSnrssgrY0g05ZUM2RmD0/1fCjY2SCoNEuEhdNrnbHXz/O8rY
         H028jqtR3zZ50kQiFQEPZV3iTKuPP2WEps/exHNUAoH2GihWEu6CS+1Lm5kIWySYhet1
         nxQLeojfeJnkqZSADiwK7NvPypFP3C0f4Ia+VxtySf4Wq7jT8HIct6V5EbVAHyZqzIt0
         AHeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723724797; x=1724329597;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0Ga671Dz+v8d15XLAuiab3cK1X5R+G/DagXaBPp4FC4=;
        b=xRQsqVDWUUpuvxmbU1uFAsrB17CpVxXufCC3lKAgRGsgNx3J+VLYnMCa1kKLN+xWkY
         ZVomFfZVtmO0OAIPE+nACXpVV+sSPn9DGmEienrPmxTZGzjfuFsfEKsJ7kG1L8B+peaC
         V321FvAtKuO25y9QedI4yRKZoEM4JIL19p76CSsI19Gs5a+MTa/LbGNrG1A/5O+v2Gnd
         C9ztP2C2t4HPjDjbgvtyEMG2M/TVTNMD7Hg/lI8MBL1iY1VkUVycmH/IcpWz2QYp7Q5J
         QAApnIQTvKaOJOPf1FrrYMbMXNSsvMgfK62qdWT+404P7qLI6a/4zcucdUPPdVXAdMZA
         EE6A==
X-Gm-Message-State: AOJu0YyvKmcymop8niqOppYrMQBeL7HT4u5qj6Oi3e5A2YBbJnQEv27Z
	N9Q2/72KJBS/opJNT/0puMbwONP3McU4B6BnwvxZotvw72J9JZKfcaCzrAGhnzdU34x4d0rkS0O
	+2NR43FiROQCpWMOdKUf5vld3zZV3fw==
X-Google-Smtp-Source: AGHT+IH/G1zcN1Fli4pBQaGSPXiJOu1eTb7hHVwtMn3WHXqL9PTjk/ovg3hkoZ75ERd1zhy6Xq9QhvpE7g3J02pSgnY=
X-Received: by 2002:a17:907:c0d:b0:a7a:ab1a:2d71 with SMTP id
 a640c23a62f3a-a83670956a2mr396131866b.59.1723724796293; Thu, 15 Aug 2024
 05:26:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAGudoHFJV=S61Fjb=QVf4mSTRfkYf5QR1y0TDMhnawZKtgyouA@mail.gmail.com>
In-Reply-To: <CAGudoHFJV=S61Fjb=QVf4mSTRfkYf5QR1y0TDMhnawZKtgyouA@mail.gmail.com>
From: Mateusz Guzik <mjguzik@gmail.com>
Date: Thu, 15 Aug 2024 14:26:24 +0200
Message-ID: <CAGudoHHO=P5VRY32fY4KgoOomJrfQMW5hhR5pKE--2wS3u+WVw@mail.gmail.com>
Subject: Re: perf loss on parallel compile due to conention on the buf semaphore
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 15, 2024 at 2:25=E2=80=AFPM Mateusz Guzik <mjguzik@gmail.com> w=
rote:
>
> I have an ext4-based system where xfs got mounted on tmpfs for testing

erm, i mean on /tmp :)

I also used noatime.

> purposes. The directory is being used a lot by gcc when compiling.
>
> I'm testing with 24 compilers running in parallel, each operating on
> their own hello world source file, listed at the end for reference.
>
> Both ext4 and btrfs backing the directory result in 100% cpu
> utilization and about 1500 compiles/second. With xfs I see about 20%
> idle(!) and about 1100 compiles/second.
>
> According to offcputime-bpfcc -K the time is spent waiting on the buf
> thing, sample traces:
>
>    finish_task_switch.isra.0
>     __schedule
>     schedule
>     schedule_timeout
>     __down_common
>     down
>     xfs_buf_lock
>     xfs_buf_find_lock
>     xfs_buf_get_map
>     xfs_buf_read_map
>     xfs_trans_read_buf_map
>     xfs_read_agi
>     xfs_ialloc_read_agi
>     xfs_dialloc
>     xfs_create
>     xfs_generic_create
>     path_openat
>     do_filp_open
>     do_sys_openat2
>     __x64_sys_openat
>     do_syscall_64
>     entry_SYSCALL_64_after_hwframe
>     -                cc (602142)
>         10639
>
>     finish_task_switch.isra.0
>     __schedule
>     schedule
>     schedule_timeout
>     __down_common
>     down
>     xfs_buf_lock
>     xfs_buf_find_lock
>     xfs_buf_get_map
>     xfs_buf_read_map
>     xfs_trans_read_buf_map
>     xfs_read_agi
>     xfs_iunlink
>     xfs_dir_remove_child
>     xfs_remove
>     xfs_vn_unlink
>     vfs_unlink
>     do_unlinkat
>     __x64_sys_unlink
>     do_syscall_64
>     entry_SYSCALL_64_after_hwframe
>     -                as (598688)
>         12050
>
> The fact that this is contended aside, I'll note the stock semaphore
> code does not do adaptive spinning, which avoidably significantly
> worsens the impact. You can probably convert this to a rw semaphore
> and only ever writelock, which should sort out this aspect. I did not
> check what can be done to contend less to begin with.
>
> reproducing:
> create a hello world .c file (say /tmp/src.c) and plop into /src:
> for i in $(seq 0 23); do cp /tmp/src.c /src/src${i}.c; done
>
> plop the following into will-it-scale/tests/cc.c && ./cc_processes -t 24
>
> #include <sys/types.h>
> #include <unistd.h>
>
> char *testcase_description =3D "compile";
>
> void testcase(unsigned long long *iterations, unsigned long nr)
> {
>         char cmd[1024];
>
>         sprintf(&cmd, "cc -c -o /tmp/out.%d /src/src%d.c", nr, nr);
>
>         while (1) {
>                 system(cmd);
>
>                 (*iterations)++;
>         }
> }
>
> --
> Mateusz Guzik <mjguzik gmail.com>



--=20
Mateusz Guzik <mjguzik gmail.com>
