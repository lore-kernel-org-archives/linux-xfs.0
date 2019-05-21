Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:42124 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728283AbfEUTAA (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 21 May 2019 15:00:00 -0400
Subject: Re: [PATCH 07/12] libfrog: fix bitmap return values
References: <155839420081.68606.4573219764134939943.stgit@magnolia>
 <155839424514.68606.14562327454853103352.stgit@magnolia>
 <5caa6c9e-3a42-6c8e-101b-c198af77e765@sandeen.net>
 <20190521170103.GD5141@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <c281d3c3-5385-90a3-125a-8a620944c971@sandeen.net>
Date: Tue, 21 May 2019 13:59:58 -0500
MIME-Version: 1.0
In-Reply-To: <20190521170103.GD5141@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On 5/21/19 12:01 PM, Darrick J. Wong wrote:
> On Tue, May 21, 2019 at 11:54:18AM -0500, Eric Sandeen wrote:
>> On 5/20/19 6:17 PM, Darrick J. Wong wrote:
>>> From: Darrick J. Wong <darrick.wong@oracle.com>
>>>
>>> Fix the return types of non-predicate bitmap functions to return the
>>> usual negative error codes instead of the "moveon" boolean.
>>
>> This seems much better, though how did you decide on negative
>> error codes?  They are usual for the kernel, but in userspace
>> we have kind of a mishmash, even in libfrog.
>>
>>   File                 Function                 Line
>> 0 libfrog/paths.c      fs_table_insert          176 error = ENOMEM;
>> 1 libfrog/paths.c      fs_extract_mount_options 354 return ENOMEM;
>> 2 libfrog/radix-tree.c radix_tree_extend        135 return -ENOMEM;
>> 3 libfrog/radix-tree.c radix_tree_insert        188 return -ENOMEM;
>> 4 libfrog/workqueue.c  workqueue_add            110 return ENOMEM;
>>
>> 3 libfrog/paths.c         fs_table_initialise_mounts         384 return ENOENT;
>> 4 libfrog/paths.c         fs_table_initialise_projects       489 error = ENOENT;
>> 5 libfrog/paths.c         fs_table_insert_project_path       560 error = ENOENT;
> 
> Blindly copying libxfs style. :)
> 
> I see your point about being consistent within libfrog but OTOH it's
> messy that we're not consistent across the various xfsprogs libraries.
> 
> Uhm.... I'll change it if you want.

If I were king (am I king?) I'd say that kernel code does negative values,
userspace does positive, and we handle differences at the interface.

Mostly I just want it to be predictable and consistent...

AFAICT everything in libfrog is positive except for the radix-tree stuff,
which is nominally kernel-ish ...?

Userspace clearly needs some cleanups; mkfs parsers return negative, everything
else seems positive; a couple metadump functions return negative, the rest is
positive; most userspace callers of libxfs negate the negative error return...

So yeah I'm of the opinion that unless it's kernel(-ish?) code it should be
positive, and I can send a patch to clean up stuff that's not.

I can be swayed by counterarguments if you have them.  :)

-Eric
