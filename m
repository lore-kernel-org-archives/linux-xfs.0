Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=203.205.221.210
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794182418;
	b=R8/0aMG6q1B7kffKDL7fQz2cvMOTg9yDuT9xOnraBzqMq68gf5pFXc+dtJH7piCRyP62
	 jSaNq3Z628Be1yy7EPYbQb4DjcwoH1JGjpIbMvQKSIXgC9HKj676SsrBgi8Rq44efKcoY
	 ZP0CO7X0Yn8VMXCDUoVw39phDfaZvxa6Vyo8lXL7ruNzvoHzy+EcAQZ/HICnlQ4eqPQNs
	 ZmbC3c78vG0Y/YcP/sg1MCuY/XTFgQX2NYn7OrhRceE7YsvuN9SzOAWMDu517vahmpi3x
	 jnDNwMP7zLytDsi/3EHzW3kYU5yPr3NB05azhL+av2L6qpuD2wLiuWFnFJ0Br9NnIJw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794182418;
	h=DMARC-Filter:DKIM-Signature:Received:X-QQ-mid:Message-ID:
	 X-QQ-XMAILINFO:X-QQ-XMRINFO:From:To:Cc:Subject:X-OQ-MSGID:In-Reply-To:
	 References:Date:Content-Type:Content-Transfer-Encoding:MIME-Version;
	bh=CVNZj2FEK2vckSpkZFnHYv6wAtnwSlgWNBDdJUtzoU8=;
	b=VCxlwtnlrGIQOORvZZheQgO4jOm799zYOcxR2tUn2Eflh8AG6P9XP7vMKknGINSDVi+N
	 nRo7xQBCw7jU/ujW1Cwizpkh6vRRUj6qYKqyTP6rdDamlpyb4jTmEcOdL0rM4wVcpXRa1
	 iw9BULn6oJYW5xBIwEgeR1bB37ZoWtOAwOwJnMcqDNjiktmFBSRhps9Uo1v7wK5ln6SzZ
	 1ccznP+n2WGWNGoNLER4XV12vgRlppnozGN6Z7vGFNxm4HCGM3jvtdvaGVv2uqcJMbR1n
	 TcbHY1ajOWqg7zumyB1ZA/ik/LMi2vCF6zhxw49UsPllnZTOq5eyYTSbsMY7/mAiGrw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=qq.com;
	spf=pass smtp.mailfrom=qq.com;
	dkim=pass header.d=qq.com header.i=@qq.com header.a=rsa-sha256 header.s=s201512 header.b="vUvKf/MR";
	arc=none smtp.remote-ip=203.205.221.210
Received: from out203-205-221-210.mail.qq.com (out203-205-221-210.mail.qq.com [203.205.221.210])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EB33606A31C;
	Mon,  9 Nov 2026 00:00:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0EB33606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=qq.com header.i=@qq.com header.a=rsa-sha256 header.s=s201512 header.b=vUvKf/MR
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1794182413; bh=CVNZj2FEK2vckSpkZFnHYv6wAtnwSlgWNBDdJUtzoU8=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=vUvKf/MRF7IygFxf7I5ZtB0p47T0QvtoEvqz6Xy836NZjmngDbqNENU/TW9eXR6ti
	 XS22ci2VKpfDNv3hLf2OT6NE4Tz+lVAR2GZz/xhMKzzv96/RRMer5DDWzoDhHk0w/x
	 f2xcSJfgFAOoOGUxE1M7xntLdF7k/pvx6BZrbkJE=
Received: from [172.18.4.77] ([202.113.185.209])
	by newxmesmtplogicsvrszc50-0.qq.com (NewEsmtp) with SMTP
	id B368E8; Mon, 09 Nov 2026 08:00:11 +0800
