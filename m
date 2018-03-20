Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:60795 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752108AbeCTKSm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 20 Mar 2018 06:18:42 -0400
Subject: Re: Question about XFS_MAXINUMBER
References: <CAOQ4uxhubJhspfj+x7yRkTJ4rUXyhZoF0x3kjuFyv-0=Lxrctw@mail.gmail.com>
 <CAOQ4uxh0H8mbbAZt0MEdLGRY-8Aqg2c9UFM56-KL2b90fLYCFQ@mail.gmail.com>
 <20180317212814.GI7000@dastard>
 <CAOQ4uxit=nHvd2C080QeM27icSFra+0Anwu8vXqs4sd=8tCCNg@mail.gmail.com>
 <20180318230259.GJ7000@dastard>
 <CAOQ4uxiHkW41RB4LogWi8+rp_NhoC+SHGNY9_ShdQi7OyJTTVA@mail.gmail.com>
 <20180320014709.GC1150@dastard>
 <CAOQ4uxh+90vyCOqhLXtNi0U+YTsi6nCYuZFJMPhBWUaRwSBDvQ@mail.gmail.com>
 <3862e7b0-4136-b864-96f0-2880b05a8940@themaw.net>
 <CAOQ4uxgwFn0bswy9W2N396cAJ8k80azjjkcu1M6grLMfRNLOKg@mail.gmail.com>
From: Ian Kent <raven@themaw.net>
Message-ID: <27c334d5-1aaa-f124-33a9-3bcd0e27c258@themaw.net>
Date: Tue, 20 Mar 2018 18:18:33 +0800
MIME-Version: 1.0
In-Reply-To: <CAOQ4uxgwFn0bswy9W2N396cAJ8k80azjjkcu1M6grLMfRNLOKg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: Dave Chinner <david@fromorbit.com>, Miklos Szeredi <miklos@szeredi.hu>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs <linux-xfs@vger.kernel.org>, overlayfs <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On 20/03/18 16:57, Amir Goldstein wrote:
> On Tue, Mar 20, 2018 at 10:04 AM, Ian Kent <raven@themaw.net> wrote:
>> Hi Amir, Miklos,
>>
>> On 20/03/18 14:29, Amir Goldstein wrote:
>>>
>>> And I do appreciate the time you've put into understanding the overlayfs
>>> problem and explaining the problems with my current proposal.
>>>
>>
>> For a while now I've been wondering why overlayfs is keen to avoid using
>> a local, persistent, inode number mapping cache?
>>
> 
> A local persistent inode map is a more complex solution.
> If you remove re-factoring, my patch set adds less than 100 lines of code
> and it solves the problem for many real world setups.
> A more complex solution needs a use case in the real world to justify
> it over a less complex solution.

Indeed, it is significantly more complex.

Ian
