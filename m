Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B18D92472AA
	for <linux-xfs@vger.kernel.org>; Mon, 13 Jul 2026 18:02:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783965765; cv=none; b=PNUY8/U7QYTxew8wskYqbMot0buE3IJw6RgUYQS1o+Po2jo3DVD2bVMfngA4b+HxwXTsq4FKtAqPC+EFLwV5V4OCnUTHuAfhWvTzMmHXd7zGGj7ZU5KHaCsPpUBxcDcRaajSn4D0KzqTcTllLkvaK59coB3Aj730+4LlQI/E0C8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783965765; c=relaxed/simple;
	bh=Lp52UTZ90ae4x8tITBKatqccXlH3pYbiRQ64F1HApNQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cZwsssf7TykT4eDF9IYQQEYb9YE4ml9w8ML0rljOeHtRSPk/pQtimJaXKWVZwtwrVcy5pvymrw9tWDj47mwIgZzpjqJSYmdy1CAFna5PLoMfXoHMHUMgvRYV9ocLdGxSIPOvJRdGt5meveP5VgiRlcoinwdnhQ3ySPNpAESBj/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dCW+fwnX; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=HYuIwwcM; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dCW+fwnX";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="HYuIwwcM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1783965762;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=e/J1Bco3e8pzGFTAz8Dlc2Y3RIbJRM5bYMQDDy63RUQ=;
	b=dCW+fwnXxMPNHbxOeW+gjKdmV4SvGc+UzDLqoXvCiepvtoAe1WNVxQ2rr8kPsz5Cs+k6QV
	MF3+JfXuajLSAuLwWfM9se3xOPSOZVe8S6AcCTysE7+TIIHVAEIpWfsJwZRzLmdw4azXS9
	rQDr1KTfcMkyvlwXRa9PejNuGxxIi88=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-231-2ULv6Ws_MTiTbCoE9L7dVA-1; Mon, 13 Jul 2026 14:02:41 -0400
X-MC-Unique: 2ULv6Ws_MTiTbCoE9L7dVA-1
X-Mimecast-MFC-AGG-ID: 2ULv6Ws_MTiTbCoE9L7dVA_1783965760
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-493c526df6bso1515635e9.3
        for <linux-xfs@vger.kernel.org>; Mon, 13 Jul 2026 11:02:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1783965760; x=1784570560; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=e/J1Bco3e8pzGFTAz8Dlc2Y3RIbJRM5bYMQDDy63RUQ=;
        b=HYuIwwcMMvKo5IL/Jt8DODX58FIX0FVIKk4wxnWLRE7NNlQ7MNRsXfzgkgLTdhVeNi
         aJ0vAf0N00bSv/bR2piH6N+ENbq8hIgDS2pX6tAe9YCDdG1jPBjS8S0yV+gADOqrFhFE
         MOdrtOm0oETJwV3mMdyfS++yH6bg5BjlGmW0l0X/xItBAbXZTrJzSHCVASGFPVxitBVN
         HuUP/saZkUNIimpYH2HkdjQxiJPXFGXTVdF/RpzI0Uw4slys7CD7MtrhQRNnm7MqySrQ
         3nwoCi/UJnIEQHztGJEIS+Wurwj90Sw7h64UFByFQbr7i6reZeq8+QDgkAgmdZ7r7W9j
         VOog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783965760; x=1784570560;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=e/J1Bco3e8pzGFTAz8Dlc2Y3RIbJRM5bYMQDDy63RUQ=;
        b=PMnh8yWuDjV0pVk0hKp+6nWd0OYgKKmby6ansLx5CEom24wkDyWRs45f0heC4FBCyr
         j8fP+GHZoBR2nzVC2G18YrjYpKaiJorwFcPQDWRCt5Z7Gk5aHxJ7teGLYCjISSlS+AvI
         HKc/nnIjESv8qCqLkrbcER1k7mYySrKAQu5QK22E4vtTwTQ8bHVcvvh9EVeJ5jf13lIn
         4HkSFAy58GnVd7it9KeUCOcbiIUIc5hGfo70MJ8Q6Z8biSvne2cUyqNvZAwTlsztLkWl
         dtrqViKDKakYMql2CIhh/T/iCdzZ9wcWl/OupSgszgdNLhpZQ57Lmpl0fCeft7N6XqSQ
         3GqQ==
