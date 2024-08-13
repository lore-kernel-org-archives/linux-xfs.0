Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 921C9339A1
	for <linux-xfs@vger.kernel.org>; Tue, 13 Aug 2024 09:19:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723540774; cv=none; b=SaZyCVJA43iWLQbr6VlOdna8ELg8/Rqlf38n+MoDjo4d9LYoj/Pq/9r4BvDWnWX0e+XJzo+6MiYO1YX1HrSsrgxdlkwKLd0rQmvVbaIMfjF2bGm7Kpv3vYlOlIlbu27BXJkMWxr/vHuaeKtNLloDoMnGRTcXk6Y+afPypprleJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723540774; c=relaxed/simple;
	bh=fviIXfk/16Iyz6UUP1CbYcG6Q4NIK7zqMivMc+bmjEs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qdhOqWqYHSoq5/Hfnn6pni9z57ZHCT60hVkq3WXTu9Q1w8Gws2gqBR7iaNe2qbt8uG6TKpEj3ufJTDcp3MGMg+u3LVtfTW3pf6U+QQtXLHmz+Zl+nZqkSj+XZcWEOqIc8/80XZOlYG3MxKGBjlum7kaVvqBXMoGXnVPnm8foolM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=q/qerAE6; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="q/qerAE6"
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-1fd78c165eeso41411955ad.2
        for <linux-xfs@vger.kernel.org>; Tue, 13 Aug 2024 02:19:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1723540772; x=1724145572; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=UOIPhCxbCnq3Yq8svFukT75BwpCgCK3DsDifbDiyOd0=;
        b=q/qerAE6tneqD0WyofibxS+CE57Z3QAfRqgeEa0vlnCWQDl4jCxr7GNn6olCXaWwhe
         9+0JUxdi56B+dlQoPH6TXvmqL8NFkv2/79Rf/xcvn4lTh6dSuctunK9oc0dQhxOjxqPd
         DEh8WJtSLgX8bYoEXi2lYV3D848oYnUXHXFfqZ/Gt8zEjJKffbLq6dCLIS1T6MxAXsC0
         MxErex1IfAf+zClgocTezwHw13ad4wc5KuC3Q5L+fo2K03r3Gl5Mg1tWzt1KNbApudwW
         OCaxPbWjb+ecg4mimUOcIKoEsemy4lVLIjns2Oz+KxVDu5Cr4DDJ4tDJVBLZUPzB6Xkn
         NqeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723540772; x=1724145572;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UOIPhCxbCnq3Yq8svFukT75BwpCgCK3DsDifbDiyOd0=;
        b=V0mSDPCmsz4HuR39+KbL/ahtJHd1/MTcHLJyfqcRA4gOZX44ly7aW0hiQeTyVHcRrE
         MRnLroCKC6isKwI9Tu3dawPnZ88G/Y7gyCCB+xbdUkDLyEt+TrBLs0My9v8RER6rqoQi
         YT45JLXc7r78HQkcx4aEgd2uM0uHWcE2cPqewegUgj2uyd35EUBy8ON9l9hgarsUcdbS
         4IiGVlXuvnNvenrnjwfN2ulC/ozpNAFJS6e3tGyHiJ8g3PPmAEJx1n2FpV3JPc/MZYqr
         cggxZ2A/kFp6Yt6lHEtqsr4xohaEOVkhTIMPvztLSMG9rJiFmHHAEzHQnd5IdeqYqMdM
         Ckqw==
X-Gm-Message-State: AOJu0YxoyfLb30Mj4XDqhrhCILQ3YJ5FS3hKmEaeTxUgXs/7V6vFUPCf
	6jhynayq7qwvdU55fKfyx9gAbYuHhV6OqSRMWqXkUi5YjQEC7i6cU0QG1VhmXzc=
X-Google-Smtp-Source: AGHT+IG+YUlmkbgzumQAnDrOC3yJM8EajByKNUPlK1PzPOi8jwfcgoCBenNrzm+PY8E05xjvd16FSA==
X-Received: by 2002:a17:903:24c:b0:1fd:9420:1073 with SMTP id d9443c01a7336-201ca209610mr42003895ad.43.1723540771793;
        Tue, 13 Aug 2024 02:19:31 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-47-239.pa.nsw.optusnet.com.au. [49.181.47.239])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-201cd12f593sm9468545ad.4.2024.08.13.02.19.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Aug 2024 02:19:31 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1sdnge-00FSKT-25;
	Tue, 13 Aug 2024 19:19:28 +1000
Date: Tue, 13 Aug 2024 19:19:28 +1000
From: Dave Chinner <david@fromorbit.com>
To: Anders Blomdell <anders.blomdell@gmail.com>
Cc: linux-xfs@vger.kernel.org,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>
Subject: Re: XFS mount timeout in linux-6.9.11
Message-ID: <ZrslIPV6/qk6cLVy@dread.disaster.area>
References: <71864473-f0f7-41c3-95f2-c78f6edcfab9@gmail.com>
 <ZraeRdPmGXpbRM7V@dread.disaster.area>
 <252d91e2-282e-4af4-b99b-3b8147d98bc3@gmail.com>
 <ZrfzsIcTX1Qi+IUi@dread.disaster.area>
 <4697de37-a630-402f-a547-cc4b70de9dc3@gmail.com>
 <ZrlRggozUT6dJRh+@dread.disaster.area>
 <6a19bfdf-9503-4c3b-bc5b-192685ec1bdd@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6a19bfdf-9503-4c3b-bc5b-192685ec1bdd@gmail.com>

