Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F09BA2C17A0
	for <linux-xfs@vger.kernel.org>; Mon, 13 Oct 2025 05:18:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760332713; cv=none; b=RrcWh5uM9DE9RsTHozfYS+JObwwpJudvopPtaT30fwR35doSWp9dWaNx1kTIJAYraODT7SThuQEMAZV/oYQd8nM9EUzzjsqIUra5pt4SeE7HFBqhxnvox0BiGjWoZIe8MPXAwzplXp1U6+m2/CKQgLlbFiiNcUoYZiI8Bqp24ag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760332713; c=relaxed/simple;
	bh=qfn0bPiNwvIjf0wOjVBZvcae1QUN/o0t00Y6ze89QOA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eNb8fRrHyTIOW3UKHRS315AOsfifQ2JTdHEquokTGg4XHIhhhLHfFYikqXnUr/LZGC5k+bGGSgSgL8AD4q0QJqUq3Le1sVv++cKhXdfiUVZJ6bhsjc7aRd7FxxL+llssQ4IGM3qU7MybbkZ2zELs/tfadUXBZjS8CkSB2zQX6Es=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SEjICBqd; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SEjICBqd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760332710;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=i+gJL5z0jaVBdvej6tFxwAUlCI1uAUXuFZV5Hlu4fb0=;
	b=SEjICBqd8dmPLJExqklVTeDRrupvVzDXCKnVfTpDOTYP0XUV4YtiXS/vkKQeFl7jrCF6sG
	OaztF5Lypu/GY94Y4lgwq34+wR5kPoffPNAecM2FPf2qbwW9lw+LD2e2fJ7qtfiJyDUrEp
	b4O22TdFtc4Q7GpUiu4jAyl/uoRfb6U=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-75-9uIRZvh6NROXMUwVq_2Ztw-1; Mon,
 13 Oct 2025 01:18:29 -0400
X-MC-Unique: 9uIRZvh6NROXMUwVq_2Ztw-1
X-Mimecast-MFC-AGG-ID: 9uIRZvh6NROXMUwVq_2Ztw_1760332707
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id ED6271800447;
	Mon, 13 Oct 2025 05:18:25 +0000 (UTC)
Received: from fedora (unknown [10.72.120.21])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7725E1800452;
	Mon, 13 Oct 2025 05:18:17 +0000 (UTC)
Date: Mon, 13 Oct 2025 13:18:12 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Fengnan Chang <changfengnan@bytedance.com>
Cc: axboe@kernel.dk, viro@zeniv.linux.org.uk, brauner@kernel.org,
	jack@suse.cz, asml.silence@gmail.com, willy@infradead.org,
	djwong@kernel.org, hch@infradead.org, ritesh.list@gmail.com,
	linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-ext4@vger.kernel.org
Subject: Re: [PATCH] block: enable per-cpu bio cache by default
Message-ID: <aOyLlFUNEKi2_vXT@fedora>
References: <20251011013312.20698-1-changfengnan@bytedance.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251011013312.20698-1-changfengnan@bytedance.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

On Sat, Oct 11, 2025 at 09:33:12AM +0800, Fengnan Chang wrote:
> Per cpu bio cache was only used in the io_uring + raw block device,
> after commit 12e4e8c7ab59 ("io_uring/rw: enable bio caches for IRQ
> rw"),  bio_put is safe for task and irq context, bio_alloc_bioset is
> safe for task context and no one calls in irq context, so we can enable
> per cpu bio cache by default.
> 
> Benchmarked with t/io_uring and ext4+nvme:
> taskset -c 6 /root/fio/t/io_uring  -p0 -d128 -b4096 -s1 -c1 -F1 -B1 -R1
> -X1 -n1 -P1  /mnt/testfile
> base IOPS is 562K, patch IOPS is 574K. The CPU usage of bio_alloc_bioset
> decrease from 1.42% to 1.22%.
> 
> The worst case is allocate bio in CPU A but free in CPU B, still use
> t/io_uring and ext4+nvme:
> base IOPS is 648K, patch IOPS is 647K.

Just be curious, how do you run the remote bio free test? If the nvme is 1:1
mapping, you may not trigger it.

BTW, ublk has this kind of remote bio free trouble, but not see IOPS drop
with this patch.

The patch itself looks fine for me.


Thanks, 
Ming

