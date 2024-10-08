Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BBAF847C
	for <linux-xfs@vger.kernel.org>; Tue,  8 Oct 2024 00:29:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728347360; cv=none; b=d/3L4m9wkGABZhHzdfRwhw+p6U8CtefNwrClDCCIsVjQ9SfB7PmjLDbTyqGO0+TGtQZtWHGEAveBeEsdPs6t/IlsugyEE5tqqY/qKcsMVF6FuZ/hNz71h7PlKbT3mG80+eSGeTXD+I2ykwlazcdcA7i3kO3Z3FGS+cbnQMtOdNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728347360; c=relaxed/simple;
	bh=Tke8szf/tF+Zw53GGM7FveqgBu9sg0bXcPAEsM0e6AA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=AD6umV/+7EfALWRxO76TxKyWUKDiPh31thTUzYcdA/Yr5c46s6L9bI65XgKafqwedY9VRZ13076qNAXiAKdGd50v2WSgH8xz5D9uuRSscoWfQPjLx+du0GghR6ByUEQ9Wkm8CPzutEu0NrBW7wOqWe5kFe/ays0QL8kDaZaZFAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SurQBpMW; arc=none smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SurQBpMW"
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-a99388e3009so344308666b.3
        for <linux-xfs@vger.kernel.org>; Mon, 07 Oct 2024 17:29:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1728347356; x=1728952156; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=nsQ1lX9RfNwwbE7U1ME2PBLb06zd6P+Kklt61iLJfEw=;
        b=SurQBpMW7G7bZrq3KaGn3kA+A8iOOqmVEuTSU8e+54O6jzmM69OUsbYB2WQ12eHK1x
         ZECw/2nGIhM+RJ6Cf0dLpwpRjAGwcMBXP1D/CmnQ17Q8o1jAIH/d9cj8KBXqMzQ313+q
         vGIxuq4lE4TAOpLuf1nbarN7u0wDwxIM8oMFM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728347356; x=1728952156;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nsQ1lX9RfNwwbE7U1ME2PBLb06zd6P+Kklt61iLJfEw=;
        b=lUMSI7VMGPhjGHp9vcrcK8AEVq/Kz8ZANyvitWRVdi+ItCj2I1wDvucn1pCqrg5vL8
         IRMHKVtvF2YgD5mF2MOiETjzKCc/XuAUMtavlSkRfPB2zumCD63tp++IC1THqhRrZqnk
         +pSmDWcslXIPvvJcK3i+92oypU8atzzgp0mUuTHCw5C+k2Ib01uCgH75dPi58+UnwdM8
         6oqkqzO7W8Ngmak91fi01dDNMgECIyA49308wmWFOH589qP+FfAoAOo7qZXEl4+aGlO7
         imwL+29SiIqtwcHRxyPcF8pxl9jay9BQeMOHvekhb9NdNBSLImBoGTZJYWuR7qV4gux1
         MHcA==
X-Forwarded-Encrypted: i=1; AJvYcCWgTO0fgbvccc0bAt0tkEUzjc7uLPFz5Cp1UdI5BNqsbwFFKuiqny9+HOhC8k0CEKfVGo6/QQXFsI4=@vger.kernel.org
X-Gm-Message-State: AOJu0YyGEzl5aaLYLbi6Etpq50rZFTepVKPqpmAwU+l7KANH6qGV610a
	25PP8DkFUm+PdjkfNkOpIVRt+RE0kNHFXJyuhloBNoIl2WNANirYYLUwiBQGa1QKnuvPgMEs4hn
	sOgyJlQ==
X-Google-Smtp-Source: AGHT+IGi6PPc/+5RZGEctOO+gWTp1ZaYAv2LkLHpLFoi7HDhfL/+SfJHwkxeBAxaekalyOWNpuAfAA==
X-Received: by 2002:a17:907:9348:b0:a7a:97ca:3059 with SMTP id a640c23a62f3a-a991bd6b53dmr1442784866b.34.1728347356420;
        Mon, 07 Oct 2024 17:29:16 -0700 (PDT)
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com. [209.85.218.43])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a993faa2cdesm361466366b.110.2024.10.07.17.29.14
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Oct 2024 17:29:14 -0700 (PDT)
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-a99388e3009so344305066b.3
        for <linux-xfs@vger.kernel.org>; Mon, 07 Oct 2024 17:29:14 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVM+1lSieGyhKmJyN1GcInoiUguzxOoQIYBzo01ahFUxdSg2ddUCMD+g+KjEL3NGsvV8geUS7Ck6gI=@vger.kernel.org
