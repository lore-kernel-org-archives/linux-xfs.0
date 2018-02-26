Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yw0-f195.google.com ([209.85.161.195]:44314 "EHLO
        mail-yw0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752307AbeBZIdS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Feb 2018 03:33:18 -0500
MIME-Version: 1.0
In-Reply-To: <a127175a-50bc-e2e2-9426-02d5d25a4b10@gmx.com>
References: <20180226073111.3066-1-wqu@suse.com> <CAOQ4uxhsvGVH19HZE6b1exnFt3pB6qwLr=PUkjpXeq12F9sNJQ@mail.gmail.com>
 <a127175a-50bc-e2e2-9426-02d5d25a4b10@gmx.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 26 Feb 2018 10:33:17 +0200
Message-ID: <CAOQ4uxhXmoaJbJVCUk-9VXipTxuYhmTHAh89bWZ1xrWUUd76GA@mail.gmail.com>
Subject: Re: [RFC PATCH] fstests: Check if a fs can survive random (emulated)
 power loss
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Qu Wenruo <wqu@suse.com>, fstests <fstests@vger.kernel.org>, Linux Btrfs <linux-btrfs@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, Ext4 <linux-ext4@vger.kernel.org>, Josef Bacik <josef@toxicpanda.com>

On Mon, Feb 26, 2018 at 10:20 AM, Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
>
>
> On 2018=E5=B9=B402=E6=9C=8826=E6=97=A5 16:15, Amir Goldstein wrote:
>> On Mon, Feb 26, 2018 at 9:31 AM, Qu Wenruo <wqu@suse.com> wrote:
>>> This test case is originally designed to expose unexpected corruption
>>> for btrfs, where there are several reports about btrfs serious metadata
>>> corruption after power loss.
>>>
>>> The test case itself will trigger heavy fsstress for the fs, and use
>>> dm-flakey to emulate power loss by dropping all later writes.
>>>
>>
>> Come on... dm-flakey is so 2016
>> You should take Josef's fsstress+log-writes test and bring it to fstests=
:
>> https://github.com/josefbacik/log-writes
>>
>> By doing that you will gain two very important features from the test:
>>
>> 1. Problems will be discovered much faster, because the test can run fsc=
k
>>     after every single block write has been replayed instead of just at =
random
>>     times like in your test
>
> That's what exactly I want!!!
>
> Great thanks for this one! I would definitely look into this.
> (Although the initial commit is even older than 2016)
>

Please note that Josef's replay-individual-faster.sh script runs fsck
every 1000 writes (i.e. --check 1000), so you can play with this argument
in your test. Can also run --fsck every --check fua or --check flush, which
may be more indicative of real world problems. not sure.

>
> But the test itself could already expose something on EXT4, it still
> makes some sense for ext4 developers as a verification test case.
>

Please take a look at generic/456
When generic/455 found a reproduciable problem in ext4,
I created a specific test without any randomness to pin point the
problem found (using dm-flakey).
If the problem you found is reproduciable, then it will be easy for you
to create a similar "bisected" test.

Thanks,
Amir.
