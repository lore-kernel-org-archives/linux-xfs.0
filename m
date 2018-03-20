Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yw0-f173.google.com ([209.85.161.173]:37920 "EHLO
        mail-yw0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751790AbeCTI6A (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 20 Mar 2018 04:58:00 -0400
MIME-Version: 1.0
In-Reply-To: <3862e7b0-4136-b864-96f0-2880b05a8940@themaw.net>
References: <CAOQ4uxhubJhspfj+x7yRkTJ4rUXyhZoF0x3kjuFyv-0=Lxrctw@mail.gmail.com>
 <CAOQ4uxh0H8mbbAZt0MEdLGRY-8Aqg2c9UFM56-KL2b90fLYCFQ@mail.gmail.com>
 <20180317212814.GI7000@dastard> <CAOQ4uxit=nHvd2C080QeM27icSFra+0Anwu8vXqs4sd=8tCCNg@mail.gmail.com>
 <20180318230259.GJ7000@dastard> <CAOQ4uxiHkW41RB4LogWi8+rp_NhoC+SHGNY9_ShdQi7OyJTTVA@mail.gmail.com>
 <20180320014709.GC1150@dastard> <CAOQ4uxh+90vyCOqhLXtNi0U+YTsi6nCYuZFJMPhBWUaRwSBDvQ@mail.gmail.com>
 <3862e7b0-4136-b864-96f0-2880b05a8940@themaw.net>
From: Amir Goldstein <amir73il@gmail.com>
Date: Tue, 20 Mar 2018 10:57:58 +0200
Message-ID: <CAOQ4uxgwFn0bswy9W2N396cAJ8k80azjjkcu1M6grLMfRNLOKg@mail.gmail.com>
Subject: Re: Question about XFS_MAXINUMBER
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Ian Kent <raven@themaw.net>
Cc: Dave Chinner <david@fromorbit.com>, Miklos Szeredi <miklos@szeredi.hu>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs <linux-xfs@vger.kernel.org>, overlayfs <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Tue, Mar 20, 2018 at 10:04 AM, Ian Kent <raven@themaw.net> wrote:
> Hi Amir, Miklos,
>
> On 20/03/18 14:29, Amir Goldstein wrote:
>>
>> And I do appreciate the time you've put into understanding the overlayfs
>> problem and explaining the problems with my current proposal.
>>
>
> For a while now I've been wondering why overlayfs is keen to avoid using
> a local, persistent, inode number mapping cache?
>

A local persistent inode map is a more complex solution.
If you remove re-factoring, my patch set adds less than 100 lines of code
and it solves the problem for many real world setups.
A more complex solution needs a use case in the real world to justify
it over a less complex solution.
I am not saying we can avoid the complex solution forever, but so far,
I did not yet see the requests from users to justify it.

> Sure there can be subtle problems with them but there are problems with
> other alternatives too.
>

There is a difference between "not applicable" and "problematic"
The -o xino solution is not applicable to all setups, but I am not aware of
any problems with this solution.
Even without underlying filesystem declaring number of used ino bit,
user can declare this with overlayfs mount option, so practically, the
problem for overlayfs over xfs is already solved.

The discussion about a VFS API for max_ino_bits is to make users
life easier, but the API is not required to fix the overlayfs inode number
problem.

Thanks,
Amir.
