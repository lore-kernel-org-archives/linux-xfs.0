Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 364C83C38
	for <linux-xfs@vger.kernel.org>; Thu, 15 Jan 2026 19:31:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768505524; cv=none; b=UrqVPisNG9LMGX+mM4/wFpF0utBn3A6E/PJ8+LWn1uHR3Dm6QzD8TS/2ZB2pKlw8xUb8oghgWp007yJTBhuQU7gYKKyJrhoOwsh8DIe/oU0J47aZrsp1p1Vv/QTD5CrR7zHGSbcx1yqB3CMwrArPlKWNIosb5GwwdKXQuI/Vn3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768505524; c=relaxed/simple;
	bh=tqmyKUNA9h+Z6aJY257mLy9/4rE73XX9k8TNa9s5T1I=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=c3iU7miHyCmDzjbm9kM4TL+jB0QWbeeeabPHvYOMDxxabVJEv2okb4ZNupe8j/E8crG3re6MQnYoTP2O3bBiSNBonJl4bDGCBX00QJKiTA9Fiey/DBrx5LEYq6R3/wDyYgYpECcAR7zbD/Vdmotjq0W2FID84uXEyoEXL6ZP9Jo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AxVt9NlZ; arc=none smtp.client-ip=209.85.208.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AxVt9NlZ"
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-64d4d8b3ad7so2029978a12.2
        for <linux-xfs@vger.kernel.org>; Thu, 15 Jan 2026 11:31:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768505512; x=1769110312; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JqDSb07Y8F9mJCkqUS0QQHnJ5q+4REJWbBlGem8BlhI=;
        b=AxVt9NlZsrEO90brpzVSG+plzsyQ/V5F7wbftBoX4Pz9aHeMCSwAnNz6M1G66/Fxbr
         ZeWBoW2tPtEREPv9Zv7Cd8WAdychR+ePKuLj1hncUtSRnPBFLGSj8dHFKB6aWTZL6TyV
         h2KmXboypZRDZ7t/d+97nOjq3zLvLLxleitUbPm7o5PWSQ9TfDmvXNqxfwpE12w2eYRL
         yP3/vF/mBt+opII8CtduDHb18q35+PS+fbCeqz175cgEUQH5OD9x8pfAic1awGuIeBK6
         LrVAzDF2YXnvXyuv0ApKt4l+8679vUGQfMq5KDT2mr81XHzqFb5aMX0yv6J/am6TNFtR
         yoeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768505512; x=1769110312;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=JqDSb07Y8F9mJCkqUS0QQHnJ5q+4REJWbBlGem8BlhI=;
        b=i9zwpDl6HHfU0HQYsmM0knG/9XywmbA6RSYoKz5a3mM6y+W9TAhAyjcNX4YX1EWdFS
         lsTT1p/npniM7nRpaaq8cVbvz/2LTjt/CQade1ryIgu6V9iZL/GkqPsystI+85odvSFQ
         4xAs0/cVP/Mg5evh04ndW1CNdL+wZxXdDVes72EGXLhuaG4HWP287CgIGskGGPQC+ISi
         yQ+bN/43cnJzbxaMyDmVFgZV1lM3+tbvyS6U14Bine2erxglmmHBxeIofZWRrxoSMdPt
         YOZEEtbdCYYUQdDU1A1czyhKeBYPQ6WXWPo86X8pJfW0DapqD/A90tRhlw/6+hV3Twzy
         hylA==
X-Forwarded-Encrypted: i=1; AJvYcCWTYumVvfxYP2xXBNxR3kQPy0YCZcbhHyitgUPTlYrE39CSv9iSJF8j0mE+3B0FlJOLOjCTWO5V/ts=@vger.kernel.org
X-Gm-Message-State: AOJu0YwflGopWCRiKo4/TRr6duz6ns4FTXC3hlmFjTPiCte4jyYJQ/M2
	QUrF2ro8sPEpQ++5Y4MzM/6TT7GP/m2NiLKA5hRYcb6zzxJIlI4Al7+HdzZhp1j8+ZHASK8dTpv
	IjNfUsUhbziDxAwwMubcSMLSY829aNkk=
