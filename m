Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 068112D1F40
	for <linux-xfs@vger.kernel.org>; Tue,  4 Mar 2025 16:15:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741104913; cv=none; b=FQTSdmsByOvIby+wt1u+5Ca9QpIi/F5vlmueiIVzJLSDcLH7fnoUo4tbEm1BxqepSLSpepwIC6IPCDE0A4vgfl0VXZ4M+wXwYyKqw1/qsoIqZzgRiM2SZtfEJWyBto/jJJzw+LfdD1p1gb0Bfs7JxGTy06VIMIpCWkQS6nS3uQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741104913; c=relaxed/simple;
	bh=HoUdEEUij4AowK9YlSYz+ODggQby4SqBMMaaeIy+IZo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NtV20klUaKACmv28UIBF9TbijopOSTG+snWSm+ZKRMCCJ+DA96b4nmzvSUPGbRxd4Gjdw587fblkDIgrd7p7BxompRPK3JwuRqgDrwLsvTQmyhuEfhdfyu6OVg/ab5heo2TQSpnUXryUhKR5rKOLZHerdgrtcLYTLJY9SRG+xlQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com; spf=none smtp.mailfrom=toxicpanda.com; dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b=Dfnn7tAZ; arc=none smtp.client-ip=209.85.160.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b="Dfnn7tAZ"
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-471fabc5bf5so27260591cf.3
        for <linux-xfs@vger.kernel.org>; Tue, 04 Mar 2025 08:15:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1741104911; x=1741709711; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Yn/mVNLBd6udkX5JiXXuHWAdMeM57oaufTToD3WukKw=;
        b=Dfnn7tAZ/Sxotj5vmOnH7uB1/z34MJBlvcJ4RethG9Xo4c1rYRWSkp8N+q+O7gntpy
         0ubuCoxTlP6/wwkrIyM0UbTMGjD12pCEDeDm4pYpPIRxUxzHALdlBSlMonzTQd1Xb4sf
         qRl16sVK/oZ2dnSIHyQ3eKqwiUzyF52fgAFdvYLGb5xFHV06YLG2+h5FXtyMXws8Vdqi
         xoOdT8hCmVJjBoAW9dJq7GUwr26/sAEnf04Oz1RMN2Z67S054yi68XJkH1pFBhUWVWTO
         ahGf7PQpjJeOSuGY1rL+Z5F+GpU3deOYiGad00ifwEuxg71NtgcN5spHuIs5ul2m+FRN
         OC9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741104911; x=1741709711;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Yn/mVNLBd6udkX5JiXXuHWAdMeM57oaufTToD3WukKw=;
        b=Qdp8Oj8mC+ZTCXLbakoRv+2fyXrY078wYny8HQUHUGpfP1jDJxx23zo+zj8wATitcc
         TIMBXxOlk06kJzybrRESvwQI8TIQdU7hnFO2JcCyEBfWYZzoZlqV3l2rNT7vYHumEKOf
         uCWPOXceFBlAK5EL2To0s0j7Y7PI1It5giQPNrthtjKkBiKgX83+9/UKvXmmUDz3VA4w
         rR183pQ1GlQ/bshEfXCRN301UznZdMokqmYUZ8/034zwJsz1i7hDAbeLVrhsqclKpYUO
         EpwwQTVoOb9okU2gw2Gthi3HzoQuJ+uS7FAHe2QzEVF5Z4ySt3bQhgVnTtiSW1eVmBql
         WTiw==
X-Forwarded-Encrypted: i=1; AJvYcCWUf9khwuc3bRSr8bETf2rzFurYRFw3JoBM2Ty+UV3RVkzIraYgebLQXcG84ez6jbmLNAbpcHoIMsc=@vger.kernel.org
X-Gm-Message-State: AOJu0YxtQx8/ONSs+4JnH3Kxej+E+v5x+U5GpTNkAevexarrJfDb0SiI
	9/LbGp7OE/2trjRT34+0RDCTJC7aVVxdKx2G7YecAnM17CgOZZEMAOGb76eGfV4=
