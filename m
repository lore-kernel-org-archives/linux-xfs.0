Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=203.205.221.210
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794042914;
	b=eL8OgpETsYsF6iVVxhRoydKJC++DC+x0aMP6u9535LOC7dfc5g8V8ggr3AQA9FdV4kL0
	 4mRbhjyRN4r023sXsi13shuvlQ6Ayxt4LYTVZtVxkzMTSZL5LbSCw6F8raxtvHUGjDrHq
	 dgbygSJBPzpx1KKnF7POk29lkfyu3RIYYtZzfvJru0NCMuVgl8NAX0Munx8DGi++Yz7HX
	 VwbDZOPbqBvorgTC3E03FZzkuj6/C+Hw3VvtyZURbUmqnnDeeiXNqHjq6CNx0lW3pmy5P
	 omE/HkIMxnerP1jPbyU/0ga+OvRKKixis9ruVl0i4zzckIM+h2o4w/gWXAu4vrD9ctw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794042914;
	h=DMARC-Filter:DKIM-Signature:Received:X-QQ-mid:Message-ID:
	 X-QQ-XMAILINFO:X-QQ-XMRINFO:From:To:Cc:Subject:X-OQ-MSGID:Date:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	bh=MucAmHwZfvXXGvF6SgWbnq+9pRH9M2Sh8sGxdlGgfiY=;
	b=GN3z6t0JOJEZ7NXVYOY8NMVCFX/AFHPyQa1fTR99+2BTQHIGR28kJh2GPJgJvOy94Wpi
	 GTbpNbTKRuVixlVbeYzX7ZAiRiXzHX3egcODL02nLCAxJzLpu4HsNmOYKvHEGZpj2JwsF
	 isPdvWWI/pfQZbsBfuN1yU9uD9zPElXzs9Ol6BfYa2x3ZpZ6LI0ubd4GOQgYci9JbH39y
	 zL/iqETQu+7dwSHnsxig61R1XElffLj/tEQX4GlHsseDsUwAwCcs39ST4Lf1aieXOl1Wr
	 udt7gx6cU1u55r6bHHSIYkM75idpSzOtboeEm9o9i57hZv9cRldV6vcXb9Kj8aojqjA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=qq.com;
	spf=pass smtp.mailfrom=qq.com;
	dkim=pass header.d=qq.com header.i=@qq.com header.a=rsa-sha256 header.s=s201512 header.b=xk8EKJeS;
	arc=none smtp.remote-ip=203.205.221.210
Received: from out203-205-221-210.mail.qq.com (out203-205-221-210.mail.qq.com [203.205.221.210])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 559E1606A326;
	Sat,  7 Nov 2026 09:15:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 559E1606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=qq.com header.i=@qq.com header.a=rsa-sha256 header.s=s201512 header.b=xk8EKJeS
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1794042903; bh=MucAmHwZfvXXGvF6SgWbnq+9pRH9M2Sh8sGxdlGgfiY=;
	h=From:To:Cc:Subject:Date;
	b=xk8EKJeSUHrr+Moz8iA9+AMxn3rTI8rc7fnushpxAtct7zaailZXv2f+DN0KlsoNx
	 4CmMKBACq+1KbOHwmcUD9rF7nncIivsOcAXYAUvx4THUbZHKwAgxHztJPQADY5vnIl
	 SaxoebczMh7WzQGVEqGHy1HgUPBBWHmj0uFSo3FU=
Received: from [172.18.4.77] ([202.113.185.209])
	by newxmesmtplogicsvrsza53-0.qq.com (NewEsmtp) with SMTP
	id 3C186437; Sat, 07 Nov 2026 17:15:01 +0800
X-QQ-mid: xmsmtpt1794042901t9v37fqed
Message-ID: <tencent_11C734248ADE0736CA2735F63B7064C76905@qq.com>
X-QQ-XMAILINFO: Od8VqZhFMB3NV2D5EPFAJHQDK19H0OO5uzL+P3r5Su9o5xZiFC1qXZLSNTu/PI
	 BQc4zsbquTWKy2asMC8RnORwP57sSx9/b7jHyIuuxOvNUd+nqp2JLi1/bZIW2ZGZlYZl+LXBuaZH
	 1oxlZ0+HL+n24vleyiaL4lnRkWKocuu9MUTSkKcWtBkwsiTPSRYX4FgtmimB/aeQESYRJ0FfMnCH
	 eBpB5bP4vsk4Hw+8EHU56aSJPIOAScIC95/nhQCW485+YxIlYTU7CTVj+ZB10GwoE55GKRS7fz9i
	 HQModdSoIZ1uQ1o2A7XmC0NDxHDm9UkLODRFRVlTbmBWOr/VfvfXsdGJmAqy5UXFr7/kPhCaC8B9
	 dpOC1Te4yZJgXjQTMvx2jgvDiK9zjG/JEo5SWTeGTpgm/QI9sYAWZAICw2Q2j5kfvN1Ki1EgGTa1
	 T0LusQYJlaBxzWGaTy94YFZ3VN8+q9RnUM3vS3/fG2+5qiRcG2SrAzT+j0mIBJ51JNeX4UpbIq7I
	 jfVfw8ImaAAZrgmiqwUOz3sHVwE16VSkBWAoo+VdNtglEqPSmd4DFsn8LWEt/X0kQp7+OtPX/uh7
	 MPDe0mGqFiUZpskGiaHxhmFjuGGJO8/9nd8VXpI0jKTW8jFqnr/W6ez+3ypVlqRiEwgVSHcjdvrF
	 PCWc//ftt8eI/mKqp32t8QowO6exH8I3fE8lhwnY4pdMN5kf+XA2ejBOqexJ7INOgbWfMpDQGYHm
	 N26152VD+eWkAU7Se28mu1qFX5w9fR7Zy06lYSaIOVfnFy4FniN4NclqG1mv/bPu+g8IaGObrEqB
	 /afCgynqt2rENmSKwpkV76SvSBEvn6hS5rJas0oGwMVssMJJFZf7q12omzJPEGRJG+hwLE8Zy0ba
	 H4yBpJLQasr+7q9hR2I5wscDHBia6gLSJU3KobiMmtKLzM77RfO1L4tL2APAa+7xYnInDzud2mBu
	 9/WpLsgljm4tV2Fq2NMs0WS5ZqkYDvgIb3+4p+oXhtK7djNq/fLLtEVyLg+miuPnV7PdZRSxp2//
	 ZcOmRt1lsFt51UbUqXKwqUCeoar/qF1v/kiXvd6ByHmiZYaU3LgYPK8yB1k6bXm+T1+FWeAfhXw7
	 5EdSwY8Jldcdy5CgI=
