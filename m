Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 587FB3ACEF5
	for <linux-xfs@vger.kernel.org>; Tue, 10 Mar 2026 05:49:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773121799; cv=none; b=ORE3TADI5BxlRcMiMPjnmODa2zTFWbK40yi0lE7Ao8GXnvV6y6Lj0jAjzmFW8LdSde/rKjwOOuzsYdb5YWEnfveUYhVKy9BIupzmwK5Q/VFWsenqsxRddnhHP6SveWhQL/vFfl8bU3wfdtRYUJLjKxw6FwoEqHUs2JJq3A8IzHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773121799; c=relaxed/simple;
	bh=/QAlSwxCL3YeNfXvPolDNjg6x5KjVV4GoQBz310VDH4=;
	h=From:To:Cc:Subject:In-Reply-To:Date:Message-ID:References; b=rGJliK370TheXwFC2UQAknygci/Nq7mZwUVPV76sx9eX0JQuC+cN5XtakH4bOmu58BtuMxMIcdxThSV76lQe06YkVS5qht/GTOnS6wHI1zaOzYO+FlR8s+iXrO/xi51BXa1HKOnfDpI1dQGToP+KkTTIxBvQTYMgFzByOpdqYO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=esYbiJki; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="esYbiJki"
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2a871daa98fso93150815ad.1
        for <linux-xfs@vger.kernel.org>; Mon, 09 Mar 2026 22:49:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773121791; x=1773726591; darn=vger.kernel.org;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=4e252tvJ7wgS17IJwLKwEjk90VH1IZzHII9iIV6zg7Q=;
        b=esYbiJkiOa6c8VSgEzfgVXJuvYifvl+0q4JtztlYusRJ2yS2o+IW53jcS1Gh7Sa1zJ
         OK1NzXHwY3gIogRdojWGGeNpHbtxFoqU4oWOFwtZPapA6t2R/2bPe4q/1gjSqDbwE7j0
         0ViKkLxcdNU0AGkFDlPVU5UxlQsE3w9cMrDzHiDXyrFgINheHP3vuYr3TFBRQBN1lpsa
         inn3/rzY7u6S28iirMr8RCCredVxLiR93Qob8HqfiabeHwBi6v1QJtpVvPJ8av+nm2yt
         mH7+TAstxnAl4qeK996HdDRIu6X6PG815P1PojaQH0DBYm2+prSgRapD9xT+o8KAzPdU
         FiNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773121791; x=1773726591;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4e252tvJ7wgS17IJwLKwEjk90VH1IZzHII9iIV6zg7Q=;
        b=fzJgNf16CGro9UzSnynJewIoZg3nR2eCUbHegbzRPOIZNCoUjrNtwchwmjPS6cvFMc
         BbwjJCVCB4hjO74A9+V73YytEK0vmtn/vDNJ4jN8/HwAN9p5lqphYao4s6RjYzfsb5C+
         XEm+QWE02DIuW2HL513uDR24oNwtLTTMvCEaUosf+F+IdZ8QaIcENonD4yeYur+Z2I85
         T5scB2xA2E70MZUBrPuG+gIcR7anaqBZlPCPEG6aS9Olx9sjzOL0f9IXXmvym/uwAs2W
         jmb0Y+cq4n3pWkz2n6iJxYDJNQ4rbjQzvbGVfvR+jd2yKKph0/S+3qDeB1nEr7mpfE77
         /Vyg==
X-Gm-Message-State: AOJu0YwO5ydMkBlW2baPotUA4EH4WGGt91pPMLJR8gI0kiA8zXnRHdw7
	0mkYanoTSjGCwBrkBV15rUgvNcBHQYPDDv7DFpLJX4cCXGL4sYOt8jnv
