Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.237
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793024505;
	b=UGNwF6zmcu9hZXAKLYqpGVMz/1qmy9r4+u/S0gProqDVUWZSKn3XR7PwxosNy4knwcWq
	 lsrYnA5PBrkdXh0GaKPQPoWB7KdxISTMoOZZXvUnixdHEmtzvs6hhWjMHhQM3bzVPIsxG
	 9gQjn5y2+6xIXdZarrD4vSpGGytzGPbyu644eI+l135c62Ej+fptA5HjeLhCYDX0Zbkab
	 WIOr1ayyniuqd1lOfcIzu3z643gpNGbZ7JsT0F5WZ1RasxLi85xOyRNawTdkshuLKCE/6
	 WVI2UNzDhX1d84eDH7MEzcltAk20bV6ZK08/cGVlYRS/WXqu6ub7javh8nf1SM5tqjQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793024505;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=YrojJ8RdT+pp1L7jagA79jqZnyIDXllAqHzZGpVUGl4=;
	b=JqzjgEmENDxDk6w9bowhroRp5g8DE5+WRuwrW3FSZvHreV5Uv2hcTgA503ecOsWRJV3j
	 lYGmWq550WjoFArcnXpYRJ8V06+pCU9Uo3wEKef8z0qhGAt6N1iBK5wEMsgVxb2ZaMvmv
	 Ud6VLGKU687QkB5aDoumyDL4r38peS4jKIJrJ3iVNpqALphCGoMp2n3INzMx56LcgdZTR
	 ebNPlRhZUj7TpzWGoefrmKmY2Euy5W4FypPNBZVOeTytkL7S5ysp94DD5qZa3YrINvMPH
	 YRFstHTNyqsoAKUX571TjjmVwdZKDO4aow7BelzQx82bcnoOvebKg3gHUr3MFbz5mtQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	arc=none smtp.remote-ip=91.218.175.237
Received: from mta0.migadu.com (out-237.mta0.migadu.com [91.218.175.237])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23770606A31F
	for <linux-xfs@vger.kernel.org>; Mon, 26 Oct 2026 14:21:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 23770606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Envelope-To: linux-xfs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=LU38JLPVoNiFrE9ir2aCoN20eLvHfG+XA+FLjWMCf10=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793024492; v=1; x=1793629292;
 b=Rr/nV/C58euHFChJjREzKK2GkRORfr2c6xAhMt3TLMROTR6l7RxwSM69VGF/bswbs2EJG3b0
 41y7XHX064jD38T8XXjJFGMZXf7MQTLWx7Ze+7K+lCeqP0ReRuPYgBShiWdO9TvPhcsByNjeN8R
 sUdbSsvIeD3cUiNSysrO1sNs=
X-Envelope-To: linux-xfs@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 79436808f9b03e13;
	Mon, 26 Oct 2026 14:21:31 +0000
X-Mizu-Trace-ID: 79436808f9b03e13
X-Migadu-Flow: FLOW_OUT
Date: Mon, 26 Oct 2026 15:21:24 +0100
From: "Pankaj Raghav (Samsung)" <pankaj.raghav@linux.dev>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] iomap: only follow dio alignment requirement if specified
Message-ID: <at9hcoPC5NnKADX3@quentin>
References: <9fae60fcce5ae356deef5e38931124b9634dba3b.1792997261.git.wqu@suse.com>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9fae60fcce5ae356deef5e38931124b9634dba3b.1792997261.git.wqu@suse.com>

Hi Qu,

On Mon, Oct 26, 2026 at 05:18:13PM +1030, Qu Wenruo wrote:
> [BUG]
> After commit 4025185cf953 ("iomap: follow the alignment requirement for
> iomap_dio_hole_iter()"), generic/091 fails on both xfs and ext4:
> 
>  FSTYP         -- ext4
>  PLATFORM      -- Linux/x86_64 btrfs-vm 7.3.0-custom+ #6 SMP PREEMPT_DYNAMIC Mon Oct 26 16:04:56 ACDT 2026
>  MKFS_OPTIONS  -- -F /dev/mapper/test-scratch1
>  MOUNT_OPTIONS -- -o acl,user_xattr /dev/mapper/test-scratch1 /mnt/scratch
> 
>  generic/091  6s ... [failed, exit status 1]- output mismatch (see /home/adam/xfstests/results//generic/091.out.bad)
>      --- /home/adam/xfstests/tests/generic/091.out	2022-05-11 11:25:30.766666664 +0930
>      +++ /home/adam/xfstests/results//generic/091.out.bad	2026-10-26 16:43:49.387401669 +1030
>      @@ -1,7 +1,25 @@
>       QA output created by 091
>       fsx -N 10000 -l 500000 -r PSIZE -t BSIZE -w BSIZE -Z -R -W
>      -fsx -N 10000 -o 8192 -l 500000 -r PSIZE -t BSIZE -w BSIZE -Z -R -W
>      -fsx -N 10000 -o 32768 -l 500000 -r PSIZE -t BSIZE -w BSIZE -Z -R -W
>      -fsx -N 10000 -o 8192 -l 500000 -r PSIZE -t BSIZE -w BSIZE -Z -R -W
>      -fsx -N 10000 -o 32768 -l 500000 -r PSIZE -t BSIZE -w BSIZE -Z -R -W
>      -fsx -N 10000 -o 128000 -l 500000 -r PSIZE -t BSIZE -w BSIZE -Z -W
>      ...
>      (Run 'diff -u /home/adam/xfstests/tests/generic/091.out /home/adam/xfstests/results//generic/091.out.bad'  to see the entire diff)
>  Ran: generic/091
>  Failures: generic/091
>  Failed 1 of 1 tests
> 

I am trying to reproduce this error in fs-next with ext4/xfs but I am unable
to.

Do we need some specific disk setup or xfstests config to trigger this?

> [CAUSE]
> The failed command of fsx is COPY_RANGE:
> 
>  copy range: 0x6800 to 0xa200 at 0x3f200

-- 
Pankaj
