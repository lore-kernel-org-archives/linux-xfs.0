Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C94CE27E071
	for <linux-xfs@vger.kernel.org>; Wed, 18 Jun 2025 14:18:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750256342; cv=none; b=dpP+uaQT3PTDCHqIw4hAIiYdTZPZUf8tw5644RXPBEFuzYc4bn/UyUJKIz4CV+ID34BdFkE6E1xcEeX7wlj2N+4YZFLOEy8xVQVLKuIkMV4d79H6dSS8wsuQvZo6PTlX+DtJO9XSFvP4E/GP/FYpGJZwitP9Y1Pq70ZClRfO5Do=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750256342; c=relaxed/simple;
	bh=0f+rmzaAkH9vjTXa0tLD6ZFmzZw13ZrIv5Job/CTy4U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fxkgwvHHvOgDEM0xJpGUGa6f+Zu7qqO2IX8T8iGsQT47ooYhBFZEcWqgxb+ReWOLmMw3wyIbk9ZWW1yu+bXhJ82gW4Dtyd9M0P7ZKoEH+Wc2d+siqZMfDjSYTYrJiNpxowh+6Wc89pERFpGrB0mr6/EFCvM7WbxBcr81I8Ya41A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dvTvogE9; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dvTvogE9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750256338;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5QxgEdsQTQIPRLxVEAqRLJKO8ewOZ9/dUburkW2EBcQ=;
	b=dvTvogE9+lyQucGhaSgFPXuG5+MotDAFkLRoVkSzvnXZpTFTDUeTxNq2J/kE26iXBzez9s
	eHkHGMj8QIkzHkeZ/MTuPgE4chCnfCSAl4rM1VkiNk3RECCIK+ZeF53DzZMOR/sf/rWli0
	aU3XV1ShGNYD2yMPePnXSs38IYJWdRQ=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-41-2vVVWPAOOqyeO4dF_P_6Vw-1; Wed, 18 Jun 2025 10:18:57 -0400
X-MC-Unique: 2vVVWPAOOqyeO4dF_P_6Vw-1
X-Mimecast-MFC-AGG-ID: 2vVVWPAOOqyeO4dF_P_6Vw_1750256336
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-313fb0ec33bso4080801a91.2
        for <linux-xfs@vger.kernel.org>; Wed, 18 Jun 2025 07:18:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750256336; x=1750861136;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5QxgEdsQTQIPRLxVEAqRLJKO8ewOZ9/dUburkW2EBcQ=;
        b=QpsIVhViUmo1aQ1zjYQpuDK6/bKS90WRTjroxVHbWF0exFQWGeqiFEalXiua9v8701
         nzUA5sUETKoYWI+UrMxBsjMvxsWPxKxEpsfawVhvQlZdT78cDblaYDJOOsG/uDWpFPqW
         cpE49LfqCbVvejUVVwvwvv3j0/69APrit3xmr+e0lzAbSpdf0ddPm9CjVU+ag1cQExrK
         Keb1IHcBARTtdB9QYFbQ6J41S0BX7/neSGCjmVm4//Ab+wDjO52GCiY6nTrIwszbOvXk
         WjvIAZhPyl3h18gbpaUODyo+C54wXZv28eW6EJR3SXlTsRsTK866ySS5DvmC6xWtGOui
         1XDw==
X-Forwarded-Encrypted: i=1; AJvYcCX1LiuOkZam2YBiQ2xAfWXOt2OthlgOGr39DVw8WypGvF3Ntdfi6fuH6gJz1+47YrhFvxEQqF4/QGc=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyt+kOTHmIJ/1dDYqBeDUmRdNhULVmIh6rLce5laewVU9CIwQM5
	J9l3q80gktYBk9vGkUwRe4c3t7Z9Lf5f4qDfXeNp3n8aCZJbX0BkuNka2lt4TGJ7+0XGiP7GdKC
	b3eUKOIB9JVyk0diy3jH7lk+55oo93AvZ33xWMLNa8yOXne3W18CrXuSD2mQvog==
X-Gm-Gg: ASbGnctYNn86HKPm8tzEuVnxFSBOMMcaNApHCIWtDxprpVACsymyK5dUQm5lcAqqXUU
	BlCvauWv5+pAXDy/xC3PlPAqCNrQvZsxFUUPZ5uZKPITe0zGFFBc/eyhMGK9DHi4qoMZN36mbml
	nmblYZfXnBs25TCApRVoBeI674SxC060neUiMwjXoIQV5hEa1qH1JPAAku2ejujHSGQQH0Uoe1r
	VtTDJpLOwdMmeMAFE69fUJ8bQCarL0RPgTUPY5vRMOLCbz6hQ8QNjI08WDbrZxQ933jaciyyuwr
	YE/qUoUz/M6g95H3VFs2E8X6225zMqff9pabpIYs0s42KEXdmfW2XuKwXguATtk=
