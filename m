Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A641346A14
	for <linux-xfs@vger.kernel.org>; Mon, 13 Jul 2026 18:36:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783967808; cv=none; b=tFYAXZvjqEVBkS3L2zJ3Aw7KKjNydMrjqx3+hxq8mTLhH/OVYx7xd1rSd4HpR1zlrPkxnQAyTLKY8eiyQYfKQWcUBPcP5NufJbY2mcvC7HVjH/4iD79+fuQe3F6k0WGnoOZDOMpqFJoWkQhm9wuiUWr/eoyX/Z116WC9sj54EYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783967808; c=relaxed/simple;
	bh=ezZB1p0ZpgidAhCy098IE16TyuFs1Z304ZL1d2h7wjg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RACQA0nwSsIGJIOIGXKuGaGoYP00wajjZAfo1NPpDhB7a+HP0vNSmFEAg8A6PceglG/AcR4vO01MSopsAEf/U7pQye4gYJP6U8h10HUGdpR4LG7dURW6Q4xoWSaKfeomPJQvGbNAk7k7FrGogt21kkCDxDm3yuAYe+xJ2Ib/B30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FviszE6i; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=A8VnWnIz; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FviszE6i";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="A8VnWnIz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1783967805;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4JohqPXLSwLb53Hhf6PMROF6kde05bVhyKdPoTd8oQo=;
	b=FviszE6i3T/eLaIcU7Hv0ORRQI6kxqSewhIakqYvUpYWeijhruCYlZc7/SbCw8YMBNh+4u
	5t2R5fm4NlUzH1xl+i+iufKiShSSV9ynSuanJBWIdq25KTSEqEFpB7YaaWK8kNuWmpItdz
	ZSumfZ6D/IETwZmDuiX45XtP+Kbpt54=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-381-K5X61UPoOPesXhiXy23Tuw-1; Mon, 13 Jul 2026 14:36:44 -0400
X-MC-Unique: K5X61UPoOPesXhiXy23Tuw-1
X-Mimecast-MFC-AGG-ID: K5X61UPoOPesXhiXy23Tuw_1783967803
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-47407691804so2487692f8f.1
        for <linux-xfs@vger.kernel.org>; Mon, 13 Jul 2026 11:36:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1783967803; x=1784572603; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=4JohqPXLSwLb53Hhf6PMROF6kde05bVhyKdPoTd8oQo=;
        b=A8VnWnIzwMcwjC2Vkv+v/D3mplK4Rj4zzL0mKJph6sPmN3iI9lWAJWfIVv4wXIMEsB
         +xytuMcmqmbJDpfUfcJla5V8hnIPAMPRzHRdxGMwFD1e4KQu8UY8BeEDY2167XfQ2Lgo
         321Ck6bikDUNysJEPI43KpEVZeNlK2ycJIMHkoIrG9yDfu0y/u7BKilBnTCXZ/PEF9IV
         nH+hppmtRXOVH+guOhA+4lTkthOf+/yKWMjVSh4ZSpIfTulWoVoMebgHs0GpapzjZyzc
         VWhnHBK4BbSej7kFjzDCmGiIfmH1CrG67d/G0a8OixYohJldnsm5Z+I9lLbygXLyF2wg
         pc9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783967803; x=1784572603;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=4JohqPXLSwLb53Hhf6PMROF6kde05bVhyKdPoTd8oQo=;
        b=Y8bcUrqK8YhAh5MqdqtyV41ss8cRMM168Br1q3pLyvVAJ4m0aufsdKW9+hQtw50tba
         0dI8vPx4v+9Hz87IBTFYMicvqQjl3+B8s98fZgK7GB6KbH7WJSmkaea30frEFhe95H+G
         0bV3JLGUEYuQTUZEfTCNOyy/lRavcJcU+MoFR0nYvYMPpvmtH749Ff9t/uUxN8y9DEpM
         E9I+yen3lXFb/A7xoP3Y/Psod2QdGQsUn6wZREoJRXv5UgEiXEBidw7kPLmTfSxCquuv
         xhXCoK7JtK14usf5pb4tM+89CoHyOYuju3qHx9hc0yDeYFEZC6I1z7+WecnXDVMYuiwi
         mf/Q==
