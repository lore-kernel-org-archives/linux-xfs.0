Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 105A2EB64DD
	for <linux-xfs@archiver.kernel.org>; Tue,  4 Jul 2023 13:53:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229645AbjGDNxp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 4 Jul 2023 09:53:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231148AbjGDNxo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 Jul 2023 09:53:44 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 758A0BE
        for <linux-xfs@vger.kernel.org>; Tue,  4 Jul 2023 06:52:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1688478777;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=s2arULlihPx+alvBnLxpjFitWjbTRZ08gyjzH/+hsu0=;
        b=CDgtWD0wLYXjPye1y7DqgSr4TB8HKmjMfO3NoBSBm6gTI/EgoTCBRgpHbYkPzNkcHajQls
        F0j63sgvkmXjnRXgyVsdNPE5VhxL0aPBkS41WSAtXOJCMDso+Gtq+OMIZMhzp75Naekr0i
        ayX+APe3bw61EEOVIJuHZhIRQMk8SwI=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-114-CVVvni9MNLeh_TEkDLpmFA-1; Tue, 04 Jul 2023 09:52:55 -0400
X-MC-Unique: CVVvni9MNLeh_TEkDLpmFA-1
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-400a393268cso59243631cf.3
        for <linux-xfs@vger.kernel.org>; Tue, 04 Jul 2023 06:52:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688478774; x=1691070774;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=s2arULlihPx+alvBnLxpjFitWjbTRZ08gyjzH/+hsu0=;
        b=K3uP2rZ7K+O028pJDGYIuAnvKUI128vjXKsNuZ/1gX/axA/U+nWDikQgFGw7MSmixG
         t+sTJyn0TJg5Y4y4vvhyB3JZ6pDhjvfqKDscwsE59RqZsBDspOAVkNqTEXDlZTSU7qza
         BDh+B29B9nNBfjf4BYwp93hp9keRji+5snv7pEkpTAe6GeTM7Fj4r9zexdWjNIjF7tWS
         jZ8IKwEK1D8W0RP0cp1sOjLnbrEH96RjLPz197AnvRFsBRWEltz1Y3E4n2R2SAh6HDyZ
         p0kfsVrCwHNNV6+hyyFAXKyxr/1M0DySt2jcf/eJ2oeAq6etxmomid4kMJgTvOhy2pj7
         PAVQ==
X-Gm-Message-State: AC+VfDw9Yz5BpOi6jdzskLJm6xeXy/2G2vFbCn1r8L0qr2YY3T3e7ZyX
        xSaRzAqdgezsqbRn4SGgtMdUbR9HoEL7uVaDa7SxZ1yjnmTY9aL24cCLLywf0E9Kws65IOOO5Hs
        N1a5Q79xXxks5BSWI4KEVzdLqzOw=
X-Received: by 2002:ac8:5a49:0:b0:403:2e12:69af with SMTP id o9-20020ac85a49000000b004032e1269afmr14012095qta.55.1688478774693;
        Tue, 04 Jul 2023 06:52:54 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7E9kHUoh0dd2H+8k/11lO9fCn5h3hdyCONUX9JExbg79EJ2imUN0unochH45cH7dgJ7p1ggQ==
X-Received: by 2002:ac8:5a49:0:b0:403:2e12:69af with SMTP id o9-20020ac85a49000000b004032e1269afmr14012078qta.55.1688478774401;
        Tue, 04 Jul 2023 06:52:54 -0700 (PDT)
Received: from aalbersh.remote.csb ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id f3-20020ac80683000000b003ef189ffa82sm1763192qth.90.2023.07.04.06.52.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Jul 2023 06:52:54 -0700 (PDT)
Date:   Tue, 4 Jul 2023 15:52:51 +0200
From:   Andrey Albershteyn <aalbersh@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     zlang@redhat.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
Subject: Re: [PATCH 1/5] xfs/529: fix bogus failure when realtime is
 configured
Message-ID: <20230704135251.epcdagmqd3mseonp@aalbersh.remote.csb>
References: <168840381298.1317961.1436890061506567407.stgit@frogsfrogsfrogs>
 <168840381873.1317961.17241883212352752910.stgit@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <168840381873.1317961.17241883212352752910.stgit@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 2023-07-03 10:03:38, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> If I have a realtime volume configured, this test will sometimes trip
> over this:
> 
> XFS: Assertion failed: nmaps == 1, file: fs/xfs/xfs_dquot.c, line: 360
> Call Trace:
>  xfs_dquot_disk_alloc+0x3dc/0x400 [xfs 97e1fa8953d397b1fb9732df4de7fa9070bda501]
>  xfs_qm_dqread+0xc9/0x190 [xfs 97e1fa8953d397b1fb9732df4de7fa9070bda501]
>  xfs_qm_dqget+0xa8/0x230 [xfs 97e1fa8953d397b1fb9732df4de7fa9070bda501]
>  xfs_qm_vop_dqalloc+0x160/0x600 [xfs 97e1fa8953d397b1fb9732df4de7fa9070bda501]
>  xfs_setattr_nonsize+0x318/0x520 [xfs 97e1fa8953d397b1fb9732df4de7fa9070bda501]
>  notify_change+0x30e/0x490
>  chown_common+0x13e/0x1f0
>  do_fchownat+0x8d/0xe0
>  __x64_sys_fchownat+0x1b/0x20
>  do_syscall_64+0x2b/0x80
>  entry_SYSCALL_64_after_hwframe+0x46/0xb0
> RIP: 0033:0x7fa6985e2cae
> 
> The test injects the bmap_alloc_minlen_extent error, which refuses to
> allocate file space unless it's exactly minlen long.  However, a
> precondition of this injection point is that the free space on the data
> device must be sufficiently fragmented that there are small free
> extents.
> 
> However, if realtime and rtinherit are enabled, the punch-alternating
> call will operate on a realtime file, which only serves to write 0x55
> patterns into the realtime bitmap.  Hence the test preconditions are not
> satisfied, so the test is not serving its purpose.
> 
> Fix it by disabling rtinherit=1 on the rootdir so that we actually
> fragment the bnobt/cntbt as required.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  tests/xfs/529 |    4 ++++
>  1 file changed, 4 insertions(+)
> 
> 
> diff --git a/tests/xfs/529 b/tests/xfs/529
> index 83d24da0ac..cd176877f5 100755
> --- a/tests/xfs/529
> +++ b/tests/xfs/529
> @@ -32,6 +32,10 @@ echo "Format and mount fs"
>  _scratch_mkfs_sized $((512 * 1024 * 1024)) >> $seqres.full
>  _scratch_mount -o uquota >> $seqres.full
>  
> +# bmap_alloc_minlen_extent only applies to the datadev space allocator, so
> +# we force the filesystem not to use the realtime volume.
> +_xfs_force_bdev data $SCRATCH_MNT
> +

Looks good to me:
Reviewed-by: Andrey Albershteyn <aalbersh@redhat.com>

-- 
- Andrey

