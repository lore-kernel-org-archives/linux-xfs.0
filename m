Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDA28C433FE
	for <linux-xfs@archiver.kernel.org>; Mon, 21 Nov 2022 20:48:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230202AbiKUUsR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 21 Nov 2022 15:48:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230070AbiKUUsQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 21 Nov 2022 15:48:16 -0500
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41DBCC902D
        for <linux-xfs@vger.kernel.org>; Mon, 21 Nov 2022 12:48:16 -0800 (PST)
Received: by mail-pg1-x530.google.com with SMTP id h193so12195891pgc.10
        for <linux-xfs@vger.kernel.org>; Mon, 21 Nov 2022 12:48:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=nXRCenvPbg9BURkijbBk1gurOEN5zK0/khvZ72DFJBw=;
        b=vF9H4B7le1DEQHBa5Td4gzNcfo1HlAe3XPRTd/FaBc10x89k5GSmJn3LK53wVm3lMM
         UXJOMIrV4Ff2OVuQ9O+vXQkrj8uCLWd+OclHygdzZ07+HnQZYTq7f5Kqj8oaSuunv4Df
         nzSC3QsNjzoP+iZnBo/tGNYqn5OSzeJl4wDIL4Iss+tKR9Zao1DZGCDRhbet+WKEmoI0
         Vr0IEJigtWI/NjgV7KjAlM8s2Blx3rR4xjNou//wWiEDlxxMURo8jriYyHLhrYDml7B+
         9uJIL/8MlC0FKOkc42BSXSWo9J5tv4fDBI2tNBIdgRuAS3xv1uFHrtUovV+WqcTXLahj
         Ob3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nXRCenvPbg9BURkijbBk1gurOEN5zK0/khvZ72DFJBw=;
        b=nDMGoK8w0xYBEFmnzGOogqHgKts8rXHeL9kaS6ABrcsKRgYmPDGnbVWxnJSXyPldZ5
         euSj6jmlAeOixTsxcrmRRTAnk9srSNO0pcKFtgNc4wqPYgA1t2zHi6hyF3XwuFwNmeCc
         wnfDOobuyMqQfiMmmOARHk/ORoitKu8YUDp6BVt3oNbLZ5LVsOMZTZDnGCYGq5U+XM8C
         /sxZQGuDBsdwu+12xIjknGp9IacmkKA+7GEjxlYK4nnHZO5BgyRhKpF+Xn8NxLRk9lJL
         8LZKTHuuHe7CvoJTR4ATfB56A8DLessx91plTiHWFsbeezJE2gnAFz8GUuG6Ib8Jkquj
         WbIQ==
X-Gm-Message-State: ANoB5pm513iEl75TeXfjmnkHHnZ3kIx3adgcjnBxlsr8C9a7c1kYwB+M
        /WcB84UA+NvR+I+9F0JpQPfpxVDnHX2DWg==
X-Google-Smtp-Source: AA0mqf4NlSc3j426YhD77PxmBOljjROkDLkk+2AUPN2bOcCppY+sh73pORW2ksrbkjCiAKt0LQb/ww==
X-Received: by 2002:a63:491c:0:b0:448:5404:6504 with SMTP id w28-20020a63491c000000b0044854046504mr1026658pga.401.1669063695778;
        Mon, 21 Nov 2022 12:48:15 -0800 (PST)
Received: from dread.disaster.area (pa49-186-65-106.pa.vic.optusnet.com.au. [49.186.65.106])
        by smtp.gmail.com with ESMTPSA id q20-20020aa78434000000b0056b91044485sm9084752pfn.133.2022.11.21.12.48.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Nov 2022 12:48:15 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1oxDi7-00H0YX-Sn; Tue, 22 Nov 2022 07:48:11 +1100
Date:   Tue, 22 Nov 2022 07:48:11 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     iamdooser <iamdooser@gmail.com>
Cc:     Eric Sandeen <sandeen@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: xfs_repair hangs at "process newly discovered inodes..."
Message-ID: <20221121204811.GI3600936@dread.disaster.area>
References: <f7f94312-ad1b-36e4-94bf-1b7f47070c1e@gmail.com>
 <39028244-fec6-6717-d8a7-b9f89f5a1f3b@redhat.com>
 <8ed7c0ee-dd04-8346-87cb-83c2222f3454@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8ed7c0ee-dd04-8346-87cb-83c2222f3454@gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Nov 19, 2022 at 12:24:18PM -0500, iamdooser wrote:
> Thank you for responding.
> 
> Yes that found errors, although I'm not accustomed to interpreting the
> output.
> 
> xfs_repair version 5.18.0
> 
> The output of xfs_repair -nv was quite large, as was the xfs_metadump...not
> sure that's indicative of something, but I've uploaded them here:
> https://drive.google.com/drive/folders/1OyQOZNsTS1w1Utx1ZfQEH-bS_Cyj8-F2?usp=sharing

Ok....

According to the the "-nv" output, you a clean log and widespread
per-AG btree corruptions and inconsistencies. Free inodes not found
in the finobt, free space only found in on free sapce btree, records
in btrees out of order, multiply-claimed blocks (cross linked files
and cross linked free space!), etc.

Every AG shows the same corruption pattern - I've never seen a
filesystem with a clean log in this state before. This sort of
widespread lack of consistency in btree structures isn't a result of
an isolated storage media or I/O error - something major has
happened here.

The first thing I have to ask: did you zero the log with xfs_repair
because you couldn't repair it and then take these repair output
dumps? This *smells* zeroing the log with xfs_repair and throwing
away all the metadata in the log after removing a bunch of files
and the system crashing immediately afterwards. Log recovery in that
case would have made the btrees and inode states mostly
consistent...

Can you please explain how the filesystem got into this state in the
first place? What storage you have, what kernel you are running,
what distro/appliance this filesystem is hosted on, what operations
were being performed when it all went wrong, etc? We really need to
know how the fs got into this state so that we can determine if
other users are at risk of this sort of thing...

> There doesn't seem to be much activity once it hangs at "process newly
> discovered inodes..." so it doesn't seem like just a slow repair. Desipte
> there being no sign of activity, I've let it run for 24+ hours and saw no
> changes..

Use "-t 300" for xfs_repair to output a progress report every 5
minutes. Likely the operation is slow because it is IO bound moving
one inode at a time to lost+found...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
