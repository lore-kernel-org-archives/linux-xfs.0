Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 654E4CD37B4
	for <linux-xfs@archiver.kernel.org>; Sun, 17 Sep 2023 22:39:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232719AbjIQWiu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 17 Sep 2023 18:38:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235283AbjIQWiq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 17 Sep 2023 18:38:46 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DA0212C
        for <linux-xfs@vger.kernel.org>; Sun, 17 Sep 2023 15:38:41 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id d2e1a72fcca58-68fb79ef55eso3621229b3a.0
        for <linux-xfs@vger.kernel.org>; Sun, 17 Sep 2023 15:38:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1694990321; x=1695595121; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ke+r8qXwhOQOEjkcPa800K8AHAdSog2oBC7oPzo38JE=;
        b=YolRK6SMg6uajGY1KK0Mb815jbUBJNKt1S1TbtY+VAGPZV0E4u5+QS7UJOsBOIN0Z0
         OFAMSED02kF76v9RiHO9nC7OSEOVtPKqmrYFnaK8q6nyOzQrIJV/yP9VZfBwZa5YlHun
         C8gcLhMOHq6Q+cCJ8hhTk+2y7c3oxiFFwY6v8yrI75gC9Iv4r8Wm1hYs7vbe/R7dol9C
         5R4yjVSDW4y1diwujn7idC/etDW2QtVGOvHQ2CgfcoAzaYwoy+VQLgueBuO5vC52xS2I
         BR1CJkcu6o1pPuAUjZQBSpTk0qccuPf+sEXx5Tc1SMpVv18d8hmgzivFziywqS0lj+iR
         FYEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694990321; x=1695595121;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ke+r8qXwhOQOEjkcPa800K8AHAdSog2oBC7oPzo38JE=;
        b=Ulv6dd33Qbwe1Jbwg27sqBIc7QNUISWNiEDCWLOHkzRZYaaErFf4OeyABnKet+m3d0
         jLz2hHS3v3VmMl6tXPNysdsmKFDEwC0lgFxOSX8O2wQigSKr3Sds05JYMOpROoz/WYdW
         tApcn4rAyozOqJ9qBJY0RwFoOE9+botbUlFJOYynEnhG0QUWx1nc14tF2oCbSHk0QsQC
         m+Zapg0uWfCIe49jMpv2KDyFUmLBh1vmKWUIN0br0PvNJdQeeCb2TMhx95Ktfs6PzUTD
         HVwfP40dNWG4rJr13Cji8xns+pAq/wJ77jcF9UhjlsgAHkWqCBDRQ85z5sz+H9YlBQXA
         WwgA==
X-Gm-Message-State: AOJu0YzbZyi0kTriX8qZ3jYtx61blrBUfaE3S851ECUNca7W4qTu1AMs
        elINMBSbNRm0cCR0g4ehChcmeg==
X-Google-Smtp-Source: AGHT+IEoyN+Ko/vfHzQTCsklohWVs/1xyU3W3CJm23TtEgGeo8n/qm7u6KZZ2GYIzVYy18nvPVPyHg==
X-Received: by 2002:a05:6a20:f38a:b0:149:602e:9233 with SMTP id qr10-20020a056a20f38a00b00149602e9233mr7133863pzb.26.1694990320910;
        Sun, 17 Sep 2023 15:38:40 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-20-59.pa.nsw.optusnet.com.au. [49.180.20.59])
        by smtp.gmail.com with ESMTPSA id bm1-20020a056a00320100b0068fbaea118esm6037350pfb.45.2023.09.17.15.38.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Sep 2023 15:38:40 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1qi0PV-00263K-1r;
        Mon, 18 Sep 2023 08:38:37 +1000
Date:   Mon, 18 Sep 2023 08:38:37 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Luis Chamberlain <mcgrof@kernel.org>
Cc:     hch@infradead.org, djwong@kernel.org, dchinner@redhat.com,
        kbusch@kernel.org, sagi@grimberg.me, axboe@fb.com,
        willy@infradead.org, brauner@kernel.org, hare@suse.de,
        ritesh.list@gmail.com, rgoldwyn@suse.com, jack@suse.cz,
        ziy@nvidia.com, ryan.roberts@arm.com, patches@lists.linux.dev,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-block@vger.kernel.org, p.raghav@samsung.com,
        da.gomez@samsung.com, dan.helmick@samsung.com
Subject: Re: [RFC v2 00/10] bdev: LBS devices support to coexist with
 buffer-heads
Message-ID: <ZQd/7RYfDZgvR0n2@dread.disaster.area>
References: <20230915213254.2724586-1-mcgrof@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230915213254.2724586-1-mcgrof@kernel.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Sep 15, 2023 at 02:32:44PM -0700, Luis Chamberlain wrote:
> Christoph added CONFIG_BUFFER_HEAD on v6.1 enabling a world where we can
> live without buffer-heads. When we opt into that world we end up also
> using the address space operations of the block device cache using
> iomap. Since iomap supports higher order folios it means then that block
> devices which do use the iomap aops can end up having a logical block
> size or physical block size greater than PAGE_SIZE. We refer to these as
> LBS devices. This in turn allows filesystems which support bs > 4k to be
> enabled on a 4k PAGE_SIZE world on LBS block devices. This alows LBS
> device then to take advantage of the recenlty posted work today to enable
> LBS support for filesystems [0].

Why do we need LBS devices to support bs > ps in XFS?

As long as the filesystem block size is >= logical sector size of
the device, XFS just doesn't care what the "block size" of the
underlying block device is. i.e. XFS will allow minimum IO sizes of
the logical sector size of the device for select metadata and
sub-block direct IO, but otherwise all other IO will be aligned to
filesystem block size and so the underlying device block sizes are
completely irrelevant...

> To experiment with larger LBA formtas you can also use kdevops and enable
> CONFIG_QEMU_ENABLE_EXTRA_DRIVE_LARGEIO. That enables a ton of drives with
> logical and physical block sizes >= 4k up to a desriable max target for
> experimentation. Since filesystems today only support up to 32k sector sizes,
> in practice you may only want to experiment up to 32k physical / logical.
> 
> Support for 64k sector sizes requires an XFS format change, which is something
> Daniel Gomez has experimental patches for, in case folks are interested in
> messing with.

Please don't do this without first talking to the upstream XFS
developers about the intended use cases and design of the new
format. Especially when the problem involves requiring a whole new
journal header and indexing format to be implemented...

As a general rule, nobody should *ever* be writing patches to change
the on-disk format of a -any- filesystem without first engaging the
people who maintain that filesystem. Architecture and design come
first, not implementation. The last thing we want is to have someone
spend weeks or months on something that takes the experts half a
minute to NACK because it is so obviously flawed....

> Patch 6 could probably be squashed with patch 5, but I wanted to be
> explicit about this, as this should be decided with the community.
> 
> There might be a better way to do this than do deal with the switching
> of the aops dynamically, ideas welcomed!

Is it even safe to switch aops dynamically? We know there are
inherent race conditions in doing this w.r.t. mmap and page faults,
as the write fault part of the processing is directly dependent
on the page being correctly initialised during the initial
population of the page data (the "read fault" side of the write
fault).

Hence it's not generally considered safe to change aops from one
mechanism to another dynamically. Block devices can be mmap()d, but
I don't see anything in this patch set that ensures there are no
other users of the block device when the swaps are done. What am I
missing?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
