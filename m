Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.169
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793882757;
	b=pBnRv3m46fAU2CD0iOYAz6oEj4SkdR6q7TqMBtrjSTcleUf6Vhz/vg/SsHKh/uLVV0cg
	 jDrhCwbQMJb3xcH1H092d83UuEWSDfDjEA5jTJp1e2Fbn869KOUOcx7ldwfUinQyQJmmt
	 ctf5uyC4D+vNvpZsC3SvYDa0CG8sq6G4CNmSBGuqJiJBQnfiSzDP/mDpDhfphV2fyLyKC
	 kb8dmFxlt/E0WAzcAIpnvaX+AhH5iWUncyQqqlQ0PnJpTe+pxTHBdMNCFw4pfTihDyM89
	 lFGtGJj9GJrPE0zOj3E2yGm4mKSavXZ4KTIxSMh6pNO+L801xuKzxT2TebyGtg/YdtA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793882757;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:In-Reply-To:References:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=i57L9NPhlWOeObQMnsgg83R3hDrmi9l2QFEwRbn/Ljs=;
	b=SAKtnWGAUXOkycUyye4KtCfhK7D5oF4FeuVvx4bpOFe8jdcyaRNyhb3lR2XAf3IJytOf
	 iQ47QHPJC5rdcmkQaNQcs/OBOrDNIvPV4iClCK55vHidQbtzOkvgp7Ew5yfpSVoUQiDeL
	 sveRJlj0hGZd8smcW2y0wGU7rctm+Lr7w9+ukD/gP9NuQ3NxzQdFkSA6aDwkBY5YXU8ue
	 0qKT2tvPO6ZhSzlvGOEXHUAp1zW65Wg+avDT0lLG45YUiFcYEKGcAK/7Q/tNmrb8Jgfi7
	 mFmK2aNiqMNvGrWJL2qP32lLLI/SIuS8iyDH1aWXtlGsU1CVpSStIqzHd51ZclgsQ7Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Ns5PjF7Y;
	arc=none smtp.remote-ip=209.85.215.169
Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F900606EEA3
	for <linux-xfs@vger.kernel.org>; Thu,  5 Nov 2026 12:45:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8F900606EEA3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Ns5PjF7Y
Received: by mail-pg1-f169.google.com with SMTP id 41be03b00d2f7-cc502d509c0so778649a12.2
        for <linux-xfs@vger.kernel.org>; Thu, 05 Nov 2026 04:45:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793882756; x=1794487556; darn=vger.kernel.org;
        h=mime-version:content-transfer-encoding:content-type:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=i57L9NPhlWOeObQMnsgg83R3hDrmi9l2QFEwRbn/Ljs=;
        b=Ns5PjF7Ya4uyR2QPdgTml+KtqWzgFmLDMdsUQ8InjAUb6eJkT3m/ifAvufkx+zW1Y2
         i8vA1fe0joPmbOhH3xWZbD1cblYL8BtQwgosNYoxrvhe+V9C3aVEFdfUsS69GZpHGero
         Beq1z0BdJHgl0fPSlbQVyoKCha9IngnGBXEPzehERbpVlD+46hUwOXG5tMW4CEaq/UM3
         zXALsnrrCiyiYbLghekwgN7VPpsS4zOn6uouAA7pGxYVpfjHwvpoaM5E15yvq0KEW2T0
         Havv8EumZB4pkLkDmE/LMr/UzmBa4tVVfCtRzBeAg39s+iJBz6zFVnt7+Opu6knGKwi4
         KVPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793882756; x=1794487556;
        h=mime-version:content-transfer-encoding:content-type:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=i57L9NPhlWOeObQMnsgg83R3hDrmi9l2QFEwRbn/Ljs=;
        b=A5bmu1QZ13kJG4HRoVICgh512TqL/rS0osoNrOIfYgJvELhadR4UNBfMSp29rGiExp
         wHsklqql5rc/C2s1fN9t76FDndbu6qyou481yqpQ+u/jQGDXZXmKedZ+V3Z/9MGeRibJ
         QS8gKRYn1n56DW0VO6b+Z/qjN2V3bgmdbTL+/JFQeDCda8TJygmJOhN/ohjyjLB5uaL9
         9BZ2UsqcKwNU42s7GVULHcWFnm0bEmH7wP3wVLNFDp16GhxwQ5IURgdEs7fOZd7jcgRy
         JQZ7JDzFn14AXA2knpTR/KGNgZhthW/VHllWhbtX3Aur5qAWJlXUn9bqsWxmECCzpN0T
         jwGA==
X-Gm-Message-State: APuU4Z8QUWMZ86Y+FWOdXTXZdOZnLH8eHt3kHdnhgfcCGGApu8FVZJjf
	ZyszmvZmGa74iH5bEBYZhSjExwzSGj4NNL7NiUiysKpi4w4w777qUosx
