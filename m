Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A44B37F52
	for <xfs@oss.sgi.com>; Fri, 25 Apr 2014 03:06:09 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 35955AC008
	for <xfs@oss.sgi.com>; Fri, 25 Apr 2014 01:06:06 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id dHvKS9WO5tWcqGI3 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 25 Apr 2014 01:06:05 -0700 (PDT)
Message-ID: <535A1750.20109@oracle.com>
Date: Fri, 25 Apr 2014 16:05:36 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: Re: [PATCH v2 10/10] xfs: isolate xfs_qm_quotacheck to its source file
References: <535078D4.4000802@oracle.com>
	<20140425065545.GE20871@infradead.org>
In-Reply-To: <20140425065545.GE20871@infradead.org>
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


On 04/25 2014 14:55 PM, Christoph Hellwig wrote:
> On Fri, Apr 18, 2014 at 08:59:00AM +0800, Jeff Liu wrote:
>> From: Jie Liu <jeff.liu@oracle.com>
>>
>> Isolate xfs_qm_quotacheck() to xfs_qm.c as there is no other users of it.
>>
>> Signed-off-by: Jie Liu <jeff.liu@oracle.com>
> 
> Looks good, but the description is a bit confusing, we'd normallay say
> something like:
> 
> "xfs: mark xfs_qm_quotacheck as static
> 
> xfs_qm_quotacheck is not used outside of xfs_qm.c.  Mark it static and
> move it around in the file to avoid a forward declaration."

Nice suggestion, thanks for your review.


Thanks,
-Jeff

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
