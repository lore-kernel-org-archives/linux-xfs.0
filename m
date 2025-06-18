Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02AC42882A2
	for <linux-xfs@vger.kernel.org>; Wed, 18 Jun 2025 09:24:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750238688; cv=none; b=OZ/xPupPALVMsHg2gwk3ti/8noSvr6uK+edZzH6uyxeUdD0+BPJC7+wquBF9ImgSympHGV6Rzr+dTAAnAjzJEWHC5OgE8NOWUa4ivqtokzAVNq1wwZEMp6jx8qqR+eIBsMdLd1zJ6VStG1yiu6PT5Ulje6jG6mRPD30yD2tNG1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750238688; c=relaxed/simple;
	bh=hPR1S4Ay5wOLqXCwwkb6oZAS5alHQAg+RwEo5FUcjkg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=G8SOyPDpYz2AwYfeOEzglEn4cplq26zgwcoNL6JQegOE7SbUiGWeoZuuUpE7OdHz2kIpOIMv8bKceCC6pmTCNoVawuXlJmSBcJ8wfH713RFEKsyPI58KQtC1r8G3m9pPTj9HnZAyhPHUovOgCfOMzPXZM10ejrAenR1J94doKBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=xdnHaUIj; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="xdnHaUIj"
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2352400344aso62990125ad.2
        for <linux-xfs@vger.kernel.org>; Wed, 18 Jun 2025 02:24:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1750238686; x=1750843486; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=8iZ7PtUM9koqAnrWEE4I3YuC9qw2C2A5NGqaXjNU+5M=;
        b=xdnHaUIjcLgzAn7PXDwWyEYYM3euXpI/C0lCE75vCHcGXKdXs2jqcHuxKFm71U8S9i
         /I+ywah0kEW9LBJk68wT1euRKH0n3iyqJx09e5GJwRkbYpPfyymtNQQA0Sni8rrYNJTY
         Vc4xlD/G04GyioS0Jv2/2AaaxPZWrO6QrqtrQ06Muy7sAUR/VKY+Z8J8xQEMrc/uzVxH
         37AzSiL76BNyiomJVWDu+Cdv3pD0A21+CDQBND3qoQcKA8ii+/Ev8JT7DRquBaLDzIS0
         JblXqVxufpYu+BvxGjQUrmUHNKr5jzFnM6fehvRHhZn1w51BME7OZYX1i9UpesXK2P2O
         s1Wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750238686; x=1750843486;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8iZ7PtUM9koqAnrWEE4I3YuC9qw2C2A5NGqaXjNU+5M=;
        b=iWiDsEvhg1SJg8LpiHMSAQr6iPTC19zLcLF+brgTqJcDybdpiYIwSHzL2LvBm9xL+y
         yqnTPJzQxrzT3BWIaoOjLgRxXoOLPa1Ne2vw8ZmR7EeWRH+ZVjSRO1tdsMHBBYwMeVCv
         vnwGNSS1r6hPbyNwQrumJRLj1qWeR3GH1eHfsBYXrW7A9pjLGR49TtYDbPgCKZn0fZei
         xDZwu16xUtFupQ/Za/6+ywvzb4qivuMI36jSHjljmuJNKmRHUb0JOWFJmYQ77PPCCxPl
         m+8dQBSseUY0swWg0uQhzNn9GAB4eDOkPn+Bwua0aJPc97augqjq/Uzmb3SZbJbh9WPE
         BBfg==
X-Forwarded-Encrypted: i=1; AJvYcCXBkGVHJQGDPzaK5o0xsiRDwpMn8n8qNMa1CjuXRrNmawvRE2FcUU6reOCLOBATqmMdGMzZR75fNHg=@vger.kernel.org
X-Gm-Message-State: AOJu0YyrgLZFDgWU+2F75IYh+RdT9YpIz48y60qS2yHD5JQGiBVkPlWU
	sUVZCC11jGfAo9Zsuhsl2VJiqVOm7MxzS88CQe3Kk6BTh3DhQDcAlTw2+/nmk2Iz/SvhWvpBD/A
	Ca5RD
