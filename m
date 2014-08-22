Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 95E777F5E
	for <xfs@oss.sgi.com>; Fri, 22 Aug 2014 06:50:45 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 23834AC005
	for <xfs@oss.sgi.com>; Fri, 22 Aug 2014 04:50:44 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id E8ilJEsfWymUWQbr (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 22 Aug 2014 04:50:39 -0700 (PDT)
Message-ID: <53F72E87.7060601@oracle.com>
Date: Fri, 22 Aug 2014 19:50:31 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: Re: [PATCH V2] xfs: combine xfs_seek_hole & xfs_seek_data
References: <53F55765.6030205@redhat.com> <53F64723.4070001@sandeen.net>
In-Reply-To: <53F64723.4070001@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>, Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>


On 08/22/2014 03:23 AM, Eric Sandeen wrote:
> xfs_seek_hole & xfs_seek_data are remarkably similar;
> so much so that they can be combined, saving a fair
> bit of semi-complex code duplication.
> 
> The following patch passes generic/285 and generic/286,
> which specifically test seek behavior.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Looks good to me. 

Reviewed-by: Jie Liu <jeff.liu@oracle.com>


Cheers,
-Jeff

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
