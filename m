Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.remote-ip=209.85.208.42
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=fail;
	t=1793201780;
	b=H32e68daEHOKkors/2h4Ie+OVBOq//IT53BuG29JlutMmROFlRfiflumt0AX95J89vbT
	 z/EmDmUKWP6CA9aignmkNi2y8M/HdCMoVX+H3Vb8V4ung6n9VLyka0aPzQXR7c1gZ/HSp
	 wYbCZ2ZPHN12t6PharakGuj/Rfww4JybMkgyOmzevf9uneO7czRmrdwlyy51HX0iIUD8Y
	 fgL3PZ0nxJj8/NCgUAAqnzUbnOsYqcqRlc7U2zqkSMIw2ZYKaUk9opSMIq88UK6PLqPDc
	 0NcoiTARAnzZiD+hUmySl/lAIVooiCRQUFlg0n6yofzlpDtnyPXrzdXlFuVrPctfIVA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793201780;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=9Bz0lN3WwW56lrjEyeicNzFHRzWGZupLlnq02xtOwZE=;
	b=xzv6/AG7AA58Y5Q0JMwk+aIfQ286wDRn52uG5qUnnbscWbwEjV67FK3ycpoaCA9v52dE
	 Ou+90tIlax9HdrfHnnbHGAr7uLtaNyOyn0WHtHm/jxOC9Th3KcQUGgOFVaYhI3k3qTzCv
	 WSzPfbjnxQrGxF3+LLL3+TRyB7VauObftz7uNZ3ACOA9SV0SZBNdCjPKN6AJhcwLEsddH
	 pVDmWZxclrFTz3UYZrLp7pJJOwwlzWuFoiRFTkh0hnqKteeT/rPwaLAykQ4QF8L9VAMlT
	 ksKT/B/wuok/QFrockLHCq694ONkATDII60Hhs1nWZHnGByTJm0cK87b/8O2jD5tFpA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="o8+eS/kO";
	arc=fail smtp.remote-ip=209.85.208.42
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF45460A260C
	for <linux-xfs@vger.kernel.org>; Wed, 28 Oct 2026 15:36:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CF45460A260C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=o8+eS/kO
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-6b4a13789b0so990762a12.0
        for <linux-xfs@vger.kernel.org>; Wed, 28 Oct 2026 08:36:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793201778; cv=none;
        d=google.com; s=arc-20260327;
        b=Kd5dXrnGQb/nqpXuTS1MQthBdt6w5sfvMbVoVYOPQ5ynnOSycAMq849ti/dc3QVpXV
         CVy3uUW6xSp1lOE9ohNBYrTJfr3H4tdFXMv7OTDS01mERqm8VwbOs3FT5nw9K28qyZp1
         pa1CRwLZ0y/JLilnxR20GgcpsfaLaxzkAgIPDnP0Q1rEhZki8KuvUMYthXhF07iDbi/i
         WRBBjEZT1oGk8OUOFZx2fF+PXAHTA9ykxzulDg8wFHaJnOfJ4EZefh2NCn2C82/NP8M7
         nn8gu+ReIOI3epAE9R8Mz6NvSRf8EFFeTnCRazZxyENYdjTDD4XsIF4U9yDaBqyb545t
         7ODw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=9Bz0lN3WwW56lrjEyeicNzFHRzWGZupLlnq02xtOwZE=;
        fh=5AadcUzb/pi9dTvRv3D7Ks+w/7NYfg94Sx4oLZmHfqI=;
        b=rVndFZRSjY+7uK/SrZC6XsQMEIud32YH5lbfjh65E3MWkluO9rGKFiljHHH3ib6l7b
         EvgcfGGQt+0jYhGAhxLWssvGQDAj9LwE/FLxKU+u80ZmMv83rAaeNFDnPAW7Xsebp9Br
         4fzErdKl3GMqNBEeBvmAmQSdqIMQCP1w1t2QqnpqaEH07LQT4jzkpoovicUd/GG0I3PG
         KWF2tdTFxTlbUxGHInE0ZLoW2NoF1vQ3glHk3YlO/+AjELiSX07GVNEbe13nf+lwpt4U
         ckEH1uwqgEx30vob5l+voK9N/yN1lR0n0zdcumTngcxQLIJoVjIEagZ92+fh9K4bIdte
         mfKw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793201778; x=1793806578; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=9Bz0lN3WwW56lrjEyeicNzFHRzWGZupLlnq02xtOwZE=;
        b=o8+eS/kOJnmSQQuDmyzKcnpM8XIf62WHDcQTpfgGgAc33ST6Cpvb/Avm5gCEO3G83f
         mwT5WJaRXBMVxl81EO5AaJjNxHST8plT8azYXYCCF/zkFLzRRxL39DAnbyDEtc0izQ7z
         BXoAb+hBgpOG2MczfmPvBVDGk/iwK7R5wDwXpDgw00NJCrhcdpnLJlcQCfyX7fUAE/q3
         TuCIcIAJMA+UYbeKn4XOSAztm+6f2MAyPPJZPpKrZOIFxUTkZmyPclmqG21F1aEzhplB
         iTR/S6KCchmPfCqzmnzIC7zf+BT3HW7rmx33Rm1wtRiZPxIFwLBfca6G1MEP1JTTmXMW
         ehHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793201778; x=1793806578;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9Bz0lN3WwW56lrjEyeicNzFHRzWGZupLlnq02xtOwZE=;
        b=pKW50Rv3Eo2hXYr8kWM3IX4RDVNugLuiqc7yIisC4KvcoFJN7yBgijk6WpCzHOWw0m
         wMU5xoDAZ4xnWwW4GmEHuStIgwxmTEukCRhmamJq80RTCLu/ByNnQm7Rn8xORmfYKKUS
         WR05Yc6hZVBfBY9uEGJAbjV+v5GQpTJQ476WyXXjZLWr7rD8lMVbSzPiW+XdoHlge00B
         6lOlVtT6zi3BAV2pKG09XjISvxywpsAz3mPBHqukt0jXpuOYjvItXBFGM+xDCLED9kja
         ckKkmvEmciqW6IyM5une5Z1Et+pHLfHq8UV/7d6dRx6KHxGigp1l/WdrsWFLdvqNZqGJ
         1v7g==
