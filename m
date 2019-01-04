Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:40214 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726094AbfADWVX (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 4 Jan 2019 17:21:23 -0500
Subject: Re: [PATCH] generic: test that xattrs can have slashes in their names
References: <20190104212336.GC12689@magnolia>
 <c44b0678-a050-e887-aa6d-9dc29d6b45a8@sandeen.net>
 <20190104221246.GE21010@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <96fed5e3-784f-1969-09a0-52a040310fc6@sandeen.net>
Date: Fri, 4 Jan 2019 16:21:22 -0600
MIME-Version: 1.0
In-Reply-To: <20190104221246.GE21010@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Eryu Guan <guaneryu@gmail.com>, xfs <linux-xfs@vger.kernel.org>, fstests <fstests@vger.kernel.org>, Eric Sandeen <sandeen@redhat.com>

On 1/4/19 4:12 PM, Darrick J. Wong wrote:
> On Fri, Jan 04, 2019 at 03:27:37PM -0600, Eric Sandeen wrote:
>> On 1/4/19 3:23 PM, Darrick J. Wong wrote:
>>> From: Darrick J. Wong <darrick.wong@oracle.com>
>>>
>>> Eric Sandeen recently found a bug in xfs_repair that flagged extended
>>> attribute names containing "/" as corrupt and purged them.  There's
>>> nothing in the IRIX or Linux manuals that say anything about slashes not
>>> being allowed (and Linux certainly allows this) so let's make sure this
>>> continues to work.
>>>
>>> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
>>> ---
>>>  tests/generic/708     |   48 ++++++++++++++++++++++++++++++++++++++++++++++++
>>>  tests/generic/708.out |    6 ++++++
>>>  tests/generic/group   |    1 +
>>>  3 files changed, 55 insertions(+)
>>>  create mode 100755 tests/generic/708
>>>  create mode 100644 tests/generic/708.out
>>>
>>> diff --git a/tests/generic/708 b/tests/generic/708
>>> new file mode 100755
>>> index 00000000..ee63ba79
>>> --- /dev/null
>>> +++ b/tests/generic/708
>>> @@ -0,0 +1,48 @@
>>> +#! /bin/bash
>>> +# SPDX-License-Identifier: GPL-2.0+
>>> +# Copyright (c) 2019 Oracle, Inc.  All Rights Reserved.
>>> +#
>>> +# FS QA Test No. 708
>>> +#
>>> +# Check that xattrs can have slashes in their name.
>>
>> Perhaps a note about what failed before?  Because set/get/list has
>> always(tm) worked:
>>
>> # (xfs_repair previously flagged this as a corruption)
> 
> Ok.

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

(fine by me if that little change goes in on commit, not that important
but adds some clarity about what got fixed IMHO)
