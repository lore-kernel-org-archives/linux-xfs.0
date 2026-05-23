Received: from mail-qv1-f42.google.com (mail-qv1-f42.google.com [209.85.219.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0006B387348
	for <linux-xfs@vger.kernel.org>; Sat, 23 May 2026 10:58:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779533940; cv=pass; b=H5eS9pviRyxsD954Th/NQom90AqGe7AVep7d91g3vBurUuFDGJOpdE5c0bIczx0ekoHpgPIAoPDmrCWR0jUWthVHJRvlTRyhA+ieLP+P66Fs5bmKOPlJ6Lke+cKpvgCuBxjv/hL3LMSgON+l0vN60IomNDdegWWqPyV6BRoDK5E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779533940; c=relaxed/simple;
	bh=nCmMwkBwUImlkzxWG3Un8vb2R7F6fTAERklhG+Bd4Lg=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=s9nBeWqQhCjTLlEoS8YRe08MTLE0mIOeClpiAe1RqXAD2t22pTsJEPdDBgJym4WNtmnaU40fUUS37bsMyN1hxpMp+5mYYEKdHGalQ6axyAiTEgYI/RI1okj0qOarTiJVv+vm5BzpgG2woIUDeRFTpZ8bcU2oWmj+Y61UUdu7BYI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IjXZvTyz; arc=pass smtp.client-ip=209.85.219.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IjXZvTyz"
Received: by mail-qv1-f42.google.com with SMTP id 6a1803df08f44-8b3fe2f19a4so86512746d6.2
        for <linux-xfs@vger.kernel.org>; Sat, 23 May 2026 03:58:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779533938; cv=none;
        d=google.com; s=arc-20240605;
        b=YAesjAqntks4zSRxqqqzgOqT+fGi4E4FXtwqHoi5oEh+evnw3c8Gvf7w5TpWl4+tCJ
         y251XZuxP3OVQz54i7AbAC2aXQYxf0tqC0ehPzV02PV6Ees6p7y/37idG/9K1sxCNv7P
         HKH9xz2+HuhDOCQOWH1/J7+HHUNwMd/wc5GZUSO8naEU52if8E6V/KoBBbDW2dg3Lt3/
         InNOaly0H7WUg5wqxYfE5ACP6N+1iQ0Al13jSJkyox1GKiQrrJi7W4gqKIbIUegTJjZV
         y+LDPhDCWGZgiDXeWKDr5/ZoGWtJ6bbUC6WgXQ4NSaGGjVvQx5b/jVJTfV2YUarDKS+y
         1JMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=nCmMwkBwUImlkzxWG3Un8vb2R7F6fTAERklhG+Bd4Lg=;
        fh=xnI1UoOcOCvPIDwSelgWsS/p9v5aXT9tVHJhv4acgpw=;
        b=V52GJF/I9WQRWkhYlFvZ1VmfPak8ME+AAs0FtSdSmoE+c8/k49Ks6ltbq22VAS2bVy
         mvnJd5E5PwtPG2ln3QdqojyvDmBDmQSxFTSyJlseMW7dYu8E3sqo0OkFBHDgFJOFCoNq
         9U91d4G+uJ9EIaO6M/HV0gSQEVHa0sDDKA98N3ZwLZ5RpdmJezjzNMDyHkPnEdl9kp9r
         064GIigaWOt5bITUF/JkBMMWpNvGn+W5PE4PmNV1UrEKsX7UJstpFLpvhFdA6ReU4uL2
         KPcIVeQFN4vKznUCsAJ0ZtoaMI+ht9UsH932E2+YYtCaR1vBBcDeu/j9RkIxZnAwO/Of
         sJig==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779533938; x=1780138738; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=nCmMwkBwUImlkzxWG3Un8vb2R7F6fTAERklhG+Bd4Lg=;
        b=IjXZvTyzZQ4sSnWU8Euii8yvJVIElpELWNS+QFkAWbqLsfCQ/br2ykrDpktyDV7Wnv
         zP6TPisEgR9ksHJBQONvyxep/w5ndliB6kHQR6LLrML8ph1B74Dwzwby+ijrcpMQILjB
         /WdEy3he30XQ1T1u/GufosWYHXaHg3MlCDkh8UqhpkNjKLECv64SxWDQ2XDij9MFmSpa
         pZvyZNtqZo3Hreyxh8lOr2cFkS4rF4wi+/Y8rfVm93mEWG1PYuQwvAurleWeUWc960A2
         DKG6gROBolet3gg4g7VhcVd7hP9OkUAVVtZOe2LegQwfhWrgGSVbklPU/jTXY9u+WcYc
         fDDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779533938; x=1780138738;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nCmMwkBwUImlkzxWG3Un8vb2R7F6fTAERklhG+Bd4Lg=;
        b=b1d+s9BTPUxMyfI1Hi7ljERxZ0e+T7Ii0jVVdXBFW8cVu9yA6XjxeqUOf8ecpNOonf
         GPy7kRWTFaOW+dmauenjSZL9O0pRczR4ZC8Qi8F+39PQLuqh/TT6Qo0Kp4B6NnYyzTJO
         ZnXWNtcTvK4/5D79VIq9igiEjEA3b2sze5VfyrvlFehlIt/Wax1bsTLRzww2rwUp/nHu
         Cw6rYp6kZYFNWAJ/9938z7H13dBD8aCFn47X+K9SdEkbyLbRCrcLaz30hiJZjU4Le/RC
         HbFuoMUzLDx+cxxaCoqEKq1T+DJZzwh3Zd4Am1VyKDN2j0gn5Gnlklw2NcZAqgGcyxgm
         rZLA==
X-Forwarded-Encrypted: i=1; AFNElJ/SXioUam9M9qBF7ZKDugAr3kz5AGSqKgLPpRHJ2VdRzOoTZXlskhBkG75MT8J3LeWRJ8b4pTFrTvI=@vger.kernel.org
X-Gm-Message-State: AOJu0YwtOH6K1aVjQcCEQHDg6AwOOPrRc0zw+6odMnyV/o9VZCwBjCpA
	tSxoRCyOCrUPFwGAgvJZ7Ns0xVsLtB2gNHODlhHHTyVuFV2bY2R6EOHG6lvMDmkX1ra8Nl6Gbrx
	f/rCBTneO7dSeYO43mR+nHo6hz8QmRV0=
X-Gm-Gg: Acq92OF8ZGsxJWzZTQxHTO6VQj7oDyjstPfonIUIDLJyOLPGojl1F3pJbZt/akJj9Xm
	jZ/7K4v8Drqy3WE6akW/bCv1K9ziynDcmx3WUsa3d7Qkkc2pSHFBYzSj+QkHLGln7hYgXl3mdZZ
	U8c8LsBEhxjlhEWD8hx0WjsUdMKzSneMjwIfpEXF1z0K6DW0j6QjThDP2Be6P8qLYS4oHoKI5i2
	xkvNv5w2pr4OfQefzfox5rV4ao39UlNU0lVNv8b+F+b3Vi4j9aukDjLQ9ogw27EXZ10IMS+vhFR
	oTLIuWvshJyZnG+IfkQBLkhMs9+iTA==
X-Received: by 2002:a05:6214:2dc7:b0:8bd:de6d:c336 with SMTP id
 6a1803df08f44-8cc7b618aa7mr109111426d6.18.1779533937855; Sat, 23 May 2026
 03:58:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Sam Sun <samsun1006219@gmail.com>
Date: Sat, 23 May 2026 18:58:46 +0800
X-Gm-Features: AVHnY4IqQEf0ebjnvb9KBwhTvsLOAOAAl8rdT96fCM2j6_dXNlD1krgnGP2bRPE
Message-ID: <CAEkJfYPhWdd59RKmuNLJg-bkypHz7xiOwaWyNVu3A8CUqQCnvg@mail.gmail.com>
Subject: [BUG] iomap: NULL dereference in iomap_finish_folio_read after
 deferred failed read
To: brauner@kernel.org, "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: syzkaller@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Dear developers and maintainers,

We encountered a NULL pointer dereference in the deferred buffered
read failure path. Unfortunately, no reproducer is available yet.

```
Oops: general protection fault, probably for non-canonical address
0xdffffc0000000000: 0000 [#1] SMP KASAN NOPTI
KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
CPU: 0 UID: 0 PID: 10774 Comm: kworker/0:9 Tainted: G L
7.1.0-rc2-g70390501d194-dirty #33 PREEMPT(full)
Tainted: [L]=SOFTLOCKUP
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.15.0-1 04/01/2014
Workqueue: events iomap_fail_reads
RIP: 0010:iomap_finish_folio_read+0x12c/0x2c0 fs/iomap/buffered-io.c:415
Code: 48 c1 e1 0c 48 c1 ea 03 4c 01 e9 80 3c 02 00 0f 85 6f 01 00 00
48 b8 00 00 00 00 00 fc ff df 4c 8b 6d 18 4c 89 ea 48 c1 ea 03 <80> 3c
02 00 0f 85 39 01 00 00 48 b8 00 00 00 00 00 fc ff df 49 8b
RSP: 0018:ffa00000058ffb50 EFLAGS: 00010246
RAX: dffffc0000000000 RBX: 00000000fffffffb RCX: 0000000000000000
RDX: 0000000000000000 RSI: ffffffff8263bc9e RDI: ffd40000023aab58
RBP: ffd40000023aab40 R08: 0000000000000001 R09: 0000000000000001
R10: ffffffff90b5ee97 R11: 00000000000009d8 R12: 0000000000000800
R13: 0000000000000000 R14: ff11000076809e80 R15: 0000000000000800
FS: 0000000000000000(0000) GS:ff11000183bb2000(0000) knlGS:0000000000000000
CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f6637788c38 CR3: 0000000036ca9000 CR4: 0000000000753ef0
DR0: 000000000000007f DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
PKRU: 55555554
Call Trace:
<TASK>
__iomap_read_end_io+0x478/0x940 fs/iomap/bio.c:21
iomap_fail_reads+0xa4/0xe0 fs/iomap/bio.c:43
process_one_work+0xbe6/0x2030 kernel/workqueue.c:3467
process_scheduled_works kernel/workqueue.c:3576 [inline]
worker_thread+0x693/0xeb0 kernel/workqueue.c:3657
kthread+0x38d/0x4a0 kernel/kthread.c:436
ret_from_fork+0xb09/0xdb0 arch/x86/kernel/process.c:158
ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
</TASK>
```

We analyzed the cause of this report. It seems that failed buffered
read bios are deferred to a global work item "failed_read_work". The
deferred worker still owns the bio/folio, but by the time it calls
`iomap_finish_folio_read()`, the folio may have been truncated,
invalidated, or otherwise detached from its mapping. In that case,
`folio->mapping` is NULL, but the error reporting path unconditionally
dereferences `folio->mapping->host`. This pattern still exists on the
latest kernel commit.

A possible fix could be avoiding the `folio->mapping->host`
dereference in the deferred failure worker, including storing a stable
inode/address_space reference when the read bio is submitted or
completed, or using `folio_mapping(folio)` in
`iomap_finish_folio_read()` and skipping `fserror_report_io()` if the
folio has been detached.

Best regards,
Yue
