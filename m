Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 6C80C7F53
	for <xfs@oss.sgi.com>; Fri, 22 Aug 2014 06:54:39 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id ED650AC004
	for <xfs@oss.sgi.com>; Fri, 22 Aug 2014 04:54:38 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id U0vc7ZIKq9oksZNl (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 22 Aug 2014 04:54:37 -0700 (PDT)
Message-ID: <53F72F76.9080301@oracle.com>
Date: Fri, 22 Aug 2014 19:54:30 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs: lseek: the "whence" argument is called "whence"
References: <53F55765.6030205@redhat.com> <53F64723.4070001@sandeen.net>
	<53F648CC.9080604@redhat.com>
In-Reply-To: <53F648CC.9080604@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>, Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-oss <xfs@oss.sgi.com>


On 08/22/2014 03:30 AM, Eric Sandeen wrote:
> For some reason, the older commit:
> 
>     965c8e5 lseek: the "whence" argument is called "whence"
> 
>     lseek: the "whence" argument is called "whence"
>     
>     But the kernel decided to call it "origin" instead.
>     Fix most of the sites.
> 
> left out xfs.  So fix xfs.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Looks good to me too.

Reviewed-by: Jie Liu <jeff.liu@oracle.com>


Cheers,
-Jeff

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
