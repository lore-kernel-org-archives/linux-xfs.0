Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A89B2BCF4C
	for <linux-xfs@vger.kernel.org>; Mon, 29 Sep 2025 12:56:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759150598; cv=none; b=mIG50++ZmXfGMiy1Vz3DjlQWWAASwPU2lMsb7NtTopmkQQx/KnobWelNYxURYxG9203X1mNP2BkTB5hNQ3oIPfUDq43JNedmi+ZXmcalffl9QmC1bk0qj05cMOHXDduZCZem7rJF5qKun58ql2DavmD0DUYoLgU0R0QJSx0vsfw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759150598; c=relaxed/simple;
	bh=czoR4K1G+s7y76NbjlWpJJ4z4V3QKtSDAu6HI/RHErw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VHN/1zvplc5D5PooO9vzoJSp0R22Bkquj4Y09qoiOjh8Moknhct+B/y4pvr+aveAP2scoZLnQVj99+BSccf++G0wZX1UfYfquTJQWsJPIDTqYrdBGyqQHqUTgSm3zhG9orhDly4NscEEwYdlqietsfWuLDOnpold+3GzcoWGJh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FCgn4P2K; arc=none smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FCgn4P2K"
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-b3b3a6f4dd4so331661066b.0
        for <linux-xfs@vger.kernel.org>; Mon, 29 Sep 2025 05:56:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759150595; x=1759755395; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vT64PoBlF5OmMwmdMDL2m5IBI9zs1VxmhdKVWW/7dn8=;
        b=FCgn4P2K1bIgFAJoDuau++Y6+Tu6orG3eYikQptlTbn2qk5fvnEX7rNz9xsa4ZIAk9
         TNz6RZf1mVEJ+Su1njyT9bIYaseGuw0JWXQMPRpP00jx3gM9a4BJqrnV9kYHqPXbJaOq
         dhlEb8pqe7t8ANKhDaOdu1T1Y/mpR47EeDuatvBM511yYbhWL6Uu/rIc2s4AYq5Ndc0a
         fop7n/Pv7EAT0po0BdS0IYOt4RiIvQ6Mn+1uZG2p8wrWzsrtqds8fVEJ48NrNm2Iofnq
         nfDx40KqhrUAlKvyAFMaZdew5N8LuEja0ysIg0wwj2ntDhoqum1eyE8GcCYO/dnVabBV
         mIUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759150595; x=1759755395;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vT64PoBlF5OmMwmdMDL2m5IBI9zs1VxmhdKVWW/7dn8=;
        b=vO+bHQZW9fWw+2Ck5flCxsPHDF5usIBt6B2h0/yf6xOh+SSQc/ITSy5HkbSwHpOnFc
         mtVw6Q5aYho/ZMkurjyVK0G8oJxC5CheGbahNnG59kSSnZfoZF7SN47CrIqpYn3q79bs
         GLeU+t87gwJVZjsRhSr/Oza6Hat29tZ4fcaGf9CymfSgNGU0DXC4hJq8lLBxZHL7YkHx
         DXvQeE4MP4ynZRcwwL/BzATSt9EIWFdvSEv4y2ShyDho1KU8UPcGYf6sQ20hpbxCOdLI
         CqPj6Vz1FnX7XMtO+UveTdTpDKQ2uxsW5fPL/woHsdLzgqgIABN0E2g1e/4rT9Y21IgP
         uDJA==
X-Forwarded-Encrypted: i=1; AJvYcCURyvebUWuTPLGigrp5rEPh5MI7dxparWX3B4idKYEJZSD4s2X362HWpfVPYQWTCMmSXdLEt5EsaWw=@vger.kernel.org
X-Gm-Message-State: AOJu0YySdBfFgcYWzOvE3WfF/XdBBr+TsBHy9PI+43DXHHWdv6uRAODB
	NA28B7R6ZDeNgCS6fUiobOw41eAdU86cYxEtHCx2T/Mv9cG8nU2+c1cFlI/x6ALDZrJLqfydNzo
	4RYse3N5/u4OzYyMHK0mt6nPZJjaLmmY=
