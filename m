Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-qk0-f196.google.com ([209.85.220.196]:43878 "EHLO
        mail-qk0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1424852AbeCBJOg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Mar 2018 04:14:36 -0500
Received: by mail-qk0-f196.google.com with SMTP id j4so11080940qke.10
        for <linux-xfs@vger.kernel.org>; Fri, 02 Mar 2018 01:14:36 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAOQ4uxjfmrJ3OPAOJ_cVQjfmMeHbcJL3gWVdHEATa_FGPWLzCA@mail.gmail.com>
References: <CAJfpegtMhcAFpVk0TkAxdoiJzDqYFHFNzykztTGWfii52rPazA@mail.gmail.com>
 <CAOQ4uxjfmrJ3OPAOJ_cVQjfmMeHbcJL3gWVdHEATa_FGPWLzCA@mail.gmail.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 2 Mar 2018 10:14:35 +0100
Message-ID: <CAJfpeguueNEu+vJteL-6MVnerWmN=fNKbNbrP7tMDZg-exFccg@mail.gmail.com>
Subject: Re: Weird overlayfs/xfs bug on v4.15
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs <linux-xfs@vger.kernel.org>, overlayfs <linux-unionfs@vger.kernel.org>

On Fri, Mar 2, 2018 at 10:07 AM, Amir Goldstein <amir73il@gmail.com> wrote:
> On Fri, Mar 2, 2018 at 10:25 AM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>> Hi,
>>
>> I get xfstests failure of overlay/017 on a kvm guest.  The symptom is
>> that the chardev turns into a whiteout (i.e. the 1/1 device number
>> magically turns to 0/0 after flushing the caches) but then turns back
>> into the old chardev on remount or another cache flush.  So the
>> underlying xfs is not currupted but the cache is (verified that i_rdev
>> was indeed zeroed out on the relevant inode).
>>
>> Btw. i_rdev on the blkdev also turned zero, but the test doesn't
>> respond to that, because it's only checking the inum and not other
>> attributes.
>>
>> The test triggers reliably, but shows signs of a heisenbug (e.g.
>> adding printks lessens or eliminates the chance of triggering)
>>
>> Attaching the full xfs trace, the output of the testcase and guest
>> kernel config.
>>
>> Haven't been able to reproduce without overlayfs, so possibly
>> overlayfs is the culprit.
>>
>> Any ideas?
>>
>
> That is supposed to be fixed by
> acd1d71598f7 xfs: preserve i_rdev when recycling a reclaimable inode
>
> It fixes a v4.15 regression.

Ah, thanks.  Missed that due to not having the Cc: stable tag.

Thanks,
Miklos
