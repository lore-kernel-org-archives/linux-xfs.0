Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6521BC4320A
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Jul 2021 02:35:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3F56960240
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Jul 2021 02:35:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234095AbhG1CfW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 27 Jul 2021 22:35:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233223AbhG1CfV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Jul 2021 22:35:21 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F68DC061757;
        Tue, 27 Jul 2021 19:35:21 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id n10so917158plf.4;
        Tue, 27 Jul 2021 19:35:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=VqM4laUk8B0vv7NXWu6CFBwhOFTp4Kj3GI5pKvXUTng=;
        b=gC/jXxQrfHZiBdgMK5LqcpMfbLz1e6IWTz7YKKoPKC/0uGMOdu00wTeqXT65nezvOz
         VlN6pT9mZUcZQs07swu6G98CfvMl5K8XbxzhjLNp34dsCle5mOv1dXp2iBthmnhIrZeR
         KgL5oqUs5CJ+waHBMXTrvauDH7xGd9x2NfdjURPVbWxrWxyyIh7dl6ZSycbWN/Y96UOY
         /63tKJU44NwqB8gDA7Kr9iLAgDkmveGIgoc3lQT7h09MPOdHCDZbtyzN77N4VQ6C248i
         1RogZg0YmsbGb+zUsuoJ1Y4tc+/Sbl0iwOsD0NGMldx4N+E7Xgnsy7eVKF17vdildzZH
         q/+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=VqM4laUk8B0vv7NXWu6CFBwhOFTp4Kj3GI5pKvXUTng=;
        b=HiwrzoynbFRu8oa3Csxjm+da9kk0iIqeYrFfObTcJkwUIQT4oynOGwPxYlrvxA9ICD
         epjLev1RxlCgibaMDNRiOoObBJSZihu76JbjHrqZUTUzVTofbld2wH9qUiAmcZmjwFSU
         ezqVmrVNIa4Tew4Rc3leUvfzUEw8NcXXi2R/MPTOrdiD3Az1CAPKL3tpHzIXeFbknXEU
         BMf6qOCBT2MJKeZhC9jK9wJ8qGWX4d/TqOnTKVW+2q06ThOrxwRGcWXmjgba880d7Yl2
         Yb0A2InHWs2rP9LBGeuN/28o2b0Yc7CI9osKYcN4+l1nYHzvpNF4iJdG0iISWof1/zt2
         ieJA==
X-Gm-Message-State: AOAM531cQcvuRopgnsswCkBCkB1BqSehtALev2OS0MOf23kPpbtEyBeO
        87TlTzivR6ARRGxMOSTm6b9MUC7SaxrmWQ==
X-Google-Smtp-Source: ABdhPJzCYTEKHLb1QHFAF9xyNwVVJXtVV4T+c1k3vF1gvMXlFhbualWs2P24bFv6BfsxzR25jrqZvA==
X-Received: by 2002:a62:1a4b:0:b029:328:da0b:d83b with SMTP id a72-20020a621a4b0000b0290328da0bd83bmr25736580pfa.59.1627439720428;
        Tue, 27 Jul 2021 19:35:20 -0700 (PDT)