X-Forwarded-Encrypted: i=1; AKwUvBwmvf2EYJG/F+pf1aINYjzUvNuyYhYJLiCQKUd3+kr+QU7Z5G8hJkAAVncJ2QmwTj+ULNfgN/vUi18=@vger.kernel.org
X-Gm-Message-State: AFq9FYIDZYoNtIL71Njfz9yymHgfBzWO/TNG0cMF4eAVY/edZ9JaG2eb
	rtKMCkmPSp2ON8Sd2p6Qo2G76+AQ3VesZhYBMitwdiZWX5B8e6XHZTOTud07P+dvUhYfLFmHsXb
	eE82banX2913/rFhakRvLE/pUW7iRPbs=
X-Gm-Gg: AYBFou0OuMdgEpg8+yDxmsSvoeux2/ycY3958A6xSAwl3znKjnN4tL9KCsU4agoyLeH
	Se3794VzFN9I75R8OPvvJvk56R6JD5Oi14fkf+9Coo9ZpBxNzYZZ8WhlM1BvL8nkLaoP5d/sDom
	Q1nsMn5SXjoRqpaODpnP9LgEFDm/14tiGKte9/zAOj7hvEIq0d3tqcAb6FEIRgBJn9seFZhnTdG
	N7zumbEM4IBgXlZLfBu855WVEUQwKB7BVFlzuQvN0QbFliYHnFgulnQgjXVwk2xG6ACwE9Yq4jO
	ZWe3q2Dw9dKp4zaoEjTonyh7pHFHiPW1SskONHB+2IsAjXqUJe6OcTZjvqKPs0U69OroytZJcGe
	gymGIviHpXE9VSOOLpO3bEfMP/9+76V8qqwkPDcniXJGXJqIvvqBt/sSiVYN3xfJd/kuFIg==
X-Received: by 2002:aa7:d955:0:b0:6b3:b0b2:6e7 with SMTP id
 4fb4d7f45d1cf-6b47bcde687mr3518808a12.18.1793201777944; Wed, 28 Oct 2026
 08:36:17 -0700 (PDT)
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261027-b4-ovl-containerized-sync-v1-0-802e512379a6@toxicpanda.com>
 <20261027-b4-ovl-containerized-sync-v1-1-802e512379a6@toxicpanda.com>
