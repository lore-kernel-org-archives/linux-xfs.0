Return-Path: <SRS0=sZmN=5D=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4E27C10DCE
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Mar 2020 19:24:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8EFF62072C
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Mar 2020 19:24:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Sw8jEp2a"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726638AbgCRTYr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 Mar 2020 15:24:47 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:56860 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726631AbgCRTYr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Mar 2020 15:24:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584559485;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=R/Q/70qeGmxVMHa9r0iT9OL/7qOJPEwceRt7CQ/kfHw=;
        b=Sw8jEp2aoCNLSITtwPTCFuPVJ6whFwowT0RgyaBlOrPqeZqTR4HjfHqDOmSDYrtUg/d62W
        e5LJMBqkjb4egPIDjDJrwrrZy6D2KkEHxDNk9urZQndBeEszKzAXSTMC8Xv4sXcThpTDsE
        5g7QRD4tMNZMMbNdBhW/OKvgyhTZCsI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-330-ND3E3Px9MmaxmKTudXVibg-1; Wed, 18 Mar 2020 15:24:43 -0400
X-MC-Unique: ND3E3Px9MmaxmKTudXVibg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 29E8418AB2FB;
        Wed, 18 Mar 2020 19:24:41 +0000 (UTC)
Received: from localhost (dhcp-12-102.nay.redhat.com [10.66.12.102])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8353A90803;
        Wed, 18 Mar 2020 19:24:40 +0000 (UTC)
Date:   Thu, 19 Mar 2020 03:35:59 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     fstests <fstests@vger.kernel.org>
Cc:     Eryu Guan <guaneryu@gmail.com>, xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] generic/587: fix rounding error in quota/stat block
 comparison
Message-ID: <20200318193559.GH14282@dhcp-12-102.nay.redhat.com>
Mail-Followup-To: fstests <fstests@vger.kernel.org>,
        Eryu Guan <guaneryu@gmail.com>, xfs <linux-xfs@vger.kernel.org>
References: <20200318150142.GA256607@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200318150142.GA256607@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 18, 2020 at 08:01:42AM -0700, Darrick J. Wong wrote:
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

I've tested this patch. It's good to me. If we can add a simple comment before
doing "($3 + 1)", to explain why we need a "blocks + 1" at here, that would be
better for others read this code.

Reviewed-by: Zorro Lang <zlang@redhat.com>

>  tests/generic/587 |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/tests/generic/587 b/tests/generic/587
> index 7b07d07d..2ffa367d 100755
> --- a/tests/generic/587
> +++ b/tests/generic/587
> @@ -57,7 +57,8 @@ check_quota_accounting()
>  {
>  	$XFS_IO_PROG -c stat $testfile > $tmp.out
>  	cat $tmp.out >> $seqres.full
> -	local stat_blocks=$(grep 'stat.blocks' $tmp.out | awk '{print $3 / 2}')
> +	local stat_blocks=$(grep 'stat.blocks' $tmp.out | \
> +		awk '{printf("%d\n", ($3 + 1) / 2);}')
>  
>  	_report_quota_blocks $SCRATCH_MNT > $tmp.out
>  	cat $tmp.out >> $seqres.full
> 

