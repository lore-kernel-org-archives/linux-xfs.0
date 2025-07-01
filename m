Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E3D9450F2
	for <linux-xfs@vger.kernel.org>; Tue,  1 Jul 2025 06:23:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751351008; cv=none; b=nstCecvHuguliZV3Brqq6lMcd564o8SfqOn7Jv+FjTuP/MZw+WUWy59h7yNTz3cmM5tUhIlJUSjpYs10GYJb7qMJ1mwVGLrww7y+pZUBn0nCmuiWwET9IojjMG90pAih1cQZrdaecvk05j9PdsHRzVlHQbcqiqGWJgwGjIsJvSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751351008; c=relaxed/simple;
	bh=6yttm5Qep3NBN0kX2vSnM3H0+zpYWdBsyhzAI2zpwU8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=N1Ia3OIMVswL3+t70QRuDwMrXj/TuWrDynRrVWC6iSpnQixSbEcl8Auf8nKsdKKavDd5SjZjHL1IW6rAdJ3LA1k+++8iS8d/NaFn78rzNBH2oLkqRpV8ptZnGRmsMz5hAHAy9gin+LHnPuZv6NYeN2hOQm99cCgYRAff2noOdtE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=anH1Z8n7; arc=none smtp.client-ip=209.85.160.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="anH1Z8n7"
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-4a58c2430edso56137491cf.1
        for <linux-xfs@vger.kernel.org>; Mon, 30 Jun 2025 23:23:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1751351006; x=1751955806; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=6yttm5Qep3NBN0kX2vSnM3H0+zpYWdBsyhzAI2zpwU8=;
        b=anH1Z8n7gTpIxKbFXysvAkXY6GYcSGYyp2kwpBWDuRqq+tzHmXpkCIpltC3K528TKm
         Vuc1gJkLA9+OpRWfvVJAglU3eAbF6O9fFqvO8Dx6qN8yERI+DTJuusNxo3UOTfHvdzlH
         B4Vy9k463Wo10p6viP/ivkGKuM0IW4f3aRE9E=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751351006; x=1751955806;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6yttm5Qep3NBN0kX2vSnM3H0+zpYWdBsyhzAI2zpwU8=;
        b=NswxORNdafKz58tCVsOTRzwRWcWZYrdFcABpUgnWFcjyat//NOAQMMMf9cCaMAnpII
         3reX3kI048umznYQGg4cMjyXf68upP7zx0nl7cgKwKQESnaWYUFR/D9W5ghcvUaQbj6+
         zdj1cd2HwNqAW7wXTX7ngcNIg/pWwoWXfDBGCLWDzpeAWDb88qgdx886awJMlWQ+4X9a
         AbFVG47sHzuR2RWmuX3wPfezFGwF/q5rY58Kv5vRNPb4U9ysVWeKnINb3QUdZS8ZiS53
         O+k45XTo/Z9KfpZi8sLHwvs/7DvEoHg03g6GkcDXmxNFTNLQxPIiT2QhzKPAnJD4uGwx
         VDrQ==
X-Forwarded-Encrypted: i=1; AJvYcCV1mEmZympuR3ocVkflMeNlUCaL2cMKLVtS3DBMd0OCFO9FOsJ7tfkNcUqzMETScRc0wt9nfipWkdw=@vger.kernel.org
X-Gm-Message-State: AOJu0YyfeedXwbdXWmJadyOxsAEVwvi/tFWs0y3RklPVTtxTY17w52TN
	YOfFAGbOJjGewVcY4G+pTDDIKq4jWrjwwG7uliX0Nn/gLGEQD34uQhI4lHbeLHPbcYnuc1rojRP
	WJG0sF0IQObMukTCjMuusnbzo+ojnqc4OyUVbPU1r5A==
X-Gm-Gg: ASbGnct4Qk/8kRII04RRNnXUD1haLKW94rqWHu0S8gVX3mirWVlqlzK+hFwzLVe6G6s
	NWeg7JsbL2a7+b/a0sYsi1mVMqou0PYPPqSxSUM9G5msHwf9SD0wlGK2dE1TDEZMUooEb4+Un5x
	tTdbzvr61cwNXUcIFRpQ3sr9XogfhihZQOSbhNCuQZ/jQOIPBXyIpxjU1XdJy8My0hI+hpFWWfi
	O4F
X-Google-Smtp-Source: AGHT+IF/4eCMJfHhQh+NomYc895/DRC2IEJWxiuPw7wJwiLPtRg1dt/Dr1B22JHPC3Z1DLGs7QY/n9Jj5bCLzyMZhhk=
X-Received: by 2002:ac8:5806:0:b0:494:b247:4ddb with SMTP id
 d75a77b69052e-4a82e9b8105mr37293761cf.4.1751351005922; Mon, 30 Jun 2025
 23:23:25 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250606233803.1421259-1-joannelkoong@gmail.com>
 <20250606233803.1421259-6-joannelkoong@gmail.com> <aEZoau3AuwoeqQgu@infradead.org>
 <20250609171444.GL6156@frogsfrogsfrogs> <aEetuahlyfHGTG7x@infradead.org>
 <aEkHarE9_LlxFTAi@casper.infradead.org> <ac1506958d4c260c8beb6b840809e1bc8167ba2a.camel@kernel.org>
 <aFWlW6SUI6t-i0dN@casper.infradead.org> <CAJnrk1b3HfGOAkxXrJuhm3sFfJDzzd=Z7vQbKk3HO_JkGAxVuQ@mail.gmail.com>
 <aFuWhnjsKqo6ftit@infradead.org> <CAJnrk1Zud2V5fn5SB6Wqbk8zyOFrD_wQp7B5jDBnUXiGyiJPvQ@mail.gmail.com>
In-Reply-To: <CAJnrk1Zud2V5fn5SB6Wqbk8zyOFrD_wQp7B5jDBnUXiGyiJPvQ@mail.gmail.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 1 Jul 2025 08:23:15 +0200
X-Gm-Features: Ac12FXx4vgjv5ycm_1iHhIFxMh2pxXOzEd-Q9OTergY2osOj37o6vwohMHvjQOk
Message-ID: <CAJfpegvOizDZb9Lw1f0BHbH05owLh7-KOqeB3H8bgZhwRpN=5Q@mail.gmail.com>
Subject: Re: [PATCH v1 5/8] iomap: add iomap_writeback_dirty_folio()
To: Joanne Koong <joannelkoong@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, Matthew Wilcox <willy@infradead.org>, 
	Jeff Layton <jlayton@kernel.org>, "Darrick J. Wong" <djwong@kernel.org>, brauner@kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, 
	bernd.schubert@fastmail.fm, kernel-team@meta.com, linux-mm@kvack.org, 
	linux-nfs@vger.kernel.org, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Wed, 25 Jun 2025 at 18:44, Joanne Koong <joannelkoong@gmail.com> wrote:

> Yes but as I understand it, the focus right now is on getting rid of
> ->launder_folio as an API. The iomap pov imo is a separate issue with
> determining whether fuse in particular needs to write back the dirty
> page before releasing or should just fail.

Fuse calls invalidate_inode_pages2() not just for direct I/O:

 - open without FOPEN_KEEP_CACHE
 - FUSE_NOTIFY_INVAL_INODE
 - mtime/size change with FUSE_AUTO_INVAL_DATA turned
on/FUSE_EXPLICIT_INVAL_DATA turned off
 - truncate

In most of these cases dirty pages d need to be written back.

Thanks,
Miklos