Received: from garuda ([122.171.208.125])
        by smtp.gmail.com with ESMTPSA id r7sm5743672pga.44.2021.07.27.19.35.18
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 27 Jul 2021 19:35:20 -0700 (PDT)
References: <20210726064313.19153-1-chandanrlinux@gmail.com> <20210726064313.19153-3-chandanrlinux@gmail.com> <20210726171916.GV559212@magnolia> <87fsw0fjq0.fsf@garuda> <20210727183734.GD559142@magnolia>
User-agent: mu4e 1.0; emacs 26.1
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     fstests@vger.kernel.org, guaneryu@gmail.com,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/3] xfs/530: Bail out if either of reflink or rmapbt is enabled
In-reply-to: <20210727183734.GD559142@magnolia>
Date:   Wed, 28 Jul 2021 08:05:15 +0530
Message-ID: <87fsvzw4gs.fsf@garuda>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 28 Jul 2021 at 00:07, Darrick J. Wong wrote:
> On Tue, Jul 27, 2021 at 10:15:27AM +0530, Chandan Babu R wrote:
>> On 26 Jul 2021 at 22:49, Darrick J. Wong wrote:
>> > On Mon, Jul 26, 2021 at 12:13:13PM +0530, Chandan Babu R wrote:
>> >> _scratch_do_mkfs constructs a mkfs command line by concatenating the values of
>> >> 1. $mkfs_cmd
>> >> 2. $MKFS_OPTIONS
>> >> 3. $extra_mkfs_options
>> >>
>> >> The corresponding mkfs command line fails if $MKFS_OPTIONS enables either
>> >> reflink or rmapbt feature. The failure occurs because the test tries to create
>> >> a filesystem with realtime device enabled. In such a case, _scratch_do_mkfs()
>> >> will construct and invoke an mkfs command line without including the value of
>> >> $MKFS_OPTIONS.
>> >>
>> >> To prevent such silent failures, this commit causes the test to exit if it
>> >> detects either reflink or rmapbt feature being enabled.
>> >
>> > Er, what combinations of mkfs.xfs and MKFS_OPTIONS cause this result?
>> > What kind of fs configuration comes out of that?
>> 
>> With MKFS_OPTIONS set as shown below,
>> 
>> export MKFS_OPTIONS="-m reflink=1 -b size=1k"
>> 
>> _scratch_do_mkfs() invokes mkfs.xfs with both realtime and reflink options
>> enabled. Such an invocation of mkfs.xfs fails causing _scratch_do_mkfs() to
>> ignore the contents of $MKFS_OPTIONS while constructing and invoking mkfs.xfs
>> once again.
>> 
>> This time, the fs block size will however be set to 4k (the default block
>> size). At the beginning of the test we would have obtained the block size of
>> the filesystem as 1k and used it to compute the size of the realtime device
>> required to overflow realtime bitmap inode's max pseudo extent count.
>> 
>> Invocation of xfs_growfs (made later in the test) ends up succeeding since a
>> 4k fs block can accommodate more bits than a 1k fs block.
>
> OK, now I think I've finally put all the pieces together.  Both of these
> patches are fixing weirdness when MKFS_OPTIONS="-m reflink=1 -b size=1k".
>
> With current HEAD, we try to mkfs.xfs with double "-b size" arguments.
> That fails with 'option respecified', so fstests tries again without
> MKFS_OPTIONS, which means you don't get the filesystem that you want.
> If, say, MKFS_OPTIONS also contained bigtime=1, you won't get a bigtime
> filesystem.
>
> So the first patch removes the double -bsize arguments.  But you still
> have the problem that the reflink=1 in MKFS_OPTIONS still causes
> mkfs.xfs to fail (because we don't do rt and reflink yet), so fstests
> again drops MKFS_OPTIONS, and now you're testing the fs without a block
> size option at all.  The test still regresses because the special rt
> geometry depends on the blocksize, and we didn't get all the geometry
> elements that we need to trip the growfs failure.
>
> Does the following patch fix all that for you?
>
> --D
>
> diff --git a/tests/xfs/530 b/tests/xfs/530
> index 4d168ac5..9c6f44d7 100755
> --- a/tests/xfs/530
> +++ b/tests/xfs/530
> @@ -60,10 +60,22 @@ echo "Format and mount rt volume"
>  
>  export USE_EXTERNAL=yes
>  export SCRATCH_RTDEV=$rtdev
> -_scratch_mkfs -d size=$((1024 * 1024 * 1024)) -b size=${dbsize} \
> +_scratch_mkfs -d size=$((1024 * 1024 * 1024)) \
>  	      -r size=${rtextsz},extsize=${rtextsz} >> $seqres.full
>  _try_scratch_mount || _notrun "Couldn't mount fs with synthetic rt volume"
>  
> +# If we didn't get the desired realtime volume and the same blocksize as the
> +# first format (which we used to compute a specific rt geometry), skip the
> +# test.  This can happen if the MKFS_OPTIONS conflict with the ones we passed
> +# to _scratch_mkfs or do not result in a valid rt fs geometry.  In this case,
> +# _scratch_mkfs will try to "succeed" at formatting by dropping MKFS_OPTIONS,
> +# giving us the wrong geometry.
> +formatted_blksz="$(_get_block_size $SCRATCH_MNT)"
> +test "$formatted_blksz" -ne "$dbsize" && \
> +	_notrun "Tried to format with $dbsize blocksize, got $formatted_blksz."
> +$XFS_INFO_PROG $SCRATCH_MNT | egrep -q 'realtime.*blocks=0' && \
> +	_notrun "Filesystem should have a realtime volume"
> +

The above solution indeed fixes the problems that patch 2 and 3 were
attempting to solve. If you plan on posting it, you can add

Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>

-- 
chandan
