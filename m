Received: from out203-205-221-242.mail.qq.com (out203-205-221-242.mail.qq.com [203.205.221.242])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E88A72517A5;
	Tue,  7 Apr 2026 07:47:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.205.221.242
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775548039; cv=none; b=SygIz8+MOHc2s42UTX1Sd3t5ijQuFgOHMX6LPT0o71XwQ+kn1AKBrEQ86c/hxd7YMibm37hkCNnnYoA837zPtnHsjySBAPpXjMGjLeAFbp3xex9cL6RLlwlTE/ZVFBB7tz3Ub4Jimo1teNFmBK2ihzzePg7t+qqkUMBruGwAD+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775548039; c=relaxed/simple;
	bh=qFv8QsFh/xiKx6VBpYuLsLqTUulIaF9v6woPtdjaatQ=;
	h=Message-ID:From:To:Cc:Subject:Date:In-Reply-To:References:
	 MIME-Version; b=ttMVh3KVGptQIIuYttvM2gIDplkhWmqgN1d/33jf364PGajcD7mmLVOt1O3cGQGq6N8w45mmUCDn9iYB2+yvNb4BtdiJIJrOc3XyQId9sUdBTDiaFK4kXv2PYS/2Dy0k8Pa2I682Chb6Yy+x1RcoyaMQnx959wkJxYxz7g8GeKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=IH6EIOq+; arc=none smtp.client-ip=203.205.221.242
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="IH6EIOq+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1775548027; bh=RDC8o6OdegxpUOEp4AJl1g//9abi5iIRbTtGQSnE0oE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IH6EIOq+MZBI5EZ6YnNWRlfGb5Dibj2zNeh9a1sntqYNijWcOUrNLyOWgsToS6CIR
	 RDI26p9dN8JlxDpSbnTMKXQHKvhX4Vtah+jqBxh7dXdEx4oanR3lLdjcNBASx6i0AY
	 9hO1E27L0umqU4wHnnHLnMPqr6fbyckp6Z8lfsc0=
Received: from lxu-ped-host.. ([111.198.231.89])
	by newxmesmtplogicsvrsza53-0.qq.com (NewEsmtp) with SMTP
	id BC523457; Tue, 07 Apr 2026 15:47:05 +0800
X-QQ-mid: xmsmtpt1775548025tzngoxk3s
Message-ID: <tencent_12A5E00DE4922B5DB55DB19945CFF68D9407@qq.com>
X-QQ-XMAILINFO: MpYZqmNm/7vMilm/vj/vO+jaCR2V2LCVFu4BaKNznZMjW67lCfO9mKkJV22AyB
	 6g324n2ht8uTXgeR7kvjQREdeLgq7B6bg6EZXaxe/eYcI1iSuGRRZD7D/3HcuOw3wuEZLDOeau6Y
	 48j4edr3oWw02a+4b5c3ZYFCJSwni5IzsCdO0T7z1MjIxUl+SA5lOCZW1cpQQiGDXoHOiHvXOQzk
	 /9ESoYpgxBs1oZ0dDzKaw05Jo7qI66oAR24orIbAyHmJ+FWm2JIctByj5z+8B3ihqLpc2i/PMmw3
	 AsYaFtfWoOxiRk5DUMOHOyxwiUcEhMjTRlHnVTe3i2Z1xwwhr4EwihlH+FvgIfAvNMHPweAkMW3H
	 5ZFdI/OWa6v8hEZajWucud3SMFFKNKpmfNxRq7+qsRiR4waRpbe7WkzI1U/OPLV/VelVSflf1240
	 FQLJkoj+d1n1JIyDb/lJ1B/nOADBtUBA71QF3hL8H+eAdCRPAxvv/2hUORMIhz7gnv3jq3egZrWA
	 bC6epHB+bfCHdXjiLVtBDvZLwC8Rosd2QIaXzEnC1+f/zyNbhFH13/Fa4BbUKWFmZK9MZvjLV8HR
	 hxZTpD0JaSh9HHIrBurr8rU+JVe6lmbJpAeM6uwUxs9A3I3PMaepDTdZSJKJuCnKySy+3ZqSFH2Q
	 S+CBLLfOHKdDFmmVtFE7aseqdyEN1ULXFFQfzjuXcL2DtjeWZmh0oAvJliX2m3rwNS6AEjTL/P83
	 pjQpeb68xvfNStSo0BEOrmf4JwtmQ2SV9+3MZXV2s5qlWEx6u+BxE/OFCAyoeq0mqleqcmlbLDBm
	 7fsgl5RDIFda+tg7jvPZhIq1DItl944/756sV4jzCHALh5okUnk2QCYiAxdMaYv7eRyTt/8IwOGV
	 Xq/ft+YXNY3mnNGf2HW+DzS5zTYzXkmJjPRyL/fkhfOoToMikEDE9GvinSwZSdD6CQ3PZTIcX48j
	 tncFjjNTrRZFf2BGsqKdr1UXEYliLM+vM3w0Np7Tguh5/OoSiLuu2vveL94x8iwjsECQ/am+fgiD
	 EOS2SyXnAbSXIdje5E
