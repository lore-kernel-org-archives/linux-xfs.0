Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.224.46
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793493223;
	b=LAAppq3DDFyBpWC8oukbS7ApzQKS9twwJYwWBBAGVjWYB3p5xuPumwXpdfYR0PUb3fWj
	 bM3/9m75qEZfLU77MAsqx0Q+pEbofW8u+KvO51rzvznaZdHfqqxZaIKhuxypJCivvAWcr
	 J/4T82XXVhNT47dXvoA1EYPOW74rflCUbvAY/USKoUQMyeMPCX4bQfS7iHWJI3PqP77vx
	 Kzl0pA62lmWNb8JP+odga+gXFY/AnCJxdMBiSFptlDGLXIn/VluTD6LenYg7N2SW6HuEG
	 xMDMWJfyTy8j2oUo0eRQMztooiKeVvUkjks31VGRNRH1BZ16Zb6LAcdHGn9CEdyxyPg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793493223;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:Autocrypt:
	 Content-Type:Content-Transfer-Encoding:User-Agent:MIME-Version;
	bh=/OyNuE+u9LVqbLjPn4c642Wjld5y0QKeGGJuFQ0QfKY=;
	b=jP4NVtt4aYDlMlhhASFV2Z9jw12rsok8Ijmm90bM6pbrSyCCRooxMN/gXSQ6RP8U33ut
	 MUbx3rmZV/jEXpO+IBqVqDFcvSXBTgBJYv5nXgp+LaeL6EWNHLgfIWmQckjUzToaSW/Np
	 NNNIciJnU46C+NEY1JDkS2zl8GCzOxWFghBT6s39LLqReqHHVYvQi/HDcsNjXvJOQNOY9
	 smwLgh0k0EW39v5LsekiBv5gBCYemxxaRMqKl3NIBeQdbWIIhifsgMmhhLavxib/kZLLl
	 Kb8jb3Fq60mZIUVFZEaTGl30DDrNyT/Q7GWuR9Oi+7ioZOPYAs8wkmDeXsojNo+jEqA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=dubeyko.com;
	spf=pass smtp.mailfrom=dubeyko.com;
	dkim=pass header.d=dubeyko-com.20260707.gappssmtp.com header.i=@dubeyko-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=opKOv9+L;
	arc=none smtp.remote-ip=74.125.224.46
