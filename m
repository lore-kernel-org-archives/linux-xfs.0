Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6219C433E6
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Feb 2021 17:21:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 83D5664DF2
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Feb 2021 17:21:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232912AbhBIRVo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 9 Feb 2021 12:21:44 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:36176 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232868AbhBIRVn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 9 Feb 2021 12:21:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612891217;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=AtZdqpo6aB6H51HC+6gWuFXmjz5/Qu5JraGjWVk9O90=;
        b=G4alU07kjnJigw8n/z66mQ6JJdXoKAQ3yXouoWWqOka1UYdtf84j0Vb+Cb+KUqNuthag8S
        4fKdXdrZOYnzrMJnAYY5VDEZBOpXVUVS/L+0SvEykCCTEMKwz9/KEGaHgGnrmHu4lCMqcu
        OzrqjoP/lPn0vbM3Y0bZeY/8/LjrfeM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-406-wH47Om96Nb6cvjBnTgq_Vg-1; Tue, 09 Feb 2021 12:20:15 -0500
X-MC-Unique: wH47Om96Nb6cvjBnTgq_Vg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E27781009618;
        Tue,  9 Feb 2021 17:20:13 +0000 (UTC)
Received: from bfoster (ovpn-113-234.rdu2.redhat.com [10.10.113.234])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 746BE171F4;
        Tue,  9 Feb 2021 17:20:13 +0000 (UTC)
Date:   Tue, 9 Feb 2021 12:20:11 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 05/10] xfs_repair: clear quota CHKD flags on the incore
 superblock too
Message-ID: <20210209172011.GC14273@bfoster>
References: <161284380403.3057868.11153586180065627226.stgit@magnolia>
 <161284383258.3057868.6167060787728229726.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161284383258.3057868.6167060787728229726.stgit@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Feb 08, 2021 at 08:10:32PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> At the end of a repair run, xfs_repair clears the superblock's quota
> checked flags if it found mistakes in the quota accounting to force a
> quotacheck at the next mount.  This is currently the last time repair
> modifies the primary superblock, so it is sufficient to update the
> ondisk buffer and not the incore mount structure.
> 
> However, we're about to introduce code to clear the needsrepair feature
> at the very end of repair, after all metadata blocks have been written
> to disk and all disk caches flush.  Since the convention everywhere else
> in xfs is to update the incore superblock, call libxfs_sb_to_disk to
> translate that into the ondisk buffer, and then write the buffer to
> disk, switch the quota CHKD code to use this mechanism too.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  repair/xfs_repair.c |    7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
> 
> 
> diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
> index 9409f0d8..32755821 100644
> --- a/repair/xfs_repair.c
> +++ b/repair/xfs_repair.c
> @@ -1108,10 +1108,9 @@ _("Warning:  project quota information would be cleared.\n"
>  	if ((mp->m_sb.sb_qflags & XFS_ALL_QUOTA_CHKD) != quotacheck_results()) {
>  		do_warn(_("Note - quota info will be regenerated on next "
>  			"quota mount.\n"));
> -		dsb->sb_qflags &= cpu_to_be16(~(XFS_UQUOTA_CHKD |
> -						XFS_GQUOTA_CHKD |
> -						XFS_PQUOTA_CHKD |
> -						XFS_OQUOTA_CHKD));
> +		mp->m_sb.sb_qflags &= ~(XFS_UQUOTA_CHKD | XFS_GQUOTA_CHKD |
> +					XFS_PQUOTA_CHKD | XFS_OQUOTA_CHKD);
> +		libxfs_sb_to_disk(sbp->b_addr, &mp->m_sb);

Nit: we can still use dsb here instead of open-coding the buffer
address. Otherwise:

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  	}
>  
>  	if (copied_sunit) {
> 

