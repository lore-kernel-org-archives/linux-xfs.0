Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC49A72067
	for <linux-xfs@vger.kernel.org>; Mon, 18 Dec 2023 20:21:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="MfB34mY/"
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-28b866dabdcso1275780a91.3
        for <linux-xfs@vger.kernel.org>; Mon, 18 Dec 2023 12:21:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1702930902; x=1703535702; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=YjQ2FYsz0CfpB7Ml0qOOzIwjlLXHkWeVLPp5rRZm9l4=;
        b=MfB34mY/Eo+t9OaalKeLReW2F8rqSaRnOxYRWAD7jBP5VtzjM/gg2FB0Khj4eS5cVE
         RcR3iZcxfUUVCtlls4MtpEWwbAvq2RuzjnvBdion4Bmj4n2uf8+ppUgX0SzF6ctTQeea
         ZzaYaNUkrvDCy9Hb+UUIM8EhkjhOUBxBLTg2Az5e0d8loDJbXM31ySpjWVE8OlViNIs6
         BeRDJJlUj5Ub8ECbOcCqhSniv6GekX937cos0obwcUxhzlvsXvMGyeEG32DntYYPST07
         yzZG6Krien8hb/9GLzMqVDf7DJEL0Qxu0nVJ31Mj6nVeaDkxmujUZ75Pu82DqvuUtm5W
         K1iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702930902; x=1703535702;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YjQ2FYsz0CfpB7Ml0qOOzIwjlLXHkWeVLPp5rRZm9l4=;
        b=Kqcks98o0TjEl5tHrYWlF1cv1M2W5ElRZ/aM3MNunZa61/viySgp+70KXvCTqjTSUe
         Zj0/9ggbtgGln1ywmGbHeIF8nCS3y/Vm4Yd7XYGaxLUpQzlCZXv//CshkznRXKboIZmn
         zbfmPR9vzEi40TtUl3axZLW3c7Z6zhafHEqasLbC31XfuqOIf3PJddm0aFBIrA7sfvQu
         HGwTXGPWWlfZg58IkikCz8oUW6UkAwoOvEPkT1Zjo6Cfw26MuXX/Ur6QhZTKsoeL3wro
         GVL8GLHE/yvTULFWBIC9AFIorLDNsq30/Kvy+llc2UvZr1XrO45hPWVb6ibKZNrXylAB
         c2MA==
X-Gm-Message-State: AOJu0YytXYqKQyMKcdOYj1y66jbgjqeSbp4mo1LDQ/5qmmgtfD9eRL0u
	lKLaUW0POQ5nTnTjW1/bQfwPAg==
X-Google-Smtp-Source: AGHT+IEE7fG8E826S4Pml94SS2hpTPjz5KrZJ4Eph3kPLDb6+7Ivm8yyPh+5gFno4N2gDdCCrccfXg==
X-Received: by 2002:a17:90a:b018:b0:28b:6f73:a340 with SMTP id x24-20020a17090ab01800b0028b6f73a340mr907372pjq.61.1702930902002;
        Mon, 18 Dec 2023 12:21:42 -0800 (PST)
Received: from dread.disaster.area (pa49-180-125-5.pa.nsw.optusnet.com.au. [49.180.125.5])
        by smtp.gmail.com with ESMTPSA id j12-20020a17090a94cc00b0028b8499dc80sm2445955pjw.39.2023.12.18.12.21.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Dec 2023 12:21:40 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1rFK7N-00A7wu-1X;
	Tue, 19 Dec 2023 07:21:37 +1100
Date: Tue, 19 Dec 2023 07:21:37 +1100
From: Dave Chinner <david@fromorbit.com>
To: Brian Foster <bfoster@redhat.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>, Long Li <leo.lilong@huawei.com>,
	brauner@kernel.org, linux-xfs@vger.kernel.org, yi.zhang@huawei.com,
	houtao1@huawei.com, yangerkun@huawei.com, Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] iomap: fix warning in iomap_write_delalloc_release()
Message-ID: <ZYCp0cAVUKssxjsu@dread.disaster.area>
References: <20231216115559.3823359-1-leo.lilong@huawei.com>
 <20231216173951.GP361584@frogsfrogsfrogs>
 <ZYA7LjdIJ3sxsyCm@bfoster>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZYA7LjdIJ3sxsyCm@bfoster>

[cc Jan Kara]

