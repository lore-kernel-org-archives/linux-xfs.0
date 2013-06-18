Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id B277A29DF8
	for <xfs@oss.sgi.com>; Mon, 17 Jun 2013 20:26:46 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 934AF304032
	for <xfs@oss.sgi.com>; Mon, 17 Jun 2013 18:26:43 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	BzaR0NcuamUbxGhJ for <xfs@oss.sgi.com>;
	Mon, 17 Jun 2013 18:26:42 -0700 (PDT)
Date: Tue, 18 Jun 2013 11:26:38 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: dmsetup arguments
Message-ID: <20130618012638.GO29376@dastard>
References: <51BAD98D.90808@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <51BAD98D.90808@oracle.com>
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

On Fri, Jun 14, 2013 at 12:51:25PM +0400, alexander.tsvetkov@oracle.com wrote:
> Hi,
> 
> XFStests suite generic/311 test fails on command: "sbin/dmsetup load
> flakey-test --table "0 150000001 flakey /dev/sdc2 0 0 180 1
> drop_writes" with error: "device-mapper: reload ioctl on flakey-test
> failed: Invalid argument", so as I understand the command format
> provided to ioctl is incorrect here. Kernel logs has message:
> 
> "Jun 13 16:47:15 tests kernel: device-mapper: table: 252:3: flakey:
> dm-flakey: Invalid argument count
> Jun 13 16:47:15 tests kernel: device-mapper: ioctl: error adding
> target to table"

What kernel and version of dmsetup are you using? If it is too old
to support the flakey target, then we need a new require rule check
for the test to avoid old versions of dmsetup...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