Received: from mail-yx1-f46.google.com (mail-yx1-f46.google.com [74.125.224.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC083606A320
	for <linux-xfs@vger.kernel.org>; Sun,  1 Nov 2026 00:33:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DC083606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dubeyko.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=dubeyko-com.20260707.gappssmtp.com header.i=@dubeyko-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=opKOv9+L
Received: by mail-yx1-f46.google.com with SMTP id 956f58d0204a3-679334baa1fso1994582d50.2
        for <linux-xfs@vger.kernel.org>; Sat, 31 Oct 2026 17:33:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dubeyko-com.20260707.gappssmtp.com; s=20260707; t=1793493221; x=1794098021; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :autocrypt:references:in-reply-to:date:cc:to:from:subject:message-id
         :from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=/OyNuE+u9LVqbLjPn4c642Wjld5y0QKeGGJuFQ0QfKY=;
        b=opKOv9+LvbvKOcsG7sEdWgW5RTy7kU6wUMYBGioVfgkQyIsS6X9+fly6DW0lh7MWmZ
         ADiBPMwopgDRliRbwbHjbfCkdevfkCAynrIpVoBW6iiAOr3rGvXAwIGA/DSi56T0vblu
         Gjg2U4eBG8LdQEXYLZ7qi60tOfNA0+pQ7N6ygLuxQG+lIgm88X+Emoi5nm9Pbaem/j76
         jkuNsmvU/V6VV1vnXToctK/8CAuMJZn01/QxEtPRFnFcVBKrtW5UUxqJ+1C3DlBlxZeW
         +ODdnrfH/Kfr0AOh7QbaNuH+k1NTTYkBG/IliHraQ9l1BkSNdeBEsxD3N5gJRd6v8Nrx
         0egw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793493221; x=1794098021;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :autocrypt:references:in-reply-to:date:cc:to:from:subject:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=/OyNuE+u9LVqbLjPn4c642Wjld5y0QKeGGJuFQ0QfKY=;
        b=EJGGc6n6HHpe13A+Be9y74xlTS9Aghnqc9miT1p41KrLiKw2ckTO7GadZhI4Bb61GZ
         +P3O5xF1G1kbV9TcHJXOJYqYZc4JG1g/T7PZM+7WL9HOW4TQiZ9N+nTItBu1QVqJS7K7
         nIMwgiqo7GGxLlgtb7noppkxHuLGNhNeKGzQSqQLaA9pFwOJdxzK55OsWATMIxIr7Al+
         dv4oOFCvMf3SKiv2DzNWJfauBaiD33ABF2CeveLC35H/kZcdjo8lMC9PXlFmHRvxa9rg
         IMuXexvFLIcjTQE57FC6FyDHrUTlp++qd9t1aC9Ecsy9DjCad51pmjuSFGwTG6+J1SLr
         FFPw==
X-Forwarded-Encrypted: i=1; AKwUvBz2gCPi7ozez98mahdxPXaiPqDtktfjBTQhEnLlFI1L47iBOf28FRUDEiCynkg11/rspDcE1PVpvA4=@vger.kernel.org
X-Gm-Message-State: APuU4Z9AKm2wnKY4XA7cYs08ymsMuR93pu0hmotule8mfK9kSGFsQtGo
	SyOC5U7eCRSYu2CZ6NgqJ5YrTlhZBh5OAcaZ7WEUDkuWfRQzO1RA/p8t6X2kNmye/MQ=
X-Gm-Gg: AYBFou0X3F8eNHceZV6L8lX8YgMW3RDJtAdljAC5q9PDBVqrXV2VaD1XtAg8krR/+Ky
	RZ/da5zwFlnLBZXFv5/BSwZKgJc3ptBBxEaY8DwMYz3TdZ3g6nvpCYuvGnxuOyxM5Esjin9wGSJ
	a6htehuhNCab/1wPEkuvlobScfg/+E4QeN8hwBJInF3LhKPlwDOu6fjIe1PnKZDb837sO9EiB/o
	ux/dFXERidnI7ooK22483dfsw3Trp/7CxX+GkZbaw9niJmhEJuzhNHb2Xh/MGI3DQt3n0Jl9fyD
	an18l6af5MLsRBywVglg3TxqXQDNDkbjvFiKy0vhrpS5UtXcRtlsNLPuGYZ4p2/R0WcQgcy7sU3
	KGxRK5VOcDQN9q1l6WUJ22lx2x9/hp3gwCebBZfTXnY8K/obOLeh23+EfB5hnz5uetaSOLwiA1Y
	seZkUhUOajxuzkf4oabxJy14mjkPKVelZhZZ/DWP1/Ws3HbwaeexI3GJD+r6uLPqJYdZN1ede75
	JSAL2DWRia+vZA2l7vqiszcqy49jPtBZIgea3inCRCKFHp8iJt0HzzMh35AsLd2VIX7h/aFrDOR
	uRBKfLm3Z/WPWJ5XITXdYyEXaoWhaXAKenicDPYLLWMWad2woCffsmCyOAqjTCaph8ZthRq0q7B
	NZ7fhMSoesjToNeiMUxu8TMQ5n/h95K0SUQDkyrNxUvEaAYAOTSQwyneGm0rWNCkVBprJLXXY+g
	F3txDiwaayqpAFxYhcDJY=
X-Received: by 2002:a05:690e:140e:b0:675:3d40:3c34 with SMTP id 956f58d0204a3-67bb3041657mr1552875d50.68.1793493220725;
        Sat, 31 Oct 2026 17:33:40 -0700 (PDT)
Received: from ?IPv6:2600:1700:6476:1430:6f84:fe3e:51d2:f3cd? ([2600:1700:6476:1430:6f84:fe3e:51d2:f3cd])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8b2b7198c65sm28593177b3.36.2026.10.31.17.33.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 31 Oct 2026 17:33:39 -0700 (PDT)
Message-ID: <39d08fa0b0e45c61dbb4f57ccc911d1235ff9b5f.camel@dubeyko.com>
Subject: Re: [PATCH v2 13/34] hfsplus: don't set SB_RDONLY when creating the
 attributes tree
From: Viacheslav Dubeyko <slava@dubeyko.com>
To: Christian Brauner <brauner@kernel.org>, linux-fsdevel@vger.kernel.org, 
 Jan Kara <jack@suse.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, ecryptfs@vger.kernel.org, 
	linux-ext4@vger.kernel.org, jfs-discussion@lists.sourceforge.net, 
	linux-nilfs@vger.kernel.org, exfat@lists.linux.dev, linux-mm@kvack.org, 
	ntfs@lists.linux.dev, ocfs2-devel@lists.linux.dev,
 linux-btrfs@vger.kernel.org, 	gfs2@lists.linux.dev,
 linux-efi@vger.kernel.org, linux-mtd@lists.infradead.org, 
	linux-xfs@vger.kernel.org
Date: Sat, 31 Oct 2026 17:33:37 -0700
In-Reply-To: <20261029-work-fs-sb_rdonly-v2-13-2f44f64f0b66@kernel.org>
References: <20261029-work-fs-sb_rdonly-v2-0-2f44f64f0b66@kernel.org>
	 <20261029-work-fs-sb_rdonly-v2-13-2f44f64f0b66@kernel.org>
Autocrypt: addr=slava@dubeyko.com; prefer-encrypt=mutual;
 keydata=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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.1 (by Flathub.org) 
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

On Thu, 2026-10-29 at 17:07 +0100, Christian Brauner wrote:
> hfs_btree_open() sets SB_RDONLY when the map record of a b-tree
> doesn't
> mark the header node as used. That's fine while mounting. But
> hfsplus_create_attributes_file() calls it too when the first extended
> attribute is set on a filesystem that has no attributes file yet.
> That
> runs on the live filesystem without s_umount and a filesystem must
> not
> change SB_RDONLY behind the VFS' back.
>=20
> hfsplus_create_attributes_file() opens a tree it has just created
> itself
> with the header node marked as used, so there's nothing to check
> there.
> Move the check into hfsplus_fill_super() and do it for every tree it
> opens. No functional changes.
>=20
> Suggested-by: Viacheslav Dubeyko <slava@dubeyko.com>
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
> ---
> =C2=A0fs/hfsplus/btree.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 42 +++++++++++++=
+++++++++++++++-----------
> ---
> =C2=A0fs/hfsplus/hfsplus_fs.h |=C2=A0 1 +
> =C2=A0fs/hfsplus/super.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 5 +++++
> =C2=A03 files changed, 34 insertions(+), 14 deletions(-)
>=20
> diff --git a/fs/hfsplus/btree.c b/fs/hfsplus/btree.c
> index bd4dbdbc8f98..4a67569050e3 100644
> --- a/fs/hfsplus/btree.c
> +++ b/fs/hfsplus/btree.c
> @@ -270,7 +270,6 @@ struct hfs_btree *hfs_btree_open(struct
> super_block *sb, u32 id)
> =C2=A0	struct hfs_btree *tree;
> =C2=A0	struct hfs_btree_header_rec *head;
> =C2=A0	struct address_space *mapping;
> -	struct hfs_bnode *node;
> =C2=A0	struct inode *inode;
> =C2=A0	struct page *page;
> =C2=A0	unsigned int size;
> @@ -381,19 +380,6 @@ struct hfs_btree *hfs_btree_open(struct
> super_block *sb, u32 id)
> =C2=A0	kunmap_local(head);
> =C2=A0	put_page(page);
> =C2=A0
> -	node =3D hfs_bnode_find(tree, HFSPLUS_TREE_HEAD);
> -	if (IS_ERR(node))
> -		goto free_inode;
> -
> -	if (!hfs_bmap_test_bit(node, 0)) {
> -		pr_warn("(%s): %s (cnid 0x%x) map record invalid or
> bitmap corruption detected, forcing read-only.\n",
> -				sb->s_id, hfs_btree_name(id), id);
> -		pr_warn("Run fsck.hfsplus to repair.\n");
> -		sb->s_flags |=3D SB_RDONLY;
> -	}
> -
> -	hfs_bnode_put(node);
> -
> =C2=A0	return tree;
> =C2=A0
> =C2=A0 fail_page:
> @@ -407,6 +393,34 @@ struct hfs_btree *hfs_btree_open(struct
> super_block *sb, u32 id)
> =C2=A0	return NULL;
> =C2=A0}
> =C2=A0
> +/*
> + * Check the map record of a b-tree at mount. hfs_btree_open() can't
> do it
> + * because hfsplus_create_attributes_file() calls it on the live
> filesystem
> + * where SB_RDONLY must not be set.
> + */
> +int hfsplus_btree_check_map(struct hfs_btree *tree)
> +{
> +	struct super_block *sb =3D tree->sb;
> +	struct hfs_bnode *node;
> +
> +	node =3D hfs_bnode_find(tree, HFSPLUS_TREE_HEAD);
> +	if (IS_ERR(node)) {
> +		pr_err("failed to load %s header node\n",
> +		=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 hfs_btree_name(tree->cnid));
> +		return PTR_ERR(node);
> +	}
> +
> +	if (!hfs_bmap_test_bit(node, 0)) {
> +		pr_warn("(%s): %s (cnid 0x%x) map record invalid or
> bitmap corruption detected, forcing read-only.\n",
> +				sb->s_id, hfs_btree_name(tree-
> >cnid), tree->cnid);
> +		pr_warn("Run fsck.hfsplus to repair.\n");
> +		sb->s_flags |=3D SB_RDONLY;
> +	}
> +
> +	hfs_bnode_put(node);
> +	return 0;
> +}
> +
> =C2=A0/* Release resources used by a btree */
> =C2=A0void hfs_btree_close(struct hfs_btree *tree)
> =C2=A0{
> diff --git a/fs/hfsplus/hfsplus_fs.h b/fs/hfsplus/hfsplus_fs.h
> index 6f240f87f8ff..58c780b09b6f 100644
> --- a/fs/hfsplus/hfsplus_fs.h
> +++ b/fs/hfsplus/hfsplus_fs.h
> @@ -362,6 +362,7 @@ int hfsplus_block_free(struct super_block *sb,
> u32 offset, u32 count);
> =C2=A0u32 hfsplus_calc_btree_clump_size(u32 block_size, u32 node_size, u6=
4
> sectors,
> =C2=A0				=C2=A0 int file_id);
> =C2=A0struct hfs_btree *hfs_btree_open(struct super_block *sb, u32 id);
> +int hfsplus_btree_check_map(struct hfs_btree *tree);
> =C2=A0void hfs_btree_close(struct hfs_btree *tree);
> =C2=A0int hfs_btree_write(struct hfs_btree *tree);
> =C2=A0int hfs_bmap_reserve(struct hfs_btree *tree, u32 rsvd_nodes);
> diff --git a/fs/hfsplus/super.c b/fs/hfsplus/super.c
> index ff7d6b3336a6..532f23502df3 100644
> --- a/fs/hfsplus/super.c
> +++ b/fs/hfsplus/super.c
> @@ -564,6 +564,11 @@ static int hfsplus_fill_super(struct super_block
> *sb, struct fs_context *fc)
> =C2=A0	}
> =C2=A0	sb->s_xattr =3D hfsplus_xattr_handlers;
> =C2=A0
> +	if (hfsplus_btree_check_map(sbi->ext_tree) ||
> +	=C2=A0=C2=A0=C2=A0 hfsplus_btree_check_map(sbi->cat_tree) ||
> +	=C2=A0=C2=A0=C2=A0 (sbi->attr_tree && hfsplus_btree_check_map(sbi-
> >attr_tree)))
> +		goto out_close_attr_tree;
> +
> =C2=A0	inode =3D hfsplus_iget(sb, HFSPLUS_ALLOC_CNID);
> =C2=A0	if (IS_ERR(inode)) {
> =C2=A0		pr_err("failed to load allocation file\n");


Looks good.

Reviewed-by: Viacheslav Dubeyko <slava@dubeyko.com>

Thanks,
Slava.
