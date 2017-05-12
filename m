Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:47100 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751729AbdELXL5 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 12 May 2017 19:11:57 -0400
Subject: Re: [PATCH 0.9/9] xfs: introduce the XFS_IOC_GETFSMAP ioctl
References: <149417257252.24656.2629280196308754994.stgit@birch.djwong.org>
 <20170508194755.GK5973@birch.djwong.org>
 <041fd06c-a3bc-e743-91b6-8ed6a33c78a5@sandeen.net>
 <20170512230509.GJ4519@birch.djwong.org>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <ffa4fc3e-d447-e46c-1861-1f5255ed2139@sandeen.net>
Date: Fri, 12 May 2017 18:11:56 -0500
MIME-Version: 1.0
In-Reply-To: <20170512230509.GJ4519@birch.djwong.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: sandeen@redhat.com, linux-xfs@vger.kernel.org

On 5/12/17 6:05 PM, Darrick J. Wong wrote:
> On Fri, May 12, 2017 at 05:29:32PM -0500, Eric Sandeen wrote:
>> On 5/8/17 2:47 PM, Darrick J. Wong wrote:
>>> From: Darrick J. Wong <darrick.wong@oracle.com>
>>>
>>> Introduce a new ioctl that uses the reverse mapping btree to return
>>> information about the physical layout of the filesystem.
>>>
>>> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
>>> ---
>>>  configure.ac          |    1 
>>>  include/builddefs.in  |    7 +++
>>>  include/linux.h       |  109 +++++++++++++++++++++++++++++++++++++++++++++++++
>>
>> So, I'm torn about whether we should be adding all the fsmap definitions
>> into xfsprogs.  (I know... I did it for statx; I'm wondering if that was a
>> bad precedent, and/or if it being a syscall makes it a different situation...).
>>
>> I don't know when we ever deprecate or remove this stuff.
>>
>> If you use packaged kernels, you'll get updated headers pretty quickly, right,
>> or on a devel box you might install your own?
>>
>> Not trying to be difficult, just trying to make sure we have a consistent
>> plan for new interfaces like this...
> 
> I was under the impression that we employ this evil hackery so that
> developers (at least) can build binaries for testing until the kernel
> headers in their build environments catch up.

Well, like I said, yeah I did it for statx.  So, that's probably enough
for you to say "stop whining and merge it!"

But do we have it for anything else?

Ok, we do override fsxattr - that was also your doing.  ;)

I guess we did the same for the FS_IOC_SET_ENCRYPTION_POLICY stuff,
though /that/ is all self-contained in io/encrypt.c.

hohum.

Ok, let's merge it, but maybe we need a policy of "nuke it after a year"

-eric

> ...unfortunately, that sort of implies that the sunset horizon is
> quite a ways out since I've never seen this stuff get removed.
> 
> --D
> 
>>
>> Thanks,
>> -Eric
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