On Mon, Aug 12, 2024 at 03:03:49PM +0200, Anders Blomdell wrote:
> On 2024-08-12 02:04, Dave Chinner wrote:
> > 
> > Ok, can you run the same series of commands but this time in another
> > shell run this command and leave it running for the entire
> > mount/unmount/mount/unmount sequence:
> > 
> > # trace-cmd record -e xfs\* -e printk

[snip location of trace]

> > That will tell me what XFS is doing different at mount time on the
> > different kernels.
> Looks like a timing issue, a trylock fails and brings about a READ_AHEAD burst.

Not timing - it is definitely a bug in the commit the bisect pointed
at.

However, it's almost impossible to actually see until someone or
something (the trace) points it out directly.

The trace confirmed what I suspected - the READ_AHEAD stuff you see
is an inode btree being walked. I knew that we walk the free inode
btrees during mount unless you have a specific feature bit set, but
I didn't think your filesystem is new enough to have that feature
set according to the xfs_info output.

However, I couldn't work out why the free inode btrees would take
that long to walk as the finobt generally tends towards empty on any
filesystem that is frequently allocating inodes. The mount time on
the old kernel indicates they are pretty much empty, because the
mount time is under a second and it's walked all 8 finobts *twice*
during mount.

What the trace pointed out was that the finobt walk to calculate
AG reserve space wasn't actually walking the finobt - it was walking
the inobt. That indexes all allocated inodes, so mount was walking
the btrees that index the ~30 million allocated inodes in the
filesystem. That takes a lot of IO, and that's the 450s pause 
to calculate reserves before we run log recovery, and then the
second 450s pause occurs after log recovery because we have to
recalculate the reserves once all the intents and unlinked inodes
have been replayed.

From that observation, it was just a matter of tracking down the
code that is triggering the walk and working out why it was running
down the wrong inobt....

In hindsight, this was a wholly avoidable bug - a single patch made
two different API modifications that only differed by a single
letter, and one of the 23 conversions missed a single letter. If
that was two patches - one for the finobt conversion, the second for
the inobt conversion, the bug would have been plainly obvious during
review....

Anders, can you try the patch below? It should fix your issue.

-Dave.
-- 
Dave Chinner
david@fromorbit.com

xfs: xfs_finobt_count_blocks() walks the wrong btree

From: Dave Chinner <dchinner@redhat.com>

As a result of the factoring in commit 14dd46cf31f4 ("xfs: split
xfs_inobt_init_cursor"), mount started taking a long time on a
user's filesystem.  For Anders, this made mount times regress from
under a second to over 15 minutes for a filesystem with only 30
million inodes in it.

Anders bisected it down to the above commit, but even then the bug
was not obvious. In this commit, over 20 calls to
xfs_inobt_init_cursor() were modified, and some we modified to call
a new function named xfs_finobt_init_cursor().

If that takes you a moment to reread those function names to see
what the rename was, then you have realised why this bug wasn't
spotted during review. And it wasn't spotted on inspection even
after the bisect pointed at this commit - a single missing "f" isn't
the easiest thing for a human eye to notice....

The result is that xfs_finobt_count_blocks() now incorrectly calls
xfs_inobt_init_cursor() so it is now walking the inobt instead of
the finobt. Hence when there are lots of allocated inodes in a
filesystem, mount takes a -long- time run because it now walks a
massive allocated inode btrees instead of the small, nearly empty
free inode btrees. It also means all the finobt space reservations
are wrong, so mount could potentially given ENOSPC on kernel
upgrade.

In hindsight, commit 14dd46cf31f4 should have been two commits - the
first to convert the finobt callers to the new API, the second to
modify the xfs_inobt_init_cursor() API for the inobt callers. That
would have made the bug very obvious during review.

Fixes: 14dd46cf31f4 ("xfs: split xfs_inobt_init_cursor")
Reported-by: Anders Blomdell <anders.blomdell@gmail.com>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_ialloc_btree.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.c b/fs/xfs/libxfs/xfs_ialloc_btree.c
index 496e2f72a85b..797d5b5f7b72 100644
--- a/fs/xfs/libxfs/xfs_ialloc_btree.c
+++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
@@ -749,7 +749,7 @@ xfs_finobt_count_blocks(
 	if (error)
 		return error;
 
-	cur = xfs_inobt_init_cursor(pag, tp, agbp);
+	cur = xfs_finobt_init_cursor(pag, tp, agbp);
 	error = xfs_btree_count_blocks(cur, tree_blocks);
 	xfs_btree_del_cursor(cur, error);
 	xfs_trans_brelse(tp, agbp);
