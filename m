Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A84D287257
	for <linux-xfs@vger.kernel.org>; Sun, 15 Feb 2026 09:02:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771146122; cv=none; b=ha446sBNozJd96qBq59+Xv8HbplB3bmyRnKP1Y8kjQEUnlaIhDvPzFgSfNEzbrJq9YTtXZOalXeMCv4KKWZrrR5TG0iq0FvF2+nHFfGtJVk2TvVLWvlljtV0AKP0i/88BrVqARg0MN2i3wyG04M70q+fbsTcMQnLQoB8IBJbPjg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771146122; c=relaxed/simple;
	bh=W6T4NKMFGU2utFNEhPpN8fZf0hDKTQ6a+z8Ar/UV6dQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MLRL4MukE5MVuhjfeGDZ/FA+D4ET5YqxyZJAiieMcxp5B75nfCav7Ad1+XGfr15GfilquR71PcATYjR4fuonO/9ahFjUCnwKAJ2kTwhDQgOKbT9lx+PWFC0NIzRUmybA4Utzbv6FB5vkMo8SFPr6xvrsqetEUQdMP/GUvF9w3gE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=S6yphLgs; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="S6yphLgs"
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-4362197d174so1471396f8f.3
        for <linux-xfs@vger.kernel.org>; Sun, 15 Feb 2026 01:02:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771146120; x=1771750920; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=+D0ODJnkgxsrPA3UYy81wUrrkW2kcfyG+MPWkVZLGUk=;
        b=S6yphLgs/m+PstcT6JoZP/nYSovXkFDplNeEQVtl6jyOyUeYp2mAe1BJ0f+zDzzWaR
         CeWutWf0eNMJC0Uww7j3uwfYIQnxzXrPrSh5mJNAtbsb89c4EWaGC0hFJmFbfIo+v4iM
         Va2938r2H/zquw6VuE/pDcXU3C37IznRCGVfuSHorOHR3qw1gExiler0I+5fQH3Ybocq
         B/D3VZJsvRIy/4iqYNA0LKbA9/nojoeghHskOACUv7l5QA5pBycNCyZoVs8oD0sSJ8p/
         aJxceRQ/BJPNieoWgi40YqCy1GMF2LY4UbsTKaS8nPAKW1xiosXx6CirjHhvGc8DkAmE
         lSzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771146120; x=1771750920;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+D0ODJnkgxsrPA3UYy81wUrrkW2kcfyG+MPWkVZLGUk=;
        b=liPnuM9oO/awzThVG+oILjIH1n1sjVgems3tdlnuaxR7buVDBInV1D4J4lqOrdce34
         4tK7stKkcysUA1D7meOF6jAP7tjQnASUWaGRAFiZdmpMH+DjraOSp7udZJI6y8fv2ld1
         HhhCtQ+u1phDnaaamSV5o/1tgfx2U+o0vWd6JXe7hPvcTaJdDWwMlhy3Dl9JTtNOSPn7
         80Kgv2SD+aynY933OLkWHK+36D68L6KKBNeJ13O7ZSouvluTWrFcCfkQ2obGjzCH2uML
         Q7FNJa1rG44/q98GCPIpO3mbi0tuUg7YJJor+h3Oy3zYUvQkZ8e3Q9peQkmUJrqz51OX
         tBSw==
X-Gm-Message-State: AOJu0Yy2Q/1519m455+T3iBREHAm34z60vW6DI6PiEddBViqvyE2KeSl
	CM9PlpiI6UQvBRsss3OLzeiGIUcbNvjkagP8a8NmDJL+GJYVv6hA7dsI
X-Gm-Gg: AZuq6aJaJFJsz1zIUIL9olCAWI+eYsMYA9XhOz/aA86NYic5NBmq1Ssn1rfLCE/NGoH
	s1L0DXAE7h2HFsz7XAJB6PSwv0ESw9v0yHE1MbiYz/Y82Afu3fT1IhA61U27ZFb+BL4qCD5GsW9
	NIpAl39FIZiouD26teH4YwjwTvI1CgzGeW20RISVUf5hdD+BcnG/oXIZemEj5lxdfBcMPdntCl6
	YX96Qd61FQK9C51sFSI69bIF6adf/IcK+6YuCFNPGUsgZpqPiTwMSh8BLX8K2LT0Gp+dYubPKLZ
	H/Pns3+PxxslR8zbaYwh1n/6JLtK2p+kB/r7c9LQi8Nd7iUdoU9K6rHI47SstAT9swvu0+Ox0nh
	IwM/H1pujY/wdR9vMsunGC7lRePHGyL5NQ9KCR+3EEUKIgnFjv16RNVUuZVfhIrnFoZNIntpQwh
	3hEZ0kDuIuBj/8PgjjGgDX