X-Gm-Gg: AYBFou1Hrwcd8Sdgu0/hk7sOuHyeAuHC9oYvzuiP0zpStApSLs6DL9+4Iq4sXUQNlRj
	f4Qo2NR5IbmUQYg2zF9qBpSn+2m/YEJL9/skZHj7x8iU3p7Nh6JLhhUBYmdHbYtXVgKr+jFHbLt
	xnyk090/rt7GM3lJ28wnxKWhjgv6LubibQl8ad/OcCrTJM2NoD/KmMuNogsRU9yXOEow3IhwDCS
	5liq2+ru8Dd9BL4ehsLP8dvRAZL+Y/Qxq7dJNqaTwKEkXnRVEWdh6fBjuvciN2GYhX3kZFBIwXK
	4Eljb8z6OVv61FZJEmIa9jXTbhsRbEk+zvrHpfwkNY1CuTgDfsjvudxk0H/CxM1IpNkopr7H9Hc
	sBFVz2FInlnLE86EmW0NhucalXERIVtjFvu3MWLIbRbHbz7QEUb8pnKFbSbOSChZONNyJv83q9v
	t5A/5vo4XO686OWxCmN3+aAoLd5UQX6hvqEKMLSRwx/vZ04JBXNaMUR/T+wGjhDpmjOH/vTRwWO
	9F82hH0QYpSRvccwxpofhkyslDE4neME7gEdqX0BTrXOjoBLAFZDoNwEBaeJf8kt+1FImNyLNed
	XUuo0cxVVG9hBAbKSKU7oDa2RQdnTEo5MEn3B66hx/0VnnKmC7C5
X-Received: by 2002:a17:90b:2551:b0:3ab:9f1a:3825 with SMTP id 98e67ed59e1d1-3ae8957c8b1mr17676948a91.4.1793882755612;
        Thu, 05 Nov 2026 04:45:55 -0800 (PST)
Received: from DESKTOP-UCPRL76.localdomain ([113.200.174.12])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b0b2cf80c9sm3927157a91.0.2026.11.05.04.45.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2026 04:45:55 -0800 (PST)
From: Zheng Shuhao <viennaoffh@gmail.com>
To: "Carlos Maiolino" <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
 syzbot+e7f24354da9f7915bc54@syzkaller.appspotmail.com
Subject: Re: [PATCH] xfs: fix slab-use-after-free in xrep_newbt_free()
Date: Thu, 05 Nov 2026 20:45:52 +0800
Message-ID: <1793882752.followup@viennaoffh.gmail.com>
In-Reply-To: <atL8bTDPVGlpZ0LB@nidhogg.toxiclabs.cc>
References: <20261016085536.591-1-viennaoffh@gmail.com>
 <atL8bTDPVGlpZ0LB@nidhogg.toxiclabs.cc>
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

Hi Carlos,

I have to admit I was not sure how to reply to your last message, or
whether I should reply at all. You said to wait until the patch gets
reviewed before sending a V2, so I did not want to push or send noise to
the list. On the other hand, it has now been a few weeks without any
further review or comment, and staying silent did not seem right either.
So I am sending this short status note; if you would rather I simply
wait, please say so and I will do that.

I also wanted to close the two items you asked about earlier, since I
promised them and then went quiet.

> Yes, sharing the reproducer (and potentially hooking it up into
> xfstests) is a good thing, specially giving the syzbot doesn't seem
> to have a reproducer for it yet.

The reproducer is a standalone harness, not a syzkaller program. It
mounts a scratch XFS with rmapbt and reflink, starts an online repair
that rebuilds a btree-format inode fork, and then issues
XFS_IOC_GOINGDOWN (LOGFLUSH and NOLOGFLUSH) from 1 to 8 helper threads
at 0-100 ms after the xfs_defer_item_pause tracepoint.

On the unpatched kernel this produces the reported KASAN
slab-use-after-free in xrep_newbt_free() -> xfs_defer_item_unpause()
on every run. With the patch applied, the scrub ioctl returns -EIO, the
shutdown path unwinds, the log replays on remount, the free block count
is unchanged, file data reads back intact, and xfs_repair -n is clean.
Healthy forced rebuilds still take the normal pause/unpause path.

I can send the harness and logs, but I did not want to attach a large
tarball to the list without asking first.

> I'm also interested if you actually passed your patch through xfstests
> before submitting it. There is no good fixing a bug if you create a
> handful of others. Specialy agains scrub, online_repair (and maybe
> fsstress_scrub) groups.

I ran the patched kernel against the scrub and online-repair fuzzer
cases, plus fsstress_scrub. To be precise about the coverage:

 - Completed with a real verdict: xfs/351, 353, 355, 357, 359, 361,
   363, 365, 367, 369, 371, 373, 375, 377, 379, 381, 383, 385, 399,
   401, 403, 405, 411, 413, 415, 417, 426, 428, 430, 497, 730, 733,
   736, 786.
 - xfs/387, 389, 391, 393, 395, 397 were started but hit my per-test
   timeout before reaching a verdict. They are long directory/xattr
   walks; I am not counting them as passes.

No KASAN report was produced by the patched kernel. The failures I did
see are all reproducible on the unpatched baseline as well, so they are
pre-existing and not introduced by this patch:

 - xfs_btree.c:1814 in xfs_btree_decrement (xfs/361, and also xfs/373)
 - xfs_buf.c:389 stale-buffer assertion (xfs/363, 365, 367)
 - xfs_log_cil.c:546 empty-transaction assertion (xfs/369)
 - xfs_attr_leaf.c:168 attribute-leaf assertion (xfs/401)
 - null-ptr-deref in xfs_btree_simple_query_range, reached from
   xrep_dinode_count_rtgroup_rmaps (xfs/375, 377, 379, 385, 399, 413,
   415, 417). This one reproduces identically on the baseline kernel.

> You'll need to send a V2. But wait until your patch gets reviewed, you
> don't need to send it right now.

Understood. I am holding the V2 until there is review feedback. When I
send it, it will use the correct identity:

    From: Zheng Shuhao <viennaoffh@gmail.com>
    Signed-off-by: Zheng Shuhao <viennaoffh@gmail.com>

Is there anything you would like changed in the patch itself, or any
additional data you want before I send the V2? If it is more useful, I
can also send the reproducer and the per-test logs now, separately from
the patch.

Thanks,
Zheng Shuhao