X-Gm-Gg: ASbGncvyuqiqRvNpkOrJ5Hu+OycbJ8Y2cxcfaefCK3uvmgT7kMKVwCIVXLJizlSrM6V
	gRS9j4jxQYSjM69e6BUJ44P3Cf3j9OUkoTbqUy7Jm1UvLeUGZWCi8FCgQPb2gXGrDn6jyakcCUD
	mm1XASJ+U52jZdvOFVIKqOGA1iPnNTnupPijS7FVvfqkEBP2ln0iQM5LqWUxP6xI1Ihnc+70BHs
	J+LNQb+3DjpiPy0xFzFKgeCHTQBv2qXTm4NQ9TN8/UJ92RnkZGvOy+9IGU5i7A=
X-Google-Smtp-Source: AGHT+IHwgU6a7k1Tl/htBp66waMHN4IzraB7wwO8zA//bOHkHjYwuv41WV4gECwjjXP36V6Dgiwj6qkk1Bdqwjmi4TU=
X-Received: by 2002:a17:907:7291:b0:b3f:9eaa:2bba with SMTP id
 a640c23a62f3a-b3f9eaa2f1dmr276916766b.63.1759150595150; Mon, 29 Sep 2025
 05:56:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250923104710.2973493-1-mjguzik@gmail.com> <20250929-samstag-unkenntlich-623abeff6085@brauner>
In-Reply-To: <20250929-samstag-unkenntlich-623abeff6085@brauner>
From: Mateusz Guzik <mjguzik@gmail.com>
Date: Mon, 29 Sep 2025 14:56:23 +0200
X-Gm-Features: AS18NWAQppLQGH4Q4QepXGfVar_40_jU-wol-wjJISWMpqe1GoM3Cv27IqmClpo
Message-ID: <CAGudoHFm9_-AuRh52-KRCADQ8suqUMmYUUsg126kmA+N8Ah+6g@mail.gmail.com>
Subject: Re: [PATCH v6 0/4] hide ->i_state behind accessors
To: Christian Brauner <brauner@kernel.org>
Cc: viro@zeniv.linux.org.uk, jack@suse.cz, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, josef@toxicpanda.com, kernel-team@fb.com, 
	amir73il@gmail.com, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, 
	linux-xfs@vger.kernel.org, ceph-devel@vger.kernel.org, 
	linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

This was a stripped down version (no lockdep) in hopes of getting into
6.18. It also happens to come with some renames.

Given that the inclusion did not happen, I'm going to send a rebased
and updated with new names variant but with lockdep.

So the routines will be:
inode_state_read_once
inode_state_read

inode_state_set{,_raw}
inode_state_clear{,_raw}
inode_state_assign{,_raw}

Probably way later today or tomorrow.

On Mon, Sep 29, 2025 at 11:30=E2=80=AFAM Christian Brauner <brauner@kernel.=
org> wrote:
>
> On Tue, 23 Sep 2025 12:47:06 +0200, Mateusz Guzik wrote:
> > First commit message quoted verbatim with rationable + API:
> >
> > [quote]
> > Open-coded accesses prevent asserting they are done correctly. One
> > obvious aspect is locking, but significantly more can checked. For
> > example it can be detected when the code is clearing flags which are
> > already missing, or is setting flags when it is illegal (e.g., I_FREEIN=
G
> > when ->i_count > 0).
> >
> > [...]
>
> Applied to the vfs-6.19.inode branch of the vfs/vfs.git tree.
> Patches in the vfs-6.19.inode branch should appear in linux-next soon.
>
> Please report any outstanding bugs that were missed during review in a
> new review to the original patch series allowing us to drop it.
>
> It's encouraged to provide Acked-bys and Reviewed-bys even though the
> patch has now been applied. If possible patch trailers will be updated.
>
> Note that commit hashes shown below are subject to change due to rebase,
> trailer updates or similar. If in doubt, please check the listed branch.
>
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git
> branch: vfs-6.19.inode
>
> [1/4] fs: provide accessors for ->i_state
>       https://git.kernel.org/vfs/vfs/c/e9d1a9abd054
> [2/4] Convert the kernel to use ->i_state accessors
>       https://git.kernel.org/vfs/vfs/c/67d2f3e3d033
> [3/4] Manual conversion of ->i_state uses
>       https://git.kernel.org/vfs/vfs/c/b8173a2f1a0a
> [4/4] fs: make plain ->i_state access fail to compile
>       https://git.kernel.org/vfs/vfs/c/3c2b8d921da8
