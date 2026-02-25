Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84B47277007
	for <linux-xfs@vger.kernel.org>; Wed, 25 Feb 2026 08:45:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=170.10.129.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772009117; cv=pass; b=BtR6TSN381+qWIlQ9+UE4lH7z5TgQWnnYfJGy9lTLIJq7c5I0aZ5fMevmG7T4xMr1LDF0QyWry5K0W5Tf187yI8ntX90mNY5GJX/L4DFYfpFrHy0EW/jEuZLhHc1EJZssX+MDVEZNLw1Zmkv4TZc0nqTyw2pz7Ra9oO3PKCkngw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772009117; c=relaxed/simple;
	bh=3ixhAy7Zgei1dxKH92e+wVk00RJmdAOojuszHfjfDgg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=b1avupr5kse/Gvg08lx+cK14wh3nszh1EN/nCcr+TaaqoDzu0vFXK9Dfg7dzMC7vtmblf+rvjdI5qvGcH0HFcOPUoF/O7XCxftR4FEP4wP6eDWo63BTjJjm6IMGDStEX2fXqPj1Rhxblu0nVQseW+in8PPkcEohYmhhQuD0HILM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hIJ835v1; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=Pn+B8QDj; arc=pass smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hIJ835v1";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="Pn+B8QDj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772009114;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wRXdb/IGXDqECk53dGXHL7cTM/S3WjgMwQT0XN9CLxU=;
	b=hIJ835v1ToSiWMMp/oqMPe5NqVQiDtJLT5UlTddyWO6xFNoE1ZRvpIty9ruNPHR31tfhAL
	Vhekya1ZH8cIfYKtJJ5MXGmQ7peu2Fd3Q/d/0CPKMOXxY+SgdppRPftXrrisj0EsYjDTJX
	mMKi+jMvTaXpK8Hq2p9zZhu61bYwZ6s=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-589-b1zJqIunPMSVcFPXFAB4Lg-1; Wed, 25 Feb 2026 03:45:07 -0500
X-MC-Unique: b1zJqIunPMSVcFPXFAB4Lg-1
X-Mimecast-MFC-AGG-ID: b1zJqIunPMSVcFPXFAB4Lg_1772009106
Received: by mail-ed1-f70.google.com with SMTP id 4fb4d7f45d1cf-65a1b27b84cso1452560a12.3
        for <linux-xfs@vger.kernel.org>; Wed, 25 Feb 2026 00:45:06 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772009106; cv=none;
        d=google.com; s=arc-20240605;
        b=XFzSklhIfk/s66sZBJEhuhwdFdpSPRu61aoX/25NHoHUoIFhLOp10bq5bEXtB1HeR4
         nJKnuyQl3AP73EzQEZX9zwGmGpTIufZeHF8g8m99eWTnEJ5HgwSmfaSe1HDmQstWzZ2q
         2CoSCOa/IUa6HYdkh1HODW4I8tY2ryXY0UF/hceEZnpTzfj+nPQfJkQgCY4NcuC4APz7
         Q8g+V7eI05wunpcjb8QwoQgao0X9JoMUlNGOn/QXn33ExjH8a+PGjS4HMPVRiXr3m1Wi
         0LN3pTGt66RMZTFOj2xQYDl27Upwycwu9GiKLbs9nad9lt2J+/ZfR4Yw1RD6G3rlFIhv
         5zQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=wRXdb/IGXDqECk53dGXHL7cTM/S3WjgMwQT0XN9CLxU=;
        fh=3nKJQftPlV0WdqeufMBwhSHNn6gNeXUhWvWQUWIpkko=;
        b=Kr+qoefQL319JY1OUfhxRzvJaXp8rsIRdLpUnfEej15NsIcVeTDW43QGdLVLqngFqg
         p3y+DiYWgYdXXkIrK7XVvkF+22F6BBlzVVtv4bpk6DMwVg9QxvUq3YBp8xKFAsqBqLv6
         JhM637p73Iw3Li9L/7bUTtbsNnjL2WY4Ow93QP50e3WqzHMENnKQlt3c0ZX9pTlENgie
         7CxEeEWgyPUltwfpUIiZqEd+tCHWMmpvknyZlD8UQA4Ct2JijAth5UkOJpOD9Yqv5ia+
         2QPA7ovg9U2RP25O7m1Pp8Tk/6w1+0/bVR9rpJMXJkZJdV9BLjThKkz5VNMeBGOnuLH6
         L2aw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1772009106; x=1772613906; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wRXdb/IGXDqECk53dGXHL7cTM/S3WjgMwQT0XN9CLxU=;
        b=Pn+B8QDjKAa0fZVSbIP8AsEu9EnRDXBnjenXxpfQq+GdodCgk9u9GC/yaDLMnag8K9
         R6k6i3Jkkw8GEaPj0PNRmoH7u/Oo8W46bFtPFpZNc7svKOHJQoaZx3OMQLi6sN7PWd0f
         OtyUEiQRqvQJeMvM7cBd1feNxqBFgfeQpdcAThyb4JCj75RZCjRER2wjR+6kKJVNri2h
         +0glLfh5vZUYbTITu6Jjgd8c2VvI2Ng7O461Bg0/IxxSNyzIdxGvtVCeaTtT68yw6InM
         KiA24Cz6t9pq981HGtRdVycJ6u454IXc1l+/t6g3+xD5NGQbSwy8gTClDteJ/fOkKJfw
         DtVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772009106; x=1772613906;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=wRXdb/IGXDqECk53dGXHL7cTM/S3WjgMwQT0XN9CLxU=;
        b=MnbaSLXDo/TOGn/nL39w9dny7z75skCwYjxS5OnNDXFuDMc481OWKKH8Atbh7TnjZC
         zzl7HGb/fSWHWo+rub4FGr0OdN8MnT9dhpy9eQGhYAOUZHtR8Rm6rULzqa2aNdB++Iza
         VU8YAkUcimAUxBTJLj6Sq7nuMLwgx4HWnMviJOUdXUU4RK+vHRR40bQMog8NUUfSL2FQ
         XUXzG+fUG944njH8NW/YCBrfBH3S29p6lIoz47fytFWeXUDRhwySPK97F9nY7Lpmr0f6
         rims+6x8gADVh0G5aujiAATlDnU4/dj1ITJAAYt4tcdXSa0Y8yYQdbEDpbrqPYcW1NEz
         ro2A==