X-QQ-mid: xmsmtpt1794182411txvd4s77k
Message-ID: <tencent_9931A9C9DF99237C4E27A67951F93E8D5108@qq.com>
X-QQ-XMAILINFO: MllZffuBkEb5TC0MCVmzphn1E0dKWRP6QKcZ9/xwomvc134rvU58iLv2OAGbFk
	 q1MR/RgbF8salfJqDX6rV08UBApO+/fHBFo8I85e7JqiG0tH+s/Sbe++mgaDtnlS4IhprLdRJFU/
	 Iqai+NoObS9rMuJ02I2DNDFwspHBiS/+lN3ueiZRp3RG72YfztHVtiQf+kyNFVT7SAZS3u4D2wXt
	 dWA6aXZk5nzRrvl11cvkmgTqEDTynz9IZL7dFcZgumAdHELtUsUeAQfMqfQYur/gwgDvWvX0TdGY
	 EOId0YpwcpNi6Qi7Pn1X+rs+jTAAQqWK9IzYB3HNy9LSt0Nj5Lg8P64FxXui/ld0bHWsdozFc2oo
	 nJV3g3s6pFTRipyYP5AHdesHeDFvyhjAnSZdGicB2AEd0TOUlmg2Sq8708d0EEyxt+Lt2DnrNyli
	 VUvNyb7bLJRSA8BQLneiwjkPpcBksan9URibdfTx5h5/BU85EPbdYIGAdRsXPOdKwhlZWWAOTc0D
	 GjEA/YsFDmio6JlkiBmSY9NC8N9tbW8uc+7uWlQNIVQrug6Po7yi22YazJE0RcfNu2M/8J9PXCqp
	 jSWD9uyQS7v6H3PvGXm0Adg64zPUr9ouBVGNgRDRxzf6Nw6Gx/aRNzJ9lgrlICXXDf50PWJ3IP4m
	 XFy5Sgw44fqmWOHGEnC0T8qiazufN/W61MKZxhKu4N7tMhBQEGDBizxt5kzmkFNQ0gtnzE5vB3f2
	 X9zbxZTyLQlBijs3FFwmJF5dtzKKpHt58BlR1D5s5kvvtLR1J0G/mPfH6v1Hgn/dA6Het02HE/xc
	 wnkwRXRLHrqNcpzSg3w2svQnHsPfO7S+wUmhzFsGl5qVdaG03ZxjPFbTNHEVNNrpcLFnzpmw4ALM
	 C2/zrRNa4BUxys2q1CxqNVi8nzMobW/42LBj9gI4Yy6MzNDSkelXxTuLsHgvcz8CCmKbA+9w+ekz
	 wlEUetKbPawNhxiTyPO3ANjS8+LghTWNU5poWfvqOPhwvU2elWd8EpAs/VmVtt/8HlaO3ZeyAFEU
	 Vf9Iz6FcrQS9c6xEFOOgTpaHYgsHWadwTGnyg3a90b8CvKpodS
X-QQ-XMRINFO: Nq+8W0+stu50tPAe92KXseR0ZZmBTk3gLg==
From: Guikun Yang <yangguikun19@qq.com>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: xfs: XLOG_WAS_CONT_TRANS on a transaction with no buffered
 regions reads ri_buf[-1] - null deref Oops during mount log recovery
X-OQ-MSGID: <c37-xfs-ilf-size-short-region-20261109@qq.com>
In-Reply-To: <c30-xfs-wascont-rideref-20261107@qq.com>
References: <c30-xfs-wascont-rideref-20261107@qq.com>
 <c31-xfs-logged-sb-geometry-20261107@qq.com>
 <c34-xfs-ilf-len-oob-20261108@qq.com>
Date: Mon, 09 Nov 2026 10:00:00 +0800
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
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

Another one from the region-collection stage that runs before any of
the item handlers - this one does not involve any item type at all.

## 7. ilf_size is read from a region smaller than the format header

xlog_recover_add_to_trans() allocates the region buffer with the
attacker-controlled oh_len and then reads the inode log format from
it (fs/xfs/xfs_log_recover.c):

  ptr = xlog_kvmalloc(len);
  memcpy(ptr, dp, len);
  in_f = (struct xfs_inode_log_format *)ptr;
  ...
  if (item->ri_total == 0) {
          if (in_f->ilf_size == 0 ||
              in_f->ilf_size > XLOG_MAX_REGIONS_IN_ITEM) {

in_f->ilf_size is at offset 2 of struct xfs_inode_log_format, so the
read needs len >= 4 - nothing checks that. len is the raw oh_len from
the operation header.

Reachability is clean: this branch only requires the item list to be
non-empty with no regions collected yet, which is exactly the state
left by a complete 16-byte transaction header (len ==
sizeof(struct xfs_trans_header) makes xlog_recover_add_item() hang an
empty item). A normal transaction header followed by a region
operation with oh_len = 1 reaches the read with a 1-byte allocation:

  BUG: KASAN: slab-out-of-bounds in xlog_recover_add_to_trans+0x799/0x830
  Read of size 2 at addr ...
   xlog_recover_add_to_trans
   xlog_recovery_process_trans
   xlog_recover_process_ophdr
   xlog_recover_process_data
   ...
   xfs_fs_fill_super

The read is of size 2 - in_f->ilf_size itself.

## Reproducer

Same shape as the previous reports: a real dirty-log image, the region
operation header's oh_len changed from 0x14 to 0x01 plus the four CRC
bytes of the log record. The unmodified image recovers and mounts
cleanly; the modified one hits the KASAN report at mount(2), 3/3.
Unchanged in mainline as of 2026-11-08.

## Suggested fix

Check the region length before interpreting it as a log format - the
header magic is the only field this stage may assume:

  if (len < sizeof(struct xfs_inode_log_format_32) /* or 4 */) {
          xfs_warn(...);
          return -EFSCORRUPTED;
  }

before the ilf_size read; the later xfs_inode_item_format_convert()
already handles short legacy formats properly, so the check belongs at
this stage.

The reproducer (image builder, ready-made image, serial log) is
available on request.

Thanks,
Guikun Yang

