Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:55158 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965063AbeFOCCM (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 14 Jun 2018 22:02:12 -0400
Subject: Re: [PATCH] xfs: symlinks can be zero length during log recovery
From: Eric Sandeen <sandeen@sandeen.net>
References: <20180615014314.27574-1-david@fromorbit.com>
 <2a19410d-171e-37b0-c4d4-5ae427ee8901@sandeen.net>
Message-ID: <596c6c42-371a-0a77-8dc6-6f34e7e6d897@sandeen.net>
Date: Thu, 14 Jun 2018 21:02:11 -0500
MIME-Version: 1.0
In-Reply-To: <2a19410d-171e-37b0-c4d4-5ae427ee8901@sandeen.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org



On 6/14/18 8:57 PM, Eric Sandeen wrote:
> On 6/14/18 8:43 PM, Dave Chinner wrote:
>> From: Dave Chinner <dchinner@redhat.com>
>>
>> A log recovery failure has been reproduced where a symlink inode has
>> a zero length in extent form. It was caused by a shutdown during a
>> combined fstress+fsmark workload.
>>
>> To fix it, we have to allow zero length symlink inodes through
>> xfs_dinode_verify() during log recovery. We already specifically
>> check and allow this case in the shortform symlink fork verifier,
>> but in this case we don't get that far, and the inode is not in
>> shortform format.
>>
>> Update the dinode verifier to handle this case, and change the
>> symlink fork verifier to only allow this case to exist during log
>> recovery.
>>
>> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> 
> Looks reasonable.
> 
> Reviewed-by: Eric Sandeen <sandeen@redhat.com>

Also probably worth tagging with

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=200063