On Mon, Dec 18, 2023 at 07:29:34AM -0500, Brian Foster wrote:
> On Sat, Dec 16, 2023 at 09:39:51AM -0800, Darrick J. Wong wrote:
> > On Sat, Dec 16, 2023 at 07:55:59PM +0800, Long Li wrote:
> > > While fsstress + drop cache test, we get following warning:
> > > 
> > >  ------------[ cut here ]------------
> > >  WARNING: CPU: 2 PID: 1003 at fs/iomap/buffered-io.c:1182 iomap_file_buffered_write_punch_delalloc+0x691/0x730
> > >  Modules linked in:
> > >  CPU: 2 PID: 1003 Comm: fsstress Not tainted 6.7.0-rc5-06945-g3ba9b31d6bf3-dirty #256
> > >  Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS ?-20190727_073836-buildvm-ppc64le-16.ppc.fedoraproject.org-3.fc31 04/01/2014
> > >  RIP: 0010:iomap_file_buffered_write_punch_delalloc+0x691/0x730
> > >  Code: d1 0b 01 0f 0b 48 83 05 14 a2 d1 0b 01 48 89 05 35 a1 d1 0b 49 39 ec 0f 8c 09 fb ff ff e9 b6 fd ff ff 48 83 05 df a1 d1 0b 01 <0f> 0b 48 83 05 dd a1 d1 0b 01 48 39 6c 24 10 7c c0 48 89 05 07 a1
> > >  RSP: 0018:ffffc900005b7b08 EFLAGS: 00010202
> > >  RAX: 0000000000000001 RBX: ffff888102363d40 RCX: 0000000000000001
> > >  RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff888108080000
> > >  RBP: 0000000000050000 R08: ffff888108084eb8 R09: ffff888108084eb8
> > >  R10: 000000000000005c R11: 0000000000000059 R12: 0000000000050000
> > >  R13: ffffffff8c978ef0 R14: 0000000000050000 R15: 000000000005a000
> > >  FS:  00007efc04c63b40(0000) GS:ffff88813bd00000(0000) knlGS:0000000000000000
> > >  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > >  CR2: 00007efc0375c000 CR3: 0000000105a4d000 CR4: 00000000000006f0
> > >  DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > >  DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> > >  Call Trace:
> > >   <TASK>
> > >   xfs_buffered_write_iomap_end+0x40/0xb0
> > >   iomap_iter+0x8e/0x5f0
> > >   iomap_file_buffered_write+0xa4/0x460
> > >   xfs_file_buffered_write+0x156/0x3d0
> > >   xfs_file_write_iter+0xb2/0x1c0
> > >   do_iter_readv_writev+0x19b/0x1f0
> > >   vfs_writev+0x114/0x4f0
> > >   do_writev+0x7f/0x1c0
> > >   __x64_sys_writev+0x24/0x30
> > >   do_syscall_64+0x3f/0xe0
> > >   entry_SYSCALL_64_after_hwframe+0x62/0x6a
> > >  RIP: 0033:0x7efc03b06610
> > >  Code: 73 01 c3 48 8b 0d 78 88 2c 00 f7 d8 64 89 01 48 83 c8 ff c3 66 0f 1f 44 00 00 83 3d d9 e0 2c 00 00 75 10 b8 14 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 31 c3 48 83 ec 08 e8 5e 8e 01 00 48 89 04 24
> > >  RSP: 002b:00007ffdf8f426d8 EFLAGS: 00000246 ORIG_RAX: 0000000000000014
> > >  RAX: ffffffffffffffda RBX: 000000000000007a RCX: 00007efc03b06610
> > >  RDX: 00000000000002c4 RSI: 00000000012f5580 RDI: 0000000000000003
> > >  RBP: 0000000000000003 R08: 00000000012f53a0 R09: 0000000000000077
> > >  R10: 000000000000007c R11: 0000000000000246 R12: 00000000000002c4
> > >  R13: 00000000012dba50 R14: 00000000012f5580 R15: 0000000000000094
> > > 
> > > The warning occurred in the following code of iomap_write_delalloc_release().
> > > After analyzing vmcore, I found that the reason for the warning is that
> > > data_end was equal to start_byte.
> > > 
> > >         WARN_ON_ONCE(data_end <= start_byte);
> > > 
> > > If some delay is added between seeking for data and seeking for hole
> > > in iomap_write_delalloc_release(), the problem can be reproduced quickly.
> > > The root cause of the problem is that clean data page was dropped between
> > > two seeking in the page cache. As a result, data_end may be equal to
> > > start_byte.
> > > 
> > > buffered write                        drop cache
> > > ---------------------------           ---------------------------
> > > xfs_buffered_write_iomap_end
> > >   iomap_file_buffered_write_punch_delalloc
> > >     iomap_write_delalloc_release
> > >       start_byte = mapping_seek_hole_data(SEEK_DATA)
> > > 
> > >                                       drop_pagecache_sb
> > >                                         invalidate_mapping_pages
> > >                                           mapping_try_invalidate
> > >                                             mapping_evict_folio
> > >                                               remove_mapping
> > > 
> > >       data_end = mapping_seek_hole_data(SEEK_HOLE)
> > >       WARN_ON_ONCE(data_end <= start_byte)
> > > 
> > > In my investigation, I found that clean data pages was alloced and added
> > > to page cache when reading the file's hole. After that, while buffered
> > > write and goes into delalloc release, we seek for data, it will find
> > > the start offset of the clean data pages. If the clean data pages was
> > > dropped, when we seek for hole, it will find the same offset as the
> > > previous seek.
> > 
> > iomap_write_delalloc_release holds the invalidation lock, shouldn't that
> > be sufficient to prevent folios from being dropped?
> > 
> 
> I believe it's the other way around. The invalidate lock prevents new
> folios from being added (i.e. to serialize an invalidation sequence).
> IIRC it won't necessarily prevent folios from going away.

It also serialises operations doing invalidations against other
operations doing invalidations (e.g. truncate, hole punch, direct
IO, etc) that require the invalidation lock to be held exclusively.

Having looked a little deeper, it appears we have a large number of
invalidation paths that don't actually hold the invalidation lock at
all. drop_pagecache_sb() is just one of them.  Is that a bug?

If not, then this code needs to prevent any mapping tree change from
occurring whilst it is walking the range of the write that needs to
be scanned. The write has partially failed at this point, and we're
trying to clean up the mess the partial write has left behind. We
really need exclusive access to that range of the mapping whilst
cleanup is done.

IOWs, if the invalidation lock is not sufficient to serialise
against other invalidations being run concurrently, what mapping
lock can we hold whilst we call into the filesystem, take sleeping
FS locks and modify the extent tree that will serialise against
other invalidations?

-Dave.

-- 
Dave Chinner
david@fromorbit.com
