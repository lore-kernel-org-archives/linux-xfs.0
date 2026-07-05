Received: from mail-yw1-f180.google.com (mail-yw1-f180.google.com [209.85.128.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCB9530D3FB
	for <linux-xfs@vger.kernel.org>; Sun,  5 Jul 2026 03:45:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.180
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783223113; cv=pass; b=nexlwYqFVa3bCNYBXsXH067sqssAJK2+95lCSxhV4KUQqDzAAM9oAj9A8gjbvlfQm1F3jPhMtmlGng/FH0ttmiOoWOywEnc1GoofCwHJ9c+aUJAZUHAcW8o7j0LDYvKHAY3N+IacdR5k68RDor0rRk3b0shHoy0Or+RNlnOKGRI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783223113; c=relaxed/simple;
	bh=DqK6kv8JoLuDgkN2QV/KRdaZn5lXfRcs7Ca8vWjJ5YU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=scxIVqy5JY0BW+GZ50dwxR3P2Ua269U9OAEZNM6z1d2a6ic/bjLHEdaHG+HhR/DgCU6qKHJv+LbKAPeVVA597ixtX8F9x0hMldgtSAcLoLrPwX8NZCJIins8nkjhbMI+3f2HMo1F3Oj4Qbmvf7BEv8ngRp7lGicGczYrxVwHOvU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aeMOe4xs; arc=pass smtp.client-ip=209.85.128.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aeMOe4xs"
Received: by mail-yw1-f180.google.com with SMTP id 00721157ae682-80d33d13a23so23085027b3.1
        for <linux-xfs@vger.kernel.org>; Sat, 04 Jul 2026 20:45:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783223108; cv=none;
        d=google.com; s=arc-20260327;
        b=jK9Aawl1p+msaMqCirtETraLMFpcJistbsgKdBac6idgIQZ6hDXwP/KvmD20HksD9l
         zeHk+wyv4tWJ2nder5NpJaGPV4dvZ7QWgKKF8+51WV6fRtx9cx8Sf77Ns8ZlxYV/kCPE
         85Jw5GdZF3jqh+KAd2ACDHV/SYmuWn6ybW3J7VImNet0O09OnT+Kv+EmWieXi7XPpmt/
         Z8UZavxqf6SEKiqq5MdAy9+UlY0s0TdCzg3sppJHLxuERpMzMZUtm38SN9XQ2qUeF5Zs
         unGZSNh+akXqtzgCQfsDYHeeBMXC9WIhN/RfrIfDk3+zQazNkerC4eDdr/E2QgOIOVug
         c/TQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=ET8ZSxCu23cuK+V9IeRdLX5vHBDHyxu+yT1P83btoWg=;
        fh=7dnXjLtfyssYHuJaP3BZWfmdcSsmVy0iM1Sm9SnCGvE=;
        b=EjDQgnkPbj6mm0KhOWzA0ku+keMGMkvxTRhNg0pO7A7n6OXdTab0iW5EqRO9v8esxX
         Nl9vhTV+jdk2wOqbQpi8de3DSSfleMtQ1g2DnhZ8enFFrWPA0mNXWtTu99wipaqYGSKY
         bBkSdOj7MthsUshTuzWFlZO37cp917Kcbfd3/yEr6VRW6YAmc+0OpKfjMLO5mtWzp4PW
         8SxPQStEH6qLLZn1Wi2ivAt6ochT0wmKF7EcME8lYoR7VXZzNPg0wtuHm46XNA1Xodrn
         dLFDGEbn9mkIdbV/z9K6wGuBKFjdHigN1/cqGbH54A/LDrgfB3m+dRhIPQIcBLkb9pHE
         R+lw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783223108; x=1783827908; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ET8ZSxCu23cuK+V9IeRdLX5vHBDHyxu+yT1P83btoWg=;
        b=aeMOe4xs6sz3xipk3J47CQMS4griUKVOplGPgXoaUN8W0pLzW3/FjnH9tPAM0A/TS+
         tSvjEHVA0++nD/PljIdCDgP1SuWWoZMXVbx5I93S72hJYdL5rJM2aFajKawWy03q1OJx
         jpOF9q0bPFjhan8nUeamn1KBD6T/G8KCj3MiideA51soWV6ku2JA3SqQliKLGWcei8Kj
         tCoRdj+2Oz2dvKmBEnxmvw/+Msr4ByH7E85eTxTWEeWIKBN0Y/ASPWl9RcBRSCh9IzTN
         6fLRRHgr/D9+3qgnf9tpwgppKLBF+StPHx4mRN7TQkmGI/kMi6frRsVj3mjaeDEj5Ahr
         1kOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783223108; x=1783827908;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ET8ZSxCu23cuK+V9IeRdLX5vHBDHyxu+yT1P83btoWg=;
        b=TE3p4MYBehOSC3N2hTrOlRr9aJYqp3vSTZ+6MArf3YJ54Cw/c78J21h486TFt1ETgc
         5rui7xDRrwB9Lp1EqEEx5NrUwVWuIWnJ5J+/3+PfaN8WRgEwcMiKGW23Lg8E/UzQiZRF
         yIClQ+xknwBznpIaUWLyNTNGkQhMTgCeR2M9/bV7BZDAlgZ0C3ngfYAgnaBiEC5yECZU
         ZLa6tolGfbDjcd1CVfQQL0/X3g9STXRs/8Wx3oeUYrL7jJy5wUbQuIrYCfrsAFoZj9av
         T4gIn1uKPlLQK3e6DBNWuj/E6C1LC4KUzRyftFLjaZ9k/eB3Qh22T7g5qJAMEY2LomNF
         SNeg==
X-Forwarded-Encrypted: i=1; AHgh+RoqcRjhD8IsR1xLwDVN+IlpgiSyQv+vbXlR6icbPWhBoDmvovek8N1U6vPhOJ6v+PLvzrqW0+dONT4=@vger.kernel.org
X-Gm-Message-State: AOJu0YwNy/w26zD3Op4H/9QfBB8hPDMC3hR/j+W1ac5uxorQMazRp2al
	9rPSOFLJNnVrkYwNPlZaQUgYOxjKs7anxrWGIq6RijQQn0QN7O2fTnjn6BWlyDvSUwPUZ1Uv892
	UswQS0IWZBeWVR4jGVM2Ts84yG5vJ/Ss=
X-Gm-Gg: AfdE7cklhKgc+uYZrYymKDJliHc0RhpuJ5yVWN6i6SiIb6j6xNcP758lO8wqJ5T8/f3
	vR4wwBYvNSaY2YxlptzvmXiLzAzp2MfNQd0UNCSIox4QNlDZX2p7vKx4IiR+FmEEoIUwcliELxH
	4+m/ybFZfMIOdSLkSgkEnGv6nGtstytpHMmBWhyCN4Xj1IaaqJjNqQK/8tqwB4rb1+3MxmT3d7r
	fiyrjSRhp/Zi9QHv9/r6RhTMz3LFzHDakOArRr3TRySCKQVjvk98/iWmnQAJx3udsEarGkOfXg=
X-Received: by 2002:a05:690c:6c8a:b0:808:2762:2d18 with SMTP id
 00721157ae682-81738510f43mr61093317b3.31.1783223108290; Sat, 04 Jul 2026
 20:45:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260705024100.3398090-1-zzzccc427@gmail.com> <51965467-4fd7-4d85-8382-9f8928ec718b@kernel.org>
In-Reply-To: <51965467-4fd7-4d85-8382-9f8928ec718b@kernel.org>
From: Cen Zhang <zzzccc427@gmail.com>
Date: Sun, 5 Jul 2026 11:44:56 +0800
X-Gm-Features: AVVi8CeRxkN4bQY6Pf1-K9n9O_o9jCbjAbTf5N0H-D353nZUooJOdLhJDEitHDE
Message-ID: <CAFRLqsWd8FnNkGPWzUgrnYSrtmhMhmtQ1M3bgoK8esPA=9ONDA@mail.gmail.com>
Subject: Re: [PATCH v2] xfs: tear down zoned sysfs before freeing zone info
To: Damien Le Moal <dlemoal@kernel.org>
Cc: Carlos Maiolino <cem@kernel.org>, Hans Holmberg <hans.holmberg@wdc.com>, linux-xfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, baijiaju1990@gmail.com
Content-Type: text/plain; charset="UTF-8"

Hi Damien,

Thanks for your review and suggestions.

> Hmmm... What if the user already has entered the show function but gets
> preempted before referencing the zone info and umount proceeds ? That problem
> remains, no ?

I double checked the sysfs/kernfs paths, and I do not think that specific
case remains with the current ordering.  sysfs reads go through the kernfs
seq_file path: kernfs_seq_start() takes an active reference before
sysfs_kf_seq_show() calls the attribute's ->show method, and
kernfs_seq_stop() drops it afterwards.  On removal, kobject_del() reaches
sysfs_remove_dir(), which calls kernfs_remove(); kernfs_remove() deactivates
the subtree and kernfs_drain() waits for active references to drain.

So if nr_open_zones_show() has already been entered and then gets preempted,
xfs_zoned_sysfs_del() should wait for that active callback to finish before
returning.  Only after that would xfs_unmount_zones() free m_zone_info.

> Why not call this in xfs_mount_zones() ?

Yes, that is cleaner.  The zoned sysfs files expose zone allocator state, so
putting xfs_zoned_sysfs_init() in xfs_mount_zones() makes the ownership and
lifetime boundary more obvious.  I will move it there for v3.

> And this as the first thing in xfs_unmount_zones() ?

Agreed.  I will make xfs_unmount_zones() remove the zoned sysfs directory
before zone GC teardown and before xfs_free_zone_info().  That keeps all
zone-info users behind the same allocator teardown entry point.

One detail is that if xfs_zoned_sysfs_init() is called after
xfs_zone_gc_mount() and then fails, the mount error path in xfs_mount_zones()
must unwind the GC thread before freeing m_zone_info.  I will handle that in
the v3 error path.

> Another simpler approach could be to simply call xfs_mount_sysfs_del() earlier
> in xfs_unmountfs(). Though that may have other implications and I have not
> checked details.

I would rather avoid moving the whole xfs_mount_sysfs_del() earlier.  The
bug is specific to the zoned sysfs subtree because those files expose
m_zone_info, whereas the rest of the per-mount sysfs tree has different
state and lifetime.  Moving only the zoned subtree into
xfs_mount_zones()/xfs_unmount_zones() seems narrower and keeps unrelated
sysfs teardown ordering unchanged.

Best Regards,
Cen Zhang
