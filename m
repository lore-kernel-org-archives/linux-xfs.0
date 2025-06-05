Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EDEA139D1B
	for <linux-xfs@vger.kernel.org>; Thu,  5 Jun 2025 15:49:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749138599; cv=none; b=t6WQiy501GDPktAhkbs0HknTBRk8fLm3r2YkVOTN1TXMwCZ0jcXL1nKbYXYbBhdBxHcapG0QEkCsThXXnOatYuVFwQ0VdLCOtaBsYiAFIC0gSn+66wZ6T35z1bVKg/ZGTJe2ENvxJr22fTWdwld8OH1ZV02hL0aSLAnVj6RYRig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749138599; c=relaxed/simple;
	bh=heSSRUrGNdzJGpdtwqJh+8ILQxdmzCEFK9AAGM4XcHE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BNigemf2X07slemr6oNx0l/lpd7oEb+fu4M67aIqtiK+5wLWyAIac1Jq3p/qj83d/4LfiZJbKenCw67INnMX096ob7k7tr68qzsP+p1w/jwTx5r6Znd+wc7g1SV/N9wIxbpJ5n1TlDKee0DlZaX3Lf+5xbP/wT5ywx49iHKBzZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=R9xlYO69; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="R9xlYO69"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1749138595;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ndj3VacoJ2B/jwA4i8T2Fiz1ZeHtUMliJW7cXQ7eK58=;
	b=R9xlYO69csO73GfH+YxKda/rZbq627RcFw3oGhkchAiRej+u2fiFfrTKkyN4R6knDpE1kG
	SbefNrk7O3hJufKuncyt+Bj9BcJeNQWmlGPVrVgqH4A4C1TXjE4MkPCe1C/cZmBPRbwWkK
	EplgrBR7QQVHHyDg3uVU9JfzB5y+Leo=
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com
 [209.85.210.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-128-Iz-DaxhpM56Hz1lxC0Klow-1; Thu, 05 Jun 2025 11:49:53 -0400
X-MC-Unique: Iz-DaxhpM56Hz1lxC0Klow-1
X-Mimecast-MFC-AGG-ID: Iz-DaxhpM56Hz1lxC0Klow_1749138593
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-74620e98ec8so1104672b3a.1
        for <linux-xfs@vger.kernel.org>; Thu, 05 Jun 2025 08:49:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749138593; x=1749743393;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ndj3VacoJ2B/jwA4i8T2Fiz1ZeHtUMliJW7cXQ7eK58=;
        b=iXB58L6HgIlUhSYxZmBf53zMmXaa8PFo9O2ZwUht++LhhFe3ehFB16HJxrRpf+vl2V
         v1U/yQ+0FH/Rf3ZkwlTIbbTVQ0RD1fe6wFaaoeJ3HDXvXT54cvSwdHMU6CW4q9Z3OMkQ
         LjOKgLRld/Oe3bFENblJOElTQObgqdl9uOJYNf5FYxowtrD5fl+1UGQVzEFXBd4d1rnT
         KF2na413bUM1beVx9TyPyj7lDSPTLHZaf5h4hV5xJevFTt0Qyrs0VhDxW9hmTHri//iE
         4hX1vxiasG7l+LaWKcyAU9IODBA9JwXf6SaPlOHWW3jxvVHTUS23W5jfqhaw9vqgYYGp
         VtBQ==
X-Forwarded-Encrypted: i=1; AJvYcCW350guIdvHZUtjgOVQheCYD9keyoUMI0uPvE+90xT+D5DLg1aKYoS49F2FZ9I0eYREnJ39XR8Sk1s=@vger.kernel.org
X-Gm-Message-State: AOJu0YyLKhHuK8ffddJL5A+j8uX9qh7JlF0RUwpqE6iyp6FabetVal98
	uZ3WhFY8N2dCA2672y5c+ZgO1Q8Uuj1X9j/2gjISMeqJNEGdJUtSYLg9Qu7crTd4I99CVn4N9lI
	l9hUJx6x7jhene3ZjMuIuGxd2+7qNqjmLA/gtNMfzLiDMgGK1zifg0NcR/Qk7OQ==
X-Gm-Gg: ASbGncvMj5xPDDBGrIMqYrGWT9F2K8PX7kzEaCvr2n5ENJH/imX+j/Fet95Exvw1YYt
	eA0YGogsrl1v1fea3KJX+ssoy+4SAYBoXLSd0wqrKcrfrm5AtpdKgipuLccrcQCnV2G/M/aBSUj
	BkYvrlPdUHadYAoRzMvSjobOqbSmk18lHHDv/PrdFzMFzCBeLnuN0ds4yNz2MfQ7/GfnSPYZ1b3
	vVLOOuXBy3Wo4qDcx4pdd+ebfCL+iNr4UFbmMjyKy+46LLI/feahicQhZNCK8i9ly7oRgn9rTXM
	YZ9zUi8fiRE8GbQ5F8Toza/c3AQkx3Z1oWpl2Bdf+LLDaPO60JGX
X-Received: by 2002:a05:6a00:3c8a:b0:736:4e14:8ec5 with SMTP id d2e1a72fcca58-74818502de9mr5002740b3a.11.1749138592789;
        Thu, 05 Jun 2025 08:49:52 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEJcVAGqdPPtYN0ODYrRbE0HfIi/9s44Lf0z02on9jhAQwnOabBzpbIKR3waQJ1MgjgUstRYw==
X-Received: by 2002:a05:6a00:3c8a:b0:736:4e14:8ec5 with SMTP id d2e1a72fcca58-74818502de9mr5002711b3a.11.1749138592406;
        Thu, 05 Jun 2025 08:49:52 -0700 (PDT)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-747affafac9sm12995560b3a.112.2025.06.05.08.49.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Jun 2025 08:49:51 -0700 (PDT)
Date: Thu, 5 Jun 2025 23:49:47 +0800
From: Zorro Lang <zlang@redhat.com>
To: Li Chen <me@linux.beauty>
Cc: fstests@vger.kernel.org, Li Chen <chenl311@chinatelecom.cn>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH] generic/738: warn & lazy-umount if thaw hangs on buggy
 XFS
