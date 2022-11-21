Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C777AC43219
	for <linux-xfs@archiver.kernel.org>; Mon, 21 Nov 2022 18:49:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230083AbiKUStG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 21 Nov 2022 13:49:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230200AbiKUSs6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 21 Nov 2022 13:48:58 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6A60E03B
        for <linux-xfs@vger.kernel.org>; Mon, 21 Nov 2022 10:47:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669056472;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=90vDbyo7NOB3NjwY6BQxR0A7z0eejg5MoS7d5cHbTkI=;
        b=IGOAB+926q6o1bwTGIehXGJfA0U0latYrzgckJPWrsUfxwH0G9ZAgq+p0t1mIxXucvSMKj
        0837Vk4ZmISAQ3lnlFxIlBl3KGY71CsOaNYE9p8qnjmPY5NnnCfMC/NQYF8qdjFQHVPR+d
        jjylb5PYt3Vfq4l6PwXwkWatz7nUlSA=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-617-_PyHG2mvOG-sRdqNvMPQgA-1; Mon, 21 Nov 2022 13:47:51 -0500
X-MC-Unique: _PyHG2mvOG-sRdqNvMPQgA-1
Received: by mail-pl1-f198.google.com with SMTP id l7-20020a170902f68700b001890d921b36so5532560plg.2
        for <linux-xfs@vger.kernel.org>; Mon, 21 Nov 2022 10:47:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=90vDbyo7NOB3NjwY6BQxR0A7z0eejg5MoS7d5cHbTkI=;
        b=8NiMqYGaTSrhCcd9mXYCqBKeolnOqrhv3Aaj/sPEvmkWzVwhOo7eyAXMx6juy/dFpB
         sp6rOnAk1hMyMeUgvAwnZtu4qZprRP7OON/YzE1nelzrTANtvf05alAuRZnHU1hh4hfW
         ktmO6zZaxMJKfV+lvdlD2oeuXJveZ60OOBScYFcqmdZCDpfqeAwScNz/xReJKSeAM1dK
         i26Pc7lLREyOaUWPz2UIAM/utS6J12WSgwkdavFEbwzckf1ACjf+RpcrsorIfXVG7HjY
         ejtnP7UTMLnwh8d2mPIRqOxap4U3lHrOiVkOfaFszBOLrVFWON6qZchDDYupxE9vJwtr
         M+TQ==
X-Gm-Message-State: ANoB5pluS/8/nd8SIXwdFRvk9XdxS9btFmQSovaYWx1aPbPLchb5b+1y
        7K1EX4AHpMYBZG3TZn0nQzKAo2wTJG+OfktJSR/EC/qnSUikQSA4bOwuOybi9fdSBl89kLS0McQ
        T6wcJWwy7bjTo5RaVXalfStoPlrSvsMoq+twxvHfcRDyniOfKRgTYl4jiimYCx57zcyL1
X-Received: by 2002:a63:ec50:0:b0:476:df9e:e792 with SMTP id r16-20020a63ec50000000b00476df9ee792mr3183506pgj.210.1669056470275;
        Mon, 21 Nov 2022 10:47:50 -0800 (PST)
X-Google-Smtp-Source: AA0mqf7lBXin8DWHlndR2w3nvhKNGtssia51ze33I5RtFlX8RSea/yhQEeXuX1GnSHpqzBS6342NkQ==
X-Received: by 2002:a63:ec50:0:b0:476:df9e:e792 with SMTP id r16-20020a63ec50000000b00476df9ee792mr3183458pgj.210.1669056469546;
        Mon, 21 Nov 2022 10:47:49 -0800 (PST)
