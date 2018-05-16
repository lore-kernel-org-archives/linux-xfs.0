Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33002 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750846AbeEPOmS (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 16 May 2018 10:42:18 -0400
Subject: Re: [PATCH V3] test online label ioctl
References: <2a743318-585d-9eb1-5430-2b07246348ab@redhat.com>
 <d65893a4-c6d8-1d85-4650-e63d04e8366a@sandeen.net>
 <20180516005139.GI10363@dastard>
From: Eric Sandeen <sandeen@redhat.com>
Message-ID: <505eba27-476e-2bb7-9d72-11d64d31e6c3@redhat.com>
Date: Wed, 16 May 2018 09:42:17 -0500
MIME-Version: 1.0
In-Reply-To: <20180516005139.GI10363@dastard>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>, Eric Sandeen <sandeen@sandeen.net>
Cc: fstests <fstests@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>

On 5/15/18 7:51 PM, Dave Chinner wrote:
> On Tue, May 15, 2018 at 10:22:37AM -0500, Eric Sandeen wrote:
>> This tests the online label ioctl that btrfs has, which has been
>> recently proposed for XFS.
>>
>> To run, it requires an updated xfs_io with the label command and a
>> filesystem that supports it
>>
>> A slight change here to _require_xfs_io_command as well, so that tests
>> which simply fail with "Inappropriate ioctl" can be caught in the
>> common case.
>>
>> Signed-off-by: Eric Sandeen<sandeen@redhat.com>
>> ---
>>
>> (urgh send as proper new thread, sorry)
>>
>> This passes on btrfs, _notruns on xfs/ext4 of yore, and passes
>> on xfs w/ my online label patchset (as long as xfs_io has the new
>> capability)
>>
>> V2: Add a max label length helper
>>      Set the proper btrfs max label length o_O oops
>>      Filter trailing whitespace from blkid output
>>
>> V3: lowercase local vars, simplify max label len function
> Looks good now, but I wondered about one thing the test doesn't
> cover: can you clear the label by setting it to a null string?
> i.e you check max length bounds, but don't check empty string
> behaviour...

hohum, yes.  I'll fix that, which will also require a change to xfs_io
to be able to set a null string.

Will send a V3 in a bit.

-Eric
