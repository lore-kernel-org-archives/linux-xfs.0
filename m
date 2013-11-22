Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B34B87F50
	for <xfs@oss.sgi.com>; Fri, 22 Nov 2013 10:21:00 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 9D4308F8064
	for <xfs@oss.sgi.com>; Fri, 22 Nov 2013 08:21:00 -0800 (PST)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id 7QXDDnF01YzhHPne (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 22 Nov 2013 08:20:56 -0800 (PST)
Message-ID: <528F84A2.4060504@oracle.com>
Date: Sat, 23 Nov 2013 00:21:54 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs: integrate xfs_quota_priv header file to xfs_qm
References: <528E188C.6070208@oracle.com>
	<20131122153807.GC15143@infradead.org>
In-Reply-To: <20131122153807.GC15143@infradead.org>
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

On 11/22/2013 11:38 PM, Christoph Hellwig wrote:

> On Thu, Nov 21, 2013 at 10:28:28PM +0800, Jeff Liu wrote:
>> From: Jie Liu <jeff.liu@oracle.com>
>>
>> The xfs_quota_priv header file is only included by xfs_qm header and
>> there is no much users for its contents, hence we can move those stuff
>> to xfs_qm header file and kill it.
>>
>> This patch also remove an unused macro DQFLAGTO_TYPESTR.
> 
> Looks like you pasted the remaining defintions twice into the new
> location.

My apologies, again this proved I should not post patch after spending a
whole day for backporting patches manually.
It's past midnight, I have to go to bed, nice day!

Thanks,
-Jeff

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
