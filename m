Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1240C4332F
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Nov 2023 06:39:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229611AbjKHGjG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 8 Nov 2023 01:39:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbjKHGjF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Nov 2023 01:39:05 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62B9D10C0
        for <linux-xfs@vger.kernel.org>; Tue,  7 Nov 2023 22:39:03 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id 98e67ed59e1d1-28120aa1c24so1944554a91.0
        for <linux-xfs@vger.kernel.org>; Tue, 07 Nov 2023 22:39:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1699425543; x=1700030343; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ulun+lAbrpCzT3jYibtLBhBSSSJOwuFULkmqLToMbfw=;
        b=dWExTNyiHn2obDBmsIPY9OJSl43A6Y/gFsUs5fd34ACkPEg4D6SEwzYgmaUfZQL8UR
         JgYrKwEz6WZPVrEGef5b4sdsgZBLSXkAaF0ehbpXJIzEMbsN4VfA9l+wIHwCTK58bEgW
         DlBzQKkD16+m7jXMaDmm8BW/2IEnEPXc+wT6xmVKReD3V6IAVqYQy0/UAHryXaldUf3v
         ZNtWWY2yP7FsrCTcEsxdKX+92NEdIT7nsXLmleD5rU7Wp0/F4e7PkA7FK6gFuvWHIZQh
         jPtrqbR5e/vOn+5OmWhvwmQZyKJVckU45gxvA9eRzl10sxtCHMfuH7sY58AyVXpzYV+F
         fN/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699425543; x=1700030343;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ulun+lAbrpCzT3jYibtLBhBSSSJOwuFULkmqLToMbfw=;
        b=cr49PWFe5tNJ2KSERWkSHO995Y7J2vKqi/6Kosh13eHdB1gyJeyyii6CWzH/1axMFF
         ldOGE0gkXqv/80eyzxxEnB6Mn16ingsWF0peYAokEugw5WwIPftlXIAIhAd3uL56dPik
         RPaR4u2UEIJoV74nAHILoGckqge3lobX86FNvbuX9GFk9ElwB/Y8QahmRxHRZFt9XIlE
         Hdkdp9kR+GEaLlmxfIhn7e+mQXkIoYXND8qKSIm5t5QH8qVTtr/uo9uK9SZfeg3LT41E
         rLa7hiawBW/iZBHZZejtZRaY6wPVD2VglESUtmW5HpGwJDeHia3aB4h9OHNzXBqf1kXE
         N3Uw==
X-Gm-Message-State: AOJu0YzVMbxzJHn7bJF91aTox0bX9Bf28JeBhXCOJ+u3NHzvL8fkXJJj
        0KjdTaOnP2VRUT4W+7+sDppFNQ==
X-Google-Smtp-Source: AGHT+IFFXJRBYVp5XA8NqYmfcQEmH+2vIgwctQ/wSElrMSTmuOY4QZZ/bILqMsNl9Frv0O+fCXZPcg==
X-Received: by 2002:a17:90b:3a89:b0:27d:2364:44f6 with SMTP id om9-20020a17090b3a8900b0027d236444f6mr933982pjb.6.1699425542754;
        Tue, 07 Nov 2023 22:39:02 -0800 (PST)
Received: from dread.disaster.area (pa49-180-125-5.pa.nsw.optusnet.com.au. [49.180.125.5])
        by smtp.gmail.com with ESMTPSA id f3-20020a17090ace0300b00274b9dd8519sm850961pju.35.2023.11.07.22.39.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Nov 2023 22:39:02 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1r0cDL-009lJd-1M;
        Wed, 08 Nov 2023 17:38:59 +1100
Date:   Wed, 8 Nov 2023 17:38:59 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Zorro Lang <zlang@redhat.com>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org,
        "Darrick J. Wong" <djwong@kernel.org>,
        Carlos Maiolino <carlos@maiolino.me>
Subject: Re: [Bug report][fstests generic/047] Internal error !(flags &
 XFS_DABUF_MAP_HOLE_OK) at line 2572 of file fs/xfs/libxfs/xfs_da_btree.c.
 Caller xfs_dabuf_map.constprop.0+0x26c/0x368 [xfs]
Message-ID: <ZUstA+1+IvHJ87eP@dread.disaster.area>
References: <20231029041122.bx2k7wwm7otebjd5@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <ZUiECgUWZ/8HKi3k@dread.disaster.area>
 <20231106192627.ilvijcbpmp3l3wcz@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <ZUlNroz8l5h1s1oF@dread.disaster.area>
 <20231107080522.5lowalssbmi6lus3@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <ZUnxswEfoeZQhw5P@dread.disaster.area>
 <20231107151314.angahkixgxsjwbot@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231107151314.angahkixgxsjwbot@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Nov 07, 2023 at 11:13:14PM +0800, Zorro Lang wrote:
> On Tue, Nov 07, 2023 at 07:13:39PM +1100, Dave Chinner wrote:
> > On Tue, Nov 07, 2023 at 04:05:22PM +0800, Zorro Lang wrote:
> > > On Tue, Nov 07, 2023 at 07:33:50AM +1100, Dave Chinner wrote:
> > > > On Tue, Nov 07, 2023 at 03:26:27AM +0800, Zorro Lang wrote:
> > > > > Thanks for your reply :) I tried to do a kernel bisect long time, but
> > > > > find nothing ... Then suddently, I found it's failed from a xfsprogs
> > > > > change [1].
> > > > > 
> > > > > Although that's not the root cause of this bug (on s390x), it just
> > > > > enabled "nrext64" by default, which I never tested on s390x before.
> > > > > For now, we know this's an issue about this feature, and only on
> > > > > s390x for now.
> > > > 
> > > > That's not good. Can you please determine if this is a zero-day bug
> > > > with the nrext64 feature? I think it was merged in 5.19, so if you
> > > > could try to reproduce it on a 5.18 and 5.19 kernels first, that
> > > > would be handy.
> > > 
> > > Unfortunately, it's a bug be there nearly from beginning. The linux v5.19
> > > can trigger this bug (with latest xfsprogs for-next branch):
> > 
> > Ok. Can you grab the pahole output for the xfs_dinode and
> > xfs_log_dinode for s390 from both 5.18 and 5.19 kernel builds?
> > (i.e. 'pahole fs/xfs/xfs_inode.o |less' and search for the two
> > structures).
> 
> I can't find xfs_log_dinode in fs/xfs/xfs_inode.o, but I can find both structures
> in fs/xfs/xfs_inode_item.o, so below output base on:
> 
>   # pahole fs/xfs/xfs_inode_item.o
> 
> The output on v5.19 is [1], v5.18 output is [2], the diff of 5.18 and 5.19 is [3].

Ok, so there's nothing wrong with the on-disk format definition or
the journal format - they both lay out in exactly the right shape
so I think at this point we need metadumps from the broken
filesystems.

Can you pick one of the failing tests and grab metadumps from
the shutdown filesystem (i.e. before it is recovered) and then
another from after it is recovered and the problem tripped over?

I know I won't be able to replay the log on x86-64, but knowing what
is in the journal vs what ends up being recovered will tell us
where to look next.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
