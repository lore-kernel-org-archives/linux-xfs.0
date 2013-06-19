Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 2B1F67CBF
	for <xfs@oss.sgi.com>; Wed, 19 Jun 2013 09:42:11 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E3A4B8F8035
	for <xfs@oss.sgi.com>; Wed, 19 Jun 2013 07:42:10 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id 4HNMRKj4fdWf0VnG (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 19 Jun 2013 07:42:09 -0700 (PDT)
Message-ID: <51C1C33A.5040501@oracle.com>
Date: Wed, 19 Jun 2013 18:42:02 +0400
From: alexander.tsvetkov@oracle.com
MIME-Version: 1.0
Subject: Re: dmsetup arguments
References: <51BAD98D.90808@oracle.com> <20130618012638.GO29376@dastard>
	<51C04DCC.7010401@oracle.com> <20130618132346.GT29338@dastard>
In-Reply-To: <20130618132346.GT29338@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 06/18/13 17:23, Dave Chinner wrote:
> On Tue, Jun 18, 2013 at 04:08:44PM +0400, alexander.tsvetkov@oracle.com wrote:
>> On 06/18/13 05:26, Dave Chinner wrote:
>>> On Fri, Jun 14, 2013 at 12:51:25PM +0400, alexander.tsvetkov@oracle.com wrote:
>>>> Hi,
>>>>
>>>> XFStests suite generic/311 test fails on command: "sbin/dmsetup load
>>>> flakey-test --table "0 150000001 flakey /dev/sdc2 0 0 180 1
>>>> drop_writes" with error: "device-mapper: reload ioctl on flakey-test
>>>> failed: Invalid argument", so as I understand the command format
>>>> provided to ioctl is incorrect here. Kernel logs has message:
>>>>
>>>> "Jun 13 16:47:15 tests kernel: device-mapper: table: 252:3: flakey:
>>>> dm-flakey: Invalid argument count
>>>> Jun 13 16:47:15 tests kernel: device-mapper: ioctl: error adding
>>>> target to table"
>>> What kernel and version of dmsetup are you using? If it is too old
>>> to support the flakey target, then we need a new require rule check
>>> for the test to avoid old versions of dmsetup...
>> Kernel version is 2.6.39, version of device-mapper-libs is 1.02.77.
> So it's an old version of both the kernel and DM, so it's probably
> not been tested at all. Like I said - it probably needs a better
> check in _require_dm_flakey() to determine if the test should be run
> or not.
>
I agree about kernel version, but why DM version of 1.02.77 is also old? 
I though that I am using the latest version of DM referenced by these 
sources:

"Releases
The userspace code (dmsetup and libdevmapper) is now maintained 
alongside the LVM2 source available from http://sources.redhat.com/lvm2/."

http://www.sourceware.org/dm/

and

"Source code

The source code is stored in git and can be accessed with git clone 
git://git.fedorahosted.org/git/lvm2.git
There is a web interface to git at http://git.fedorahosted.org/git/lvm2.git"

http://sources.redhat.com/lvm2/

so finally I've got DM of version 1.02.77 within lvm2 package of version 
2.02.98 from http://git.fedorahosted.org/git/lvm2.git, it's of latest 
released version in the provided list.
Most recent lvm2 package from master branch of 2.02.99 version contains 
DM ofversion 1.02.78 which has no attribute "drop_writes" in sources as 
well.

Thanks,
Alexander Tsvetkov

> Patches are welcome...
>
> Cheers,
>
> Dave.
>
> PS: please reply-to-all for mailing list traffic, not by private
> email. I've re-added the XFS list to the CC list.
>
> PPS: Top posting destroys the context of your reply - nobody has any
> idea of what part of the previous message you are responding to.
> Repsonding inline is much easier to follow with when conversions get
> long...

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