X-Received: by 2002:a05:6000:2311:b0:435:a258:76e with SMTP id ffacd0b85a97d-4379793dd5emr12414131f8f.60.1771146118907;
        Sun, 15 Feb 2026 01:01:58 -0800 (PST)
Received: from localhost ([2a0d:6fc2:4b0a:db00:eb98:5335:fc91:c4bc])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43796abd793sm18612064f8f.25.2026.02.15.01.01.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Feb 2026 01:01:58 -0800 (PST)
Date: Sun, 15 Feb 2026 11:01:57 +0200
From: Amir Goldstein <amir73il@gmail.com>
To: Pankaj Raghav <pankaj.raghav@linux.dev>,
	Andres Freund <andres@anarazel.de>
Cc: linux-xfs@vger.kernel.org, linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org, lsf-pc@lists.linux-foundation.org,
	djwong@kernel.org, john.g.garry@oracle.com, willy@infradead.org,
	hch@lst.de, ritesh.list@gmail.com, jack@suse.cz,
	ojaswin@linux.ibm.com, Luis Chamberlain <mcgrof@kernel.org>,
	dchinner@redhat.com, Javier Gonzalez <javier.gonz@samsung.com>,
	gost.dev@samsung.com, tytso@mit.edu, p.raghav@samsung.com,
	vi.shah@samsung.com
Subject: Re: [LSF/MM/BPF TOPIC] Buffered atomic writes
Message-ID: <aZGLhTvjmRVZNA8m@amir-ThinkPad-T480>
References: <d0c4d95b-8064-4a7e-996d-7ad40eb4976b@linux.dev>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d0c4d95b-8064-4a7e-996d-7ad40eb4976b@linux.dev>

On Fri, Feb 13, 2026 at 11:20:36AM +0100, Pankaj Raghav wrote:
> Hi all,
> 
> Atomic (untorn) writes for Direct I/O have successfully landed in kernel
> for ext4 and XFS[1][2]. However, extending this support to Buffered I/O
> remains a contentious topic, with previous discussions often stalling due to
> concerns about complexity versus utility.
> 
> I would like to propose a session to discuss the concrete use cases for
> buffered atomic writes and if possible, talk about the outstanding
> architectural blockers blocking the current RFCs[3][4].
> 
> ## Use Case:
> 
> A recurring objection to buffered atomics is the lack of a convincing use
> case, with the argument that databases should simply migrate to direct I/O.
> We have been working with PostgreSQL developer Andres Freund, who has
> highlighted a specific architectural requirement where buffered I/O remains
> preferable in certain scenarios.
> 
> While Postgres recently started to support direct I/O, optimal performance
> requires a large, statically configured user-space buffer pool. This becomes
> problematic when running many Postgres instances on the same hardware, a
> common deployment scenario. Statically partitioning RAM for direct I/O
> caches across many instances is inefficient compared to allowing the kernel
> page cache to dynamically balance memory pressure between instances.
> 
> The other use case is using postgres as part of a larger workload on one
> instance. Using up enough memory for postgres' buffer pool to make DIO use
> viable is often not realistic, because some deployments require a lot of
> memory to cache database IO, while others need a lot of memory for
> non-database caching.
> 
> Enabling atomic writes for this buffered workload would allow Postgres to
> disable full-page writes [5]. For direct I/O, this has shown to reduce
> transaction variability; for buffered I/O, we expect similar gains,
> alongside decreased WAL bandwidth and storage costs for WAL archival. As a
> side note, for most workloads full page writes occupy  a significant portion
> of WAL volume.
> 
> Andres has agreed to attend LSFMM this year to discuss these requirements.
> 

Andres,

If you wish to attend LSFMM, please request an invite via the Google
form:

  https://forms.gle/hUgiEksr8CA1migCA

Thanks,
Amir.