X-Forwarded-Encrypted: i=1; AJvYcCXVIzP30nx6BTbG2fqcHl+Kr8bSXC8NnD05W2HpR+/S8z/cCZz7vj4b9KKa55zDngLc6MukQyyW5eE=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx91B5zY0ReExgb+cgrf1WB4xr81MkabIHJp/CVaiNG/9pMHeS2
	NZJzB5CIVsO32lw775CHALSuiwhTrfiqVhfAS+BunxhWJeh/LkebuHGpEMjO1E1xYILY0wS5xkU
	+mZL8RkCJ2bRItiIwxORtOtS0P2ZWzxPbmd8vc0Us8dprs+wn+oNlHhan28/QRilhL8LXIJ9/Hp
	M2F8xS7irUd+xbzBzHLXxmHqVm78fWENztmrZW
X-Gm-Gg: ATEYQzwtOhJkFPWgRWs7tutkGkNuaexiSxmZDv1fHBhZMFxdkdwOwyuaD0v8KqbJt0k
	kRfYSy5b17v5n6f3zZVbaFxT36O7KLczS8R4YRKc/iSQAcNurSG+M/DyTs6dKa3W0uM11eT9QB1
	ob7SDXiNq8wtkbCOoXhvNkE+uRZOXIhjitI9j+z9PYaOjvCQmo+GSKDQO0aqv7OmJdIqTnmUe1q
	o3wBikB
X-Received: by 2002:a05:6402:2707:b0:65b:f20d:7630 with SMTP id 4fb4d7f45d1cf-65ea4f04b77mr9672840a12.27.1772009105519;
        Wed, 25 Feb 2026 00:45:05 -0800 (PST)
X-Received: by 2002:a05:6402:2707:b0:65b:f20d:7630 with SMTP id
 4fb4d7f45d1cf-65ea4f04b77mr9672819a12.27.1772009104975; Wed, 25 Feb 2026
 00:45:04 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <aYC0pe-S-RWSMXHn@infradead.org> <20260202185959.GJ7712@frogsfrogsfrogs>
