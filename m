Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 7FC7D7F55
	for <xfs@oss.sgi.com>; Thu,  2 Oct 2014 10:37:21 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 5CFDB8F8059
	for <xfs@oss.sgi.com>; Thu,  2 Oct 2014 08:37:18 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id NhYyiXXCqgU9Uvp2 for <xfs@oss.sgi.com>;
	Thu, 02 Oct 2014 08:37:16 -0700 (PDT)
Message-ID: <542D712E.7050903@sandeen.net>
Date: Thu, 02 Oct 2014 10:37:18 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: XFS issue xfs goes offline with various messages drive not
	recoverable without reboot
References: <dd6d1d6e9fa7469584e72574347bb088@BN1PR0301MB0625.namprd03.prod.outlook.com>	<20140925081254.GH4758@dastard>
	<dcbe632f22434828866c744247fcad08@BN1PR0301MB0625.namprd03.prod.outlook.com>
In-Reply-To: <dcbe632f22434828866c744247fcad08@BN1PR0301MB0625.namprd03.prod.outlook.com>
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
To: Simon Dray <sdray@Espial.com>, Dave Chinner <david@fromorbit.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On 10/2/14 6:05 AM, Simon Dray wrote:

...
> CE: hpet increasing min_delta_ns to 40226 nsec
> hpsa 0000:03:00.0: Abort request on C3:B0:T0:L4
> hpsa 0000:03:00.0: cp ffff8800bd3ee000 is reported invalid (probably means target device no longer present)
> hpsa 0000:03:00.0: cp ffff8800bd3ee000 is reported invalid (probably means target device no longer present)
> hpsa 0000:03:00.0: FAILED abort on device C3:B0:T0:L4
> hpsa 0000:03:00.0: resetting device 3:0:0:4
> hpsa 0000:03:00.0: cp ffff8800bd3ee000 is reported invalid (probably means target device no longer present)
> hpsa 0000:03:00.0: resetting device failed.
> sd 3:0:0:4: Device offlined - not ready after error recovery
> sd 3:0:0:4: [sde] Unhandled error code
> sd 3:0:0:4: [sde] Result: hostbyte=DID_OK driverbyte=DRIVER_TIMEOUT
> sd 3:0:0:4: [sde] CDB: Write(16): 8a 00 00 00 00 02 39 90 e9 60 00 00 0c 08 00 00
> sd 3:0:0:4: rejecting I/O to offline device
> sd 3:0:0:4: [sde] killing request
> sd 3:0:0:4: rejecting I/O to offline device
> sd 3:0:0:4: rejecting I/O to offline device
> sd 3:0:0:4: rejecting I/O to offline device
> sd 3:0:0:4: rejecting I/O to offline device
...
> sd 3:0:0:4: [sde] Unhandled error code
> sd 3:0:0:4: [sde] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
> sd 3:0:0:4: [sde] CDB: Write(10): 2a 00 b6 43 28 00 00 0c 98 00
> Buffer I/O error on device md0, logical block 3583397932
> lost page write due to I/O error on md0
> Buffer I/O error on device md0, logical block 3583397933
> lost page write due to I/O error on md0
...

It looks like you need to address your storage issues first, and then see what if any repair needs to be done on the xfs filesystem.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
