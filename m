Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:35654 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726028AbfFQOzp (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 17 Jun 2019 10:55:45 -0400
Subject: Re: [PATCH 1/9] libxfs: break out the GETXATTR/SETXATTR manpage
References: <155993574034.2343530.12919951702156931143.stgit@magnolia>
 <155993574662.2343530.11024375240678275350.stgit@magnolia>
 <1def4f4f-e938-76e2-2583-a07fc18b3ed8@sandeen.net>
 <20190615164332.GL3773859@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <d1930542-58e7-1709-3847-fe688b08d256@sandeen.net>
Date: Mon, 17 Jun 2019 09:55:44 -0500
MIME-Version: 1.0
In-Reply-To: <20190615164332.GL3773859@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On 6/15/19 11:43 AM, Darrick J. Wong wrote:
> On Fri, Jun 14, 2019 at 04:17:10PM -0500, Eric Sandeen wrote:
>> On 6/7/19 2:29 PM, Darrick J. Wong wrote:
>>> From: Darrick J. Wong <darrick.wong@oracle.com>
>>>
>>> Break out the xfs file attribute get and set ioctls into a separate
>>> manpage to reduce clutter in xfsctl.
>>
>> <comes up for air>
>>
>> Now that we've uh, hoisted it to be a generic vfs interface,
>> FS_IOC_FSGETXATTR, shouldn't we be documenting it as that instead
>> of the (old) xfs variant?
> 
> No, first we document the old xfs ioctl, then we move the manpage over
> to the main man-pages.git project as the vfs ioctl, and then we update
> the xfsprogs manpage to say "Please refer to the VFS documentation but
> in case your system doesn't have it, here you go..." :)

I guess it's kind of a sad state of affairs that I'm not quite sure
if this is serious.  :)

>>
>> (honestly that'd be mostly just search and replace for this patch)
>>
>> Except of course XFS_IOC_FSGETXATTRA has no vfs variant.  :/
>>
>> I also wonder if FS_IOC_SETFLAGS should be mentioned, and/or a
>> SEE_ALSO because some of the functionality overlaps?
> 
> Oh, wow, there's actually a manpage for it...
> 
> ...bleh, it's the weekend, I'll respond to the rest later.

ok thanks

-Eric