X-Gm-Gg: ASbGncvo5NVsz4shbNVbnb3QJmaoAl2qqTghFF3jpTX8f09BEUf+bDMotLDfU0W7gjB
	ZfzaJLIq1gi5XuXGTsMGXyK/AHPAEfcp8wACqrSlzpgvEGpCwxspul7rSPI8QwmPSeCE3Qh5y3E
	ho1G69AK7p5amZWk58Nct94YJFCQvrs5nPxi1id1ko44Wiq2x7vIqIuJWKCc9ycxDukC3XD3x1O
	d8cg0pR1R/nedyx2nOtOwhA/7eyZkLXkAt8furSVgL0ss8vtBWZLP63z/4iZtxU1r+BlgShOKk2
	PzCzwVLnp3KeDLN1Nrs73XSjEcHeIjCF2QabN9D0VxeRL3+RlK1Jj6ABP5KYz6i22TV6cRVQvNV
	/92JHGw==
X-Google-Smtp-Source: AGHT+IET7KPbwwaDJPgxaLzaAdHSOjh+Hip5XZIqRDysdxQdHiaEvAFtjPuu1+nbA8r6dL+tqRwBGA==
X-Received: by 2002:ac8:5a49:0:b0:471:a523:6ac1 with SMTP id d75a77b69052e-474bc0558bcmr281954941cf.6.1741104910839;
        Tue, 04 Mar 2025 08:15:10 -0800 (PST)
