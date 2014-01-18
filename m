Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id EC0B77F52
	for <xfs@oss.sgi.com>; Fri, 17 Jan 2014 21:52:43 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id C8C708F8074
	for <xfs@oss.sgi.com>; Fri, 17 Jan 2014 19:52:40 -0800 (PST)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id abYyP8G0TF4OTUq3 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 17 Jan 2014 19:52:39 -0800 (PST)
Message-ID: <52D9FA81.3030807@oracle.com>
Date: Sat, 18 Jan 2014 11:52:33 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs: remove unused tr_swrite
References: <52D997BD.1090701@redhat.com>
In-Reply-To: <52D997BD.1090701@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>

On 01/18 2014 04:51 AM, Eric Sandeen wrote:
> tr_swrite is never used, remove it.
> 
> From a very quick look, I think the usage of it (and its ancestor
> XFS_SWRITE_LOG_RES) went away in commit 13e6d5cd "xfs: merge fsync
> and O_SYNC handling" back in 2009.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Looks good to me.

Reviewed-by: Jie Liu <jeff.liu@oracle.com>

Thanks,
-Jeff

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
