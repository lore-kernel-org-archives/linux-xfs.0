Return-Path: <SRS0=P3J0=4X=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC7D1C10F25
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Mar 2020 09:22:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C557B20848
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Mar 2020 09:22:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bxC8SFpm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725855AbgCFJWk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 6 Mar 2020 04:22:40 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:31726 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726162AbgCFJWk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 6 Mar 2020 04:22:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583486558;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=GqDzJrEnUL3t6EcmzutSGSoXkRGW9+zbh09QQ+zpyUk=;
        b=bxC8SFpmOeehccfiDVe2/Ujt75zZus8dYuknoSv8mOwdSTihlsayLwjkXu9abZtuVxrvJX
        XdobSdj5qFpwni5bJV/Jc0XpATT8DMxmY1kpRcdTvjMcmINFTQRnbSjXvHGOk6PM9xScOn
        FnqvC2RBqz4FAlHA1TQP4C/Rza86/mU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-269-PkOUhdKrOs-EhClK4fNZbQ-1; Fri, 06 Mar 2020 04:22:35 -0500
X-MC-Unique: PkOUhdKrOs-EhClK4fNZbQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B00238017CC;
        Fri,  6 Mar 2020 09:22:34 +0000 (UTC)
Received: from localhost (dhcp-12-102.nay.redhat.com [10.66.12.102])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 25BB348;
        Fri,  6 Mar 2020 09:22:33 +0000 (UTC)
Date:   Fri, 6 Mar 2020 17:33:22 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     fstests@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/3] generic/402: skip test if xfs_io can't parse the
 date value
Message-ID: <20200306093322.GX14282@dhcp-12-102.nay.redhat.com>
Mail-Followup-To: fstests@vger.kernel.org, linux-xfs@vger.kernel.org
References: <158328998787.2374922.4223951558305234252.stgit@magnolia>
 <158328999421.2374922.12052887381904972734.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158328999421.2374922.12052887381904972734.stgit@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 03, 2020 at 06:46:34PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> If xfs_io's utimes command cannot interpret the arguments that are given
> to it, it will print out "Bad value for [am]time".  Detect when this
> happens and drop the file out of the test entirely.
> 
> This is particularly noticeable on 32-bit platforms and the largest
> timestamp seconds supported by the filesystem is INT_MAX.  In this case,
> the maximum value we can cram into tv_sec is INT_MAX, and there is no
> way to actually test setting a timestamp of INT_MAX + 1 to test the
> clamping.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> Reviewed-by: Amir Goldstein <amir73il@gmail.com>
> ---

Looks good to me.

>  tests/generic/402 |   20 ++++++++++++++++++--
>  1 file changed, 18 insertions(+), 2 deletions(-)
> 
> 
> diff --git a/tests/generic/402 b/tests/generic/402
> index 2a34d127..2481a5d2 100755
> --- a/tests/generic/402
> +++ b/tests/generic/402
> @@ -63,10 +63,26 @@ run_test_individual()
>  	# check if the time needs update
>  	if [ $update_time -eq 1 ]; then
>  		echo "Updating file: $file to timestamp $timestamp"  >> $seqres.full
> -		$XFS_IO_PROG -f -c "utimes $timestamp 0 $timestamp 0" $file
> -		if [ $? -ne 0 ]; then
> +		rm -f $tmp.utimes
> +		$XFS_IO_PROG -f -c "utimes $timestamp 0 $timestamp 0" $file > $tmp.utimes 2>&1
> +		local res=$?
> +
> +		cat $tmp.utimes >> $seqres.full
> +		if [ "$timestamp" -ne 0 ] && grep -q "Bad value" "$tmp.utimes"; then
> +			echo "xfs_io could not interpret time value \"$timestamp\", skipping \"$file\" test." >> $seqres.full
> +			rm -f $file $tmp.utimes
> +			return
> +		fi
> +		cat $tmp.utimes
> +		rm -f $tmp.utimes
> +		if [ $res -ne 0 ]; then
>  			echo "Failed to update times on $file" | tee -a $seqres.full
>  		fi
> +	else
> +		if [ ! -f "$file" ]; then
> +			echo "xfs_io did not create file for time value \"$timestamp\", skipping test." >> $seqres.full
> +			return
> +		fi
>  	fi
>  
>  	tsclamp=$((timestamp<tsmin?tsmin:timestamp>tsmax?tsmax:timestamp))
> 