In-Reply-To: <20260202185959.GJ7712@frogsfrogsfrogs>
From: Ravi Singh <ravising@redhat.com>
Date: Wed, 25 Feb 2026 14:14:53 +0530
X-Gm-Features: AaiRm53cklConvaPryUVqm-nf0TK59g_PezQ15uaMefTjEHLDUNr5bax4dAD8qQ
Message-ID: <CAF-d4OshnJ997DDsgWzr0f+4-JpRaQ+B5-y6M0PUm=es9LpQXA@mail.gmail.com>
Subject: Re: generic/753 crash with LARP
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Darrick,

When running xfstests generic/753, I=E2=80=99ve been running into the same
crash(with debug) during attribute log recovery as well as xfs_repair
error messages(with non-debug). I found that the xfstests commit
e72c9219 (=E2=80=9Cfsstress: fix attr_set naming=E2=80=9D) exposed a pre-ex=
isting gap
in XFS attribute crash recovery. Prior to this change, fsstress did
not correctly exercise multi-transaction attribute replace operations
and was silently failing to do so, which masked the underlying
recovery issue.

There are two related issues here, one for debug (with LARP) and one
affecting non-debug(without LARP) build.

Issue 1: With Debug  ASSERT failure during LARP recovery

Root cause: During log recovery, xfs_attr_recover_work() reconstructs
the initial state for a logged REPLACE by calling
xfs_attr_init_replace_state(). When XFS_DA_OP_LOGGED is set, this
returns xfs_attr_init_remove_state() - starting the state machine at
XFS_DAS_NODE_REMOVE. The intent log item doesn't record which state
the operation had reached before the crash, so recovery always
restarts from the beginning.

The state machine enters XFS_DAS_NODE_REMOVE in xfs_attr_set_iter()
which calls xfs_attr_node_removename_setup() ->
xfs_attr_leaf_mark_incomplete() -> xfs_attr3_leaf_setflag(). This
function asserts that XFS_ATTR_INCOMPLETE is not already set.
But if the crash occurred after the transaction that set the
INCOMPLETE flag had committed (i.e., the original operation had
already passed through xfs_attr3_leaf_setflag and committed) but
before the full replace finished, then the entry already has
INCOMPLETE on disk. Recovery replays setflag on an already-INCOMPLETE
entry and trips the assertion.

Issue 2: Non-debug (LARP disabled) - xfs_repair detects INCOMPLETE entries.

The multi-transaction sequence is:
  1. Add new entry with XFS_ATTR_INCOMPLETE set (committed)
  2. Allocate remote value blocks if needed (committed in one or more
transactions)
  3. xfs_attr3_leaf_flipflags() atomically clears INCOMPLETE on new
entry and sets it on old entry (committed)
  4. Remove old entry and its remote blocks

If a crash occurs between steps 1 and 3 (e.g., generic/753 induces a
dm-error crash), the new attribute entry exists on disk with
XFS_ATTR_INCOMPLETE set and potentially partially or fully allocated
remote blks. Since no ATTRI intent was logged, log recovery has
nothing to replay. The INCOMPLETE entry and its associated blocks are
orphaned permanently.

When xfs_repair detects INCOMPLETE entries, it clears the attribute
fork. However, the inode=E2=80=99s di_nblocks and di_anextents counters are
not updated and still include the blocks that were allocated to the
removed attribute data. This discrepancy leads to counter mismatch
errors

Errors from generic/753.full :

attribute entry #6 in attr block 82, inode 132 is INCOMPLETE
problem with attribute contents in inode 132
would clear attr fork
bad nblocks 2119 for inode 132, would reset to 0
bad anextents 921 for inode 132, would reset to 0
attribute entry #5 in attr block 140, inode 133 is INCOMPLETE
problem with attribute contents in inode 133
would clear attr fork
bad nblocks 1243 for inode 133, would reset to 0
bad anextents 684 for inode 133, would reset to 0

A potential fix for the debug build might look like this:

xfs_attr3_leaf_setflag()

  /* Before: */
  ASSERT((entry->flags & XFS_ATTR_INCOMPLETE) =3D=3D 0);

  /* After: */
  if (entry->flags & XFS_ATTR_INCOMPLETE) {
      ASSERT(args->op_flags & XFS_DA_OP_RECOVERY);
      return 0;
  }

But I=E2=80=99m not sure what the appropriate fix would be for the non-debu=
g build.

Thanks,
Ravi