X-Forwarded-Encrypted: i=1; AHgh+RrjliSZzVX2YKaCkPV5Y8F7dnCwK8DcPKfMzpi8MgSYVhDX015UhoxFWm2P/C20dQeKonHitNY4TSU=@vger.kernel.org
X-Gm-Message-State: AOJu0YzNm1n5bJ+KYbysTGqMvRgso0+J5nW8U+mlx/0m0jSg0LCVP+bw
	9MHA4Y6Eo8s7mLTjfyA384BY9YIlKALA50OfPfo3ZO3tXxF5GaPn1UiF5yYMN/Fhr+J6xk2TB6C
	lQpn4a1HiRokICnp0f/LOGPpWurXhWf3DnYdtcYWSc1AGmqPTxG+09iarEwJ3
X-Gm-Gg: AfdE7cl3lpWWXjp9b6mTbgywaac8Pw2nFN5Nx437Xy09ozCQ0e3Jy/kd35mS0waPnHb
	HcqQp/1wv8VcFzToDuDOIG5181QNTEkTRiKr9eTLXMGeIaJV2wfE4aQox0x9nHS6a4xGg3fjc+e
	9/Qz0TO/WFOHQ3Fle44T2esGwl2rbzqjC1i8YvqjIk1CJ3RNRpzOfK0tfVKuGLrzqgR4+LXm9Lx
	sGFQAbzOPR46Hll684RHP7upN3wE1iZ2A+M27avmwrk+7ycDTW0nbNvsAiFCjFk42kBcNn8Dxqw
	vjXOVDzqNNA8rCjHXVZS4xhCcjjmxu7i0BWJZpj26KUX8lRrR85JpDQVHogO3ig9Q7HODegbF4H
	UTMOdyXp46wI3E5/SP5JSJqy918834Tnq4kU+EZwuGdUhgg==
X-Received: by 2002:a05:600c:8b29:b0:493:c337:db0e with SMTP id 5b1f17b1804b1-493f881d069mr102592645e9.18.1783965759717;
        Mon, 13 Jul 2026 11:02:39 -0700 (PDT)
X-Received: by 2002:a05:600c:8b29:b0:493:c337:db0e with SMTP id 5b1f17b1804b1-493f881d069mr102592135e9.18.1783965759070;
        Mon, 13 Jul 2026 11:02:39 -0700 (PDT)
