Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yw0-f194.google.com ([209.85.161.194]:38816 "EHLO
        mail-yw0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755270AbeCSO7B (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 19 Mar 2018 10:59:01 -0400
MIME-Version: 1.0
In-Reply-To: <20180319134013.GE27855@kroah.com>
References: <CAOQ4uxjE31j7XDpEGnnym7cgD_kqsPnio4KN2gphajsCNMrG1g@mail.gmail.com>
 <20180311162442.GB2013@kroah.com> <20180312162744.GB4865@magnolia>
 <CAOQ4uxjn8UN2-Hzr8u404ydKf8s41yVpMA93-n7r6Dr2VBz3dA@mail.gmail.com>
 <CAOQ4uxhdkhZup=ndukKCRtU13YVs8jQxT0zgOT_XN3_-tB8TfQ@mail.gmail.com>
 <CAOQ4uxhCjBA99X_C-GpEBf=jC4S_wSrxMwS6Ovj7BtWLK1GmUA@mail.gmail.com>
 <20180313131109.GB6260@lst.de> <CAOQ4uxiDHSC19-fRdZmXM5BJB3-p9_LdPgSmxpjGrdCzhV2W2Q@mail.gmail.com>
 <20180313215028.GE18129@dastard> <CAOQ4uxgsMwtQRCkpJTJoVO-mbU1yRz7F0pMOAVcJphEEKq8SHA@mail.gmail.com>
 <20180319134013.GE27855@kroah.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 19 Mar 2018 16:59:00 +0200
Message-ID: <CAOQ4uxjdXLzAd7eTgq5dcVmWSUH=xPWhQN_j8UFF8gsZx3J5wQ@mail.gmail.com>
Subject: Re: [PATCH v2] xfs: preserve i_rdev when recycling a reclaimable inode
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@lst.de>, "Darrick J. Wong" <darrick.wong@oracle.com>, Eryu Guan <eguan@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>, stable <stable@vger.kernel.org>

On Mon, Mar 19, 2018 at 3:40 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Wed, Mar 14, 2018 at 08:24:30AM +0200, Amir Goldstein wrote:
>> On Tue, Mar 13, 2018 at 11:50 PM, Dave Chinner <david@fromorbit.com> wrote:
>> > On Tue, Mar 13, 2018 at 04:33:15PM +0200, Amir Goldstein wrote:
>> >> On Tue, Mar 13, 2018 at 3:11 PM, Christoph Hellwig <hch@lst.de> wrote:
>> >> > On Tue, Mar 13, 2018 at 02:46:09PM +0200, Amir Goldstein wrote:
>> >> >> OK, found the patches the fix soft lockups in generic/269 and
>> >> >> assertion in generic/232, so expunging those 2 tests from v4.15.y
>> >> >> test runs.
>> >> >
>> >> > Which patches are those?  We should probably backport them to 4.15-stable.
>> >>
>> >> Probably, but I guess Darrick has those in his TODO.
>> >>
>> >> There is this series that refers to failure in generic/232:
>> >> https://marc.info/?l=linux-xfs&m=151701545720824&w=2
>> >>
>> >> These 2 commits refer to generic/269 specifically in commit message:
>> >>  70c57dcd606f xfs: skip CoW writes past EOF when writeback races with truncate
>> >>  be78ff0e7277 xfs: recheck reflink / dirty page status before freeing
>> >> CoW reservations
>> >> and the thread on the second commit also mentions generic/270
>> >> (I found out the hard way that it also soft locks).
>> >>
>> >> But there are surely more patches for stable in master.
>> >> I recon CC: stable and/or Fixes: tags could have been helpful,
>> >> but I don't see any of those in v4.16-rcX from the core xfs developers.
>> >
>> > AS I always say: if you want to maintain a stable backport kernel
>> > with all the fixes that go into the bleeding edge, you're more than
>> > welcome to do it.
>> >
>> > Everyone else is flat out just keeping up with on going development
>> > and fixing bugs in the kernel as it's moving forward. So if you have
>> > the need for stable backports, please keep backporting patches you
>> > need, testing them and asking the stable maintainers to include
>> > them.
>> >
>>
>> Greg,
>>
>> I tested the patch in question per Darrick's request.
>> I found no regressions with full "auto" run on xfs with reflinks enabled.
>> Please include this patch in stable 4.15.
>
> I have no idea anymore what "this patch" means here :(
>
> Please resend the git commit id of what I need to apply to where.
>

Please apply commit
acd1d71598f7 xfs: preserve i_rdev when recycling a reclaimable inode

to stable kernel v4.15

Thanks,
Amir.
