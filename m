Return-Path: <SRS0=lRpT=32=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34B06C2D0B1
	for <linux-xfs@archiver.kernel.org>; Thu,  6 Feb 2020 04:40:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 012BB20661
	for <linux-xfs@archiver.kernel.org>; Thu,  6 Feb 2020 04:40:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OnOzBHdo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727728AbgBFEkz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 5 Feb 2020 23:40:55 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:24434 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727572AbgBFEkz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 5 Feb 2020 23:40:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580964054;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=X8TKYvFWE6LeY5/Rq0YIg3zM8oyz4ehPS9JrtGrDuUE=;
        b=OnOzBHdoHZ3qV8yWNKhlt3MJ/hAk4XZgF33n0qNcUGpN1FBsKL1AldkEIMv0ktkyt4kjtN
        7igbhGxQGJWNkukb1kPfpv2xno+hObZT8WdSUXiaJWtQR01iT9ZcHqa5lwMH/iRmJKPFYy
        dnoF0Zq03OOnlFG5Le4nQJVViAUxnhI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-77-j-53BtRGP2upxaUX1gUJcQ-1; Wed, 05 Feb 2020 23:40:50 -0500
X-MC-Unique: j-53BtRGP2upxaUX1gUJcQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5D8631137841;
        Thu,  6 Feb 2020 04:40:49 +0000 (UTC)
Received: from localhost (dhcp-12-102.nay.redhat.com [10.66.12.102])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C7624863AB;
        Thu,  6 Feb 2020 04:40:48 +0000 (UTC)
Date:   Thu, 6 Feb 2020 12:50:42 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 4/5] xfs/117: fix inode corruption loop
Message-ID: <20200206045042.GR14282@dhcp-12-102.nay.redhat.com>
Mail-Followup-To: "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org
References: <158086090225.1989378.6869317139530865842.stgit@magnolia>
 <158086092701.1989378.15455195869104309401.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158086092701.1989378.15455195869104309401.stgit@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Feb 04, 2020 at 04:02:07PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> `seq X Y` will print all numbers between X and Y, including Y.  Since
> inode chunks contain inodes numbered from X to X+63, we need to set the
> loop variables correctly.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  tests/xfs/117 |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> 
> diff --git a/tests/xfs/117 b/tests/xfs/117
> index 0a7831d5..e3249623 100755
> --- a/tests/xfs/117
> +++ b/tests/xfs/117
> @@ -70,7 +70,7 @@ echo "+ check fs"
>  _scratch_xfs_repair -n >> $seqres.full 2>&1 || _fail "xfs_repair should not fail"
>  
>  echo "+ corrupt image"
> -seq "${inode}" "$((inode + 64))" | while read ino; do
> +seq "${inode}" "$((inode + 63))" | while read ino; do

This makes more sense, good to me.

>  	_scratch_xfs_db -x -c "inode ${ino}" -c "stack" -c "blocktrash -x 32 -y $((blksz * 8)) -z ${FUZZ_ARGS}" >> $seqres.full 2>&1
>  done
>  
> 

