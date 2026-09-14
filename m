Received: from a9-67.smtp-out.amazonses.com (a9-67.smtp-out.amazonses.com [54.240.9.67])
	(using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAD4A2EA75E
	for <linux-xfs@vger.kernel.org>; Mon, 14 Sep 2026 01:58:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.240.9.67
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789351108; cv=none; b=BP+FGWGvSITYblo5wqoMQ1SsEXsCCM7yxrn3R9/xxgY+1zshoGK8tdO6UcY2RR0s9eWJgtYSZEhiX6U7d5nZI1QSUSFERdkFpPNbE7/w+S/Os+7U6vD6N89zNntfZscw/xcswqeoU+nwVQeoEe26TFbh3Fy+v7WBWSQcUal5+Mo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789351108; c=relaxed/simple;
	bh=TxnJBVDzFfOMxrhRpL8fujJTb8wSqSKpVLfJzJ0voEo=;
	h=In-Reply-To:From:To:Subject:Message-ID:Date:MIME-Version:
	 Content-Type; b=Nxf0St61NWCY8tD5LKHBdzocjBGGUCvO5BiGhCukRMcsqd2Red8CCXiV9joJkhwQP560VisDeGs5iFD3r/o5WZuollyBeNc6A8q0hqsyIeMDiIIed0WbD7VNrLxtCd0Lfb0entA1VffpDU5qpc/9pt5XekGPtzERnNVPEMWOhTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bugs.sh; spf=pass smtp.mailfrom=send.bugs.sh; dkim=pass (1024-bit key) header.d=bugs.sh header.i=@bugs.sh header.b=cvLF4BM1; dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b=So3JdQS3; arc=none smtp.client-ip=54.240.9.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bugs.sh
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=send.bugs.sh
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=bugs.sh header.i=@bugs.sh header.b="cvLF4BM1";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="So3JdQS3"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple; s=resend;
	d=bugs.sh; t=1789351106;
	h=In-Reply-To:From:To:Subject:Message-ID:Content-Transfer-Encoding:Date:MIME-Version:Content-Type;
	bh=TxnJBVDzFfOMxrhRpL8fujJTb8wSqSKpVLfJzJ0voEo=;
	b=cvLF4BM18jbuevQiaAI3YZnNF8iY9l4LBqnw9vYHdut5fR+f+7xuCzHlR7RSB6iN
	FordWGKEy8u+b/9GXVn7T9X9Dh7Ne8RuZycA4lw3CRYWUY3v4bQACNfO9kDpv6ltzZM
	71HglED8hDyQuDKx5S87WayyL/Sng+FVoWr72WVY=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=224i4yxa5dv7c2xz3womw6peuasteono; d=amazonses.com; t=1789351106;
	h=In-Reply-To:From:To:Subject:Message-ID:Content-Transfer-Encoding:Date:MIME-Version:Content-Type:Feedback-ID;
	bh=TxnJBVDzFfOMxrhRpL8fujJTb8wSqSKpVLfJzJ0voEo=;
	b=So3JdQS3ApuOAgOgHlI/CaXZ6BzhyVEtHwnW6vnCsk0DYxFZa3nxjov5fLcmIUt6
	VVogwBciOaAK/PkORAox3VWtCeraf2mFngB6qvM/UQO1QHyrbAo/8CBizXpNjICmDjz
	z4n8o01X/iM3/dtrgzoyyw87sUAZnXMeIF6fzjU8=
X-Forwarded-Encrypted: i=1;
 AKwUvBzk9yn03qSaSWvhDL855Tmgh7ayWsCOIgaobW95k/WnupfmgEsrraE9By6t5O62pP+qrOQwMOi5u8g=@vger.kernel.org
X-Gm-Message-State:
 AFuF++mpV8fxvXr2r3iGHc0HmOBZ2x2us/H4ulrD6jHaqu7TXsI5QCV6
 tpwXsEy7d8UR+BnqZRxjggH0uuW/VEql/imzxLbRfRWfqofNyFxy5/Cg/69s1YCR3tjNWLCGVOs
 6FNIZya7avlre3++RF7POZopc1WNnD9tzbantlUx/
X-Received: by 2002:a17:90b:2586:b0:38e:fea2:df53 with SMTP id
 98e67ed59e1d1-39debf6f4a1mr1192985a91.4.1789351104062; Sun, 13 Sep 2026
 18:58:24 -0700 (PDT)
In-Reply-To: <aqZALi7GdVprcNOh@cronus.toxiclabs.cc>
X-Gmail-Original-Message-ID:
 <CAPpSM+QVz8-kioqnWZTgK-h=9M1+kF=x2V4tZDoUaryw+v+d_A@mail.gmail.com>
X-Gm-Features:
 AcwNN1XHWWLPVHVDfa5oHDbSV_RgR139yo3Y0348QaQjD803Dohgi6AFM_7E5UA
From: CO <co@bugs.sh>
To: linux-xfs@vger.kernel.org
Subject: Re: [BUG] fs/xfs: out-of-bounds in xlog_recover_buf_reorder()
Message-ID: <010001a09da313cd-e84d1b93-e49c-441e-b646-59f6259a04b3-000000@email.amazonses.com>
Content-Transfer-Encoding: quoted-printable
Date: Mon, 14 Sep 2026 01:58:25 +0000
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Feedback-ID: :1.us-east-1.yL0noGNZdXCKlJHw27bHz8/I7/GZTaYDRe4l4bGvzjPa1Q4S+kzxKgpyYIxfCxOFAjHX6QJhZdsZN1SP8V3NfEiLJ34m58z2/mmJDZ5RtdRTZ06dzneIWyoUkJ1DSaTbU2HlPz+Zb2/NZ41D3j4FLWNy2FyGjUOa4qpft7gzKcs=:1.us-east-1.QSNtDRXSTq9sAuvRl56h5mypgasnQ5yDLNpVzTnziu0=:AmazonSES
X-SES-Outgoing: 2026.09.14-54.240.9.67

On Sat, Sep 12, 2026 at 11:28=E2=80=AFPM Carlos Maiolino <cem@kernel.org> =
wrote:
>
> Thank you for the report... A few suggestions below:
>
> >     Everything in this mail is validated by the reproducer below.
> >
> >     We also hold an unreviewed LLM-generated analysis and candidate
> >     patch. The same reproducer panics the unpatched kernel and runs
> >     clean with that patch applied. Use it as a starting point, or =
ignore
> >     it and write your own:
> >
> >         patch.diff  =
https://bugs.sh/b/af981e62f5c7171a/patch.diff
>
> If you have a suggested =
patch, include it inlined in the message, do not
> expect somebody to go =
and click on some random link sent to the mailing
> list.
>
>
> >         report.md   https://bugs.sh/b/af981e62f5c7171a/report.md
>
> If you have no capacity to review your generated AI reports, then don't
> send them to the list, we are not your AI-slop moderators/reviewers.
> Neither your lab rats.
>
> >
> >     Happy to test patches. Complaints =
and suggestions about our work
> >     are welcome at:
> >
> >         cedalion@bugs.sh
> >
> > =3D=3D Environment =
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D
> >     Reproduced on  2709dd5ae32f ("Merge tag =
'sched-urgent-2026-08-22' of git://git.kernel.org/pub/scm/linux/kernel/git/=
tip/tip")
> >     VM setup       https://bugs.sh/b/af981e62f5c7171a/run.sh
> >     config         https://bugs.sh/b/af981e62f5c7171a/config.gz
> >     poc            https://bugs.sh/b/af981e62f5c7171a/repro.c
>
> Again, same as above. Include everything in the email, do not expect
> people to go and keep clicking on random links to access whatever
> information you provided.
> A reproducer is appreciated, but it should be=
 in the email message not
> at some random URL. This is not safe and is a =
security risk for
> maintainers and developers to just go and click on =
random links.
>
Thanks so much for these comments. They are valuable to us!
(We didn't realize including links in the email raises security concerns)

We'll make bug reports:
1. External-link-free
2. No AI-generated analysis
3. The patch would be inlined at the end of the report, and we'll
state the patch's limitations clearly.

Best,
Xiang


> Carlos
>
> >
> > =3D=3D Sanitizer Report =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > BUG: KASAN: slab-out-of-bounds in =
xlog_recover_buf_reorder (fs/xfs/xfs_buf_item_recover.c:164)
> > Read of size 2 at addr ffff88800beee384 by task exploit/147
> > Call Trace:
> > dump_stack_lvl (lib/dump_stack.c:94 lib/dump_stack.=
c:120)
> > print_report (mm/kasan/report.c:378 mm/kasan/report.c:482)
> > kasan_report (mm/kasan/report.c:595)
> > xlog_recover_buf_reorder =
(fs/xfs/xfs_buf_item_recover.c:164)
> > xlog_recover_reorder_trans =
(fs/xfs/xfs_log_recover.c:1929)
> > xlog_recover_commit_trans =
(fs/xfs/xfs_log_recover.c:2053)
> > xlog_recovery_process_trans =
(fs/xfs/xfs_log_recover.c:2319)
> > xlog_recover_process_data =
(fs/xfs/xfs_log_recover.c:2510)
> > xlog_do_recovery_pass =
(fs/xfs/xfs_log_recover.c:3253)
> > xlog_do_log_recovery =
(fs/xfs/xfs_log_recover.c:3340)
> > xlog_do_recover (fs/xfs/xfs_log_recover=
.c:3377)
> > xlog_recover (fs/xfs/xfs_log_recover.c:3502)
> > xfs_log_mount (fs/xfs/xfs_log.c:617)
> > xfs_mountfs (fs/xfs/xfs_mount.=
c:1031)
> > xfs_fs_fill_super (fs/xfs/xfs_super.c:1987)
> > get_tree_bdev_flags (fs/super.c:1887)
> > vfs_get_tree (fs/super.=
c:1947)
> > fc_mount (fs/namespace.c:1198)
> > path_mount (fs/namespace.=
c:3772 fs/namespace.c:3848 fs/namespace.c:4168)
> > __x64_sys_mount =
(fs/namespace.c:4181 fs/namespace.c:4397 fs/namespace.c:4374 fs/namespace.=
c:4374)
> > do_syscall_64 (arch/x86/entry/syscall_64.c:61 =
arch/x86/entry/syscall_64.c:84)
> > entry_SYSCALL_64_after_hwframe =
(arch/x86/entry/entry_64.S:121)
> > The buggy address belongs to the object=
 at ffff88800beee380
> > which belongs to the cache kmalloc-8 of size 8
> > The buggy address is located 0 bytes to the right of
>