X-QQ-XMRINFO: OWPUhxQsoeAVwkVaQIEGSKwwgKCxK/fD5g==
From: Edward Adam Davis <eadavis@qq.com>
To: bfoster@redhat.com
Cc: cem@kernel.org,
	eadavis@qq.com,
	linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	syzbot+b7dfbed0c6c2b5e9fd34@syzkaller.appspotmail.com,
	syzkaller-bugs@googlegroups.com
Subject: Re: [PATCH] xfs: reject CRC validation when the log header cannot be retrieved
Date: Tue,  7 Apr 2026 15:47:05 +0800
X-OQ-MSGID: <20260407074704.35442-2-eadavis@qq.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <adO_Rm7EN4vwWaYX@bfoster>
References: <adO_Rm7EN4vwWaYX@bfoster>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Mon, 6 Apr 2026 10:12:22 -0400, Brian Foster wrote:
> > When the traditional algorithm fails to locate the log header, it triggers
> > the uninitialized-value issue regarding tmp_rhead_blk reported in [1],
> > continuing with the subsequent CRC verification traversal in such a
> > scenario is futile.
> >
> > A check has been added to detect the absence of the log header and prevent
> > the execution of the subsequent CRC verification traversal.
> >
> > [1]
> > BUG: KMSAN: uninit-value in xlog_verify_head+0x6c3/0x910 fs/xfs/xfs_log_recover.c:1058
> >  xlog_verify_head+0x6c3/0x910 fs/xfs/xfs_log_recover.c:1058
> >  xlog_find_tail+0xc2e/0x1a50 fs/xfs/xfs_log_recover.c:1315
> >  xlog_recover+0x6d/0x800 fs/xfs/xfs_log_recover.c:3426
> >  xfs_log_mount+0x4da/0x880 fs/xfs/xfs_log.c:617
> >
> > Local variable tmp_rhead_blk created at:
> >  xlog_verify_head+0x81/0x910 fs/xfs/xfs_log_recover.c:1032
> >
> > Reported-by: syzbot+b7dfbed0c6c2b5e9fd34@syzkaller.appspotmail.com
> > Closes: https://syzkaller.appspot.com/bug?extid=b7dfbed0c6c2b5e9fd34
> > Signed-off-by: Edward Adam Davis <eadavis@qq.com>
> > ---
> >  fs/xfs/xfs_log_recover.c | 3 +++
> >  1 file changed, 3 insertions(+)
> >
> > diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> > index 09e6678ca487..0d1b4bddd193 100644
> > --- a/fs/xfs/xfs_log_recover.c
> > +++ b/fs/xfs/xfs_log_recover.c
> > @@ -1050,6 +1050,9 @@ xlog_verify_head(
> >  	if (error < 0)
> >  		return error;
> >
> > +	if (!error)
> > +		return -EIO;
> > +
> 
> Hmm.. at this point we've located the head block, pulled the tail block
> from the log record header and are attempting to find the last written
> log record that could have potentially been torn based on max iclogs so
> we can verify it with a CRC pass.
> 
> Have you dug into how syzbot triggers this issue? The tweak seems
> reasonable at a glance as I'm not sure why we wouldn't find at least one
> log record header in the head/tail range, but at minimum the patch
> should provide some analysis on why we should make that assumption here
> and how this happens. It would also be ideal to know what's going on to
> help determine whether there isn't some other issue here that might need
> to be addressed.
> 
> For example, are we returning 0 here for the head verification pass and
> aside from the uninit variable issue, falling into an otherwise
> functional log recovery? Or does log recovery ultimately fail further
> along? I'd be hesitant to blindly add an error return into a functioning
> recovery situation as that might imply there's something wrong with the
> verification logic, whereas maybe it's a different story if there's some
> corruption or something that we're not handling gracefully enough.
> 
> FWIW, I did some LLM prodding at if/how something like this might happen
> and it threw out some ideas based on records wrapping the log, but TBH
> given the difficulty it has processing the details and layers of
> complexity here I'm not really sure I trust it. The best bet is probably
> to dig more into what the log looks like and why it triggers the issue.
I have reviewed the logs but was unable to find sufficient evidence to
substantiate the existence of records between the start and tail points.
Perhaps once syzbot generates a relevant reproducer, I will be able to
investigate the root cause further.

Edward