Message-ID: <20250605154947.bddkusxeryj2emzb@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <20250601070059.341669-1-me@linux.beauty>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250601070059.341669-1-me@linux.beauty>

On Sun, Jun 01, 2025 at 03:00:59PM +0800, Li Chen wrote:
> From: Li Chen <chenl311@chinatelecom.cn>
> 
> If `xfs_freeze -u` goes D-state (because of freeze-reclaim deadlock)
> the test never finishes and the harness stalls.
> Run thaw in background, wait 10 s, and when it’s still alive:
> 
>   * emit a warning plus the fixing commit
>       ab23a7768739  “xfs: per-cpu deferred inode inactivation queues”
>   * `umount -l` the scratch FS so the rest of xfstests can proceed
>   * skip any `wait` that would block on the hung tasks.
> 
> Fixed kernels behave as before; broken ones no longer wedge the run.
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
> ---
>  tests/generic/738 | 20 ++++++++++++++++++--
>  1 file changed, 18 insertions(+), 2 deletions(-)
> 
> diff --git a/tests/generic/738 b/tests/generic/738
> index 6f1ea7f8..9a90eefa 100755
> --- a/tests/generic/738
> +++ b/tests/generic/738
> @@ -11,8 +11,24 @@ _begin_fstest auto quick freeze
>  
>  _cleanup()
>  {
> -	xfs_freeze -u $SCRATCH_MNT 2>/dev/null
> -	wait
> +    # Thaw may dead-lock on unfixed XFS kernels.  Run it in background,
> +    # wait a tiny bit, then decide whether it is stuck.
> +    xfs_freeze -u $SCRATCH_MNT 2>/dev/null &
> +    _thaw_pid=$!
> +
> +    sleep 8
> +
> +    if [ -e "/proc/$_thaw_pid" ]; then
> +            # still running → stuck in D-state
> +            if [ "$FSTYP" = "xfs" ]; then
> +                    echo "generic/738: known XFS freeze-reclaim deadlock; " \
> +                         "fixed by kernel commit ab23a7768739 " \
> +                         '"xfs: per-cpu deferred inode inactivation queues"' \

If want to mark a known fix, you can add below line to this case:

_fixed_by_kernel_commit ab23a7768739 \
	"xfs: per-cpu deferred inode inactivation queues"

But for this patch, I don't think we should do this for a bug. If it blocks your
testing on someone downstream system, you can skip this test. CC xfs list if you
need more review points for this xfs bug.

Thanks,
Zorro

> +                         | tee -a "$seqres.full"
> +            fi
> +            umount -l "$SCRATCH_MNT" 2>/dev/null
> +    fi
> +
>  	cd /
>  	rm -r -f $tmp.*
>  }
> -- 
> 2.49.0
> 
> 

