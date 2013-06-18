Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 10CB67CBF
	for <xfs@oss.sgi.com>; Tue, 18 Jun 2013 08:23:56 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id EFDB98F8035
	for <xfs@oss.sgi.com>; Tue, 18 Jun 2013 06:23:52 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	kz4jENGjVEPWac6B for <xfs@oss.sgi.com>;
	Tue, 18 Jun 2013 06:23:51 -0700 (PDT)
Date: Tue, 18 Jun 2013 23:23:46 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: dmsetup arguments
Message-ID: <20130618132346.GT29338@dastard>
References: <51BAD98D.90808@oracle.com> <20130618012638.GO29376@dastard>
	<51C04DCC.7010401@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <51C04DCC.7010401@oracle.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: alexander.tsvetkov@oracle.com
Cc: xfs@oss.sgi.com

On Tue, Jun 18, 2013 at 04:08:44PM +0400, alexander.tsvetkov@oracle.com wrote:
> On 06/18/13 05:26, Dave Chinner wrote:
> >On Fri, Jun 14, 2013 at 12:51:25PM +0400, alexander.tsvetkov@oracle.com wrote:
> >>Hi,
> >>
> >>XFStests suite generic/311 test fails on command: "sbin/dmsetup load
> >>flakey-test --table "0 150000001 flakey /dev/sdc2 0 0 180 1
> >>drop_writes" with error: "device-mapper: reload ioctl on flakey-test
> >>failed: Invalid argument", so as I understand the command format
> >>provided to ioctl is incorrect here. Kernel logs has message:
> >>
> >>"Jun 13 16:47:15 tests kernel: device-mapper: table: 252:3: flakey:
> >>dm-flakey: Invalid argument count
> >>Jun 13 16:47:15 tests kernel: device-mapper: ioctl: error adding
> >>target to table"
> >What kernel and version of dmsetup are you using? If it is too old
> >to support the flakey target, then we need a new require rule check
> >for the test to avoid old versions of dmsetup...
>
> Kernel version is 2.6.39, version of device-mapper-libs is 1.02.77.

So it's an old version of both the kernel and DM, so it's probably
not been tested at all. Like I said - it probably needs a better
check in _require_dm_flakey() to determine if the test should be run
or not.

Patches are welcome...

Cheers,

Dave.

PS: please reply-to-all for mailing list traffic, not by private
email. I've re-added the XFS list to the CC list.

PPS: Top posting destroys the context of your reply - nobody has any
idea of what part of the previous message you are responding to.
Repsonding inline is much easier to follow with when conversions get
long...
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
