Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-it0-f68.google.com ([209.85.214.68]:39565 "EHLO
        mail-it0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726983AbeHDQ0S (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 4 Aug 2018 12:26:18 -0400
Received: by mail-it0-f68.google.com with SMTP id g141-v6so12405818ita.4
        for <linux-xfs@vger.kernel.org>; Sat, 04 Aug 2018 07:25:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180804090619.GA1888@infradead.org>
References: <20180803191730.GX30972@magnolia> <20180804090619.GA1888@infradead.org>
From: Andreas Gruenbacher <agruenba@redhat.com>
Date: Sat, 4 Aug 2018 16:25:26 +0200
Message-ID: <CAHc6FU4dGZ_XC3ZPt6LJn8BqTZ_VJVK=4Z6vyG41_oGRV1CzVA@mail.gmail.com>
Subject: Re: [ANNOUNCE] xfs-linux: for-next updated to a0e336ba3e3d
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, xfs <linux-xfs@vger.kernel.org>

On 4 August 2018 at 11:06, Christoph Hellwig <hch@infradead.org> wrote:
>> Andreas Gruenbacher (6):
>>       [3d7b6b21f6c5] iomap: mark newly allocated buffer heads as new
>>       [ebf00be37de3] iomap: complete partial direct I/O writes synchronously
>>       [19e0c58f6552] iomap: generic inline data handling
>>       [e184fde6f3f5] iomap: add private pointer to struct iomap
>>       [ec181f6782d8] iomap: support direct I/O to inline data
>>       [806a1477b10a] iomap: add inline data support to iomap_readpage_actor
>
> Did you rebase the tree?  We really need to keep the iomap base
> branch stable as the gfs2 tree is also based on it and we want to avoid
> duplicate commits.

Those hashes look okay to me. We only depend on the iomap-4.19-merge
branch, and that hasn't changed in a while and is still consistent
with the gfs2 for-next branch.

Thanks,
Andreas