X-Gm-Gg: AY/fxX4kDEBxiDjX0lzte9vcYasrOHba8Fw1CE1ddTbQbtIfKULg8PpHfKGPvLgmGAG
	3Im1OkXWdgiAm4+luepBfCaqJ6Dotxg1c8KNXk+hN/qGrN9JaLfHPlmBN2TPi8EkCtWjgUnl1iD
	gz5MLT7Nut9pIY+q3BAVUbXkmBQSxQyUFqNzaXHiCKgzFQEG6UWfE1V6+nIDs0QkG4j+sVlblya
	ylPr9ozsPKi8g8EJClUN4ZDcRlJEbu+NPReNvUM+PjCnLRc4zBvYeOhm29Y/RslpYIn/JMDubIj
	1slcKc07h8tzgGty1JeDYsoVEWpy6w==
X-Received: by 2002:a17:907:3c87:b0:b87:442:e9b6 with SMTP id
 a640c23a62f3a-b879690c54amr11543766b.17.1768505511676; Thu, 15 Jan 2026
 11:31:51 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260115-exportfs-nfsd-v1-0-8e80160e3c0c@kernel.org>
 <CAOQ4uxjOJMwv_hRVTn3tJHDLMQHbeaCGsdLupiZYcwm7M2rm3g@mail.gmail.com>
 <d486fdb8-686c-4426-9fac-49b7dbc28765@app.fastmail.com> <CAOQ4uxhnoTC6KBmRVx2xhvTXYg1hRkCJWrq2eoBQGHKC3sv3Hw@mail.gmail.com>
In-Reply-To: <CAOQ4uxhnoTC6KBmRVx2xhvTXYg1hRkCJWrq2eoBQGHKC3sv3Hw@mail.gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 15 Jan 2026 20:31:40 +0100
X-Gm-Features: AZwV_QhvHAFd_rX2K5lnQvHY5zGWrCY2L2ECA3-jgjFMNT8gFVUBrqM9bcPeRhY
Message-ID: <CAOQ4uxhnSPoqwws7XW4JU=jjgZJoFgCjcWwbfPaprDCZq=wnKQ@mail.gmail.com>
Subject: Re: [PATCH 00/29] fs: require filesystems to explicitly opt-in to
 nfsd export support
