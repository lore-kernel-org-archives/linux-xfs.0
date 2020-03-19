Return-Path: <SRS0=LwPM=5E=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 984C6C4332D
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Mar 2020 03:54:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 68F9520753
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Mar 2020 03:54:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MEAI7zyz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726666AbgCSDyg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 Mar 2020 23:54:36 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:60110 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726596AbgCSDyf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Mar 2020 23:54:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584590074;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=eQj6eymn7n1uFoSqwFXSFIaRrKojfA0qIM5v6sQK8Ao=;
        b=MEAI7zyzkurHMuziydS9XxUGyVGll0S/L+oRsicEnfjpzTS8/7yoJJQCrA5kL59z1rTgLa
        nSyBADRPdFma84XFsJnZ4SgqcJIwX4Ld8YEisv3hppAHKCNnMEDkVqOCAtjUAoOPbxFkE2
        4Y+HNf12ALqjCOocmRocOpjDSfgkG2k=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-380-9_8zNvX6O5SA58R65skXSA-1; Wed, 18 Mar 2020 23:54:32 -0400
X-MC-Unique: 9_8zNvX6O5SA58R65skXSA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C74EC8017CC;
        Thu, 19 Mar 2020 03:54:31 +0000 (UTC)
Received: from localhost (dhcp-12-102.nay.redhat.com [10.66.12.102])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 42DC85C1D8;
        Thu, 19 Mar 2020 03:54:31 +0000 (UTC)
Date:   Thu, 19 Mar 2020 12:05:51 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     fstests <fstests@vger.kernel.org>
Cc:     Eryu Guan <guaneryu@gmail.com>, xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH v2] generic/587: fix rounding error in quota/stat block
 comparison
Message-ID: <20200319040551.GI14282@dhcp-12-102.nay.redhat.com>
Mail-Followup-To: fstests <fstests@vger.kernel.org>,
        Eryu Guan <guaneryu@gmail.com>, xfs <linux-xfs@vger.kernel.org>
References: <20200318150142.GA256607@magnolia>
 <20200318201136.GF256767@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200318201136.GF256767@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 18, 2020 at 01:11:36PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> It turns out that repquota (which reports in units of 1k blocks) reports
> rounded up numbers when the fs blocksize is 512 bytes.  However, xfs_io
> stat always reports block counts in units of 512 bytes.  If the number
> of (512b) file blocks is not an even number, the "$3 / 2" expression
> will round down, causing the test to fail.  Round up to the nearest 1k
> to match repquota's behavior.
> 
> Reported-by: zlang@redhat.com
> Fixes: 6b04ed05456fc6c ("generic: test unwritten extent conversion extent mapping quota accounting")
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
> v2: improve the comments to explain exactly what we're doing and why
> ---
>  tests/generic/587 |   10 +++++++---
>  1 file changed, 7 insertions(+), 3 deletions(-)
> 
> diff --git a/tests/generic/587 b/tests/generic/587
> index 7b07d07d..3e58a302 100755
> --- a/tests/generic/587
> +++ b/tests/generic/587
> @@ -51,13 +51,17 @@ ENDL
>  
>  # Make sure that the quota blocks accounting for qa_user on the scratch fs
>  # matches the stat blocks counter for the only file on the scratch fs that
> -# is owned by qa_user.  Note that stat reports in units of 512b blocks whereas
> -# repquota reports in units of 1k blocks.
> +# is owned by qa_user.
>  check_quota_accounting()
>  {
> +	# repquota rounds the raw numbers up to the nearest 1k when reporting
> +	# space usage.  xfs_io stat always reports space usage in 512b units,
> +	# so use an awk script to round this number up to the nearest 1k, just
> +	# like repquota does.

Yeah, it's better to have a comment to explain why we need a "+1" at here.
The V2 looks good to me too.

>  	$XFS_IO_PROG -c stat $testfile > $tmp.out
>  	cat $tmp.out >> $seqres.full
> -	local stat_blocks=$(grep 'stat.blocks' $tmp.out | awk '{print $3 / 2}')
> +	local stat_blocks=$(grep 'stat.blocks' $tmp.out | \
> +		awk '{printf("%d\n", ($3 + 1) / 2);}')
>  
>  	_report_quota_blocks $SCRATCH_MNT > $tmp.out
>  	cat $tmp.out >> $seqres.full
> 