Received: from zlang-mailbox ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id ip13-20020a17090b314d00b00212cf2fe8c3sm24396836pjb.1.2022.11.21.10.47.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Nov 2022 10:47:49 -0800 (PST)
Date:   Tue, 22 Nov 2022 02:47:45 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     fstests@vger.kernel.org
Subject: Re: [PATCH] nfs: test files written size as expected
Message-ID: <20221121184745.p3duc7thj53s5fgv@zlang-mailbox>
References: <20221105032329.2067299-1-zlang@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221105032329.2067299-1-zlang@kernel.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Nov 05, 2022 at 11:23:29AM +0800, Zorro Lang wrote:
> Test nfs and its underlying fs, make sure file size as expected
> after writting a file, and the speculative allocation space can
> be shrunken.
> 
> Signed-off-by: Zorro Lang <zlang@kernel.org>
> ---
> 
> Hi,
> 
> The original bug reproducer is:
> 1. mount nfs3 backed by xfs
> 2. dd if=/dev/zero of=/nfs/10M bs=1M count=10
> 3. du -sh /nfs/10M                           
> 16M	/nfs/10M 
> 
> As this was a xfs issue, so cc linux-xfs@ to get review.
> 
> Thanks,
> Zorro
> 
>  tests/nfs/002     | 43 +++++++++++++++++++++++++++++++++++++++++++
>  tests/nfs/002.out |  2 ++
>  2 files changed, 45 insertions(+)
>  create mode 100755 tests/nfs/002
>  create mode 100644 tests/nfs/002.out
> 
> diff --git a/tests/nfs/002 b/tests/nfs/002
> new file mode 100755
> index 00000000..3d29958d
> --- /dev/null
> +++ b/tests/nfs/002
> @@ -0,0 +1,43 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2022 Red Hat, Inc.  All Rights Reserved.
> +#
> +# FS QA Test 002
> +#
> +# Make sure nfs gets expected file size after writting a big sized file. It's
> +# not only testing nfs, test its underlying fs too. For example a known old bug
> +# on xfs (underlying fs) caused nfs get larger file size (e.g. 16M) after
> +# writting 10M data to a file. It's fixed by a series of patches around
> +# 579b62faa5fb16 ("xfs: add background scanning to clear eofblocks inodes")
> +#
> +. ./common/preamble
> +_begin_fstest auto rw
> +
> +# real QA test starts here
> +_supported_fs nfs
> +_require_test
> +
> +localfile=$TEST_DIR/testfile.$seq
> +rm -rf $localfile
> +
> +$XFS_IO_PROG -f -t -c "pwrite 0 10m" -c "fsync" $localfile >>$seqres.full 2>&1
> +block_size=`stat -c '%B' $localfile`
> +iblocks_expected=$((10 * 1024 * 1024 / $block_size))
> +# Try several times for the speculative allocated file size can be shrunken
> +res=1
> +for ((i=0; i<10; i++));do
> +	iblocks_real=`stat -c '%b' $localfile`
> +	if [ "$iblocks_expected" = "$iblocks_real" ];then
> +		res=0
> +		break
> +	fi
> +	sleep 10
> +done

Hmm... this case sometimes fails on kernel 6.1.0-rc6 [1] (nfs4.2 base on xfs),
even I changed the sleep time to 20s * 10, it still fails. But I can't reproduce
this failure if the underlying fs is ext4... cc linux-xfs, to check if I miss
something for xfs? Or this's a xfs issue?

Thanks,
Zorro

[1]
# ./check nfs/002
FSTYP         -- nfs
PLATFORM      -- Linux/x86_64 dell-per640-04 6.1.0-rc6 #1 SMP PREEMPT_DYNAMIC Mon Nov 21 00:51:20 EST 2022
MKFS_OPTIONS  -- dell-per640-04.dell2.lab.eng.bos.redhat.com:/mnt/xfstests/scratch/nfs-server
MOUNT_OPTIONS -- -o vers=4.2 -o context=system_u:object_r:root_t:s0 dell-per640-04.dell2.lab.eng.bos.redhat.com:/mnt/xfstests/scratch/nfs-server /mnt/xfstests/scratch/nfs-client

nfs/002 3s ... - output mismatch (see /var/lib/xfstests/results//nfs/002.out.bad)
    --- tests/nfs/002.out       2022-11-21 01:29:33.861770474 -0500
    +++ /var/lib/xfstests/results//nfs/002.out.bad      2022-11-21 13:27:37.424199056 -0500
    @@ -1,2 +1,3 @@
     QA output created by 002
    +Write 20480 blocks, but get 32640 blocks
     Silence is golden
    ...
    (Run 'diff -u /var/lib/xfstests/tests/nfs/002.out /var/lib/xfstests/results//nfs/002.out.bad'  to see the entire diff)
Ran: nfs/002
Failures: nfs/002
Failed 1 of 1 tests


> +if [ $res -ne 0 ];then
> +	echo "Write $iblocks_expected blocks, but get $iblocks_real blocks"
> +fi
> +
> +echo "Silence is golden"
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/nfs/002.out b/tests/nfs/002.out
> new file mode 100644
> index 00000000..61705c7c
> --- /dev/null
> +++ b/tests/nfs/002.out
> @@ -0,0 +1,2 @@
> +QA output created by 002
> +Silence is golden
> -- 
> 2.31.1
> 