To: Chuck Lever <cel@kernel.org>
Cc: Jeff Layton <jlayton@kernel.org>, Christian Brauner <brauner@kernel.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Chuck Lever <chuck.lever@oracle.com>, 
	NeilBrown <neil@brown.name>, Olga Kornievskaia <okorniev@redhat.com>, Dai Ngo <Dai.Ngo@oracle.com>, 
	Tom Talpey <tom@talpey.com>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Theodore Tso <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.com>, 
	Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>, Yue Hu <zbestahu@gmail.com>, 
	Jeffle Xu <jefflexu@linux.alibaba.com>, Sandeep Dhavale <dhavale@google.com>, 
	Hongbo Li <lihongbo22@huawei.com>, Chunhai Guo <guochunhai@vivo.com>, 
	Carlos Maiolino <cem@kernel.org>, Ilya Dryomov <idryomov@gmail.com>, Alex Markuze <amarkuze@redhat.com>, 
	Viacheslav Dubeyko <slava@dubeyko.com>, Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>, 
	Luis de Bethencourt <luisbg@kernel.org>, Salah Triki <salah.triki@gmail.com>, 
	Phillip Lougher <phillip@squashfs.org.uk>, Steve French <sfrench@samba.org>, 
	Paulo Alcantara <pc@manguebit.org>, Ronnie Sahlberg <ronniesahlberg@gmail.com>, 
	Shyam Prasad N <sprasad@microsoft.com>, Bharath SM <bharathsm@microsoft.com>, 
	Miklos Szeredi <miklos@szeredi.hu>, Mike Marshall <hubcap@omnibond.com>, 
	Martin Brandenburg <martin@omnibond.com>, Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, 
	Joseph Qi <joseph.qi@linux.alibaba.com>, 
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, 
	Ryusuke Konishi <konishi.ryusuke@gmail.com>, Trond Myklebust <trondmy@kernel.org>, 
	Anna Schumaker <anna@kernel.org>, Dave Kleikamp <shaggy@kernel.org>, 
	David Woodhouse <dwmw2@infradead.org>, Richard Weinberger <richard@nod.at>, Jan Kara <jack@suse.cz>, 
	Andreas Gruenbacher <agruenba@redhat.com>, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, 
	Jaegeuk Kim <jaegeuk@kernel.org>, Christoph Hellwig <hch@infradead.org>, linux-nfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, linux-ext4@vger.kernel.org, linux-erofs@lists.ozlabs.org, 
	linux-xfs@vger.kernel.org, ceph-devel@vger.kernel.org, 
	linux-btrfs@vger.kernel.org, linux-cifs@vger.kernel.org, 
	samba-technical@lists.samba.org, linux-unionfs@vger.kernel.org, 
	devel@lists.orangefs.org, ocfs2-devel@lists.linux.dev, ntfs3@lists.linux.dev, 
	linux-nilfs@vger.kernel.org, jfs-discussion@lists.sourceforge.net, 
	linux-mtd@lists.infradead.org, gfs2@lists.linux.dev, 
	linux-f2fs-devel@lists.sourceforge.net
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 15, 2026 at 8:14=E2=80=AFPM Amir Goldstein <amir73il@gmail.com>=
 wrote:
>
> On Thu, Jan 15, 2026 at 7:32=E2=80=AFPM Chuck Lever <cel@kernel.org> wrot=
e:
> >
> >
> >
> > On Thu, Jan 15, 2026, at 1:17 PM, Amir Goldstein wrote:
> > > On Thu, Jan 15, 2026 at 6:48=E2=80=AFPM Jeff Layton <jlayton@kernel.o=
rg> wrote:
> > >>
> > >> In recent years, a number of filesystems that can't present stable
> > >> filehandles have grown struct export_operations. They've mostly done
> > >> this for local use-cases (enabling open_by_handle_at() and the like)=
.
> > >> Unfortunately, having export_operations is generally sufficient to m=
ake
> > >> a filesystem be considered exportable via nfsd, but that requires th=
at
> > >> the server present stable filehandles.
> > >
> > > Where does the term "stable file handles" come from? and what does it=
 mean?
> > > Why not "persistent handles", which is described in NFS and SMB specs=
?
> > >
> > > Not to mention that EXPORT_OP_PERSISTENT_HANDLES was Acked
> > > by both Christoph and Christian:
> > >
> > > https://lore.kernel.org/linux-fsdevel/20260115-rundgang-leihgabe-1201=
8e93c00c@brauner/
> > >
> > > Am I missing anything?
> >
> > PERSISTENT generally implies that the file handle is saved on
> > persistent storage. This is not true of tmpfs.
>
> That's one way of interpreting "persistent".
> Another way is "continuing to exist or occur over a prolonged period."
> which works well for tmpfs that is mounted for a long time.
>
> But I am confused, because I went looking for where Jeff said that
> you suggested stable file handles and this is what I found that you wrote=
:
>
> "tmpfs filehandles align quite well with the traditional definition
>  of persistent filehandles. tmpfs filehandles live as long as tmpfs files=
 do,
>  and that is all that is required to be considered "persistent".
>
> >
> > The use of "stable" means that the file handle is stable for
> > the life of the file. This /is/ true of tmpfs.
>
> I can live with STABLE_HANDLES I don't mind as much,
> I understand what it means, but the definition above is invented,
> whereas the term persistent handles is well known and well defined.
>

And also forgot to mention - STABLE HANDLES is very lexicographically
close to STALE HANDLES :-/

Thanks,
Amir.