X-QQ-XMRINFO: MSVp+SPm3vtSI1QTLgDHQqIV1w2oNKDqfg==
From: Guikun Yang <yangguikun19@qq.com>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: xfs: XLOG_WAS_CONT_TRANS on a transaction with no buffered regions
 reads ri_buf[-1] - null deref Oops during mount log recovery
X-OQ-MSGID: <c30-xfs-wascont-rideref-20261107@qq.com>
Date: Sat, 07 Nov 2026 10:00:00 +0800
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

Hi,

Mounting an XFS volume whose log record after the transaction header
carries an operation header with the XLOG_WAS_CONT_TRANS flag panics
the kernel during log recovery - on a stock kernel, no sanitizer
configuration needed:

  BUG: unable to handle page fault for address: fffffffffffffff0
  #PF: supervisor read access in kernel mode
  Oops: Oops: 0000 [#1] SMP KASAN PTI
  RIP: xlog_recover_add_to_cont_trans+0xf9/0x460
   xlog_recovery_process_trans
   xlog_recover_process_ophdr
   xlog_recover_process_data
   xlog_recover_process
   xlog_do_recovery_pass
  Kernel panic - not syncing: Fatal exception

## The gap

xlog_recover_add_to_trans() creates a recover item for the transaction
header via xlog_recover_add_item():

  item =3D kzalloc_obj(struct xlog_recover_item, ...);
  INIT_LIST_HEAD(&item->ri_list);
  list_add_tail(&item->ri_list, head);

The item has ri_cnt =3D=3D 0 and ri_buf =3D=3D NULL - the transaction header
itself is copied into trans->r_theader, not into the item.

If the very next operation header carries XLOG_WAS_CONT_TRANS,
xlog_recovery_process_trans() dispatches to
xlog_recover_add_to_cont_trans(), which takes the tail item and indexes
it without checking that it has any regions buffered
(fs/xfs/xfs_log_recover.c:2144):

  item =3D list_entry(trans->r_itemq.prev, struct xlog_recover_item, ri_list);
  old_ptr =3D item->ri_buf[item->ri_cnt-1].iov_base;

ri_buf is NULL and ri_cnt is 0, so the expression reads
NULL[-1] - the faulting address fffffffffffffff0.

Nothing on the path validates the operation-flag sequence against the
item state. The only ri_cnt-related check in the recovery code is an
ASSERT() in xlog_recover_reorder_trans(), which is a no-op on a kernel
without XFS debugging enabled.

Note that the flag's name suggests it belongs to a continuation, but
reaching the crash does not require constructing one: a single
XLOG_WAS_CONT_TRANS operation right after the transaction header is
enough, because the dispatcher never checks that the previous region
had a buffer attached.

## Reproducer shape

The volume is made with a real dirty log (mkfs.xfs, files, sync, crash),
then the first region operation header after the transaction header has
its oh_flags changed from 0x00 to 0x08 (XLOG_WAS_CONT_TRANS), and the
v2 log record CRC is recomputed (328-byte header + h_len payload). The
unmodified dirty-log image recovers and mounts cleanly as a control.

Trigger is mount(2) alone. Reproduced 3/3 with panic_on_oops; the code
in mainline as of 2026-11-06 is identical here.

## Suggested fix

Either bound the item before use in add_to_cont_trans(), or validate
the flag sequence at dispatch time - XLOG_WAS_CONT_TRANS on a
transaction whose tail item has no regions is corruption and should
fail recovery the same way the other -EFSCORRUPTED paths do:

  item =3D list_entry(trans->r_itemq.prev, struct xlog_recover_item, ri_list);
+ if (!item->ri_cnt) {
+         xfs_warn(log->l_mp, "%s: continuation with no previous region", __f=
unc__);
+         return -EFSCORRUPTED;
+ }

The reproducer (image builder that locates the record/op, flips the
flag and recomputes the CRC, plus a ready-made image and serial log) is
available on request.

Thanks,
Guikun Yang

