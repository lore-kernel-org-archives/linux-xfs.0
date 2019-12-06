Return-Path: <SRS0=r/Pz=Z4=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA532C43603
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Dec 2019 06:51:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9C74A24679
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Dec 2019 06:51:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="D+9fjajK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726214AbfLFGvV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 6 Dec 2019 01:51:21 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:35881 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726104AbfLFGvU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 6 Dec 2019 01:51:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575615079;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YqTOqD21JmdNvahJz1XWlE4TrA7WcM03PzsvpT9irh4=;
        b=D+9fjajKiV+bzlt6aDk+O/eEeiWS1zRzyyTb1B6Q3mVCevz8Cf6nA7av8WjP1j8qaEMYO1
        d/6QsD/ZQUZZ/xUfm/6CLBJpZX0uoqhZeNom3fbtZeSJNm2ieebNiXseyB1fcg6MO5VWJW
        xlCdiNRiDeU6HNcsvsHjHTqs0oxht6A=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-57-Hv_K7ohYPWiNt1DqV7fuVA-1; Fri, 06 Dec 2019 01:51:17 -0500
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6F8C68017DF;
        Fri,  6 Dec 2019 06:51:16 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 65692600D1;
        Fri,  6 Dec 2019 06:51:16 +0000 (UTC)
Received: from zmail23.collab.prod.int.phx2.redhat.com (zmail23.collab.prod.int.phx2.redhat.com [10.5.83.28])
        by colo-mx.corp.redhat.com (Postfix) with ESMTP id 5AA9365D35;
        Fri,  6 Dec 2019 06:51:16 +0000 (UTC)
Date:   Fri, 6 Dec 2019 01:51:16 -0500 (EST)
From:   Xiaoli Feng <xifeng@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Eryu Guan <guaneryu@gmail.com>,
        Yang Xu <xuyang2018.ky@cn.fujitsu.com>,
        fstests <fstests@vger.kernel.org>,
        xfs <linux-xfs@vger.kernel.org>
Message-ID: <443856653.20019671.1575615076055.JavaMail.zimbra@redhat.com>
In-Reply-To: <20191204023642.GD7328@magnolia>
References: <20191204023642.GD7328@magnolia>
Subject: Re: [PATCH] xfs/148: sort attribute list output
MIME-Version: 1.0
X-Originating-IP: [10.72.12.224, 10.4.195.14]
Thread-Topic: xfs/148: sort attribute list output
Thread-Index: xZOT9Gl2XMZBM8n0f5pP8Qbd1ECoPA==
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-MC-Unique: Hv_K7ohYPWiNt1DqV7fuVA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi,

----- Original Message -----
> From: "Darrick J. Wong" <darrick.wong@oracle.com>
> To: "Eryu Guan" <guaneryu@gmail.com>
> Cc: "Yang Xu" <xuyang2018.ky@cn.fujitsu.com>, "fstests" <fstests@vger.kernel.org>, "xfs" <linux-xfs@vger.kernel.org>
> Sent: Wednesday, December 4, 2019 10:36:42 AM
> Subject: [PATCH] xfs/148: sort attribute list output
> 
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Yang Xu reported a test failure in xfs/148 that I think comes from
> extended attributes being returned in a different order than they were
> set.  Since order isn't important in this test, sort the output to make
> it consistent.
> 
> Reported-by: Yang Xu <xuyang2018.ky@cn.fujitsu.com>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  tests/xfs/148     |    2 +-
>  tests/xfs/148.out |    4 ++--
>  2 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/tests/xfs/148 b/tests/xfs/148
> index 42cfdab0..ec1d0ece 100755
> --- a/tests/xfs/148
> +++ b/tests/xfs/148
> @@ -76,7 +76,7 @@ test_names+=("too_many" "are_bad/for_you")
>  
>  access_stuff() {
>  	ls $testdir
> -	$ATTR_PROG -l $testfile
> +	$ATTR_PROG -l $testfile | grep 'a_' | sort
>  
>  	for name in "${test_names[@]}"; do
>  		ls "$testdir/f_$name"
> diff --git a/tests/xfs/148.out b/tests/xfs/148.out
> index c301ecb6..f95b55b7 100644
> --- a/tests/xfs/148.out
> +++ b/tests/xfs/148.out
> @@ -4,10 +4,10 @@ f_another
>  f_are_bad_for_you
>  f_something
>  f_too_many_beans
> +Attribute "a_another" has a 3 byte value for TEST_DIR/mount-148/testfile
> +Attribute "a_are_bad_for_you" has a 3 byte value for

From my test on RHEL8&RHEL7, when touch a file, there is a default attribute:
Attribute "selinux" has a 37 byte value for TEST_DIR/mount-148/testfile
Could you share the OS you test?

Thanks.

> TEST_DIR/mount-148/testfile
>  Attribute "a_something" has a 3 byte value for TEST_DIR/mount-148/testfile
>  Attribute "a_too_many_beans" has a 3 byte value for
>  TEST_DIR/mount-148/testfile
> -Attribute "a_are_bad_for_you" has a 3 byte value for
> TEST_DIR/mount-148/testfile
> -Attribute "a_another" has a 3 byte value for TEST_DIR/mount-148/testfile
>  TEST_DIR/mount-148/testdir/f_something
>  Attribute "a_something" had a 3 byte value for TEST_DIR/mount-148/testfile:
>  heh
> 
> 