X-Forwarded-Encrypted: i=1; AHgh+RrJ9qLk/W3n9VfgQOL6V92LXnMh+9ORDyYhuk4wHGtTP+wO0VSwZJxv3119vA0Hn/vzuBoLXewFUDo=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy+QMDkHzrtnpXtfS2SMbFTSrpf+XZKCTaNOZyg1uvgC2UqNo9T
	Q+YTlm11NqmejdJxpQyhI/SHSa934ePYIGzUAOTgI8lgzgUjtPV/V3Kj3VpOzYQIi1drEVrclCI
	kp15kZeXy58cAdHM0RL6cAlris7U5q4uwKt3nfDMKiVDE6BPcnK5ggLvSg8yW
X-Gm-Gg: AfdE7ckl1if5UT+J02iMwue+vo3CebMG1z9NidVagG3gsWQBI/BnUAvFZjXLKa9rrwr
	3RDdPgc0iTRX1B9Trhsj970UyPYojC8hyO+qAZlbQnSBjtu/Oi42mIlU6XpO82kdtS7xpp/QZ8i
	LUJPB/zLBpJHInWg6vc/7p8v6pUW2ojOK/0K2DK/PkPnXdVlQ/f2C3Cy+ayyCywVzEHTZIWLl59
	QKjuUm4vyK+zm85rrGyc4KbLnVQpHVdGMe5Np0oGA/+75HkzTzjOnCT+xadDM/yaGlyaGAeykM7
	fDTC24nrvkvXi50AXUe8zNg/d1mRLayPc/Pjj5VMoX0iZ1Qy90lfMT5iOZ0J0bzR8VtITwvzTQZ
	otPy3JjCWhRJIOb/zM2b1PC47rcoBnbIfB8riUqbqcJ4XvQ==
X-Received: by 2002:a5d:5846:0:b0:474:9002:c74a with SMTP id ffacd0b85a97d-47f2dced169mr11370064f8f.35.1783967802693;
        Mon, 13 Jul 2026 11:36:42 -0700 (PDT)
X-Received: by 2002:a5d:5846:0:b0:474:9002:c74a with SMTP id ffacd0b85a97d-47f2dced169mr11370032f8f.35.1783967802155;
        Mon, 13 Jul 2026 11:36:42 -0700 (PDT)
Received: from aalbersh-thinkpadx1carbongen13.rmtcz.csb ([217.30.74.39])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47f464c7c96sm1245840f8f.33.2026.07.13.11.36.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2026 11:36:41 -0700 (PDT)
Date: Mon, 13 Jul 2026 20:36:41 +0200
From: Andrey Albershteyn <aalbersh@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Andrey Albershteyn <aalbersh@kernel.org>, linux-xfs@vger.kernel.org, 
	alexjlzheng@tencent.com, bfoster@redhat.com, cem@kernel.org, cmaiolino@redhat.com, 
	dgc@kernel.org, hch@lst.de, liuhuan01@kylinos.cn, msinguru@redhat.com, 
	romain.naour@smile.fr, syzbot+0391d34e801643e2809b@syzkaller.appspotmail.com, 
	wilfred.mallawa@wdc.com, ytohnuki@amazon.com
Subject: Re: [ANNOUNCE] xfsprogs: v7.1.0 released
Message-ID: <alUvSnHWlWLYTc_1@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
References: <alDUTZkDnQodyG2R@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
 <20260713155405.GC7195@frogsfrogsfrogs>
 <alUm3yMFKm9w0Mjm@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
 <20260713181542.GF7195@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260713181542.GF7195@frogsfrogsfrogs>

