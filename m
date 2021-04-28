Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73D42C433B4
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Apr 2021 17:47:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3EEF561107
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Apr 2021 17:47:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242688AbhD1Rs3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 28 Apr 2021 13:48:29 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:38772 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242717AbhD1RsZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 28 Apr 2021 13:48:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619632059;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=drB3o/MiYgDqr8IxUrlFg5juuvQ0VeT4f34Qbw6CKD8=;
        b=UrVNZLLLwtr+pXs65+BfZx2BxJdQwWvSqzcDelm68m3db9Wi/WrudQNCETqclE20ZD0tD+
        eP69y3dfw6ouOSE4rzkU7gKC161j3SfNiLfu5KyUevxiKsfEBoaJUAF1uer0PunRTd7jiv
        F3vBbzWD7BJA3gL8C9R7tTgq9fZmNGw=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-427-wq6Q_aOIPaGLXuYHklP4Mw-1; Wed, 28 Apr 2021 13:47:36 -0400
X-MC-Unique: wq6Q_aOIPaGLXuYHklP4Mw-1
Received: by mail-qk1-f199.google.com with SMTP id g184-20020a3784c10000b02902e385de9adaso25554552qkd.3
        for <linux-xfs@vger.kernel.org>; Wed, 28 Apr 2021 10:47:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=drB3o/MiYgDqr8IxUrlFg5juuvQ0VeT4f34Qbw6CKD8=;
        b=B6WHzMTAfBYGqKyMem4zYu+IiIQRdN2yolnoX6Av3IUrWK150XM/L54fTMDGLgdRKq
         a8ziqWE0cp8FK2ejbBGmqelAIpjI3GUqKs02cvVk5+MKWCpUg+G0dTYK+gFwsEOG6O8o
         DKOmh02k5S1GUHqSxwEf2J86Xh5kFBtsTEBPSubR57MURsCEhcUgbGY8ciiLmtG8cZcW
         URR0UrBJV5qJHXaTRtHli9Nn220wMSuevShrI1z7lb3O98iLF0vsSHuATYK3mY/0NFD2
         /MPT482B3oCeCGBd0nsJ5nvnIpqlVJwSjbmb+Y1co0aqHasd/h/2JiDNRBbjX12ZuCA4
         sQDQ==
X-Gm-Message-State: AOAM531eHzZvp6aa/nQCIio8CTbqOrmoO842JDsV4KUAT8fdsMS0dNYw
        3+2zbYn0Ec1aFmN2i0x9w9IZ+wBZnzGFIyBEETud43ZiQTUs7JLJ5O6QCYPC8vvTZPXy0ipW1Mv
        T+3v7ar5faAKSkROuLfIo
X-Received: by 2002:a37:a4c6:: with SMTP id n189mr11069613qke.65.1619632056512;
        Wed, 28 Apr 2021 10:47:36 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxgZ4je+l4tE2bAuozCWbOmXjD/4Bgs6MrgJUcKE6VnX60m9VSha/tPPnLX15cjfdDMoU7YUA==
X-Received: by 2002:a37:a4c6:: with SMTP id n189mr11069598qke.65.1619632056344;
        Wed, 28 Apr 2021 10:47:36 -0700 (PDT)
Received: from bfoster ([98.216.211.229])
        by smtp.gmail.com with ESMTPSA id n16sm515524qtl.48.2021.04.28.10.47.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Apr 2021 10:47:35 -0700 (PDT)
Date:   Wed, 28 Apr 2021 13:47:33 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
Subject: Re: [PATCH 3/5] generic/449: always fill up the data device
Message-ID: <YImftSB+Pa/LRZug@bfoster>
References: <161958293466.3452351.14394620932744162301.stgit@magnolia>
 <161958295276.3452351.11071488836337123863.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161958295276.3452351.11071488836337123863.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Apr 27, 2021 at 09:09:12PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> This is yet another one of those tests that looks at what happens when
> we run out of space for more metadata (in this case, xattrs).  Make sure
> that the 256M we write to the file to try to stimulate ENOSPC gets
> written to the same place that xfs puts xattr data -- the data device.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  tests/generic/449 |    5 +++++
>  1 file changed, 5 insertions(+)
> 
> 
> diff --git a/tests/generic/449 b/tests/generic/449
> index a2d882df..5fd15367 100755
> --- a/tests/generic/449
> +++ b/tests/generic/449
> @@ -43,6 +43,11 @@ _require_attrs trusted
>  _scratch_mkfs_sized $((256 * 1024 * 1024)) >> $seqres.full 2>&1
>  _scratch_mount || _fail "mount failed"
>  
> +# This is a test of xattr behavior when we run out of disk space for xattrs,
> +# so make sure the pwrite goes to the data device and not the rt volume.
> +test "$FSTYP" = "xfs" && \
> +	$XFS_IO_PROG -c 'chattr -t' $SCRATCH_MNT
> +

This seems like the type of thing we'll consistently be playing
whack-a-mole with unless we come up with a better way to manage it. I'm
not sure what the solution for that is though, so:

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  TFILE=$SCRATCH_MNT/testfile.$seq
>  
>  # Create the test file and choose its permissions
> 

