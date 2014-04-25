Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A5C667F52
	for <xfs@oss.sgi.com>; Fri, 25 Apr 2014 01:55:46 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 7F19D8F8040
	for <xfs@oss.sgi.com>; Thu, 24 Apr 2014 23:55:46 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id b5u0JYmpNIgSGppa (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 24 Apr 2014 23:55:45 -0700 (PDT)
Date: Thu, 24 Apr 2014 23:55:45 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2 10/10] xfs: isolate xfs_qm_quotacheck to its source file
Message-ID: <20140425065545.GE20871@infradead.org>
References: <535078D4.4000802@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <535078D4.4000802@oracle.com>
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
To: Jeff Liu <jeff.liu@oracle.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Fri, Apr 18, 2014 at 08:59:00AM +0800, Jeff Liu wrote:
> From: Jie Liu <jeff.liu@oracle.com>
> 
> Isolate xfs_qm_quotacheck() to xfs_qm.c as there is no other users of it.
> 
> Signed-off-by: Jie Liu <jeff.liu@oracle.com>

Looks good, but the description is a bit confusing, we'd normallay say
something like:

"xfs: mark xfs_qm_quotacheck as static

xfs_qm_quotacheck is not used outside of xfs_qm.c.  Mark it static and
move it around in the file to avoid a forward declaration."

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