X-Received: by 2002:a17:90b:3cce:b0:315:6f2b:ce53 with SMTP id 98e67ed59e1d1-3156f2bcfccmr4842764a91.25.1750256336197;
        Wed, 18 Jun 2025 07:18:56 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHCe1i3E0Bx7XwW7x5n4p4GoWfzlINHlJrzmaufkTIOSb6G0Dppb7K0ZonwlI2o/7109xyOnQ==
X-Received: by 2002:a17:90b:3cce:b0:315:6f2b:ce53 with SMTP id 98e67ed59e1d1-3156f2bcfccmr4842715a91.25.1750256335786;
        Wed, 18 Jun 2025 07:18:55 -0700 (PDT)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-313c19cd5a6sm12877479a91.12.2025.06.18.07.18.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Jun 2025 07:18:55 -0700 (PDT)
Date: Wed, 18 Jun 2025 22:18:51 +0800
From: Zorro Lang <zlang@redhat.com>
To: Li Chen <me@linux.beauty>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	fstests <fstests@vger.kernel.org>,
	linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH V2] generic/738 : add missing _fixed_by_git_commit line
 to the test
Message-ID: <20250618141851.p3qgjw53ynnuwrfz@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <20250610025242.11403-1-me@linux.beauty>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250610025242.11403-1-me@linux.beauty>