Received: from localhost (syn-076-182-020-124.res.spectrum.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-47503d688f7sm5731921cf.56.2025.03.04.08.15.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Mar 2025 08:15:10 -0800 (PST)
Date: Tue, 4 Mar 2025 11:15:09 -0500
From: Josef Bacik <josef@toxicpanda.com>
To: Amir Goldstein <amir73il@gmail.com>
Cc: Jan Kara <jack@suse.cz>,
	syzbot <syzbot+7229071b47908b19d5b7@syzkaller.appspotmail.com>,
	akpm@linux-foundation.org, axboe@kernel.dk, brauner@kernel.org,
	cem@kernel.org, chandan.babu@oracle.com, djwong@kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-xfs@vger.kernel.org,
	syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [xfs?] WARNING in fsnotify_file_area_perm
Message-ID: <20250304161509.GA4047943@perftesting>
References: <67a487f7.050a0220.19061f.05fc.GAE@google.com>
 <67c4881e.050a0220.1dee4d.0054.GAE@google.com>
 <7ehxrhbvehlrjwvrduoxsao5k3x4aw275patsb3krkwuq573yv@o2hskrfawbnc>
 <CAOQ4uxjf5H_vj-swF7wEvUkPobEuxs2q6jfO9jFsx4pqxtJMMg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOQ4uxjf5H_vj-swF7wEvUkPobEuxs2q6jfO9jFsx4pqxtJMMg@mail.gmail.com>

On Tue, Mar 04, 2025 at 04:09:16PM +0100, Amir Goldstein wrote:
> On Tue, Mar 4, 2025 at 12:06 PM Jan Kara <jack@suse.cz> wrote:
> >
> > Josef, Amir,
> >
> > this is indeed an interesting case:
> >
> > On Sun 02-03-25 08:32:30, syzbot wrote:
> > > syzbot has found a reproducer for the following issue on:
> > ...
> > > ------------[ cut here ]------------
> > > WARNING: CPU: 1 PID: 6440 at ./include/linux/fsnotify.h:145 fsnotify_file_area_perm+0x20c/0x25c include/linux/fsnotify.h:145
> > > Modules linked in:
> > > CPU: 1 UID: 0 PID: 6440 Comm: syz-executor370 Not tainted 6.14.0-rc4-syzkaller-ge056da87c780 #0
> > > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 12/27/2024
> > > pstate: 80400005 (Nzcv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
> > > pc : fsnotify_file_area_perm+0x20c/0x25c include/linux/fsnotify.h:145
> > > lr : fsnotify_file_area_perm+0x20c/0x25c include/linux/fsnotify.h:145
> > > sp : ffff8000a42569d0
> > > x29: ffff8000a42569d0 x28: ffff0000dcec1b48 x27: ffff0000d68a1708
> > > x26: ffff0000d68a16c0 x25: dfff800000000000 x24: 0000000000008000
> > > x23: 0000000000000001 x22: ffff8000a4256b00 x21: 0000000000001000
> > > x20: 0000000000000010 x19: ffff0000d68a16c0 x18: ffff8000a42566e0
> > > x17: 000000000000e388 x16: ffff800080466c24 x15: 0000000000000001
> > > x14: 1fffe0001b31513c x13: 0000000000000000 x12: 0000000000000000
> > > x11: 0000000000000001 x10: 0000000000ff0100 x9 : 0000000000000000
> > > x8 : ffff0000c6d98000 x7 : 0000000000000000 x6 : 0000000000000000
> > > x5 : 0000000000000020 x4 : 0000000000000000 x3 : 0000000000001000
> > > x2 : ffff8000a4256b00 x1 : 0000000000000001 x0 : 0000000000000000
> > > Call trace:
> > >  fsnotify_file_area_perm+0x20c/0x25c include/linux/fsnotify.h:145 (P)
> > >  filemap_fault+0x12b0/0x1518 mm/filemap.c:3509
> > >  xfs_filemap_fault+0xc4/0x194 fs/xfs/xfs_file.c:1543
> > >  __do_fault+0xf8/0x498 mm/memory.c:4988
> > >  do_read_fault mm/memory.c:5403 [inline]
> > >  do_fault mm/memory.c:5537 [inline]
> > >  do_pte_missing mm/memory.c:4058 [inline]
> > >  handle_pte_fault+0x3504/0x57b0 mm/memory.c:5900
> > >  __handle_mm_fault mm/memory.c:6043 [inline]
> > >  handle_mm_fault+0xfa8/0x188c mm/memory.c:6212
> > >  do_page_fault+0x570/0x10a8 arch/arm64/mm/fault.c:690
> > >  do_translation_fault+0xc4/0x114 arch/arm64/mm/fault.c:783
> > >  do_mem_abort+0x74/0x200 arch/arm64/mm/fault.c:919
> > >  el1_abort+0x3c/0x5c arch/arm64/kernel/entry-common.c:432
> > >  el1h_64_sync_handler+0x60/0xcc arch/arm64/kernel/entry-common.c:510
> > >  el1h_64_sync+0x6c/0x70 arch/arm64/kernel/entry.S:595
> > >  __uaccess_mask_ptr arch/arm64/include/asm/uaccess.h:169 [inline] (P)
> > >  fault_in_readable+0x168/0x310 mm/gup.c:2234 (P)
> > >  fault_in_iov_iter_readable+0x1dc/0x22c lib/iov_iter.c:94
> > >  iomap_write_iter fs/iomap/buffered-io.c:950 [inline]
> > >  iomap_file_buffered_write+0x490/0xd54 fs/iomap/buffered-io.c:1039
> > >  xfs_file_buffered_write+0x2dc/0xac8 fs/xfs/xfs_file.c:792
> > >  xfs_file_write_iter+0x2c4/0x6ac fs/xfs/xfs_file.c:881
> > >  new_sync_write fs/read_write.c:586 [inline]
> > >  vfs_write+0x704/0xa9c fs/read_write.c:679
> >
> > The backtrace actually explains it all. We had a buffered write whose
> > buffer was mmapped file on a filesystem with an HSM mark. Now the prefaulting
> > of the buffer happens already (quite deep) under the filesystem freeze
> > protection (obtained in vfs_write()) which breaks assumptions of HSM code
> > and introduces potential deadlock of HSM handler in userspace with filesystem
> > freezing. So we need to think how to deal with this case...
> 
> Ouch. It's like the splice mess all over again.
> Except we do not really care to make this use case work with HSM
> in the sense that we do not care to have to fill in the mmaped file content
> in this corner case - we just need to let HSM fail the access if content is
> not available.
> 
> If you remember, in one of my very early version of pre-content events,
> the pre-content event (or maybe it was FAN_ACCESS_PERM itself)
> carried a flag (I think it was called FAN_PRE_VFS) to communicate to
> HSM service if it was safe to write to fs in the context of event handling.
> 
> At the moment, I cannot think of any elegant way out of this use case
> except annotating the event from fault_in_readable() as "unsafe-for-write".
> This will relax the debugging code assertion and notify the HSM service
> (via an event flag) that it can ALLOW/DENY, but it cannot fill the file.
> Maybe we can reuse the FAN_ACCESS_PERM event to communicate
> this case to HSM service.
> 
> WDYT?

I think that mmap was a mistake.

Is there a way to tell if we're currently in a path that is under fsfreeze
protection?  Just denying this case would be a simpler short term solution while
we come up with a long term solution. I think your solution is fine, but I'd be
just as happy with a simpler "this isn't allowed" solution. Thanks,

Josef
