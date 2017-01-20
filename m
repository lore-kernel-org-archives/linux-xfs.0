Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:57666 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753239AbdATUeB (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 20 Jan 2017 15:34:01 -0500
Subject: Re: [PATCH v3] xfsprogs: replace xfs_mode_to_ftype table with switch
 statement
References: <1484116217-7594-1-git-send-email-amir73il@gmail.com>
 <d1fbdb06-ae8a-d2db-cd02-bb5f06e7edfc@sandeen.net>
 <CAOQ4uxjbYZh8Wr28kJiUX6bnTn-bxgApKOA7qxwrbDA=Y31sVg@mail.gmail.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <62671831-e226-bcd9-8367-a3cbe3ca1e01@sandeen.net>
Date: Fri, 20 Jan 2017 14:33:58 -0600
MIME-Version: 1.0
In-Reply-To: <CAOQ4uxjbYZh8Wr28kJiUX6bnTn-bxgApKOA7qxwrbDA=Y31sVg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: "Darrick J . Wong" <darrick.wong@oracle.com>, Brian Foster <bfoster@redhat.com>, Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org

On 1/20/17 4:58 AM, Amir Goldstein wrote:
> On Wed, Jan 11, 2017 at 6:23 PM, Eric Sandeen <sandeen@sandeen.net> wrote:
>> On 1/11/17 12:30 AM, Amir Goldstein wrote:
>>> The size of the xfs_mode_to_ftype[] conversion table
>>> was too small to handle an invalid value of mode=S_IFMT.
>>>
>>> Instead of fixing the table size, replace the conversion table
>>> with a conversion helper that uses a switch statement.
>>>
>>> Suggested-by: Christoph Hellwig <hch@lst.de>
>>> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
>>> ---
>>>  libxfs/xfs_dir2.c    | 36 ++++++++++++++++++++++--------------
>>>  libxfs/xfs_dir2.h    |  5 ++---
>>>  repair/dino_chunks.c |  6 +-----
>>>  repair/phase6.c      |  2 +-
>>>  4 files changed, 26 insertions(+), 23 deletions(-)
>>>
>>> Eric,
>>>
>>> This is a matching patch to the one that got Reviewed-by Darrick for kernel.
>>>
>>> Tested xfs_repair with the new xfs/348 test with -n ftype=0|1.
>>
>> Thanks, I'll pull this in after Darrick commits it to the kernel.
>>
> 
> FYI, commit is in kernel and xfstest xfs/348 which sanity tests
> xfs_repair with this change
> is already merged as well.

Yep, merged & testing now.

Thanks,
-Eric
