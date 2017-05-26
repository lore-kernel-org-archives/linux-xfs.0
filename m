Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44170 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1948790AbdEZWM1 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 26 May 2017 18:12:27 -0400
Subject: Re: [PATCH 0.9/9] xfs: introduce the XFS_IOC_GETFSMAP ioctl
References: <149417257252.24656.2629280196308754994.stgit@birch.djwong.org>
 <20170508194755.GK5973@birch.djwong.org>
 <9d94c89f-f730-955c-bde3-eb9264737303@sandeen.net>
 <20170526214142.GO4521@birch.djwong.org>
From: Eric Sandeen <sandeen@redhat.com>
Message-ID: <0e27be7e-17b0-391f-bc80-512ad5523436@redhat.com>
Date: Fri, 26 May 2017 17:12:25 -0500
MIME-Version: 1.0
In-Reply-To: <20170526214142.GO4521@birch.djwong.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs@vger.kernel.org

On 5/26/17 4:41 PM, Darrick J. Wong wrote:
> On Fri, May 26, 2017 at 04:20:49PM -0500, Eric Sandeen wrote:
>>
>>
>> On 5/8/17 2:47 PM, Darrick J. Wong wrote:
>>> From: Darrick J. Wong <darrick.wong@oracle.com>
>>>
>>> Introduce a new ioctl that uses the reverse mapping btree to return
>>> information about the physical layout of the filesystem.
>>>
>>> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
>>
>> Ok, howzabout this:
>>
>> Changes from your version:
>>
>> - remove libxfs stuff, I synced that separately already
>> - rename sys_fsmap just fsmap (it's not a syscall)
>> - change meaning of "have_fsmap" - it now means we have it on the
>>   system, not that this platform (linux) might support it.*
> 
> I'll have a look... though afaict this removes anything that would
> prevent us from building the fsmap stuff on a non-linux platform.
> Seeing as fsmap is linux-only, we might as well restrict it on the
> platforms we still support.

Right, so in this patch, either we define HAVE_GETFSMAP if we find
it on the system, or we implement it in include/linux.h and define
it then.  So HAVE_GETFSMAP won't get set on non-linux.

But in the next patch that actually makes use of the fsmap ioctl,
we'll need to conditionally include fsmap.c, and then all should
be good, I think, right?  Something like:

+# On linux we get fsmap from the system or define it ourselves
+# so include this based on platform type.  If this reverts to only
+# the autoconf check w/o local definition, change to testing HAVE_GETFSMAP
+ifeq ($(PKG_PLATFORM),linux)
+CFILES += fsmap.c
+endif

> Darwin?  (I think Jan Tulak added this, though OSX doen't do XFS...)
> BSD?  (Wasn't XFS removed from their kernel a few years ago?)

Jan, do you still use it? 

-Eric
