Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11665140E5F
	for <linux-xfs@vger.kernel.org>; Mon, 23 Mar 2026 03:01:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774234899; cv=none; b=HY85jEhPuoH+Oo1bbNC/XihkiH6I6LfvIiiFreOKhDlHyy08jpmc0tchn/V4KO6/A8vm1WlEPHzqME/j1pGcMqg2fMoEBwfveUHSExlmIsmhNCV3TcCaujSwXVV6uPPlOQrD2ubZmqC4B/sVoVzserwi+1wLC9xOUsoN6zh5jUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774234899; c=relaxed/simple;
	bh=kMPbl2Dxy9QAwmi2DAzeHK7NgmEeElirTgKVHhB+j4Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=GNpYfPK/5Zo4prJkMWo4YRgubWMjCWQgqo8icvmRIcTy2ywUo77Qh7T9gH6aBbhE5wzNcZo5dcvcbracPItPK64t0kDZSAz3EAVolKFLng744MeZODUoE+aFcM7ZPieEXcffrRrJy7GqTEmeOqNonjF7fvfHNIhWZ+/8RpbZmdo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Rg/LLIeS; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=dQm3RKy0; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Rg/LLIeS";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="dQm3RKy0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774234897;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5Oy6gTA/oMYuKJcGhA/xtv3SWmyfDUciochQKNFImkM=;
	b=Rg/LLIeS7B/EgtqxDq/y/6O8OcS9kbr3DF/mXGuwRysNgLh5yl/6difaOIakANLeSbLdeJ
	2c32CvT4aTbvU33Vqj/ucbCqFL7q3R9qBbjUM260YcmbT5mZtwXNFv3lgBNhuWlh/zMiDN
	tdaKOtuIruVHDg3t8LyPW25H+KuiXAU=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-128-4zOTY85FNUaluXjk7z5fdg-1; Sun, 22 Mar 2026 23:01:35 -0400
X-MC-Unique: 4zOTY85FNUaluXjk7z5fdg-1
X-Mimecast-MFC-AGG-ID: 4zOTY85FNUaluXjk7z5fdg_1774234895
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2b05370ec01so256344735ad.1
        for <linux-xfs@vger.kernel.org>; Sun, 22 Mar 2026 20:01:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1774234894; x=1774839694; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=5Oy6gTA/oMYuKJcGhA/xtv3SWmyfDUciochQKNFImkM=;
        b=dQm3RKy0cn4S1d2Mby0HiWIorW5uCLkTXKWmOatxvTLGUk0BATqW9GB3Gx6uqo9HiE
         HL28sKEqunBDI0mlKh1QGXqB0Bd9oKaDWRTwhAtDsoI5WNjbZfNKv6Jw+9wLTNIP8nWB
         e63dRatHxsdaymGtu81Vpv9/3aHQ8x7B9gW25ABYF2K7sAcu/okgF5uTcSc9X2+divl9
         PEYOWUVjP+WWUwGpk5zh5lGoX+WOhvtqjMSAGtpze5DimG1NVfqhrAS/YTuRwsKCftLJ
         iaKl1Yt2qST95MQf6VeTBzriQAfSiHKcNBCR3J+WxLGUBvLd8h9V8aKx403NyHhFB2Py
         7BEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774234894; x=1774839694;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5Oy6gTA/oMYuKJcGhA/xtv3SWmyfDUciochQKNFImkM=;
        b=eFCko1y5+jvncx8UR6UG1jS84GFHYHH3/lPaUYRFpgFsT4ZF4gt/94+PB1dD8BgFmp
         IwoF+1SgYwdXBk42FjZ7PMNCvANNrpVlC9nYiRhCTq3OmCdMS7OULn+Zl8EjSD51A1JG
         BXIP8wCRjwd0LoQeK605yubk706Nw2bySlLSfNumMd5hUTzZHL53iLRDkbo5XSDopeQj
         +gB9LJ2Zc1yjej3UWCnIxsD1B7mgseVhCrQ4YjBjvVHdk/8COyUT50qTY8aE/OtK9VNP
         LLca6HLQi4W2fHVw9dAqbWDIwUx48lskJx45E5QQNhXPjao/jujm97xwtP6oW9nlw+Mr
         Ztgg==