In-Reply-To: <20261027-b4-ovl-containerized-sync-v1-1-802e512379a6@toxicpanda.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 28 Oct 2026 17:36:06 +0200
X-Gm-Features: AclHuK-uy9OcEc2oh0_9o59ea-Px6xRmZClAxF9aj0taY8198qZo83-6yRUk1Js
Message-ID: <CAOQ4uxjNWagHSXM0q+3q-SwX1RRun746iSsfyoR-4fLjcqH16A@mail.gmail.com>
Subject: Re: [PATCH 01/10] fs: add SB_I_OVL_USE_SYNC_FS
To: Josef Bacik <josef@toxicpanda.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Christian Brauner <brauner@kernel.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, "Theodore Ts'o" <tytso@mit.edu>, 
	Carlos Maiolino <cem@kernel.org>, David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>, 
	Chengguang Xu <cgxu519@mykernel.net>, linux-unionfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, 
	linux-xfs@vger.kernel.org, linux-btrfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 27, 2026 at 11:09=E2=80=AFPM Josef Bacik <josef@toxicpanda.com>=
 wrote:
>
> sync_filesystem() writes every dirty inode of a filesystem and then calls
> ->sync_fs().  The data needs that.  Whether the metadata does depends on
> the filesystem.  ext2 copies an inode to its buffer in ->write_inode() an=
d
> nowhere else.  A filesystem which logs its metadata has recorded the
> change when it was made, and ->sync_fs() commits the log.
>
> overlayfs wants to sync what was changed through one overlay instead of
> the whole upper filesystem.  It knows which inodes it wrote data to.  It
> has a much harder time with all the inodes which the upper filesystem
> dirtied on its behalf, many of which it has no inode of its own for:
> whiteouts, index entries, work directories, the parents of all of them.
> With a filesystem which logs its metadata it doesn't have to know.
>
> Add SB_I_OVL_USE_SYNC_FS, by which a filesystem says that ->sync_fs() wit=
h
> wait set makes every change of metadata durable which was made before the
> call, whether ->write_inode() was called for the inode or not.  Timestamp=
s
> which lazytime holds back are not covered by that.  As an upper filesyste=
m
> of overlayfs it then gets ->sync_fs() instead of sync_filesystem().
>
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> ---
>  include/linux/fs/super_types.h | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/include/linux/fs/super_types.h b/include/linux/fs/super_type=
s.h
> index 72f4288e16c5..370b0d27815b 100644
> --- a/include/linux/fs/super_types.h
> +++ b/include/linux/fs/super_types.h
> @@ -359,5 +359,6 @@ struct super_block {
>  #define SB_I_NOIDMAP   0x00002000      /* No idmapped mounts on this sup=
erblock */
>  #define SB_I_ALLOW_HSM 0x00004000      /* Allow HSM events on this super=
block */
>  #define SB_I_NO_DATA_INTEGRITY 0x00008000 /* fs cannot guarantee data pe=
rsistence on sync */
> +#define SB_I_OVL_USE_SYNC_FS   0x00010000 /* overlayfs: ->sync_fs() comm=
its all metadata */
>


I have some reservations about the flag name (how could I not).
Not easy, but can we try the flag to describe the contract?

I am interested to know if the same flag or maybe even a more
strict contract which is fulfilled by ext4/xfs/btrfs could be
used to help determine ovl_should_sync_metadata() -

In commit 7d6899fb69d25 ("ovl: fsync after metadata copy-up")
we added fsync on parent directories and metadata after copy up
to fix correctness on ubifs.

In commit 1f6ee9be92f8d ("ovl: make fsync after metadata copy-up
opt-in mount option") fsync=3Dstrict was created for opting-in to fsync
parent dirs on copy up, after a report on regression over ext4 when
due to the unconditional metadata fsync.

I am wondering whether fsync=3Dauto could decide regarding fsync of
metadata on copy up depending on the flag, so metadata would be
fsynced on ubifs and not fsynced on ext4.

The problem is that your flag speaks of the metadata ordering contract
of sync_fs(sb) and my interest is the metadata ordering contract of
fsync(inode).

To be more specific, in this sequence:
mkdir t1
chmod 700 t1
mv t1 A
mkdir t2
chmod 700 t2
mv t2 A/B
touch t3
chmod 600 t3
sync -d t3
mv t3 A/B/foo

When A/B/foo is observed after a crash, in xfs I know that because
all metadata writes are serialized in the single transaction, the mode
of parents is correct.

Not sure about btrfs and ext4 fast commit.

If you think that the answer is that they provide the same guaranty
then if the flag could be named something like
SB_I_ORDERED_METADATA or something and
the contract is documented, then perhaps it also fits the
sync_fs case, because what you really want to know is that
sync_fs persistent the metadata that the inode depends on.

Am I talking nonsense?

Thanks,
Amir.