Received: from aalbersh-thinkpadx1carbongen13.rmtcz.csb ([217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4950a33a926sm11245805e9.15.2026.07.13.11.02.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2026 11:02:38 -0700 (PDT)
Date: Mon, 13 Jul 2026 20:02:37 +0200
From: Andrey Albershteyn <aalbersh@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Andrey Albershteyn <aalbersh@kernel.org>, linux-xfs@vger.kernel.org, 
	alexjlzheng@tencent.com, bfoster@redhat.com, cem@kernel.org, cmaiolino@redhat.com, 
	dgc@kernel.org, hch@lst.de, liuhuan01@kylinos.cn, msinguru@redhat.com, 
	romain.naour@smile.fr, syzbot+0391d34e801643e2809b@syzkaller.appspotmail.com, 
	wilfred.mallawa@wdc.com, ytohnuki@amazon.com
Subject: Re: [ANNOUNCE] xfsprogs: v7.1.0 released
Message-ID: <alUm3yMFKm9w0Mjm@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
References: <alDUTZkDnQodyG2R@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
 <20260713155405.GC7195@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260713155405.GC7195@frogsfrogsfrogs>

On 2026-07-13 08:54:05, Darrick J. Wong wrote:
> On Mon, Jul 13, 2026 at 11:23:41AM +0200, Andrey Albershteyn wrote:
> > Hi folks,
> > 
> > The xfsprogs master branch in repository at:
> > 
> > 	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git
> > 
> > has just been updated.
> > 
> > This release consist mostly of a bunch of fixes for xfs_scrub and xfs_healer
> > found with help of Codex. The xfs_scrub systemd units now have less security
> > restrictions due to issues with postfix. Multiple memory leaks and overflows
> > fixed. A lot of fixes for xfs_scrub phased repair flow. xfs_protofile now also
> > works with non-directories. The build system is fixed for path containing ".o".
> > Manual pages and mkfs messages now have correct MiB units.
> > 
> > Patches often get missed, so if your outstanding patches are properly reviewed
> > on the list and not included in this update, please let me know.
> > 
> > The for-next branch has also been updated to match the state of master.
> > 
> > The new head of the master branch is commit:
> > 
> > e80b048d87fdc5735e0d03ae29b497b402ea8bbe
> > 
> > New commits:
> > 
> > Andrey Albershteyn (1):
> >       [e80b048d87fd] xfsprogs: Release v7.1.0
> > 
> > Christoph Hellwig (1):
> >       [846570fc6498] xfs: switch (back) to a per-buftarg buffer hash
> > 
> > Darrick J. Wong (65):
> >       [1aadfecf6afb] xfs_healer: fix error reporting
> >       [d21aab594247] xfs_healer: recommend offline fsck for XCORRUPT repairs
> >       [44849c72c720] xfs_healer: initialize variable here
> >       [fc76bac6ce1f] xfs_healer: run a full xfs_scrub repair if we don't know how to do a spot repair
> >       [79551362141a] xfs_healer: fix Makefile errors
> >       [4d62c2fa83ba] xfs_healer: don't leak wh->mntpoint if fd_to_handle fails
> >       [a6b85058f1ae] xfs_healer: coordinate access to weakhandle::mntpoint correctly
> >       [de2bc2763b53] xfs_scrub_media_fail: reduce security lockdowns to avoid postfix problems
> >       [ff0aeb233200] xfs_scrub_all: fix broken command line string array construction
> >       [ee3ea981af6b] xfs_scrub_all_fail: reduce security lockdowns to avoid postfix problems
> >       [24362b13fb76] xfs_scrub_fail: send content headers for xfs_scrub_all failures
> >       [472b010d0c84] xfs_scrub: fix uninitialized variable
> >       [a42fc3ec97db] xfs_scrub: fix integer overflows
> >       [9d36b3db1212] xfs_scrub: don't count internal log space in the data device used count
> >       [064834b6a0a2] xfs_scrub: widen scrub and repair dependency mask
> >       [44eee006149b] xfs_scrub: fix work estimation for rtgroups filesystems
> >       [5db0a8b13358] xfs_scrub: don't report media errors in specially-owned areas as file data
> >       [b65854f9e580] xfs_scrub: return SCRUB_RET_OPERROR if unicode collision detection fails to initialize
> >       [a34231de7668] xfs_scrub: fix nonsense advice after a scrub finds errors
> >       [25c97ededd3e] xfs_scrub: don't allow NAN as fstrim percentage
> >       [709b7eab8977] xfs_scrub: reset bulkstat pointer on retry
> >       [dc4e11fa3d7c] xfs_scrub: don't return garbage value from bulkstat_the_rest
> >       [d0b07b57faf0] xfs_scrub: don't continue with phase1 if autofsck=none
> >       [4a093a994c63] xfs_scrub: don't crash trying to complain about clean health
> >       [353333f0f3ff] xfs_scrub: fix inverted return value from ptvar_get
> >       [a5732e6c61f5] xfs_scrub: don't obscure repair failures in repair_list_schedule
> >       [33cc9bbc4dce] xfs_scrub: bitmap iteration functions must retur
> >       [5556c32a0304] xfs_scrub: read verification isn't ok if it hit runtime errors
> >       [359eeef71fae] libfrog: fix buffer overflow in getparents path_to_string
> >       [5b0f430d8e59] xfs_healer: don't allow aliasing of mon_fd in setup_monitor
> >       [425126caa89c] xfs_healer_start: check listmount when doing a --check
> >       [577d6415adbb] xfs_healer_start: fix static checking
> >       [76ef8d90a3f0] xfs_healer_start: increase statmount buffer size
> >       [a0f50dec3540] xfs_healer: allow AF_UNIX socket access for xfs_healer instances
> >       [f6505519ef79] xfs_healer: don't put the slice file in LDIRT
> >       [64344c43430a] xfs_scrub: handle missing media verify ioctl failure return codes
> >       [2712427c08a5] xfs_scrub: report bad file ranges correctly
> >       [3e4bb144f657] xfs_scrub: handle media scans of internal rt devices correctly
> >       [c001fa7d4db4] xfs_scrub: track inode scan abort state with an enum
> >       [bc9371417a61] xfs_scrub: don't skip bulkstat batch when scrub_scan_user_files helper returns ESTALE
> >       [b6dba3d85ae5] xfs_scrub: warn about incomplete repairs if we never get to them
> >       [e2df9f9bb984] xfs_scrub: report external log space usage in phase 7
> >       [243048f90dd4] xfs_scrub: account only data extent tail after an overlap
> >       [baef30aabbd5] xfs_scrub: account for reflinked realtime file data
> >       [a4080cef33fd] xfs_scrub: don't leak the autofsck fsproperty handle
> >       [157d76940c3c] xfs_scrub: warn about difficult rtgroup repairs
> >       [0bafb12d66e7] xfs_scrub: stop user file scan if caller already aborted
> >       [bac5085ac2e3] xfs_scrub: don't flatten error numbers in read_verify_schedule_now
> >       [b43e9064d665] xfs_scrub: actually handle NEEDSCHECK scrub items in phase 4
> >       [41530a0981a1] xfs_scrub: don't leak phase 5 scan items after a failed workqueue_add
> >       [f4dfa0b0c565] xfs_scrub: fix phase 8 debug reporting
> >       [f75bb3f2d598] xfs_scrub: always finish cleanup, even if reporting healthy state fails
> >       [4399db49dec0] xfs_scrub: fix spacemap external log device scan dev key
> >       [70d0a4f27464] xfs_scrub: fix estimate of work items for phase 4
> >       [b64c29f5bfed] xfs_db: fix type conversions
> >       [1bbedb6d165e] xfs_db: dump zoned filesystem superblock fields
> >       [7a26df144fad] xfs_healer: fix getmntent race in weakhandle
> >       [b07c386bc60b] mkfs: don't redefine DIRT for protofiles
> >       [2df5f48fb829] mkfs: fix PATH_MAX check
> >       [46b0ee102f25] mkfs: fix symlink target length check in create_nondir_inode
> >       [b3268fb3d822] xfs_protofile: make nondirectory arguments actually work
> >       [a2b765f7d0fd] mkfs: pass stat buf pointers around the protofile code
> >       [63a4a9d6966c] mkfs: fix hardlink detection in directory import code
> >       [8c6bf6721ac4] mkfs: PQUOTA shouldn't conflict with GQNOENFORCE
> >       [074c18165ea3] xfs_scrub: fix spacemap scan for internal rt devices
> 
> Hmmm, this patch seems to have gotten the same rtstart hunk pasted into
> both scan_ag_rmaps and scan_rtg_rmaps even though the original patch
> only changed scan_rtg_rmaps.  I'll send a fix.

Hmm I miss-understood the patch flow here. I intentionally squashed
these two patches, I thought you sent fix in two patches (both had
identical commit message).

standalone fix:
https://lore.kernel.org/linux-xfs/20260701145124.GE6526@frogsfrogsfrogs/

part of the pr:
https://lore.kernel.org/linux-xfs/178302114913.828394.9290073519402547866.stg-ugh@frogsfrogsfrogs/

-- 
- Andrey

