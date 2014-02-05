Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 7DFA27F51
	for <xfs@oss.sgi.com>; Wed,  5 Feb 2014 03:39:32 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 529A7304071
	for <xfs@oss.sgi.com>; Wed,  5 Feb 2014 01:39:29 -0800 (PST)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id 8I8WCHqgcKuxN0a9 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 05 Feb 2014 01:39:28 -0800 (PST)
Message-ID: <52F206AA.20505@oracle.com>
Date: Wed, 05 Feb 2014 17:38:50 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs: return -E2BIG if hit the maximum size limits of ACLs
References: <52EBB032.8070306@oracle.com> <20140204155156.GA3810@infradead.org>
In-Reply-To: <20140204155156.GA3810@infradead.org>
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


On 02/04 2014 23:51 PM, Christoph Hellwig wrote:
> On Fri, Jan 31, 2014 at 10:16:18PM +0800, Jeff Liu wrote:
>> From: Jie Liu <jeff.liu@oracle.com>
>>
>> We should return -E2BIG rather than -EINVAL if hit the maximum size
>> limits of ACLS, as the former is consistent with VFS xattr syscalls.
> 
> Looks good,
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> You were already working on tests for this area, right?

Not yet, but I'll work out a separate generic test towards ACLs.

Thanks,
-Jeff

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