X-Gm-Gg: ATEYQzzqWkHJJrExJYd+saccnox39Kxy1IFIpncEqQSP8tU919jOX9HCnc8n0v0yADJ
	Bnu//PKJGRh0BhyHKZcDnOeJpgTbzUnT54kuBhxVEM//bw3ZYk96emuhTXFQcKwlqYA9qFf+Gqf
	KLNj9gHWLrsaw4a/Cu34F5s4OFeTgZCzg3Zq6IM7ZECBn+8ZJ4AK2vUd148vNE/tEYCKO1F+vcK
	lPt9upxWKLD690YznOS97fo6KxkRKh5edfv+Ju+7Pr3c65GKMgzon3UNZvCP5V2Tep5uTGUZ1XB
	lE/f1gl1Y655mrPFJVXxEj4m8MHdNHvsV0o3WWB37oO83f8Jus5SM8qXuZNwyvdNyaSNc2+JiOI
	pjR6JXulEgd2k3VsRttxSvPhaKTcR+LITdtinRKCJaSn+Yy8vl9bjmeKnRvyhGhkc0ezeNijf1u
	iNZFwDdtjdHRnOC7BMayNetQ==
X-Received: by 2002:a17:902:ea02:b0:2ae:7ed6:46e3 with SMTP id d9443c01a7336-2ae824441d8mr137516745ad.27.1773121791358;
        Mon, 09 Mar 2026 22:49:51 -0700 (PDT)
Received: from pve-server ([49.205.216.49])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ae83e58592sm187181675ad.14.2026.03.09.22.49.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Mar 2026 22:49:50 -0700 (PDT)
From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
To: "Darrick J. Wong" <djwong@kernel.org>, Ojaswin Mujoo <ojaswin@linux.ibm.com>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, john.g.garry@oracle.com, willy@infradead.org, hch@lst.de, jack@suse.cz, Luis Chamberlain <mcgrof@kernel.org>, dgc@kernel.org, tytso@mit.edu, p.raghav@samsung.com, andres@anarazel.de, linux-kernel@vger.kernel.org
Subject: Re: [RFC 2/3] iomap: Enable stable writes for RWF_WRITETHROUGH inodes
In-Reply-To: <20260310035719.GI1105363@frogsfrogsfrogs>
Date: Tue, 10 Mar 2026 10:55:04 +0530
Message-ID: <4imouuhb.ritesh.list@gmail.com>
References: <cover.1773076216.git.ojaswin@linux.ibm.com> <3704b81046b11f8b8da0367c7c8ad8767f42e5df.1773076216.git.ojaswin@linux.ibm.com> <20260310035719.GI1105363@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>

"Darrick J. Wong" <djwong@kernel.org> writes:

> On Mon, Mar 09, 2026 at 11:04:32PM +0530, Ojaswin Mujoo wrote:
>> Currently, RWF_WRITETHROUGH writes wait for writeback to complete
>> on a folio before performing the writethrough. This serializes
>> writethrough with each other and the writeback path. However, it is also
>> desirable have similar guarantees between RWF_WRITETHROUGH and non
>> writethrough writes.
>> 
>> Hence, ensure stable writes are enabled on an inode's mapping as
>> long as a writethrough write is ongoing. This way, all paths will
>> wait for RWF_WRITETHROUGH to complete on a folio before proceeding.
>> 
>> To track inflight writethrough writes, we use an atomic counter in the
>> inode->i_mapping. This struct was chosen because (i) writethrough is an
>> operation on the folio and (ii) we don't want to add bloat to struct
>> inode.

Now I am also questioning the need of this counter.
If mapping has AS_STABLE_WRITES bit set, then that means the
inode->mapping is going through stable writes until that bit is
cleared. And since in future we are going to add support of async
buffered write-through, so the stable writes bit should get cleared in
the completion path (like how it is done now.) 

>
> What if we just set it whenever someone successfully initiates a
> RWF_WRITETHROUGH write?  Then we wouldn't need all this atomic counter
> machinery.
>

I agree. If we set the mapping as stable before initiating
iomap_write_begin() itself, then we don't need this atomic counter.

Maybe, we can set it in iomap_file_writethrough_write() itself
(we have mapping available from iocb).


> Also: What if some filesystem (not xfs, obviously) finds a need to
> change the stablepages bit while there might be writethrough writes in
> progress?

Is there a usecase where this can happen (just curious)?

> It's a little awkward to have a flag /and/ a counter; why not
> change mapping_{set,clear}_stable_pages to inc and dec the counter and
> base the test off that?
>

Yes, either ways, I agree that I don't see the need of an extra counter here.

-ritesh
