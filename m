Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id C09B07F52
	for <xfs@oss.sgi.com>; Fri, 25 Apr 2014 02:55:36 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 9A5308F8049
	for <xfs@oss.sgi.com>; Fri, 25 Apr 2014 00:55:36 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id mcfXkivlnnkEP9Sj (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 25 Apr 2014 00:55:31 -0700 (PDT)
Message-ID: <535A14D5.30203@oracle.com>
Date: Fri, 25 Apr 2014 15:55:01 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: Re: [PATCH v2 07/10] xfs: introduce xfs_bulkstat_grab_ichunk
References: <535078C5.5060107@oracle.com>
	<20140425065301.GD20871@infradead.org>
In-Reply-To: <20140425065301.GD20871@infradead.org>
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


On 04/25 2014 14:53 PM, Christoph Hellwig wrote:
>> -				agino = r.ir_startino + XFS_INODES_PER_CHUNK;
> 
>> +				agino += r.ir_startino + XFS_INODES_PER_CHUNK;
> 
> why did this turns from a = into a += ?

Ah, this should be "a = ", will fix it.

Thanks,
-Jeff

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