X-Gm-Gg: ASbGncsbsFOF1UlacAF/+o1ErpKlLwkJ0aK6MPzM3ejX4a8g9f/+BGkM++IDWkVfn+j
	ukRnqmfZFSFRvIyNGfU6KGHQcU7Sxr1IDf7l1KTrfFlzDF2/V5LXsjZoOEikk+kklWIAu7fVfhy
	5zXBTDGliIhTeGTHJgA1/j2ah65PNcZG8+qEo0z1Bn8KKIYM6iWYXnF/J1iN6oZE4Ahyc9FfHCS
	aC0QPGg4jRCNZsRvtkct2wTIwk8iQrqv9wyLYfFVFmrm2kGsCCBOfREsM1QKhfUthaIlL+cJKah
	rGOxhrddex/E70W1ju6s2mKG5wfolpYv/uqHKnGrMZNmuEwcL+ijo4MaNYFD+wgKUZMiriQq+vi
	9+LRKMZ4huvDB2PNSPSk/ogmwOTFxXujwbXI3Qg==
X-Google-Smtp-Source: AGHT+IGMN79g4+64qUD9Eadfx4LcIOPhhI42+eJGhEKlX4YZIZ7f3no0DhyF1hob9JzdyLHQmk7pdQ==
X-Received: by 2002:a17:903:f90:b0:225:abd2:5e4b with SMTP id d9443c01a7336-2366afe7c13mr262705185ad.16.1750238686220;
        Wed, 18 Jun 2025 02:24:46 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-184-88.pa.nsw.optusnet.com.au. [49.180.184.88])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2365deca2b5sm95902465ad.195.2025.06.18.02.24.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Jun 2025 02:24:45 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.98.2)
	(envelope-from <david@fromorbit.com>)
	id 1uRp2A-000000008rd-0QhG;
	Wed, 18 Jun 2025 19:24:42 +1000
Date: Wed, 18 Jun 2025 19:24:42 +1000
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: cleanup log item formatting
Message-ID: <aFKF2taXrSKl3QoO@dread.disaster.area>
References: <20250610051644.2052814-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250610051644.2052814-1-hch@lst.de>

On Tue, Jun 10, 2025 at 07:14:57AM +0200, Christoph Hellwig wrote:
> Hi all,
> 
> I dug into a rabit hole about the log item formatting recently,
> and noticed that the handling of the opheaders is still pretty
> ugly because it leaks pre-delayed logging implementation
> details into the log item implementations.
> 
> The core of this series is to remove the to reserve space in the
> CIL buffers/shadow buffers for the opheaders that already were
> generated more or less on the fly by the lowlevel log write
> code anyway, but there's lots of other cleanups around it.

OK, so I found the xfs-log-format-cleanups branch in your
tree. I just had check-parallel fail with:

