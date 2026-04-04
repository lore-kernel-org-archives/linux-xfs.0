Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1FB5182D0
	for <linux-xfs@vger.kernel.org>; Sat,  4 Apr 2026 08:59:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775293156; cv=none; b=qoYL3yP8dHgZChiLLy8SoxOntFYf8cKWAw7/quETuVMag4gGQ/C0Hp9KdQqI/XcjiaHBe/JBMryeL30zxD5nTCWAE4daGKGyT4cdxDgMDVXyfzTbemW7rqNgxtWY3naOslIPqYiOmS0CkuhGbACSYPjaHh69wqG7F49nM6mFSik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775293156; c=relaxed/simple;
	bh=uDJtadNJQtVClJNGz6Fgvc0qOOD8ZBGg7n46C9beoAI=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=ryLQ7cuL+1GUphDArlt5bZo30x0Bo+GXumof/3qT3IK+Smwx+PPwatYhhm0/dmHLFe1LMOUzlu2M2ndCr0CZAhpqqqLaTxVg4tDKfav9p+l/Ecdu8xPeOGfKmCNF3M8474lZOuUs8RAHuWI1G3UMcx0SPFiky7LD7WvVfiXfiuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=APBqtasz; arc=none smtp.client-ip=209.85.216.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="APBqtasz"
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-35d96be7c13so1524249a91.0
        for <linux-xfs@vger.kernel.org>; Sat, 04 Apr 2026 01:59:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775293153; x=1775897953; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=+kz27emeQpXLA53ZgoxFIbwzHRJwb1l4CVdcohSXzQg=;
        b=APBqtasz4vbMdgpdGFkn84GpE9pncljnTKRYGWy7OCdn73MGUaNpbH9ICK96iyOXtP
         qWoPSebTch8oB9S1Lf1cGZXyuoln8KMRojTscs/tvHggnAc1658CtOLRA+BeqA4bnj1q
         GHVvYJlh9WMG+Y3h+drLI5mzEtjbUyEYaL0c4DaZyLwQlE8/sswI1ax3IL3uGpELKLkL
         onydV9tbS6vcy0lEFYyEmX7XAE8G9lK5jJYlMHVQ9WFEPzb2sgCkilQOauIjxB2+LrJ5
         kgZ0dNOqE/vIlViK3nseWYVMGvwEwJSl8FgRfQUk5hlWiYLU9uAuWLuXCUocIcQ7s1PP
         NSHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775293153; x=1775897953;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+kz27emeQpXLA53ZgoxFIbwzHRJwb1l4CVdcohSXzQg=;
        b=IG/j75rYbCGGpVfWfM8s5r5nXnpGox5EUjohzZOAxVALb8u/TO4+hG7vsiqXMtUa+V
         h0PJSsJRptQkagH7tCUsNih74ordDua1AhT1JIcFp4c3s9DMc/bWaezfn9O8yDGuCCWj
         XJ4B69U43eXdiwLSdD9Iz2dUsbaQ8Cs+z1PMSDMc7CnkI8J0JwQrzvalZ6JeVMAoBLQw
         Rh2dsVOoA+qMzG87wpyZA/Ltcg4V4mR0xPyhZRFf41vL1PDiANFj0ZyFVy4XVXXqcg3B
         FbQ+1JnKXy4Js4Z771FXRPgphcMDB7lOd9ZG9qOGdxJDvf2N5Yk+o7xZZfQia1rcTb4K
         ptOg==
X-Forwarded-Encrypted: i=1; AJvYcCU6R10hlTU90LBt7wOPs54hsx7wyNZNNKNF6f/VZlwGH05U4mRhvtWWLfuKwK4ueEB8F1Pepsrc6aU=@vger.kernel.org
X-Gm-Message-State: AOJu0YysZrzC4Vo9+z4Y6gnHnZCcgD3DgoagNP7Ej09SI5lumfYBsWFw
	vBKt0edGRSPznAUSdy/gwzDI3axBvNxJd/NGhB541Rk4lpZOe2LQGYG2Jbf7gBge
