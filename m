Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C31EEC41535
	for <linux-xfs@archiver.kernel.org>; Tue,  7 Nov 2023 15:32:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343878AbjKGPc4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 7 Nov 2023 10:32:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235400AbjKGPcn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 7 Nov 2023 10:32:43 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B84C1BEF
        for <linux-xfs@vger.kernel.org>; Tue,  7 Nov 2023 07:32:40 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id d9443c01a7336-1cc2b8deb23so8221955ad.1
        for <linux-xfs@vger.kernel.org>; Tue, 07 Nov 2023 07:32:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1699371160; x=1699975960; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9Ji/rj2qBgxozHTNNPEhvKWWU1spdtvm+JdV3xf1fTk=;
        b=relNU1V9B+kVhRyM1ZYk2SNQOBpCPy7sp5O0sZSniHyUn4QqTvU1xga5yiqtvyi5XQ
         KHE5sgiYlqaa6WDciqDMXGgwT61jBvjoHidH/kDdpPs3BQfNLPQ5E1pdSYUTtYwMnapB
         8yaj2tveR6sBIgItQGNEgqME1F9s/BRFm8Koh6QgqAObQUeIqvdq2cXPqqaE7fPOelCC
         diKpOZDMVepiOBil4PXQo2R+vEhmgM3dVLYWpGOIH0hwjWkrbfCqz1KYbpSYWG+jr5WP
         WkhyW7Jk+IQGayqjgxTupVZbxKvTeWpPJkm/CJkRmsOU9ulRtSL/qKWTQUDs5DH9cfSy
         PfZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699371160; x=1699975960;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9Ji/rj2qBgxozHTNNPEhvKWWU1spdtvm+JdV3xf1fTk=;
        b=nPQ+818uNJ55xNC5BcqR8L1dA7jGR/OwCZOBQyX98ly8w8N8dmaMgHjhuuVbpZBOKe
         aSsUj70WCwqAydiO4BiyE690XRefYvvBLeYp9uwKGgNJvP66R99VfW/5zuqvCfcQgNB9
         kNfUNE/CCjo8gHy9SpGXj4iP2PGIsmry75ODgMy9G+mZVFoJDZCcLbuwRaqePnaSeW2j
         3AzijgsZuZ46kticYHegucaBBgmyxm/2DxbqM1/pru9MqGx71D4pT6bxql0UnPdh71pQ
         5zGirUfYUfwwZA4CIxAHTEmu8bogyuPLVmr8j4VfL7DqKsqM5BhEHkRIfXxidNPma75+
         +qzQ==
X-Gm-Message-State: AOJu0YylTkvWbXx9CPdcKwXWgk23JBlzElofTroQurSTUSzFFSabqE/S
        XchcFhNbdD1oDDA/YwO93q8bKA==
X-Google-Smtp-Source: AGHT+IGje4cKvrvlMmvsWmwvVisdTup3LfFtuTDl0Lnyq4WXnmKzyWfrugxCSRJA1lkdM3MqBi4ysg==
X-Received: by 2002:a17:902:e3d3:b0:1cc:2bc4:5157 with SMTP id r19-20020a170902e3d300b001cc2bc45157mr31464645ple.1.1699371159556;
        Tue, 07 Nov 2023 07:32:39 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id u9-20020a170902b28900b001c72f4334afsm7724041plr.20.2023.11.07.07.32.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Nov 2023 07:32:38 -0800 (PST)
Message-ID: <73072f69-0e36-4b5d-88ad-3d9df577f9cd@kernel.dk>
Date:   Tue, 7 Nov 2023 08:32:37 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/7 v3] block: Add config option to not allow writing to
 mounted devices
Content-Language: en-US
To:     Jan Kara <jack@suse.cz>, Christian Brauner <brauner@kernel.org>
Cc:     linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>,
        Kees Cook <keescook@google.com>,
        syzkaller <syzkaller@googlegroups.com>,
        Alexander Popov <alex.popov@linux.com>,
        linux-xfs@vger.kernel.org, Dmitry Vyukov <dvyukov@google.com>
References: <20231101173542.23597-1-jack@suse.cz>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20231101173542.23597-1-jack@suse.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 11/1/23 11:43 AM, Jan Kara wrote:
> Hello!
> 
> This is the third version of the patches to add config option to not allow
> writing to mounted block devices. The new API for block device opening has been
> merged so hopefully this patchset can progress towards being merged. We face
> some issues with necessary btrfs changes (review bandwidth) so this series is
> modified to enable restricting of writes for all other filesystems. Once btrfs
> can merge necessary device scanning changes, enabling the support for
> restricting writes for it is trivial.
> 
> For motivation why restricting writes to mounted block devices is interesting
> see patch 3/7. I've been testing the patches more extensively and I've found
> couple of things that get broken by disallowing writes to mounted block
> devices:
> 
> 1) "mount -o loop" gets broken because util-linux keeps the loop device open
>    read-write when attempting to mount it. Hopefully fixable within util-linux.
> 2) resize2fs online resizing gets broken because it tries to open the block
>    device read-write only to call resizing ioctl. Trivial to fix within
>    e2fsprogs.
> 3) Online e2label will break because it directly writes to the ext2/3/4
>    superblock while the FS is mounted to set the new label.  Ext4 driver
>    will have to implement the SETFSLABEL ioctl() and e2label will have
>    to use it, matching what happens for online labelling of btrfs and
>    xfs.
> 
> Likely there will be other breakage I didn't find yet but overall the breakage
> looks minor enough that the option might be useful. Definitely good enough
> for syzbot fuzzing and likely good enough for hardening of systems with
> more tightened security.

For the series:

Reviewed-by: Jens Axboe <axboe@kernel.dk>

-- 
Jens Axboe

