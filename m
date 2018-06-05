Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:51886 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752412AbeFEVvn (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 5 Jun 2018 17:51:43 -0400
Subject: Re: [PATCH] xfs: mark sb_fname as nonstring
References: <20180525151421.2317292-1-arnd@arndb.de>
 <ea7ec2ef-f30f-c4dc-c1d3-c0a2a4810fd5@sandeen.net>
 <CAK8P3a1qnvUVN0jF3BYgtyCSNL6gZm8Lc3pg8kVfga5TVN2vTg@mail.gmail.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <b6cfddbc-e643-231c-af73-d1ca686ea057@sandeen.net>
Date: Tue, 5 Jun 2018 16:51:41 -0500
MIME-Version: 1.0
In-Reply-To: <CAK8P3a1qnvUVN0jF3BYgtyCSNL6gZm8Lc3pg8kVfga5TVN2vTg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Arnd Bergmann <arnd@arndb.de>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs <linux-xfs@vger.kernel.org>, Eric Sandeen <sandeen@redhat.com>, Martin Sebor <msebor@gmail.com>, Brian Foster <bfoster@redhat.com>, Dave Chinner <dchinner@redhat.com>, Dan Williams <dan.j.williams@intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>



On 6/5/18 4:23 PM, Arnd Bergmann wrote:
> On Tue, Jun 5, 2018 at 8:44 PM, Eric Sandeen <sandeen@sandeen.net> wrote:
>> On 5/25/18 10:14 AM, Arnd Bergmann wrote:
> 
>>> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
>>> index 84fbf164cbc3..eb79f2bc4dcc 100644
>>> --- a/fs/xfs/xfs_ioctl.c
>>> +++ b/fs/xfs/xfs_ioctl.c
>>> @@ -1819,12 +1819,12 @@ xfs_ioc_getlabel(
>>>       BUILD_BUG_ON(sizeof(sbp->sb_fname) > FSLABEL_MAX);
>>>
>>>       spin_lock(&mp->m_sb_lock);
>>> -     strncpy(label, sbp->sb_fname, sizeof(sbp->sb_fname));
>>> +     strncpy(label, sbp->sb_fname, XFSLABEL_MAX);
>>>       spin_unlock(&mp->m_sb_lock);
>>>
>>>       /* xfs on-disk label is 12 chars, be sure we send a null to user */
>>>       label[XFSLABEL_MAX] = '\0';
>>> -     if (copy_to_user(user_label, label, sizeof(sbp->sb_fname)))
>>> +     if (copy_to_user(user_label, label, sizeof(label)))
>>
>> I /think/ this also runs the risk of copying out stack memory.
>>
>> I'll send another proposal based on this with slight modifications.
> 
> I assumed it's safe since the earlier strncpy() pads the local 'label'
> with zero bytes up the XFSLABEL_MAX, and the last byte
> is explicitly set to guarantee zero padding.

Ah you are right, I forgot that strncpy pads.  Did I mention that I hate
C strings... o_O

In that case I suppose your original patch is fine, if you'd like to fix
the "mark as nonstring" subject.

Thanks,
-Eric