X-Gm-Gg: AeBDieszYKwNlNPaHHtObsBQBl5lJIF/yZvEQg1prEkgOJhgjRL9DUqunj9HUXRZ4Rr
	takMWYNsU3hRdicJTAFZVkksr2nC8+2T2WW7R2qdRdtKmt3xeKNG3j2ozj5LtLDqmvcJ1DGb1t1
	IBqg5rNJm2OWG74BLCgaM82gmvIHaYejsb3yCyjtYcAAKYHsVRc3hxDIWuejAK4XEaRbP3ahhfY
	UyqVNezdZ0gqOwQor9xSeawcUUF0n/XVDVHUlwZVXVp4Jda/EyU79Ua6ehpmfivG5vTctxTQTd3
	i26LVS75EtnK3HGr4IsO+BweW/2DegvRmvCZ3pRu6ndGJVhT1ZRN0gko7p+tissR/Cmzw4PK3by
	IATxXWmD+0kQpKfOwEoVcTndRzrfPxWiTTNAFrdJernXajyMoxPemkI8Y11659JmQvjnRQvK16j
	dzwZans54aZ+WKM10wGPJNhW6C6d0=
X-Received: by 2002:a17:90b:52cf:b0:35c:195e:112f with SMTP id 98e67ed59e1d1-35dd68b3edamr8054586a91.18.1775293152635;
        Sat, 04 Apr 2026 01:59:12 -0700 (PDT)
Received: from [192.168.50.90] ([116.87.14.48])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c76c6491fe0sm6489143a12.11.2026.04.04.01.59.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 04 Apr 2026 01:59:12 -0700 (PDT)
Message-ID: <5bda3d00-df35-4ea1-b313-2fef6e5c5682@gmail.com>
Date: Sat, 4 Apr 2026 16:59:08 +0800
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/3] ext4: derive f_fsid from block device to avoid
 collisions
From: Anand Jain <anajain.sg@gmail.com>
To: Theodore Tso <tytso@mit.edu>, Christoph Hellwig <hch@infradead.org>,
 "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org,
 linux-xfs@vger.kernel.org, Anand Jain <asj@kernel.org>
References: <cover.1774092915.git.asj@kernel.org>
 <33e8eb64c304a4d42b60f608c26497bf9a2e9e19.1774092915.git.asj@kernel.org>
 <20260323041624.GA11453@mac.lan>
 <d4a9970b-e7ed-4e74-be9d-2d08400f9d79@gmail.com>
Content-Language: en-US
In-Reply-To: <d4a9970b-e7ed-4e74-be9d-2d08400f9d79@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit


Hi Ted, Christoph, Darrick,

As I prepare v3, I'd appreciate your final thoughts on the mount option
naming and its necessity for ext4.

For the new option, I am considering:

  -o nodup_f_fsid

  -o unique_f_fsid

Context:
Currently, ext4's f_fsid is consistent across reboots but fails to be
unique when dealing with cloned filesystems (sharing the same UUID). Per
statfs(2) [1], the primary requirement is that the (f_fsid, ino) pair
uniquely identifies a file. The man page makes no explicit guarantee
regarding consistency across mount cycles or reboots.

Proposal:
With this fix, f_fsid becomes f(uuid, dev_t). This ensures OS-wide
uniqueness and maintains consistency as long as the underlying dev_t
remains stable.

Dilemma:
While statfs(2) [1] suggests f_fsid is "some random stuff," we know
userspace (NFS, systemd) often treats it as a persistent handle.

Do you prefer one of the names above, or is there a more idiomatic ext4
naming convention I should follow?

Given the ambiguity in the man page, is gating this behind an -o option
necessary, or should we consider making uniqueness the default behavior?



[1]
----------
statfs(2)

<snap>
       Nobody knows what f_fsid is supposed to contain (but see below).

<snap>
   The f_fsid field
       Solaris,  Irix,  and  POSIX  have  a  system  call  statvfs(2)
that  returns  a  struct statvfs (defined in <sys/statvfs.h>) containing
an unsigned long f_fsid. Linux,  SunOS,  HP-UX,  4.4BSD  have  a  system
 call statfs()  that  returns a struct statfs (defined in <sys/vfs.h>)
containing a fsid_t f_fsid, where fsid_t is defined as struct { int
val[2]; }.  The same holds for  FreeBSD,  except  that  it  uses  the
include  file <sys/mount.h>.

       The  general  idea is that f_fsid contains some random stuff such
that the pair (f_fsid,ino) uniquely determines a file.  Some operating
systems use (a variation on) the device number, or the device number
combined with  the  filesystem type.  Several operating systems restrict
giving out the f_fsid field to the superuser only (and zero it for
unprivileged users), because this field is used in the filehandle  of
the  filesystem when NFS-exported, and giving it out is a security concern.

       Under some operating systems, the fsid can be used as the second
argument to the sysfs(2) system call.
----------


Thanks, Anand