On Tue, Jun 10, 2025 at 10:52:42AM +0800, Li Chen wrote:
> From: Li Chen <chenl311@chinatelecom.cn>
> 
> Add the usual  _fixed_by_kernel_commit  line so the user can find
> that the hang is cured by
> 
>     ab23a7768739  ("xfs: per-cpu deferred inode inactivation queues")
> 
> The hung task call trace would be as below:
> [   20.535519]       Not tainted 5.14.0-rc4+ #27
> [   20.537855] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [   20.539420] task:738             state:D stack:14544 pid: 7124 ppid:   753 flags:0x00004002
> [   20.540892] Call Trace:
> [   20.541424]  __schedule+0x22d/0x6c0
> [   20.542128]  schedule+0x3f/0xa0
> [   20.542751]  percpu_rwsem_wait+0x100/0x130
> [   20.543516]  ? percpu_free_rwsem+0x30/0x30
> [   20.544259]  __percpu_down_read+0x44/0x50
> [   20.545002]  xfs_trans_alloc+0x19a/0x1f0
> [   20.545747]  xfs_free_eofblocks+0x47/0x100
> [   20.546519]  xfs_inode_mark_reclaimable+0x115/0x160
> [   20.547398]  destroy_inode+0x36/0x70
> [   20.548077]  prune_icache_sb+0x79/0xb0
> [   20.548789]  super_cache_scan+0x159/0x1e0
> [   20.549536]  shrink_slab.constprop.0+0x1b1/0x370
> [   20.550363]  drop_slab_node+0x1d/0x40
> [   20.551041]  drop_slab+0x30/0x70
> [   20.551600]  drop_caches_sysctl_handler+0x6b/0x80
> [   20.552311]  proc_sys_call_handler+0x12b/0x250
> [   20.552931]  new_sync_write+0x117/0x1b0
> [   20.553462]  vfs_write+0x1bd/0x250
> [   20.553914]  ksys_write+0x5a/0xd0
> [   20.554381]  do_syscall_64+0x3b/0x90
> [   20.554854]  entry_SYSCALL_64_after_hwframe+0x44/0xae
> [   20.555481] RIP: 0033:0x7f90928d3300
> [   20.555946] RSP: 002b:00007ffc2b50b998 EFLAGS: 00000202 ORIG_RAX: 0000000000000001
> [   20.556853] RAX: ffffffffffffffda RBX: 0000000000000002 RCX: 00007f90928d3300
> [   20.557686] RDX: 0000000000000002 RSI: 000055a5d6c47750 RDI: 0000000000000001
> [   20.558524] RBP: 000055a5d6c47750 R08: 0000000000000007 R09: 0000000000000073
> [   20.559335] R10: 0000000000000000 R11: 0000000000000202 R12: 0000000000000002
> [   20.560154] R13: 00007f90929ae760 R14: 0000000000000002 R15: 00007f90929a99e0
> 
> localhost login: [   30.773559] INFO: task 738:7124 blocked for more than 20 seconds.
> [   30.775236]       Not tainted 5.14.0-rc4+ #27
> [   30.777449] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [   30.779729] task:738             state:D stack:14544 pid: 7124 ppid:   753 flags:0x00004002
> [   30.781267] Call Trace:
> [   30.781850]  __schedule+0x22d/0x6c0
> [   30.782618]  schedule+0x3f/0xa0
> [   30.783297]  percpu_rwsem_wait+0x100/0x130
> [   30.784110]  ? percpu_free_rwsem+0x30/0x30
> [   30.785085]  __percpu_down_read+0x44/0x50
> [   30.786071]  xfs_trans_alloc+0x19a/0x1f0
> [   30.786877]  xfs_free_eofblocks+0x47/0x100
> [   30.787727]  xfs_inode_mark_reclaimable+0x115/0x160
> [   30.788708]  destroy_inode+0x36/0x70
> [   30.789395]  prune_icache_sb+0x79/0xb0
> [   30.790056]  super_cache_scan+0x159/0x1e0
> [   30.790712]  shrink_slab.constprop.0+0x1b1/0x370
> [   30.791381]  drop_slab_node+0x1d/0x40
> [   30.791924]  drop_slab+0x30/0x70
> [   30.792469]  drop_caches_sysctl_handler+0x6b/0x80
> [   30.793328]  proc_sys_call_handler+0x12b/0x250
> [   30.793948]  new_sync_write+0x117/0x1b0
> [   30.794471]  vfs_write+0x1bd/0x250
> [   30.794941]  ksys_write+0x5a/0xd0
> [   30.795414]  do_syscall_64+0x3b/0x90
> [   30.795928]  entry_SYSCALL_64_after_hwframe+0x44/0xae
> [   30.796595] RIP: 0033:0x7f90928d3300
> [   30.797090] RSP: 002b:00007ffc2b50b998 EFLAGS: 00000202 ORIG_RAX: 0000000000000001
> [   30.798033] RAX: ffffffffffffffda RBX: 0000000000000002 RCX: 00007f90928d3300
> [   30.798852] RDX: 0000000000000002 RSI: 000055a5d6c47750 RDI: 0000000000000001
> [   30.799703] RBP: 000055a5d6c47750 R08: 0000000000000007 R09: 0000000000000073
> [   30.800833] R10: 0000000000000000 R11: 0000000000000202 R12: 0000000000000002
> [   30.801764] R13: 00007f90929ae760 R14: 0000000000000002 R15: 00007f90929a99e0
> [   30.802628] INFO: task xfs_io:7130 blocked for more than 10 seconds.
> [   30.803421]       Not tainted 5.14.0-rc4+ #27
> [   30.803985] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [   30.804979] task:xfs_io          state:D stack:13712 pid: 7130 ppid:  7127 flags:0x00000002
> [   30.806013] Call Trace:
> [   30.806399]  __schedule+0x22d/0x6c0
> [   30.806867]  schedule+0x3f/0xa0
> [   30.807334]  rwsem_down_write_slowpath+0x1d8/0x510
> [   30.808018]  thaw_super+0xd/0x20
> [   30.808748]  __x64_sys_ioctl+0x5d/0xb0
> [   30.809292]  do_syscall_64+0x3b/0x90
> [   30.809797]  entry_SYSCALL_64_after_hwframe+0x44/0xae
> [   30.810454] RIP: 0033:0x7ff1b48c5d1b
> [   30.810943] RSP: 002b:00007fff0bf88ac0 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
> [   30.811874] RAX: ffffffffffffffda RBX: 000055b93ae5fc40 RCX: 00007ff1b48c5d1b
> [   30.812743] RDX: 00007fff0bf88b2c RSI: ffffffffc0045878 RDI: 0000000000000003
> [   30.813583] RBP: 000055b93ae60fe0 R08: 0000000000000000 R09: 0000000000000000
> [   30.814497] R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000001
> [   30.815413] R13: 000055b93a3a94e9 R14: 0000000000000000 R15: 000055b93ae61150
> 
> Signed-off-by: Li Chen <chenl311@chinatelecom.cn>
> ---
> Changes since v1: use _fixed_by_kernel_commit helper as suggested by
> Zorro

Thanks, good to me now

Reviewed-by: Zorro Lang <zlang@redhat.com>

> 
>  tests/generic/738 | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/tests/generic/738 b/tests/generic/738
> index 6f1ea7f8..b0503025 100755
> --- a/tests/generic/738
> +++ b/tests/generic/738
> @@ -9,6 +9,9 @@
>  . ./common/preamble
>  _begin_fstest auto quick freeze
>  
> +[ "$FSTYP" = "xfs" ] && _fixed_by_kernel_commit ab23a7768739 \
> +	"xfs: per-cpu deferred inode inactivation queues"
> +
>  _cleanup()
>  {
>  	xfs_freeze -u $SCRATCH_MNT 2>/dev/null
> -- 
> 2.49.0
> 

