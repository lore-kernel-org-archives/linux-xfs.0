Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:36792 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751840AbdATK6Z (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 20 Jan 2017 05:58:25 -0500
Received: by mail-oi0-f65.google.com with SMTP id u143so5223322oif.3
        for <linux-xfs@vger.kernel.org>; Fri, 20 Jan 2017 02:58:25 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <d1fbdb06-ae8a-d2db-cd02-bb5f06e7edfc@sandeen.net>
References: <1484116217-7594-1-git-send-email-amir73il@gmail.com> <d1fbdb06-ae8a-d2db-cd02-bb5f06e7edfc@sandeen.net>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 20 Jan 2017 12:58:24 +0200
Message-ID: <CAOQ4uxjbYZh8Wr28kJiUX6bnTn-bxgApKOA7qxwrbDA=Y31sVg@mail.gmail.com>
Subject: Re: [PATCH v3] xfsprogs: replace xfs_mode_to_ftype table with switch statement
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: "Darrick J . Wong" <darrick.wong@oracle.com>, Brian Foster <bfoster@redhat.com>, Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org

On Wed, Jan 11, 2017 at 6:23 PM, Eric Sandeen <sandeen@sandeen.net> wrote:
> On 1/11/17 12:30 AM, Amir Goldstein wrote:
>> The size of the xfs_mode_to_ftype[] conversion table
>> was too small to handle an invalid value of mode=S_IFMT.
>>
>> Instead of fixing the table size, replace the conversion table
>> with a conversion helper that uses a switch statement.
>>
>> Suggested-by: Christoph Hellwig <hch@lst.de>
>> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
>> ---
>>  libxfs/xfs_dir2.c    | 36 ++++++++++++++++++++++--------------
>>  libxfs/xfs_dir2.h    |  5 ++---
>>  repair/dino_chunks.c |  6 +-----
>>  repair/phase6.c      |  2 +-
>>  4 files changed, 26 insertions(+), 23 deletions(-)
>>
>> Eric,
>>
>> This is a matching patch to the one that got Reviewed-by Darrick for kernel.
>>
>> Tested xfs_repair with the new xfs/348 test with -n ftype=0|1.
>
> Thanks, I'll pull this in after Darrick commits it to the kernel.
>

FYI, commit is in kernel and xfstest xfs/348 which sanity tests
xfs_repair with this change
is already merged as well.
