Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id CFA917F37
	for <xfs@oss.sgi.com>; Fri, 17 May 2013 05:34:40 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 4B091AC003
	for <xfs@oss.sgi.com>; Fri, 17 May 2013 03:34:40 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id HvhfznYoywWjYCpR (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 17 May 2013 03:34:39 -0700 (PDT)
Message-ID: <519607B6.5090009@oracle.com>
Date: Fri, 17 May 2013 18:34:30 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: Re: [PATCH v2 7/8] xfs: Add xfs_log_rlimit.[c|h]
References: <5195C279.3060502@oracle.com> <5195EC13.2060502@gmail.com>
	<5195FB1B.9000803@oracle.com> <20130517102946.GT24635@dastard>
In-Reply-To: <20130517102946.GT24635@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: "Michael L. Semon" <mlsemon35@gmail.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On 05/17/2013 06:29 PM, Dave Chinner wrote:
> On Fri, May 17, 2013 at 05:40:43PM +0800, Jeff Liu wrote:
>> Hi Michael,
>>
>> Are you compiling kernel on 32-bit system?
>>
>> Looks this issue is regarding 64-bit division at roundup() on 32-bit if so.
> 
> roundup_64() is what you want, then.
Yep, will take care of it.

Thanks,
-Jeff

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