[ 5060.219054] XFS (loop210): xlog_recovery_process_trans: bad flag 0x1
[ 5060.225296] XFS: Assertion failed: 0, file: fs/xfs/xfs_log_recover.c, line: 2324
[ 5060.233223] ------------[ cut here ]------------
[ 5060.243515] kernel BUG at fs/xfs/xfs_message.c:102!
[ 5060.262119] Oops: invalid opcode: 0000 [#2] SMP NOPTI
[ 5060.295341] CPU: 9 UID: 0 PID: 2180403 Comm: mount Tainted: G      D             6.15.0-dgc+ #338 PREEMPT(full)
[ 5060.295347] Tainted: [D]=DIE
[ 5060.295348] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
[ 5060.295350] RIP: 0010:assfail+0x3a/0x40
[ 5060.295360] Code: 89 f1 48 89 fe 48 c7 c7 8a f7 ed 82 48 c7 c2 f2 85 e8 82 e8 c8 fc ff ff 80 3d 19 b6 50 03 01 74 09 0f 0b 5d c3 cc cc cc cc cc <0f> 0b 0f 1f 40 00 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90
[ 5060.295363] RSP: 0018:ffffc900198a79c8 EFLAGS: 00010246
[ 5060.317824] RAX: f72505c615164000 RBX: ffff8888c8204680 RCX: f72505c615164000
[ 5060.317826] RDX: ffffc900198a7898 RSI: 000000000000000a RDI: ffffffff82edf78a
[ 5060.317827] RBP: ffffc900198a79c8 R08: 0000000000000000 R09: 000000000000000a
[ 5060.317829] R10: 0000000000000000 R11: 0000000000000021 R12: ffff88821c475800
[ 5060.317830] R13: ffff8881d27bcc70 R14: ffff8881d27bcc7c R15: ffffc900198a7b58
[ 5060.317834] FS:  00007f6d916b8840(0000) GS:ffff88889a6be000(0000) knlGS:0000000000000000
[ 5060.317835] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 5060.317836] CR2: 00007f4c2650d350 CR3: 0000000226620000 CR4: 0000000000350ef0
[ 5060.317841] Call Trace:
[ 5060.341040]  <TASK>
[ 5060.341043]  xlog_recovery_process_trans+0xd6/0x100
[ 5060.341050]  xlog_recover_process_ophdr+0xdd/0x140
[ 5060.341052]  xlog_recover_process_data+0x9b/0x160
[ 5060.341054]  xlog_recover_process+0xb2/0x110
[ 5060.341056]  xlog_do_recovery_pass+0x685/0x900
[ 5060.341059]  xlog_do_log_recovery+0x43/0xb0
[ 5060.341061]  xlog_do_recover+0x2c/0x190
[ 5060.341063]  xlog_recover+0x165/0x180
[ 5060.341065]  xfs_log_mount+0x14d/0x270
[ 5060.376607]  xfs_mountfs+0x3aa/0x990
[ 5060.376616]  xfs_fs_fill_super+0x701/0x870
[ 5060.376619]  ? __pfx_xfs_fs_fill_super+0x10/0x10
[ 5060.474403]  get_tree_bdev_flags+0x120/0x1a0
[ 5060.476710]  get_tree_bdev+0x10/0x20
[ 5060.478520]  xfs_fs_get_tree+0x15/0x20
[ 5060.480175]  vfs_get_tree+0x28/0xe0
[ 5060.481861]  vfs_cmd_create+0x5f/0xd0
[ 5060.483491]  vfs_fsconfig_locked+0x50/0x130
[ 5060.485358]  __se_sys_fsconfig+0x349/0x3d0
[ 5060.487273]  __x64_sys_fsconfig+0x25/0x30
[ 5060.489136]  x64_sys_call+0x3be/0x2f60
[ 5060.491533]  do_syscall_64+0x6c/0x140
[ 5060.493430]  ? exc_page_fault+0x62/0xc0
[ 5060.495220]  entry_SYSCALL_64_after_hwframe+0x76/0x7e

The test that triggered is was xfs/609 running with this config:

[xfs_1k]
FSTYP=xfs
MKFS_OPTIONS="-m rmapbt=1 -b size=1k -i exchange=1"
TEST_MKFS_OPTS="-m rmapbt=1 -b size=1k -i exchange=1"

I don't know if this is reproducable yet.

The assert failure is this case in xlog_recovery_process_trans():

        case XLOG_START_TRANS:
        default:
                xfs_warn(log->l_mp, "%s: bad flag 0x%x", __func__, flags);
                ASSERT(0);
                error = -EFSCORRUPTED;
                break;
        }

This implies that more that one ophdr in a transaction had the
XLOG_START_TRANS flag set, or that there are duplicate transaction
IDs in the journal. i.e. something likely went wrong in xlog_write()
at runtime, but it's not until the journal is recovered that the
issue is noticed....

This reminds me of the subtle, hard to hit xlog_write bugs that
took me months of recovery testing to shake out last time I rewrote
the checkpoint and xlog_write() code... :/

-Dave.
-- 
Dave Chinner
david@fromorbit.com
