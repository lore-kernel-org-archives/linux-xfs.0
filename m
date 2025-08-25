Received: from mail-yw1-f174.google.com (mail-yw1-f174.google.com [209.85.128.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBB142F83A5
	for <linux-xfs@vger.kernel.org>; Mon, 25 Aug 2025 18:22:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756146169; cv=none; b=oOseUasr+6mrfYdmCzEAudg9m6wQr0WeusYu9+bylDXWZn3fHme+dwQ9Pus0aj7qJcBixuIyGz7txvzfREa0adCb1qYIiOp48E5QwPiJrBqDYZzC1Zma3vDeN/2t/0zjSOJbhsycdy4lrsoa/hWTb+q5Xv0N6YBl9JzHh46oYek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756146169; c=relaxed/simple;
	bh=FS4D6RzJNe0/1vJ29vQERztz4mfXg+H3Its9k7rkj3M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZV7/8KVKV0S0hlbY/ekLaiUMNmwdR0voHRhlkvFs4VZ3h5CwV0E0brWUul/HjOTDUHOQFc8Pm/VA6A8K5cNYbuCUee2i+Kyi4d9wgY0KRn5yaVgTDxS3Hjm4NULwnGIDebyP6f/mExyEcSw26G5w7kBDXr97fHRkUOpHNJTLh6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com; spf=none smtp.mailfrom=toxicpanda.com; dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b=KB94o+7K; arc=none smtp.client-ip=209.85.128.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b="KB94o+7K"
Received: by mail-yw1-f174.google.com with SMTP id 00721157ae682-71d60157747so37634687b3.0
        for <linux-xfs@vger.kernel.org>; Mon, 25 Aug 2025 11:22:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1756146166; x=1756750966; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=UbBH3BstU0W0il045l8W91T5IUJiQUm4fEy5zUE09Y0=;
        b=KB94o+7KKpbkv4W85iNWsTnXZBq+eoTrAAd03r/GUpW0lH55v9fQW2T3HaZluuTaYZ
         h45N4FqF4TYQN5Q/HLtSM8dO+TstZ6NdWaKaU90mJwugXK8ZxKdvG86fsNCjzBDsAlQ2
         Kp4xoYG5oFHQCXQjHHMCj9tmfCHIfevuMQoDGvgiNIYVyLtCEjmDIHt1Gattwl/VS0YJ
         mgYJNL3WGQVMzurI1zMNisAuH3FIJJznJlnlq4jtZ0l0S9IfMHxqa7LQca1LLIqmjy9u
         ubjxkmbYK0K3ZTrCMnWehcA0E+FyrZAFeCBOk/xQmtTPY+HiIr/UlDLHhs5kq/czoB9G
         DgzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756146166; x=1756750966;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UbBH3BstU0W0il045l8W91T5IUJiQUm4fEy5zUE09Y0=;
        b=WiwPFiBJLrQffcAviiWvqgybiH7SzLYAH7iMchJYkQf9H/h6MyFomKb5I7Q+ROexAd
         rTO3d5/Urx6EI8OaSd+TDR/xjIQKqZaOpg5/PwgI6HLlDvBjSa6YCEEiZ5/fPr22mBbb
         mqAzBsu9gkUDTbsdakZ5yMEeS0JLKPfwZo2dYFy4zHAUlJJIePVF4/FWeSqWxwALGXeq
         +5TCy+NGG8hYC5qWOiwv6WnRInijR0ca3JMCPHSiIVfqbcG6vADSQJ4ihPoo3K78ky0y
         P7dO8kLUgrKNLeEFYC+TWagAOmm75z1tyGMcadt2/7efJbNViyGhP5i+6eo1l52p7vg9
         ImrA==
X-Forwarded-Encrypted: i=1; AJvYcCViydexex79QfPwvvduS00sM8zIzKQiASotBsSDfhDmug7bzRR2ch+O/GFPXqsgySkeVA8orOegWik=@vger.kernel.org
X-Gm-Message-State: AOJu0YxsXo/ebwVjolwMMqPQAlhR9Rt0Ju7j6jwF0J6EjrZiGI9wkSLh
	VkVvngDSlQZRQ4GDqoVF/0Q6VQQKKhkA2PbdcMklSGCkB+5TYd9ckR6+GUFksf8qNQk=
X-Gm-Gg: ASbGncvT6WS/K5QnkgHDQZKYPzGgwXxQax0SYv11eZho01IkEteGG6ezwbM+A7m2mDx
	kDjjRLYQ3t1i3wni44oiBQIRBwP9bH2GKLgQgCSdOilNSjfGFyb3u2dv0nouLlN/jtqQS6H47DI
	EK0BHjUlaeqkHGi/ufjXE7s94bKHgiJTixQ7XltuBI0W1U4tC/5Z2tlhWHj1GiJUyAD753cZuUK
	MXL9udUBNIBlJXs1a37JyFnwEJltIDpFnPqdKSjGMMwLTvtqC9zARKSwjF2SqPzA4wsYgzzbAnz
	HsbMZJkbahZcVreclwVkVIJJqGBfUbRJyrSZHpsi8rKbh5ehs3Ka8U11o51wPUGC465m8qvR3pd
	ZCxCHjiFFmeHfvjBWX2V49VR8RH5tgQhZZY/2UNfk0QETbF1iwi4WAeN+84hBKlOKjDrqnA==
X-Google-Smtp-Source: AGHT+IERtHisFfW+VyMjl1dMZngork77s7Qk0/q0F0qZcCiOk6L/mrYgqmr7IGpI0tYf+zVYRA2mng==
X-Received: by 2002:a05:690c:9a82:b0:71f:c5f0:3368 with SMTP id 00721157ae682-71fdc2abbcdmr141089057b3.9.1756146165612;
        Mon, 25 Aug 2025 11:22:45 -0700 (PDT)
Received: from localhost (syn-076-182-020-124.res.spectrum.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-71ff18840f8sm19178147b3.47.2025.08.25.11.22.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Aug 2025 11:22:44 -0700 (PDT)
Date: Mon, 25 Aug 2025 14:22:43 -0400
From: Josef Bacik <josef@toxicpanda.com>
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	kernel-team@fb.com, linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org, viro@zeniv.linux.org.uk
Subject: Re: [PATCH 27/50] fs: use inode_tryget in evict_inodes
Message-ID: <20250825182243.GA1123234@perftesting>
References: <cover.1755806649.git.josef@toxicpanda.com>
 <7564463eb7f0cb60a84b99f732118774d2ddacaa.1755806649.git.josef@toxicpanda.com>
 <20250825-jungautor-aprikosen-9e6622636614@brauner>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250825-jungautor-aprikosen-9e6622636614@brauner>

On Mon, Aug 25, 2025 at 01:43:57PM +0200, Christian Brauner wrote:
> On Thu, Aug 21, 2025 at 04:18:38PM -0400, Josef Bacik wrote:
> > Instead of checking I_WILL_FREE|I_FREEING we can simply use
> > inode_tryget() to determine if we have a live inode that can be evicted.
> > 
> > Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> > ---
> >  fs/inode.c | 8 ++++++--
> >  1 file changed, 6 insertions(+), 2 deletions(-)
> > 
> > diff --git a/fs/inode.c b/fs/inode.c
> > index a14b3a54c4b5..4e1eeb0c3889 100644
> > --- a/fs/inode.c
> > +++ b/fs/inode.c
> > @@ -983,12 +983,16 @@ void evict_inodes(struct super_block *sb)
> >  	spin_lock(&sb->s_inode_list_lock);
> >  	list_for_each_entry(inode, &sb->s_inodes, i_sb_list) {
> >  		spin_lock(&inode->i_lock);
> > -		if (inode->i_state & (I_NEW | I_FREEING | I_WILL_FREE)) {
> > +		if (inode->i_state & I_NEW) {
> > +			spin_unlock(&inode->i_lock);
> > +			continue;
> > +		}
> > +
> > +		if (!inode_tryget(inode)) {
> 
> So it reads like if we fail to take a reference count on @inode then
> someone else is already evicting it. I get that.
> 
> But what's confusing to me is that the __iget() call you're removing
> was an increment from zero earlier in your series because evict_inodes()
> was only callable on inodes that had a zero i_count.
> 
> Oh, ok, I forgot, you mandate that for an inode to be on an LRU they
> must now hold an i_count reference not just an i_obj_count reference.
> 
> So in the prior scheme i_count was zero and wouldn't go back up from
> zero. In your scheme is i_count guaranteed to be one and after you've
> grabbed another reference and it's gone up to 2 is that the max it can
> reach or is it possible that i_count can be grabbed by others somehow?

It can be grabbed by others now.

The idea here is that we're drastically simplifying the logic. We no longer care
to only operate on inodes that are truly dead. If we can grab a reference to the
inode then it is live by some other means (LRU, someone holding a file open,
etc). We remove it from the LRU and then we drop our reference. At this point
becasue S_ACTIVE is not set we know that we won't be adding inodes to the LRU
anymore, and this should free the inode.

However if there's some bug in the filesystem or elsewhere and we have an
elevated refcount then we could still leak the inode. But we just don't care
about that here. Before we wouldn't even bother to touch the inode, now we
uncondtionally process all the inodes, and if there's still inodes left then
there's a bug.  Thanks,

Josef