X-Received: by 2002:a17:906:6a19:b0:a99:762f:b296 with SMTP id
 a640c23a62f3a-a99762fbb7fmr20741966b.59.1728347354279; Mon, 07 Oct 2024
 17:29:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241002014017.3801899-1-david@fromorbit.com> <20241002014017.3801899-5-david@fromorbit.com>
 <Zv5GfY1WS_aaczZM@infradead.org> <Zv5J3VTGqdjUAu1J@infradead.org>
 <20241003115721.kg2caqgj2xxinnth@quack3> <CAHk-=whg7HXYPV4wNO90j22VLKz4RJ2miCe=s0C8ZRc0RKv9Og@mail.gmail.com>
 <ZwRvshM65rxXTwxd@dread.disaster.area>
In-Reply-To: <ZwRvshM65rxXTwxd@dread.disaster.area>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 7 Oct 2024 17:28:57 -0700
X-Gmail-Original-Message-ID: <CAHk-=wi5ZpW73nLn5h46Jxcng6wn_bCUxj6JjxyyEMAGzF5KZg@mail.gmail.com>
Message-ID: <CAHk-=wi5ZpW73nLn5h46Jxcng6wn_bCUxj6JjxyyEMAGzF5KZg@mail.gmail.com>
Subject: Re: lsm sb_delete hook, was Re: [PATCH 4/7] vfs: Convert sb->s_inodes
 iteration to super_iter_inodes()
To: Dave Chinner <david@fromorbit.com>
Cc: Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org, 
	linux-xfs@vger.kernel.org, linux-bcachefs@vger.kernel.org, 
	kent.overstreet@linux.dev, =?UTF-8?B?TWlja2HDq2wgU2FsYcO8bg==?= <mic@linux.microsoft.com>, 
	Jann Horn <jannh@google.com>, Serge Hallyn <serge@hallyn.com>, Kees Cook <keescook@chromium.org>, 
	linux-security-module@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>
Content-Type: text/plain; charset="UTF-8"

On Mon, 7 Oct 2024 at 16:33, Dave Chinner <david@fromorbit.com> wrote:
>
> There may be other inode references being held that make
> the inode live longer than the dentry cache. When should the
> fsnotify marks be removed from the inode in that case? Do they need
> to remain until, e.g, writeback completes?

Note that my idea is to just remove the fsnotify marks when the dentry
discards the inode.

That means that yes, the inode may still have a lifetime after the
dentry (because of other references, _or_ just because I_DONTCACHE
isn't set and we keep caching the inode).

BUT - fsnotify won't care. There won't be any fsnotify marks on that
inode any more, and without a dentry that points to it, there's no way
to add such marks.

(A new dentry may be re-attached to such an inode, and then fsnotify
could re-add new marks, but that doesn't change anything - the next
time the dentry is detached, the marks would go away again).

And yes, this changes the timing on when fsnotify events happen, but
what I'm actually hoping for is that Jan will agree that it doesn't
actually matter semantically.

> > Then at umount time, the dentry shrinking will deal with all live
> > dentries, and at most the fsnotify layer would send the FS_UNMOUNT to
> > just the root dentry inodes?
>
> I don't think even that is necessary, because
> shrink_dcache_for_umount() drops the sb->s_root dentry after
> trimming the dentry tree. Hence the dcache drop would cleanup all
> inode references, roots included.

Ahh - even better.

I didn't actually look very closely at the actual umount path, I was
looking just at the fsnotify_inoderemove() place in
dentry_unlink_inode() and went "couldn't we do _this_ instead?"

> > Wouldn't that make things much cleaner, and remove at least *one* odd
> > use of the nasty s_inodes list?
>
> Yes, it would, but someone who knows exactly when the fsnotify
> marks can be removed needs to chime in here...

Yup. Honza?

(Aside: I don't actually know if you prefer Jan or Honza, so I use
both randomly and interchangeably?)

> > I have this feeling that maybe we can just remove the other users too
> > using similar models. I think the LSM layer use (in landlock) is bogus
> > for exactly the same reason - there's really no reason to keep things
> > around for a random cached inode without a dentry.
>
> Perhaps, but I'm not sure what the landlock code is actually trying
> to do.

Yeah, I wouldn't be surprised if it's just confused - it's very odd.

But I'd be perfectly happy just removing one use at a time - even if
we keep the s_inodes list around because of other users, it would
still be "one less thing".

> Hence, to me, the lifecycle and reference counting of inode related
> objects in landlock doesn't seem quite right, and the use of the
> security_sb_delete() callout appears to be papering over an internal
> lifecycle issue.
>
> I'd love to get rid of it altogether.

Yeah, I think the inode lifetime is just so random these days that
anything that depends on it is questionable.

The quota case is probably the only thing where the inode lifetime
*really* makes sense, and that's the one where I looked at the code
and went "I *hope* this can be converted to traversing the dentry
tree", but at the same time it did look sensible to make it be about
inodes.

If we can convert the quota side to be based on dentry lifetimes, it
will almost certainly then have to react to the places that do
"d_add()" when re-connecting an inode to a dentry at lookup time.

So yeah, the quota code looks worse, but even if we could just remove
fsnotify and landlock, I'd still be much happier.

             Linus
