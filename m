Return-Path: <SRS0=8N9+=DU=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F17DC433DF
	for <linux-xfs@archiver.kernel.org>; Tue, 13 Oct 2020 11:07:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 166A4214DB
	for <linux-xfs@archiver.kernel.org>; Tue, 13 Oct 2020 11:07:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="H9qrdony"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727097AbgJMLHQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 13 Oct 2020 07:07:16 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:32230 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726510AbgJMLHQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 13 Oct 2020 07:07:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602587235;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=JgxsR0jY+AfHpFJp3QRRRoWhl4CRLiW+dT+RGfFF/+k=;
        b=H9qrdonyX9b9p/i11PB8MzhffRbmv1cqXyCAIh0eg9RNrFMDomeqg2WUlT0aT3Y4eqllE+
        6ePxmyoqcfrSBGGC6Q8g9Qt3Va2WdKjAJy97fHClG3LayT42YnWux3NOcGS1+HttxESsae
        SX3VlpRKMxG0ujMdcN9QSyaFelRoyd4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-487-H-YJ6WeGP8q2qHjJoe6Guw-1; Tue, 13 Oct 2020 07:07:13 -0400
X-MC-Unique: H-YJ6WeGP8q2qHjJoe6Guw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8BBD1107464F
        for <linux-xfs@vger.kernel.org>; Tue, 13 Oct 2020 11:07:12 +0000 (UTC)
Received: from bfoster (ovpn-112-249.rdu2.redhat.com [10.10.112.249])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 29CC25C1C2;
        Tue, 13 Oct 2020 11:07:12 +0000 (UTC)
Date:   Tue, 13 Oct 2020 07:07:10 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Pavel Reichl <preichl@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v11 4/4] xfs: replace mrlock_t with rw_semaphores
Message-ID: <20201013110710.GC966478@bfoster>
References: <20201009195515.82889-1-preichl@redhat.com>
 <20201009195515.82889-5-preichl@redhat.com>
 <20201012160412.GK917726@bfoster>
 <a6afba10-64a2-a30c-94de-e99a324a6114@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a6afba10-64a2-a30c-94de-e99a324a6114@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Oct 12, 2020 at 11:02:51PM +0200, Pavel Reichl wrote:
> 
> > ...
> >> @@ -384,16 +385,17 @@ xfs_isilocked(
> >>  	struct xfs_inode	*ip,
> >>  	uint			lock_flags)
> >>  {
> >> -	if (lock_flags & (XFS_ILOCK_EXCL|XFS_ILOCK_SHARED)) {
> >> -		if (!(lock_flags & XFS_ILOCK_SHARED))
> >> -			return !!ip->i_lock.mr_writer;
> >> -		return rwsem_is_locked(&ip->i_lock.mr_lock);
> >> +	if (lock_flags & (XFS_ILOCK_EXCL | XFS_ILOCK_SHARED)) {
> >> +		ASSERT(!(lock_flags & ~(XFS_ILOCK_EXCL | XFS_ILOCK_SHARED)));
> >> +		return __xfs_rwsem_islocked(&ip->i_lock,
> >> +				(lock_flags >> XFS_ILOCK_FLAG_SHIFT));
> >>  	}
> >>  
> >> -	if (lock_flags & (XFS_MMAPLOCK_EXCL|XFS_MMAPLOCK_SHARED)) {
> >> -		if (!(lock_flags & XFS_MMAPLOCK_SHARED))
> >> -			return !!ip->i_mmaplock.mr_writer;
> >> -		return rwsem_is_locked(&ip->i_mmaplock.mr_lock);
> >> +	if (lock_flags & (XFS_MMAPLOCK_EXCL | XFS_MMAPLOCK_SHARED)) {
> >> +		ASSERT(!(lock_flags &
> >> +			~(XFS_MMAPLOCK_EXCL | XFS_MMAPLOCK_SHARED)));
> >> +		return __xfs_rwsem_islocked(&ip->i_mmaplock,
> >> +				(lock_flags >> XFS_MMAPLOCK_FLAG_SHIFT));
> >>  	}
> >>  
> >>  	if (lock_flags & (XFS_IOLOCK_EXCL | XFS_IOLOCK_SHARED)) {
> > 
> > Can we add a similar assert for this case as we have for the others?
> > Otherwise the rest looks fairly straightforward to me.
> > 
> 
> Sure we can! But do we want to?
> 
> I think that these asserts are supposed to make sure that only flags for one of the inode's locks are used eg. ILOCK, MMAPLOCK or IOLOCK but no combination! So if we reach this 3rd condition we already know that the flags for ILOCK and MMAPLOCK were not set. However if there's possibility for more locks to be added in the future or just for the 'code symmetry' purposes - I have no problem to update the code.
>  
> 

Fair point. I do tend to agree with Darrick that I'd rather not rely on
even mildly tricky/subtle logic to optimize away things like asserts
(that are already optimized away on production kernels). Somebody could
come along, refactor this function and very easily gloss over the fact
that particular checks are missing. That said, I suppose it's
technically dead code with the current logic so it's not that big of a
deal IMO.

Brian

