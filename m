Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A949263F32
	for <linux-xfs@vger.kernel.org>; Mon, 24 Mar 2025 16:56:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742835384; cv=none; b=Y/olX8gSc6GiSPNyqs0FIadshe9l7iY7FyMMZ05UZyYi00NzrOYWHQC6/257QrbiwZ2mpqCw6/gmmsUp5qWpOHcP9cGGC15Xj9okb/HYj+50//JXwhAV6PIMOwoq9uylKYDYzkBP5YHr3TEnBe2mP2Jsa56ZOHNQgD/tccF0uWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742835384; c=relaxed/simple;
	bh=RfS5R5wZqA3RxWIBfBAmpH4BHzP5SZ38X5jF9/c3+o0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Kj2xmCQoKHZFxY73Zyt0JbHSUp/gtorZGY9hIkh3lF/w36zbITMKNWyaIHX0qLDwASC6vZ80zfFTxSAFPISVKdSiGgx8s4HiXtvbkpsbzo6QdaQt4pFpJyCsiIORn3CWQyZldOYJBCdoGa89KAZk9/CC6Px/JCkNE1/ka7PlDEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OK4N3X3h; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OK4N3X3h"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1742835380;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UDXmNwMeckwBpYnhUGp2iG9JgaMKMmBfkWkN9wEHfxg=;
	b=OK4N3X3h8U373acpnn3oMg4EpaleW8q4JEgJmWsQiOWN3vb/GwCzqRky9emLq5iN/2qrui
	hGMf9MI9BIOV24L344tQ2VAsKkwGvddkrLT2H6NDH2111pupUs+wQE8iyCHrKQYhH5tx5u
	jlgOQJ0W5KEDZiAbygpBPaWrxUIL1Cs=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-286-VIWkIULdNoiRcmx7lrXElg-1; Mon,
 24 Mar 2025 12:56:19 -0400
X-MC-Unique: VIWkIULdNoiRcmx7lrXElg-1
X-Mimecast-MFC-AGG-ID: VIWkIULdNoiRcmx7lrXElg_1742835378
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A9622196B377;
	Mon, 24 Mar 2025 16:56:17 +0000 (UTC)
Received: from redhat.com (unknown [10.22.65.116])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1853B1956095;
	Mon, 24 Mar 2025 16:56:15 +0000 (UTC)
Date: Mon, 24 Mar 2025 11:56:12 -0500
From: Bill O'Donnell <bodonnel@redhat.com>
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs@vger.kernel.org, djwong@kernel.org, hch@infradead.org
Subject: Re: [PATCH v3] xfs_repair: handling a block with bad crc, bad uuid,
 and bad magic number needs fixing
Message-ID: <fg6o7yymto2yk2d35e2mxy7rppaknps62kzzkodzgp2yqwqk6y@5woxrceormv6>
References: <20250321220532.691118-4-bodonnel@redhat.com>
 <19fbe9e4-c898-40b3-a4b5-5347f78e31d5@sandeen.net>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19fbe9e4-c898-40b3-a4b5-5347f78e31d5@sandeen.net>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

On Sun, Mar 23, 2025 at 10:51:52AM -0500, Eric Sandeen wrote:
> On 3/21/25 5:05 PM, bodonnel@redhat.com wrote:
> > From: Bill O'Donnell <bodonnel@redhat.com>
> > 
> > In certain cases, if a block is so messed up that crc, uuid and magic
> > number are all bad, we need to not only detect in phase3 but fix it
> > properly in phase6. In the current code, the mechanism doesn't work
> > in that it only pays attention to one of the parameters.
> > 
> > Note: in this case, the nlink inode link count drops to 1, but
> > re-running xfs_repair fixes it back to 2. This is a side effect that
> > should probably be handled in update_inode_nlinks() with separate patch.
> > Regardless, running xfs_repair twice, with this patch applied
> > fixes the issue. Recognize that this patch is a fix for xfs v5.
> 
> The reason this fix leaves the inode nlinks in an inconsistent state
> is because the dir is (was) a longform directory (XFS_DIR2_FMT_BLOCK),
> and we go down this path with your patch in place:
> 
>                 /* check v5 metadata */
>                 if (xfs_has_crc(mp)) {
>                         error = check_dir3_header(mp, bp, ino);
>                         if (error) {
>                                 fixit++;
>                                 if (fmt == XFS_DIR2_FMT_BLOCK) { <==== true
>                                         goto out_fix;	<=== goto
>                                 }
> 
>                                 libxfs_buf_relse(bp);
>                                 bp = NULL;
>                                 continue;
>                         }
>                 }
> 
>                 longform_dir2_entry_check_data(mp, ip, num_illegal, need_dot,
>                                 irec, ino_offset, bp, hashtab,
>                                 &freetab, da_bno, fmt == XFS_DIR2_FMT_BLOCK);
> ...
> 
> out_fix:
> 
>         if (!no_modify && (fixit || dotdot_update)) {
>                 longform_dir2_rebuild(mp, ino, ip, irec, ino_offset, hashtab);
> 
> 
> longform_dir2_rebuild tries to rebuild the directory from the entries found
> via longform_dir2_entry_check_data() and placed in hashtab, but because we never
> called longform_dir2_entry_check_data(), hashtab is empty. This is why all
> entries in the problematic dir end up in lost+found.
> 
> That also means that longform_dir2_rebuild completes without adding any entries
> at all, and so the directory is now shortform. Because shortform directories 
> have no explicit "." entry, I think it would need an extra ref added at this
> point.
> 
> But I wonder - why not call longform_dir2_entry_check_data() before we check
> the header? That way it /will/ populate hashtab with any found entries in the
> block, and when the header is found to be corrupt, it will rebuild it with all
> entries intact, and leave nothing in lost+found.

Yes, this works as you describe.
Thanks-
Bill

