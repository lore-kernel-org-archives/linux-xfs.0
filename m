Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-qt0-f194.google.com ([209.85.216.194]:36989 "EHLO
        mail-qt0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S967951AbeEYUSR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 25 May 2018 16:18:17 -0400
MIME-Version: 1.0
In-Reply-To: <20180525165222.GA7567@infradead.org>
References: <20180525151421.2317292-1-arnd@arndb.de> <20180525165222.GA7567@infradead.org>
From: Arnd Bergmann <arnd@arndb.de>
Date: Fri, 25 May 2018 22:18:16 +0200
Message-ID: <CAK8P3a285ALRRECYVW=1_e7Dx0ybzG_1OWzVstXcm9VPQ3vUZA@mail.gmail.com>
Subject: Re: [PATCH] xfs: mark sb_fname as nonstring
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs <linux-xfs@vger.kernel.org>, Eric Sandeen <sandeen@redhat.com>, Martin Sebor <msebor@gmail.com>, Brian Foster <bfoster@redhat.com>, Dave Chinner <dchinner@redhat.com>, Eric Sandeen <sandeen@sandeen.net>, Dan Williams <dan.j.williams@intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>

On Fri, May 25, 2018 at 6:52 PM, Christoph Hellwig <hch@infradead.org> wrote:
>> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
>> index 84fbf164cbc3..eb79f2bc4dcc 100644
>> --- a/fs/xfs/xfs_ioctl.c
>> +++ b/fs/xfs/xfs_ioctl.c
>> @@ -1819,12 +1819,12 @@ xfs_ioc_getlabel(
>>       BUILD_BUG_ON(sizeof(sbp->sb_fname) > FSLABEL_MAX);
>>
>>       spin_lock(&mp->m_sb_lock);
>> -     strncpy(label, sbp->sb_fname, sizeof(sbp->sb_fname));
>> +     strncpy(label, sbp->sb_fname, XFSLABEL_MAX);
>>       spin_unlock(&mp->m_sb_lock);
>
> Hmm, shouldn't we just do a memcpy here?

I thought about that as well, but decided that strncpy()'s zero-padding
is better here than padding with potentially random contents of the user
space stack.

> Also given that the kernel never even looks at sb_fname maybe
> we can turn into an array of unsigned chars to escape those string
> warnings?

I don't think that makes a difference to gcc.

        Arnd