X-Gm-Message-State: AOJu0YzscQSY8+uETmmdNZ2z0Wgypik/XrGLW1twgXzFy4TuX3i2DwUM
	G9fuDtE0yDYbNF+4Vg86nJCekkwsvhftEinC5Ef2ZhEa8zbOrfOGTAV2lrXzkZzVxQmbCoA6u2b
	Z2nEHDG48HTXvgd0UdLqnwQvemNKkkX7TVxsknDHQ5PijWNvyd7t5RawIe+Pj6VHx7axdKab3uk
	4Ks/CfcNwCyFW+YKFwp48F3qzFaj5OPXGuUW8yK4kFDmwiOg==
X-Gm-Gg: ATEYQzwxMvUPiK6iET9SfNYXwi+GUtJH7Eq0UluFdC9nLfN2GCvUiv7nc8P8EilwxPK
	gAJy7ktwe3svySh1ht8V4IYAaWEsrxEdIZ1PDiXDT7VA69KWTBULTjwgw48w/iNe/s8bWdqhAQV
	iw9SdwaU2l7uF3n3GNT5Y+gFRzwYLoQ1w2LPM69WZSHxwg1MnohjEGxy7c7IRFhfAC43BrIwtLz
	vCWW5MU1bi4B/hQvQnBHz+7wW8d+t+YJpUE7IRsMAh4+RjtneYnPKz4qMoD6xUFo7srfpFyt5Nj
	V4J4vV8kZE2iwnS4pDHglyhiev1d1KR7x7xLvmgbmg9Sq7jqqOx32h7pB0R7N6IC8y4xwnUL+1e
	EPij53FpoFN1DTt4YiY19Yx526XQVfH3gN81cp75fnHDH/Tq4feJErx0agbhw3avIQ5t8bNg=
X-Received: by 2002:a17:902:e943:b0:2ae:80bc:9bfb with SMTP id d9443c01a7336-2b0827bc880mr99125145ad.40.1774234894398;
        Sun, 22 Mar 2026 20:01:34 -0700 (PDT)
X-Received: by 2002:a17:902:e943:b0:2ae:80bc:9bfb with SMTP id d9443c01a7336-2b0827bc880mr99124865ad.40.1774234893807;
        Sun, 22 Mar 2026 20:01:33 -0700 (PDT)
Received: from ?IPV6:2001:8003:4a36:e700:56b6:ee78:9da2:b58f? ([2001:8003:4a36:e700:56b6:ee78:9da2:b58f])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b0836a3066sm90777125ad.75.2026.03.22.20.01.31
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 22 Mar 2026 20:01:33 -0700 (PDT)
Message-ID: <8cd00eed-58d1-4c34-8892-fff34504c2e1@redhat.com>
Date: Mon, 23 Mar 2026 14:01:29 +1100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/5] xfsrestore: remove failing assert from
 noref_elim_recurse
To: linux-xfs@vger.kernel.org
References: <20260224071712.1014075-1-ddouwsma@redhat.com>
 <20260224071712.1014075-5-ddouwsma@redhat.com>
Content-Language: en-US, en-AU
From: Donald Douwsma <ddouwsma@redhat.com>
In-Reply-To: <20260224071712.1014075-5-ddouwsma@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 24/2/26 18:17, Donald Douwsma wrote:
> We are getting reports from the field where cumulative restores are
> aborting due due to a failing assertion.
> 
>   xfsrestore: tree.c:1421: noref_elim_recurse: Assertion 'isrealpr' failed
> 
> This appears to be caused by a rename within the tree between restore
> levels, or a combination of modifications occurring during dump.
> Fixing it will likely require changes in noref_elim_recurse and
> tree_post, to ensure elements of the tree are created for these edge
> conditions. Given the state of xfsdump this is a bit risky for
> maintenance streams.

With some more digging it looks like this is triggered during subtree
restores. A cumulative restore started by excluding a specific subtree
with -s doesn't cause subsequent restores to prune the non subtree
sections from the restore.

This leads to the assert firing when in noref_elim_recurse when its
asked to handle a rename for a directory not created due to the
subtree restriction.

mkdir -p /mnt/scratch/dir1/dir2/dir3
mkdir -p /mnt/scratch/restore_me/dirA/dirB/dirC

xfsdump -L label -M media -l0 -f /tmp/l0.dump /mnt/scratch

mv /mnt/scratch/dir1/dir2 /mnt/scratch/dir10

xfsdump -L label -M media -l2 -f /tmp/l2.dump /mnt/scratch

