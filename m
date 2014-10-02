Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A20CF7F50
	for <xfs@oss.sgi.com>; Thu,  2 Oct 2014 14:42:18 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 2F065AC005
	for <xfs@oss.sgi.com>; Thu,  2 Oct 2014 12:42:18 -0700 (PDT)
Received: from na01-bn1-obe.outbound.protection.outlook.com
	(mail-bn1on0114.outbound.protection.outlook.com
	[157.56.110.114]) by cuda.sgi.com with ESMTP id
	gOsuuEtwoRHQvNcW (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Thu, 02 Oct 2014 12:42:16 -0700 (PDT)
From: Simon Dray <sdray@Espial.com>
Subject: Re: XFS issue xfs goes offline with various messages drive not
	recoverable without reboot
Date: Thu, 2 Oct 2014 19:42:14 +0000
Message-ID: <3F39336F-7FE2-4FB5-815A-A0A6ACF0ACCB@Espial.com>
References: <dd6d1d6e9fa7469584e72574347bb088@BN1PR0301MB0625.namprd03.prod.outlook.com>
	<20140925081254.GH4758@dastard>
	<dcbe632f22434828866c744247fcad08@BN1PR0301MB0625.namprd03.prod.outlook.com>
	<542D712E.7050903@sandeen.net>
	<FC1F5573-DA27-4E68-98CA-B5CE63DACE3D@Espial.com>,
	<542DAA34.4090701@sandeen.net>
In-Reply-To: <542DAA34.4090701@sandeen.net>
Content-Language: en-GB
MIME-Version: 1.0
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

Eric

thanks appreciate your time

Regards Simon



> On 2 Oct 2014, at 20:40, Eric Sandeen <sandeen@sandeen.net> wrote:
> 
> Yes, something went wrong w/ storage, lost IOs, and xfs is reacting - 
> telling you about the problems it encountered as a result.
> 
> -Eric
> 
>> On 10/2/14 12:30 PM, Simon Dray wrote:
>> Eric
>> 
>> So would you say this is hardware
>> 
>> Thanks for looking 
>> 
>> Regards Simon
>> 
>> Simon Dray
>> Espial (UK)
>> sdray@espial.com
>> Tel: +441223716476
>> 
>> 
>>> On 2 Oct 2014, at 16:37, Eric Sandeen <sandeen@sandeen.net> wrote:
>>> 
>>> On 10/2/14 6:05 AM, Simon Dray wrote:
>>> 
>>> ...
>>>> CE: hpet increasing min_delta_ns to 40226 nsec
>>>> hpsa 0000:03:00.0: Abort request on C3:B0:T0:L4
>>>> hpsa 0000:03:00.0: cp ffff8800bd3ee000 is reported invalid (probably means target device no longer present)
>>>> hpsa 0000:03:00.0: cp ffff8800bd3ee000 is reported invalid (probably means target device no longer present)
>>>> hpsa 0000:03:00.0: FAILED abort on device C3:B0:T0:L4
>>>> hpsa 0000:03:00.0: resetting device 3:0:0:4
>>>> hpsa 0000:03:00.0: cp ffff8800bd3ee000 is reported invalid (probably means target device no longer present)
>>>> hpsa 0000:03:00.0: resetting device failed.
>>>> sd 3:0:0:4: Device offlined - not ready after error recovery
>>>> sd 3:0:0:4: [sde] Unhandled error code
>>>> sd 3:0:0:4: [sde] Result: hostbyte=DID_OK driverbyte=DRIVER_TIMEOUT
>>>> sd 3:0:0:4: [sde] CDB: Write(16): 8a 00 00 00 00 02 39 90 e9 60 00 00 0c 08 00 00
>>>> sd 3:0:0:4: rejecting I/O to offline device
>>>> sd 3:0:0:4: [sde] killing request
>>>> sd 3:0:0:4: rejecting I/O to offline device
>>>> sd 3:0:0:4: rejecting I/O to offline device
>>>> sd 3:0:0:4: rejecting I/O to offline device
>>>> sd 3:0:0:4: rejecting I/O to offline device
>>> ...
>>>> sd 3:0:0:4: [sde] Unhandled error code
>>>> sd 3:0:0:4: [sde] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
>>>> sd 3:0:0:4: [sde] CDB: Write(10): 2a 00 b6 43 28 00 00 0c 98 00
>>>> Buffer I/O error on device md0, logical block 3583397932
>>>> lost page write due to I/O error on md0
>>>> Buffer I/O error on device md0, logical block 3583397933
>>>> lost page write due to I/O error on md0
>>> ...
>>> 
>>> It looks like you need to address your storage issues first, and then see what if any repair needs to be done on the xfs filesystem.
>>> 
>>> -Eric
>> 
>> _______________________________________________
>> xfs mailing list
>> xfs@oss.sgi.com
>> http://oss.sgi.com/mailman/listinfo/xfs
>> 
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
