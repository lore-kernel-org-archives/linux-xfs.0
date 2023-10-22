Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78CECCDB474
	for <linux-xfs@archiver.kernel.org>; Sun, 22 Oct 2023 22:43:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231444AbjJVWnG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 22 Oct 2023 18:43:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbjJVWnF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 22 Oct 2023 18:43:05 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49BBF93
        for <linux-xfs@vger.kernel.org>; Sun, 22 Oct 2023 15:43:03 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id d9443c01a7336-1c8a1541232so22754615ad.0
        for <linux-xfs@vger.kernel.org>; Sun, 22 Oct 2023 15:43:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1698014583; x=1698619383; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=HMTfJmJtA58o/yFwSGoJzWA+Dlp46j60GqtZIoxvH58=;
        b=vDAW6yqdb6nWCJppAFJFOAuq6WXm7u6vX91gbjqwj6sdRUpWE/z8wBs+q8Icq8SZzH
         EB4vlW53WIR9bszMV1WEvOd/6kB7S/dPl5N/sjeNyNptwdG+XV3ZgY8LOpIJiCgH/TNK
         6AttH0vLVup98lH60fWpZ6mPWBUeW+coh4wIXfFRkPLHAFTrcuXLueNmQpD+Ux+loAuT
         xqZdobWIObH9Ovx/xhGMkMqdNKyYWB6ShuqoMt+2BON/DnrxpHCugbGWGeGsDoe76YNV
         uFNVoL7hifX3cLpDE3qVkYFl/5Ac5iu+efSF5Hj87wTVXShASTiiT6FSfWc4RzcoVjw2
         6lQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698014583; x=1698619383;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HMTfJmJtA58o/yFwSGoJzWA+Dlp46j60GqtZIoxvH58=;
        b=pV2Evuw8Iw/ir3YpuuZFwzo3y2bFp/FH3vb5kfsVtLu+RtUTqUHp6Hjr9mF8XpGpwW
         BdbSAVDLxy68EYZuYXZapfVv0U6IAk7IClxj/WqgTBR2NhHXrgzc+YFBp6dj6995Ag+g
         lPcUOeorzrgNaKd9M62GJoZD00bTjpdZOsN+tTzIePKOBmeQUqQ4nhz0x99e//G4AFSn
         zTzrbaW5GsTQRj0flMFdNnzjjY1e1H8f674XgsDFCfLYHA3AEJY64luxbJDtD168NDvq
         3Yw2VOPqAWAn+S5tXi4eqPLKMoPMtgepgNxLv4LZWODcxKtefKvL+OwQKxu/6iZxjNb6
         SEUQ==
X-Gm-Message-State: AOJu0YyYTQSjgFlZcmTZQqeoi/KxQhSe20Yeu0UQGWts1ItIJ6aGbdIt
        XbwORkqe5tg6/vZeEPz2E2gp4A==
X-Google-Smtp-Source: AGHT+IGQdTG171oubIQDL0G0jM2i/VaN6joWADkPfCffrS7NG6HKZPErykcoYDCV3NkL9fMstXtztQ==
X-Received: by 2002:a17:902:cec4:b0:1ca:2caa:aca6 with SMTP id d4-20020a170902cec400b001ca2caaaca6mr9319931plg.68.1698014582715;
        Sun, 22 Oct 2023 15:43:02 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-20-59.pa.nsw.optusnet.com.au. [49.180.20.59])
        by smtp.gmail.com with ESMTPSA id 12-20020a170902c14c00b001b895336435sm4815936plj.21.2023.10.22.15.43.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Oct 2023 15:43:02 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1quh9v-002clj-0o;
        Mon, 23 Oct 2023 09:42:59 +1100
Date:   Mon, 23 Oct 2023 09:42:59 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Catherine Hoang <catherine.hoang@oracle.com>,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH v4] xfs: allow read IO and FICLONE to run concurrently
Message-ID: <ZTWlc3R95DPLOjw3@dread.disaster.area>
References: <20231017201208.18127-1-catherine.hoang@oracle.com>
 <ZS92TizgnKHdBtDb@infradead.org>
 <20231019200411.GN3195650@frogsfrogsfrogs>
 <ZTIY8jE9vK6A0FE3@infradead.org>
 <20231020153448.GR3195650@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231020153448.GR3195650@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Oct 20, 2023 at 08:34:48AM -0700, Darrick J. Wong wrote:
> On Thu, Oct 19, 2023 at 11:06:42PM -0700, Christoph Hellwig wrote:
> > On Thu, Oct 19, 2023 at 01:04:11PM -0700, Darrick J. Wong wrote:
> > > Well... the stupid answer is that I augmented generic/176 to try to race
> > > buffered and direct reads with cloning a million extents and print out
> > > when the racing reads completed.  On an unpatched kernel, the reads
> > > don't complete until the reflink does:
> > 
> > > So as you can see, reads from the reflink source file no longer
> > > experience a giant latency spike.  I also wrote an fstest to check this
> > > behavior; I'll attach it as a separate reply.
> > 
> > Nice.  I guess write latency doesn't really matter for this use
> > case?
> 
> Nope -- they've gotten libvirt to tell qemu to redirect vm disk writes
> to a new sidecar file.  Then they reflink the original source file to
> the backup file, but they want qemu to be able to service reads from
> that original source file while the reflink is ongoing.  When the backup
> is done, they commit the sidecar contents back into the original image.
> 
> It would be kinda neat if we had file range locks.  Regular progress
> could shorten the range as it makes progress.  If the thread doing the
> reflink could find out that another thread has blocked on part of the
> file range, it could even hurry up and clone that part so that neither
> reads nor writes would see enormous latency spikes.
> 
> Even better, we could actually support concurrent reads and writes to
> the page cache as long as the ranges don't overlap.  But that's all
> speculative until Dave dumps his old ranged lock patchset on the list.

The unfortunate reality is that range locks as I was trying to
implement them didn't scale - it was a failed experiment.

The issue is the internal tracking structure of a range lock. It has
to be concurrency safe itself, and even with lockless tree
structures using per-node seqlocks for internal sequencing, they
still rely on atomic ops for safe concurrent access and updates.

Hence the best I could get out of an uncontended range lock (i.e.
locking different exclusive ranges concurrently) was about 400,000
lock/unlock operations per second before the internal tracking
structure broke down under concurrent modification pressure.  That
was a whole lot better than previous attempts that topped out at
~150,000 lock/unlock ops/s, but it's still far short of the ~3
million concurrent shared lock/unlock ops/s than a rwsem could do on
that same machine.

Worse for range locks was that once passed peak performance,
internal contention within the range lock caused performance to fall
off a cliff and ends up being much worse than just using pure
exclusive locking with a mutex.

Hence without some novel new internal lockless and memory allocation
free tracking structure and algorithm, range locks will suck for the
one thing we want them for: high performance, highly concurrent
access to discrete ranges of a single file.

-Dave.

-- 
Dave Chinner
david@fromorbit.com
