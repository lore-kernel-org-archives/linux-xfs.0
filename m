Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91624C4321E
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Nov 2022 22:07:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236964AbiK2WHE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 29 Nov 2022 17:07:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232970AbiK2WGu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Nov 2022 17:06:50 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4C1E6F0E6
        for <linux-xfs@vger.kernel.org>; Tue, 29 Nov 2022 14:06:49 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id b13-20020a17090a5a0d00b0021906102d05so67526pjd.5
        for <linux-xfs@vger.kernel.org>; Tue, 29 Nov 2022 14:06:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=XMtjXlIm2cNL+TD6AmrjXoFZbnbnwLpz/+JAJhhK9lg=;
        b=UgIWiQj97GW5iQLOhYutWRwHC6cFMu6l0ZHFsIoDvqjhMuRayyJ5mPLti8Cpv3/UxY
         g0ZswrtSvMwiYUHP4dBJkpHyNCZ+pXHJPrxErO2fNH0K/JRbkxgBLAZixm1zwuuR4NVT
         XGGOsH1jxHw/LJGzwja5plT53ChWsFk2t9BKTWpjOyIHZlLdoUuf476vXnpUKLZZXDqo
         SjDKoukE9+wSwTsIbPXXfGqbd7bLgf4vS1gQi214lV5psCnwvWqlA4lI9o269EHHzGVM
         NJKPQ506nrBLwa1c9uH1cKVBISICVEUZZ+W4JLD4D+K995XUWq2+glVhpgcrUEAfEWYz
         7GoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XMtjXlIm2cNL+TD6AmrjXoFZbnbnwLpz/+JAJhhK9lg=;
        b=06T4PMYhcAfw10CYTQh9QN3ZwFg+142nrCHHr3OUiWyHVj78oewl9+u2g99ruXRxwE
         rlvRqWNxmI+B5CvJQsI46TJXwjdW9FQ2yMKYfl5tLyqdTl5okEOQ6Sh23AKOiz7XA1+t
         MUO0A7KglQFTqGu2e4up2HW8EfgbDzTvPNvMxpeyTe9oLK1i+UmR67nXT3O9Kp7FyNNH
         pM1TYR2vLtkOYRtoZXY2ZTfIiItam2RCYamitGQ5yWm83po6ArXUXoPB7GCC4q7nUOQG
         kiQHwKqvFA9KzinZPwdo91hn9rAVs228TzkSrKZ/7PUGfOk/qAJW6mT5fuH1GgkMzQX+
         C45w==
X-Gm-Message-State: ANoB5pk16QIQl6ON9vgm37pSkxb+uv0xc6OU5nvUW4a33ZYFwVoPHLpu
        FEbk92SHU9DT29wevL3Fxoqglpuj/BxPNQ==
X-Google-Smtp-Source: AA0mqf7uTQuPyt738AhAVc41FlgxG0TXX1z2D9xsgpMVRrMUms+OIPk8I1VYkBb/vz6Jv3OZBVABCw==
X-Received: by 2002:a17:90a:7183:b0:212:ede4:3c19 with SMTP id i3-20020a17090a718300b00212ede43c19mr62917820pjk.151.1669759609419;
        Tue, 29 Nov 2022 14:06:49 -0800 (PST)
Received: from dread.disaster.area (pa49-186-65-106.pa.vic.optusnet.com.au. [49.186.65.106])
        by smtp.gmail.com with ESMTPSA id f197-20020a6238ce000000b0056a7486da77sm10755966pfa.13.2022.11.29.14.06.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Nov 2022 14:06:49 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1p08kY-002aW6-3Y; Wed, 30 Nov 2022 09:06:46 +1100
Date:   Wed, 30 Nov 2022 09:06:46 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Chris Boot <lists@bootc.boo.tc>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: XFS corruption help; xfs_repair isn't working
Message-ID: <20221129220646.GI3600936@dread.disaster.area>
References: <c3fc1808-dbbf-b1c0-36de-1e55be1942e8@bootc.boo.tc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c3fc1808-dbbf-b1c0-36de-1e55be1942e8@bootc.boo.tc>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Nov 29, 2022 at 08:49:27PM +0000, Chris Boot wrote:
> Hi all,
> 
> Sorry, I'm mailing here as a last resort before declaring this filesystem
> done for. Following a string of unclean reboots and a dying hard disk I have
> this filesystem in a very poor state that xfs_repair can't make any progress
> on.
> 
> It has been mounted on kernel 5.18.14-1~bpo11+1 (from Debian
> bullseye-backports). Most of the repairs were done using xfsprogs 5.10.0-4
> (from Debian bullseye stable), though I did also try with 6.0.0-1 (from
> Debian bookworm/testing re-built myself).
> 
> I've attached the full log from xfs_repair, but the summary is it all starts
> with multiple instances of this in Phase 3:
> 
> Metadata CRC error detected at 0x5609236ce178, xfs_dir3_block block
> 0xe101f32f8/0x1000
> bad directory block magic # 0x1859dc06 in block 0 for directory inode
> 64426557977
> bad bestfree table in block 0 in directory inode 64426557977: repairing
> table

I think that the problem is that we are trying to repair garbage
without completely reinitialising the directory block header. We
don't bother checking the incoming directory block for sanity after
the CRC fails, and then we only warn that it has a bad magic number.

We then go a process it as though it is a directory block,
essentially trusting that the directory block header is actually
sane. Which it clearly isn't because the magic number in the dir
block has been trashed.

We then rescan parts of the directory block and rewrite parts of the
block header, but the next time we re-scan the block we find that
there are still bad parts in the header/directory block. Then we
rewrite the magic number to make it look like a directory block,
and when repair is finished it goes to write the recovered directory
block to disk and it fails the verifier check - it's still a corrupt
directory block because it's still full of garbage that doesn't pass
muster.

From a recovery persepective, I think that if we get a bad CRC and
an unrecognisable magic number, we have no idea what the block is
meant to contain - we cannot trust it to contain directory
information, so we should just trash the block rather than try to
rebuild it. If it was a valid directory block, this will result in
the files it pointed to being moved to lost+found so no data is
actually lost.

If it wasn't a dir block at all, then simply trashing the data fork
of the inode and not touching the contents of the block at all is
right thing to do. Modifying something that may be cross-linked
before we've resolved all the cross-linked extents is a bad thing to
be doing, so if we cannot recognise the block as a directory block,
we shouldn't try to recover it as a directory block at all....

Darrick, what are your thoughts on this?

> As it is the filesystem can be mounted and most data appears accessible, but
> several directories are corrupt and can't be read or removed; the kernel
> reports metadata corruption and CRC errors and returns EUCLEAN.
> 
> Ideally I'd like to remove the corrupt directories, recover as much of
> what's left as possible, and make the filesystem usable again (it's an
> rsnapshot destination) - but I'll take what I can.

Yup, it's only a small number of directory inodes, so we might be
able to do this with some manual xfs_db magic. I think all we'd
need to do is rewrite specific parts of the dir block header and
repair should then do the rest...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