dir=$(mktemp -d /mnt/scratch/dir_XXX)
xfsrestore -r -f /tmp/l0.dump -s restore_me $dir
xfsrestore -r -f /tmp/l2.dump $dir
## xfsrestore: tree.c:1369: noref_elim_recurse: Assertion `isrealpr' failed.

The subtree filter state was saved in the state file

[root@rhel8 ~]# hexdump -C /mnt/scratch/dir_ILX/xfsrestorehousekeepingdir/state | grep restore_me
00005010  72 65 73 74 6f 72 65 5f  6d 65 00 00 00 00 00 00  |restore_me......|
[root@rhel8 ~]# 


> While current builds have assert(3) active, remove this one allowing
> xfsrestore to continue, warning on failing renames for directory nodes
> that haven't been created. Once the full tree is built referenced
> directories will end up in the orphanage allowing for user recovery.

This didn't end up in the orphanage, which seems to suggest that the
subtree option had some affect.

[root@rhel8 xfsdump-dev]# restore/xfsrestore -r -f /tmp/l2.2.dump $dir
restore/xfsrestore: using file dump (drive_simple) strategy
restore/xfsrestore: version 3.2.0 (dump format 3.0) - type ^C for status and control
restore/xfsrestore: searching media for dump
restore/xfsrestore: examining media file 0
restore/xfsrestore: dump description: 
restore/xfsrestore: hostname: rhel8
restore/xfsrestore: mount point: /mnt/scratch
restore/xfsrestore: volume: /dev/vdc
restore/xfsrestore: session time: Mon Mar 23 13:25:57 2026
restore/xfsrestore: level: 2
restore/xfsrestore: session label: "label"
restore/xfsrestore: media label: "media"
restore/xfsrestore: file system id: cb6c9beb-45a7-42b4-b125-502ed787e4fb
restore/xfsrestore: session id: 3832f932-2b4f-4f87-841d-f071e4cb3a1c
restore/xfsrestore: media id: 58d8ce69-90a7-4164-901d-4a64a0f9ba69
restore/xfsrestore: using online session inventory
restore/xfsrestore: searching media for directory dump
restore/xfsrestore: reading directories
restore/xfsrestore: 16 directories and 21 entries processed
restore/xfsrestore: directory post-processing
restore/xfsrestore: WARNING: unable to rename dir dir1/dir2 to dir orphanage/67109056.572736669: No such file or directory
restore/xfsrestore: restore complete: 0 seconds elapsed
restore/xfsrestore: Restore Summary:
restore/xfsrestore:   stream 0 /tmp/l2.2.dump OK (success)
restore/xfsrestore: Restore Status: SUCCESS
[root@rhel8 xfsdump-dev]#

[root@rhel8 xfsdump-dev]# find $dir
/mnt/scratch/dir_P67
/mnt/scratch/dir_P67/xfsrestorehousekeepingdir
/mnt/scratch/dir_P67/xfsrestorehousekeepingdir/state
/mnt/scratch/dir_P67/xfsrestorehousekeepingdir/namreg
/mnt/scratch/dir_P67/xfsrestorehousekeepingdir/tree
/mnt/scratch/dir_P67/xfsrestorehousekeepingdir/dirextattr
/mnt/scratch/dir_P67/xfsrestorehousekeepingdir/dirattr
/mnt/scratch/dir_P67/restore_me
/mnt/scratch/dir_P67/restore_me/dirA
/mnt/scratch/dir_P67/restore_me/dirA/dirB
/mnt/scratch/dir_P67/restore_me/dirA/dirB/dirC
/mnt/scratch/dir_P67/restore_me/dirD
[root@rhel8 xfsdump-dev]# 

> 
> Signed-off-by: Donald Douwsma <ddouwsma@redhat.com>
> ---
>  restore/tree.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/restore/tree.c b/restore/tree.c
> index bf89c6a..81666ac 100644
> --- a/restore/tree.c
> +++ b/restore/tree.c
> @@ -1404,12 +1404,13 @@ noref_elim_recurse(nh_t parh,
>  				Node_free(&cldh);
>  			}
>  
> +			/* Process renames for directories that have been created.
> +			 */
>  			if (isrenamepr) {
>  				nrh_t nrh;
>  				node_t *renamep;
>  
>  				assert(isrefpr);
> -				assert(isrealpr);
>  				ok = Node2path(cldh,
>  						path1,
>  						_("tmp dir rename src"));

