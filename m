Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 39C167F61
	for <xfs@oss.sgi.com>; Wed, 12 Mar 2014 18:14:12 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D6E6FAC002
	for <xfs@oss.sgi.com>; Wed, 12 Mar 2014 16:14:11 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id OoSBEhwHUAzlSKLT (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 12 Mar 2014 16:14:10 -0700 (PDT)
Message-ID: <5320EA20.7000807@oracle.com>
Date: Thu, 13 Mar 2014 07:13:36 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: Re: [PATCH v2] xfstests: shared/051: add filter to match the golden
	output for large acls
References: <531FC057.70804@oracle.com> <20140312103230.GA4167@infradead.org>
In-Reply-To: <20140312103230.GA4167@infradead.org>
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


On 03/12 2014 18:32 PM, Christoph Hellwig wrote:
>> +# we return E2BIG if hit the max acl limits on new kernel, but EINVAL
>> +# on old kernel. So we need to filter the error message out in order
>> +# to make the current golden output works for both old and new kernels.
> 
> Hate to nitpick, but shouldn't the new one be in the golden output and
> the old one fixed up?

Exactly, I'll post a fix.

Thanks,
-Jeff

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
