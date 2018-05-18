Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:35528 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750763AbeERRJZ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 18 May 2018 13:09:25 -0400
Subject: Re: [PATCH v2 5/5] mkfs.xfs: add configuration file parsing support
 using our own parser
References: <20180517192700.23457-1-mcgrof@kernel.org>
 <20180517192700.23457-6-mcgrof@kernel.org>
 <1f1e87df-aba5-e285-e3cb-820306f24f1c@sandeen.net>
 <20180518034600.GW23858@magnolia>
 <20180518153805.GE24680@garbanzo.do-not-panic.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <c2e7b213-0dad-7609-7984-e4c897d6bb08@sandeen.net>
Date: Fri, 18 May 2018 12:09:23 -0500
MIME-Version: 1.0
In-Reply-To: <20180518153805.GE24680@garbanzo.do-not-panic.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Luis R. Rodriguez" <mcgrof@kernel.org>, "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, jack@suse.com, jeffm@suse.com, okurz@suse.com, lpechacek@suse.com, jtulak@redhat.com

On 5/18/18 10:38 AM, Luis R. Rodriguez wrote:
> On Thu, May 17, 2018 at 08:46:00PM -0700, Darrick J. Wong wrote:
>> On Thu, May 17, 2018 at 10:24:13PM -0500, Eric Sandeen wrote:

...
  
> Let us recall that the reason for -c set in stone on /@sysconfigdir@/mkfs.xfs.d/
> was to allow clean simple code.
> 
> The MKFS_XFS_CONFIG is simply a comopromise to allow flexibility on a
> full path in case you cannot use the /@sysconfigdir@/mkfs.xfs.d/
> directory.
> 
> Supporting both remains simple.
> 
> If we wanted to support what you suggest, if a user specified -c hoogah
> we'd have to treat multiple possibilities in code, increasing complexity:
> 
>    a) Did the user mean the hoogah in the present directory?
>    b) Did the user mean hoogah in /@sysconfigdir@/mkfs.xfs.d/
> 
> Granted, if the user specified a -c /tmp/hoogah its clearer that the
> full path would be desirable. So, I think what you suggest makes sense
> provided we get rid of a) option and require only an alternative path
> *iff* the first character in the path is '/'. Does this work for all
> cases we wish to support a full path in?

Possibly include "./" as well. i.e.  mkfs.xfs -c ./configdir/myconfig

so:

mkfs.xfs -c hoogah		searches /@sysconfigdir@/mkfs.xfs.d/
mkfs.xfs -c ./hoogah		or
mkfs.xfs -c /path/to/hoogah	do exactly what you'd expect.

>> And the -c
>> option can be specified once to override the environment variable /
>> builtin detaults?

I'd like to drop the environment variable altogether.  If there is a strong
case to be made for keeping it, please make it. :)  (I don't consider the
existence of MKE2FS_CONFIG to be a strong argument, FWIW, because our
semantics & mechanisms are quite different.)

Thanks,
-Eric