On 2026-07-13 11:15:42, Darrick J. Wong wrote:
> On Mon, Jul 13, 2026 at 08:02:37PM +0200, Andrey Albershteyn wrote:
> > On 2026-07-13 08:54:05, Darrick J. Wong wrote:
> > > On Mon, Jul 13, 2026 at 11:23:41AM +0200, Andrey Albershteyn wrote:
> > > > Hi folks,
> > > > 
> > > > The xfsprogs master branch in repository at:
> > > > 
> > > > 	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git
> > > > 
> > > > has just been updated.
> > > > 
> > > > This release consist mostly of a bunch of fixes for xfs_scrub and xfs_healer
> > > > found with help of Codex. The xfs_scrub systemd units now have less security
> > > > restrictions due to issues with postfix. Multiple memory leaks and overflows
> > > > fixed. A lot of fixes for xfs_scrub phased repair flow. xfs_protofile now also
> > > > works with non-directories. The build system is fixed for path containing ".o".
> > > > Manual pages and mkfs messages now have correct MiB units.
> > > > 
> > > > Patches often get missed, so if your outstanding patches are properly reviewed
> > > > on the list and not included in this update, please let me know.
> > > > 
> > > > The for-next branch has also been updated to match the state of master.
> > > > 
> > > > The new head of the master branch is commit:
> > > > 
> > > > e80b048d87fdc5735e0d03ae29b497b402ea8bbe
> > > > 
> > > > New commits:
> > > > 
> > > > Andrey Albershteyn (1):
> > > >       [e80b048d87fd] xfsprogs: Release v7.1.0
> > > > 
> > > > Christoph Hellwig (1):
> > > >       [846570fc6498] xfs: switch (back) to a per-buftarg buffer hash
> > > > 
> > > > Darrick J. Wong (65):
> > > >       [1aadfecf6afb] xfs_healer: fix error reporting
> > > >       [d21aab594247] xfs_healer: recommend offline fsck for XCORRUPT repairs
> > > >       [44849c72c720] xfs_healer: initialize variable here
> > > >       [fc76bac6ce1f] xfs_healer: run a full xfs_scrub repair if we don't know how to do a spot repair
> > > >       [79551362141a] xfs_healer: fix Makefile errors
> > > >       [4d62c2fa83ba] xfs_healer: don't leak wh->mntpoint if fd_to_handle fails
> > > >       [a6b85058f1ae] xfs_healer: coordinate access to weakhandle::mntpoint correctly
> > > >       [de2bc2763b53] xfs_scrub_media_fail: reduce security lockdowns to avoid postfix problems
> > > >       [ff0aeb233200] xfs_scrub_all: fix broken command line string array construction
> > > >       [ee3ea981af6b] xfs_scrub_all_fail: reduce security lockdowns to avoid postfix problems
> > > >       [24362b13fb76] xfs_scrub_fail: send content headers for xfs_scrub_all failures
> > > >       [472b010d0c84] xfs_scrub: fix uninitialized variable
> > > >       [a42fc3ec97db] xfs_scrub: fix integer overflows
> > > >       [9d36b3db1212] xfs_scrub: don't count internal log space in the data device used count
> > > >       [064834b6a0a2] xfs_scrub: widen scrub and repair dependency mask
> > > >       [44eee006149b] xfs_scrub: fix work estimation for rtgroups filesystems
> > > >       [5db0a8b13358] xfs_scrub: don't report media errors in specially-owned areas as file data
> > > >       [b65854f9e580] xfs_scrub: return SCRUB_RET_OPERROR if unicode collision detection fails to initialize
> > > >       [a34231de7668] xfs_scrub: fix nonsense advice after a scrub finds errors
> > > >       [25c97ededd3e] xfs_scrub: don't allow NAN as fstrim percentage
> > > >       [709b7eab8977] xfs_scrub: reset bulkstat pointer on retry
> > > >       [dc4e11fa3d7c] xfs_scrub: don't return garbage value from bulkstat_the_rest
> > > >       [d0b07b57faf0] xfs_scrub: don't continue with phase1 if autofsck=none
> > > >       [4a093a994c63] xfs_scrub: don't crash trying to complain about clean health
> > > >       [353333f0f3ff] xfs_scrub: fix inverted return value from ptvar_get
> > > >       [a5732e6c61f5] xfs_scrub: don't obscure repair failures in repair_list_schedule
> > > >       [33cc9bbc4dce] xfs_scrub: bitmap iteration functions must retur
> > > >       [5556c32a0304] xfs_scrub: read verification isn't ok if it hit runtime errors
> > > >       [359eeef71fae] libfrog: fix buffer overflow in getparents path_to_string
> > > >       [5b0f430d8e59] xfs_healer: don't allow aliasing of mon_fd in setup_monitor
> > > >       [425126caa89c] xfs_healer_start: check listmount when doing a --check
> > > >       [577d6415adbb] xfs_healer_start: fix static checking
> > > >       [76ef8d90a3f0] xfs_healer_start: increase statmount buffer size
> > > >       [a0f50dec3540] xfs_healer: allow AF_UNIX socket access for xfs_healer instances
> > > >       [f6505519ef79] xfs_healer: don't put the slice file in LDIRT
> > > >       [64344c43430a] xfs_scrub: handle missing media verify ioctl failure return codes
> > > >       [2712427c08a5] xfs_scrub: report bad file ranges correctly
> > > >       [3e4bb144f657] xfs_scrub: handle media scans of internal rt devices correctly
> > > >       [c001fa7d4db4] xfs_scrub: track inode scan abort state with an enum
> > > >       [bc9371417a61] xfs_scrub: don't skip bulkstat batch when scrub_scan_user_files helper returns ESTALE
> > > >       [b6dba3d85ae5] xfs_scrub: warn about incomplete repairs if we never get to them
> > > >       [e2df9f9bb984] xfs_scrub: report external log space usage in phase 7
> > > >       [243048f90dd4] xfs_scrub: account only data extent tail after an overlap
> > > >       [baef30aabbd5] xfs_scrub: account for reflinked realtime file data
> > > >       [a4080cef33fd] xfs_scrub: don't leak the autofsck fsproperty handle
> > > >       [157d76940c3c] xfs_scrub: warn about difficult rtgroup repairs
> > > >       [0bafb12d66e7] xfs_scrub: stop user file scan if caller already aborted
> > > >       [bac5085ac2e3] xfs_scrub: don't flatten error numbers in read_verify_schedule_now
> > > >       [b43e9064d665] xfs_scrub: actually handle NEEDSCHECK scrub items in phase 4
> > > >       [41530a0981a1] xfs_scrub: don't leak phase 5 scan items after a failed workqueue_add
> > > >       [f4dfa0b0c565] xfs_scrub: fix phase 8 debug reporting
> > > >       [f75bb3f2d598] xfs_scrub: always finish cleanup, even if reporting healthy state fails
> > > >       [4399db49dec0] xfs_scrub: fix spacemap external log device scan dev key
> > > >       [70d0a4f27464] xfs_scrub: fix estimate of work items for phase 4
> > > >       [b64c29f5bfed] xfs_db: fix type conversions
> > > >       [1bbedb6d165e] xfs_db: dump zoned filesystem superblock fields
> > > >       [7a26df144fad] xfs_healer: fix getmntent race in weakhandle
> > > >       [b07c386bc60b] mkfs: don't redefine DIRT for protofiles
> > > >       [2df5f48fb829] mkfs: fix PATH_MAX check
> > > >       [46b0ee102f25] mkfs: fix symlink target length check in create_nondir_inode
> > > >       [b3268fb3d822] xfs_protofile: make nondirectory arguments actually work
> > > >       [a2b765f7d0fd] mkfs: pass stat buf pointers around the protofile code
> > > >       [63a4a9d6966c] mkfs: fix hardlink detection in directory import code
> > > >       [8c6bf6721ac4] mkfs: PQUOTA shouldn't conflict with GQNOENFORCE
> > > >       [074c18165ea3] xfs_scrub: fix spacemap scan for internal rt devices
> > > 
> > > Hmmm, this patch seems to have gotten the same rtstart hunk pasted into
> > > both scan_ag_rmaps and scan_rtg_rmaps even though the original patch
> > > only changed scan_rtg_rmaps.  I'll send a fix.
> > 
> > Hmm I miss-understood the patch flow here. I intentionally squashed
> > these two patches, I thought you sent fix in two patches (both had
> > identical commit message).
> > 
> > standalone fix:
> > https://lore.kernel.org/linux-xfs/20260701145124.GE6526@frogsfrogsfrogs/
> > 
> > part of the pr:
> > https://lore.kernel.org/linux-xfs/178302114913.828394.9290073519402547866.stg-ugh@frogsfrogsfrogs/
> 
> Both the standalone patch I sent to the list and the one in the PR[1]
> modify scan_rtg_rmaps.

Oh you're right, somehow b4 shazam'ing the patch on top of your PR
made it apply to scan_ag_rmaps(). I probably did it at some point
and got confused; I thought there's two different commits.

-- 
- Andrey

