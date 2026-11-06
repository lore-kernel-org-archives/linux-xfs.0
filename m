Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.208.179
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793967839;
	b=GWIQxIsWhdk6uKlE6AphKM3R8ryyuC8SS9qZONEY46cAhI5XYB1Opsw6b2v7vVPFjIrG
	 EoxQSvbK/yz7UZ3tqvnlYWiIpn9rkaoihRnYN3Czwxk3/xGHHWKPcYtlDaBEIu4y0sY54
	 yKgMWuy1a5hpwlL/leBjGXgsdA9iWX+qx2puGYWHn5ZXva1RWTmadyiFoxAADyZ0UwVcG
	 Ixmr9IVaffHUNJnYISuj7mYMdcCNQOWP8FraoNbWd4jthMBbZXYuwd8n3Y+QFkOWQCEiT
	 WiHF2Gspnbr5d6Kxu6YRXybH9HDFRgSJOignpqFNqbkoCY77JzOE+Lg/lmA/KWmhE3Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793967839;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NQPbYu3Q9KcstzDxgfXXgopmFd3Xb9lToagK1Zql/ic=;
	b=lzYIFwKcn/p8+GJLJyd51IRNZUfEFkVmcPXtjiUUTJyaiAZ4BVyK03CeZcabpQTWXNMK
	 J94vpOh4awkjIKqLULhQKMtlwE8TGUuLSwsWqcAbWpCZtbC3mrnxkbpSegk/PSyp8gzah
	 2gFTfmNf/8dyllNSNPIDLNvTZwKpEXIh898Tq4JCyWh65pLd4XxvToXY9r5YQMHX/X+22
	 PLRBsHUrV4c+T9nmL1sZGjH19uS7dY3tjtOYkab5QL7WYS0oqszBr8ELbFIASRU0Z7dad
	 5qf4yClK6xjvEyijXWtEmOJ9MNu9H0TdDB2qDjmvjrqrN2F0J3XUuhKQ7UCUEChrJEg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=zj7FBJpa;
	arc=none smtp.remote-ip=209.85.208.179
Received: from mail-lj1-f179.google.com (mail-lj1-f179.google.com [209.85.208.179])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 892BA606A326
	for <linux-xfs@vger.kernel.org>; Fri,  6 Nov 2026 12:23:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 892BA606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=zj7FBJpa
Received: by mail-lj1-f179.google.com with SMTP id 38308e7fff4ca-3aca0bf7fd0so4073251fa.0
        for <linux-xfs@vger.kernel.org>; Fri, 06 Nov 2026 04:23:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793967838; x=1794572638; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=NQPbYu3Q9KcstzDxgfXXgopmFd3Xb9lToagK1Zql/ic=;
        b=zj7FBJpaVFxjbjvptwfucPwvBFjgfEy8g2yxVHJj6w9JrjEhHAB40Wu2T8uBZDCEtK
         r3Kty4XBTyN0XxB6m9zvM39h6zgvmeGu+/A53OBLWnlJWA1hTla+1cHWtETSiVvGGcm4
         Z2nJLR2YCGQM4jE3l30brRVpWvQkF/FYctNVNjQsQM5t8Q46AMKRmjLTFeCzl453UFyI
         0AOZNHA4HURZIraITsMxYKvdEg7ASHkS2VLbhG/RdtqeCBXvVbI//L1TzvaqhHjCSkbW
         mQshFZq0loNCpAPPoQ+4MBbuNzvPOdem6PaT0VkuBBue+reYZ2Fr8KVzbDv+jp53yH92
         FYKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793967838; x=1794572638;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=NQPbYu3Q9KcstzDxgfXXgopmFd3Xb9lToagK1Zql/ic=;
        b=YtPHaIgpIdj1nfH8FfKAdP9BiEo0ScRrZ2TImN59lC/64rMBwnzhTxdK4nZREfeZIW
         RNWxb+RR75VZqfcfi1khBkqQQMSLQhPmukqqB0n5jbkPX73+A7dzWJulkbHGj8APtalj
         2z7eWnClKfwjXXPcrNpS3PR8G/mimFOOMYwXe4lZAleW3auQ3/NOG4HvjS65U7Ow6goJ
         qZxBr330htHtgQ+bYep8gEFLQO3Fd602+Kkc2adKlxXFfHw8et9c73PPVxbslyYr48Nb
         LW/DpEDXzFDTQdo5zFbHf6C48E9iIuvn4gjSs6UNY0wgix1HW74e+hFr35dRB8U0U3+8
         sukg==
X-Forwarded-Encrypted: i=1; AKwUvByOh6KAao8khMI6HmcMkqYCm0c8lYSHJUV3mySiLQMFhj3TP3OCcaPFf9VKIin8dHLqPSSDLLiryzE=@vger.kernel.org
X-Gm-Message-State: APuU4Z8yodrbd1/d59HZm+f5q/09Rk4oMJ8dtYbNTAze/LU9yxlVt9/L
	C2R9ubw9b3w+d1l5eLeUAZGWY+aF73BRVhGUnScLtchuhr60hwPYZN/u
