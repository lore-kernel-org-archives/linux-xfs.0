Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm0-f48.google.com ([74.125.82.48]:37977 "EHLO
        mail-wm0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751683AbdGALlq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 1 Jul 2017 07:41:46 -0400
Received: by mail-wm0-f48.google.com with SMTP id f67so14428877wmh.1
        for <linux-xfs@vger.kernel.org>; Sat, 01 Jul 2017 04:41:46 -0700 (PDT)
Received: from [192.168.2.44] (p57ACA7F0.dip0.t-ipconnect.de. [87.172.167.240])
        by smtp.googlemail.com with ESMTPSA id t74sm12992774wmt.19.2017.07.01.04.41.44
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 01 Jul 2017 04:41:44 -0700 (PDT)
References: <20170701023529.GP5874@birch.djwong.org>
In-Reply-To: <20170701023529.GP5874@birch.djwong.org>
From: Marian Beermann <public@enkore.de>
Subject: Re: Re: Any tips for moving to reflink?
Message-ID: <03eb6ac0-6c6e-0494-b008-25a187b43e12@enkore.de>
Date: Sat, 1 Jul 2017 13:41:43 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hi

> > I'm planning to use this reflink feature for instant local snapshots
> > and then use my backup software of choice, borg, to keep a long time
> > history of my work on a remote server. Since borg stores data in a
> > dedup fashion I can also backup the reflink snapshots and they won't
> > take additional space. The only drawback is that today borg need to
> > hash all the files found in a reflink directory in order to find out
> > about dedup blocks. I asked a question on the borg mailing list
> > https://github.com/borgbackup/borg/issues/2743 and apparently it
> > won't be an issue to add a feature to support XFS in order to
> > identify the physical extents. Is rmapbt required for that?
>
> borgbackup will probably need to call the GETFSMAP ioctl, which won't
> land until 4.12.  On xfs, rmapbt is needed to supply data block
> ownership info, which is what borgbackup (and bees, and...) say they
> want to be smarter about dedup.

My understanding so far was that FIEMAP would be sufficient to query the
extents associated with a file. Shouldn't this be sufficient to know
whether two files on the same file system refer to the same data?

Cheers, Marian
