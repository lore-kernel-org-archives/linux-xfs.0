Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 8122C7F50
	for <xfs@oss.sgi.com>; Fri, 22 Nov 2013 03:56:47 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 3A0E6304053
	for <xfs@oss.sgi.com>; Fri, 22 Nov 2013 01:56:47 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id xu8zwcAMxd3B9yRI (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 22 Nov 2013 01:56:45 -0800 (PST)
Message-ID: <528F2A40.8060502@oracle.com>
Date: Fri, 22 Nov 2013 17:56:16 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs: make quota metadata truncation behavior consistent
	to user space
References: <528EF3D0.70102@oracle.com> <20131122091827.GC32568@infradead.org>
In-Reply-To: <20131122091827.GC32568@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On 11/22 2013 17:18, Christoph Hellwig wrote:
> On Fri, Nov 22, 2013 at 02:04:00PM +0800, Jeff Liu wrote:
>> From: Jie Liu <jeff.liu@oracle.com>
>>
>> In xfs_qm_scall_trunc_qfiles(), we ignore the error if failed to remove
>> the users quota metadata and proceed to remove groups and projects if
>> they are being there.  However, in user space, the remove operation will
>> break and return if failed to remove any kind of quota.
>> Also for v5 super block, we can enabled both group and project quota at
>> the same time, in this case the current error handling will cover the
>> group error with projects but they might failed due to different reasons.
>>
>> It seems we'd better the error handling consistent to the user space and
>> don't trying to remove another kind of quota metadata if the previous
>> operation is failed.
> 
> Looks good.  Just curious, did you manage to reproduce an error
> truncating the quota files?
Yup, I thought it over how to break it while occasionally glanced over this
function for backporting upstream patches this morning, but can not figure
out a simple method.

Thanks,
-Jeff 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