X-Gm-Gg: AYBFou05yJUY6lp6nYPX1f0Km2JcePs/qSxoNUaUqTI8Cmnq3y2zgenHtoGWoU1x5Vs
	1HnHIPDH9OmoeeG3Pj1gqF6BhkxtP9U1ySaQrbFhZ6q855A9IvDdHHgFzjqaU956zUfe8cG2C6m
	tKvnJAnipUzJY1HUKPNUz4BqbxGbBXVqxxpmSjjyLgz8T/SHutuZqZThYf9oP7WrmsnEDPWRyT5
	KXnekvgwaFxlc0KQDhbifTsGmpaj5GwbKwmSczv/RAE1KLxDlLYDkoFqM2bh6O1Upkzan+D8TnY
	+8yKlwMRfhdDf4QJKg2SeWfD+umUOZcnFRYDuqY+O+n6SIE5ENw5mauDh/gFXoc+qka3A32S5ek
	rCREW7HPKKuriE+bID89T3gRwsKQOmzpGKHXXBiXyg2M0X3a7VCL0UEJ3u9em1XKRLq2TUVrXRm
	s96dC2N4fJ4dDuFerqo02SkE5kRwRuSkxsioKBolkMqtzKMVuQzvovnxxC0Vj5M+HBGmgt0/1A1
	kQWYQKsk3zxQ9sZCmkPiWHBhFra4i7g8grbNCI/8zG8UgOj/3ZPN5rMcBJ4snrD0gQLt1KAhjvI
	2vRrZJW8kP54vDx09HbdGWMC0ot+s1iEznbE6IyW5ROpS3+LN4c26KeLZPOfgY9EfJlcpsxBHeP
	gFwXErBOPB3E9YWcP4Ng8RYBok1pC3ZGJjCtb0JBAk8y0kzfB7AaU1V7NrvihTKjUm0uUxdSvZs
	z4HVZ4
X-Received: by 2002:a05:651c:1506:b0:3a6:692d:b7ed with SMTP id 38308e7fff4ca-3acf3b2ec94mr5887391fa.20.1793967837435;
        Fri, 06 Nov 2026 04:23:57 -0800 (PST)
Received: from Lauri-G-Pro-14-M4.intra.lakuz.com (n2vuxegy3pwmc89dqti-1.v6.elisa-laajakaista.fi. [2001:99a:2ab:bb00:c40d:a019:da27:d206])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-3acf60cf65esm2487441fa.38.2026.11.06.04.23.56
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 06 Nov 2026 04:23:56 -0800 (PST)
From: Lauri Gates <lauri.gates@gmail.com>
To: Dave Chinner <dgc@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>,
	linux-xfs@vger.kernel.org,
	Carlos Maiolino <cem@kernel.org>
Subject: Re: Concurrent FIEMAP on reflinked files serialises on the AGF buffer lock
Date: Fri,  6 Nov 2026 14:23:55 +0200
Message-ID: <20261106122355.16885-1-lauri.gates@gmail.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <auudz7Iwm2MrNA-b@dread>
References: <auudz7Iwm2MrNA-b@dread>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Thu, Nov 05, 2026 at 08:04:15AM +1100, Dave Chinner wrote:
> The problem is that we don't have a 'this inode has shared extents'
> flag in the file_getattr() flag set, hence there is no easy way to
> query if the inode may or may not have shared extents in it. That
> would be trivial to add, and would avoid the need to FIEMAP every
> single file in the fs to check for shared extents...

That would help most trees: for a file without the flag, a du tool
could skip open + FIEMAP + close and make one file_getattr() call by
path. On 100,000 never-reflinked files, warm cache, with open + FIEMAP
+ close run in one process per worker so the shared fd table stays out
of the comparison (file_getattr() opens nothing):

                                open+FIEMAP+close  file_getattr()
  Ryzen 9 3900X, 6.17, 24 workers        27.5 ms         11.3 ms
  GCP n2-standard-8, 7.0, 8 workers      49.3 ms         21.4 ms

Mirroring XFS_DIFLAG2_REFLINK, the flag would mean "may have shared
extents", which is all a du tool needs to decide whether to look
closer. If it helps, I can write the patch.

> Efficient ad hoc physical extent status querying is what the
> GETFSMAP ioctl is supposed to provide, right?
>
> The owner of an physical extent is part of the input key filters, so
> it extending the implementation to filter extents by owner field
> would allow arbitrary per-file extent map lookups. e.g.
> functionality like "report only shared extents for a given inode
> number range" is well within the functional scope of this interface.

I tried the nearest thing that works today: per file, a GETFSMAP query
limited to that file's physical range, taken from an untimed FIEMAP
beforehand, so the best case for an owner-filtered query. As root on
the same GCP VM, same 100,000 files, one process per worker:

                       1 worker   8 workers
  open+FIEMAP+close      200 ms      49 ms
  per-file GETFSMAP      560 ms     564 ms

Each query reads the AGF in __xfs_getfsmap_datadev() and holds it for
that AG's walk, so concurrent queries queue on the AGF buffer lock,
also for never-reflinked files, where FIEMAP returns before the
refcount lookup. In a traced run with 4 threads, bpftrace put every
D-state switch in xfs_buf_lock() under xfs_alloc_read_agf() and
xfs_getfsmap(). And since the rmapbt key orders by physical block
before owner, an owner filter would need the inode's extents mapped
first to avoid walking the whole rmapbt.

So for a scan that touches every file, I expect it to stay slower
than FIEMAP unless the AGF can be held shared. Am I missing a way to
use it here? The permission model from your other reply, the owner
matching the inode behind the fd, makes sense to me; the cost per
query is what I am unsure about.

Thanks,
Lauri