On Tue, Feb 3, 2026 at 12:30=E2=80=AFAM Darrick J. Wong <djwong@kernel.org>=
 wrote:
>
> On Mon, Feb 02, 2026 at 06:28:53AM -0800, Christoph Hellwig wrote:
> > I've seen a few crashed during xfstests where generic/753 crashed durin=
g
> > attr log recovery.  They never reproduced when running the test
> > standalone in the loop, which made me realize that normally the
> > test does not even hit attr log recovery.  Forcing using the attr log
> > items using:
> >
> > echo 1 > /sys/fs/xfs/debug/larp
> >
> > Now makes it crash immediately for me.  I plan to separately look why
> > LARP is enabled during my -g auto run, probably some issue with the
> > actual LARP tests, but for now here is the trace.  Sending this to
> > Darrick as I think he touched that area last and might have ideas.
>
> Huh, that's interesting.  I still get other weird failures in g/753 like
> attr fork block 0 containing random garbage, but I've not seen this one
> yet.
>
> I suspect what's happening is that the attr intent code might have
> finished writing the new attr and cleared incomplete but didn't manage
> to write the attrd log item to disk before the fs went down.
>
> The strange thing that I think I'm seeing is a dirty log with an ondisk
> transaction that ends with the updates needed to allocate and map a new
> block into the attr fork at fileoff 0, but oddly is missing the buffer
> log item to set the contents of the new block 0 to an attr leaf block.
>
> But it takes a good hour of pounding before that happens, so it's hard
> even to add debugging to chase this down.
>
> --D
>
> > [   40.121475] XFS (dm-0): Mounting V5 Filesystem 82ccfb3f-c733-4297-a5=
60-0b583af89968
> > [   40.325118] XFS (dm-0): Starting recovery (logdev: internal)
> > [   40.947262] XFS: Assertion failed: (entry->flags & XFS_ATTR_INCOMPLE=
TE) =3D=3D 0, file: fs/xfs/libxfs/xfs_attr_leaf.c, line: 2996
> > [   40.947950] ------------[ cut here ]------------
> > [   40.948205] kernel BUG at fs/xfs/xfs_message.c:102!
> > [   40.948500] Oops: invalid opcode: 0000 [#1] SMP NOPTI
> > [   40.948932] CPU: 0 UID: 0 PID: 4585 Comm: mount Not tainted 6.19.0-r=
c6+ #3467 PREEMPT(full)
> > [   40.949483] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS=
 rel-1.17.0-0-gb52ca86e094d-prebuilt.qemu.org 04/01/2014
> > [   40.950048] RIP: 0010:assfail+0x2c/0x35
> > [   40.950252] Code: 40 d6 49 89 d0 41 89 c9 48 c7 c2 58 ed f8 82 48 89=
 f1 48 89 fe 48 c7 c7 d6 33 02 83 e8 fd fd ff ff 80 3d 7e ce 84 02 00 74 02=
 <0f> 0b 0f 0b c3 cc cc cc cc 48 8d 45 10 48 89 e2 4c 89 e6 48 89 1c
> > [   40.950871] RSP: 0018:ffffc90006dc3a68 EFLAGS: 00010202
> > [   40.950871] RAX: 0000000000000000 RBX: ffff8881130bd158 RCX: 0000000=
07fffffff
> > [   40.950871] RDX: 0000000000000000 RSI: 0000000000000000 RDI: fffffff=
f830233d6
> > [   40.950871] RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000=
00000000a
> > [   40.950871] R10: 000000000000000a R11: 0fffffffffffffff R12: ffff888=
11ac9c000
> > [   40.950871] R13: ffff88811ac9c0d0 R14: ffff888117b8e300 R15: ffff888=
1130bd100
> > [   40.950871] FS:  00007f35a3087840(0000) GS:ffff8884eb58a000(0000) kn=
lGS:0000000000000000
> > [   40.950871] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > [   40.950871] CR2: 00007fff920deed8 CR3: 000000012821e004 CR4: 0000000=
000770ef0
> > [   40.950871] PKRU: 55555554
> > [   40.950871] Call Trace:
> > [   40.950871]  <TASK>
> > [   40.950871]  xfs_attr3_leaf_setflag+0x188/0x1e0
> > [   40.950871]  xfs_attr_set_iter+0x46d/0xbb0
> > [   40.950871]  xfs_attr_finish_item+0x48/0x110
> > [   40.950871]  xfs_defer_finish_one+0xfd/0x2a0
> > [   40.950871]  xlog_recover_finish_intent+0x68/0x80
> > [   40.950871]  xfs_attr_recover_work+0x360/0x5a0
> > [   40.950871]  xfs_defer_finish_recovery+0x1f/0x90
> > [   40.950871]  xlog_recover_process_intents+0x9f/0x2b0
> > [   40.950871]  ? _raw_spin_unlock_irqrestore+0x1d/0x40
> > [   40.950871]  ? debug_object_activate+0x1ec/0x250
> > [   40.950871]  xlog_recover_finish+0x46/0x320
> > [   40.950871]  xfs_log_mount_finish+0x16a/0x1c0
> > [   40.950871]  xfs_mountfs+0x52e/0xa60
> > [   40.950871]  ? xfs_mru_cache_create+0x179/0x1c0
> > [   40.950871]  xfs_fs_fill_super+0x669/0xa30
> > [   40.950871]  ? __pfx_xfs_fs_fill_super+0x10/0x10
> > [   40.950871]  get_tree_bdev_flags+0x12f/0x1d0
> > [   40.950871]  vfs_get_tree+0x24/0xd0
> > [   40.950871]  vfs_cmd_create+0x54/0xd0
> > [   40.950871]  __do_sys_fsconfig+0x4f6/0x6b0
> > [   40.950871]  do_syscall_64+0x50/0x2a0
> > [   40.950871]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
> > [   40.950871] RIP: 0033:0x7f35a32ac4aa
> > [   40.950871] Code: 73 01 c3 48 8b 0d 4e 59 0d 00 f7 d8 64 89 01 48 83=
 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 49 89 ca b8 af 01 00 00 0f 05=
 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 1e 59 0d 00 f7 d8 64 89 01 48
> > [   40.950871] RSP: 002b:00007ffce01ac698 EFLAGS: 00000246 ORIG_RAX: 00=
000000000001af
> > [   40.950871] RAX: ffffffffffffffda RBX: 00005625531e3ad0 RCX: 00007f3=
5a32ac4aa
> > [   40.950871] RDX: 0000000000000000 RSI: 0000000000000006 RDI: 0000000=
000000003
> > [   40.950871] RBP: 00005625531e4bf0 R08: 0000000000000000 R09: 0000000=
000000000
> > [   40.950871] R10: 0000000000000000 R11: 0000000000000246 R12: 0000000=
000000000
> > [   40.950871] R13: 00007f35a343e580 R14: 00007f35a344026c R15: 00007f3=
5a3425a23
> > [   40.950871]  </TASK>
> > [   40.950871] Modules linked in:
> > [   40.964577] ---[ end trace 0000000000000000 ]---
> > [   40.965044] RIP: 0010:assfail+0x2c/0x35
> > [   40.965274] Code: 40 d6 49 89 d0 41 89 c9 48 c7 c2 58 ed f8 82 48 89=
 f1 48 89 fe 48 c7 c7 d6 33 02 83 e8 fd fd ff ff 80 3d 7e ce 84 02 00 74 02=
 <0f> 0b 0f 0b c3 cc cc cc cc 48 8d 45 10 48 89 e2 4c 89 e6 48 89 1c
> > [   40.966296] RSP: 0018:ffffc90006dc3a68 EFLAGS: 00010202
> > [   40.966588] RAX: 0000000000000000 RBX: ffff8881130bd158 RCX: 0000000=
07fffffff
> > [   40.967151] RDX: 0000000000000000 RSI: 0000000000000000 RDI: fffffff=
f830233d6
> > [   40.967546] RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000=
00000000a
> > [   40.967947] R10: 000000000000000a R11: 0fffffffffffffff R12: ffff888=
11ac9c000
> > [   40.968322] R13: ffff88811ac9c0d0 R14: ffff888117b8e300 R15: ffff888=
1130bd100
> > [   40.968687] FS:  00007f35a3087840(0000) GS:ffff8884eb58a000(0000) kn=
lGS:0000000000000000
> > [   40.969101] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > [   40.969437] CR2: 00007f9fd47ad3f0 CR3: 000000012821e004 CR4: 0000000=
000770ef0
> > [   40.969806] PKRU: 55555554
> >
>

