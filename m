Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 7F4017F3F
	for <xfs@oss.sgi.com>; Tue, 17 Dec 2013 01:25:41 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 663BC304053
	for <xfs@oss.sgi.com>; Mon, 16 Dec 2013 23:25:38 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id QqwJr9AvnsmNSPor (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 16 Dec 2013 23:25:37 -0800 (PST)
Message-ID: <52AFFC69.7010007@oracle.com>
Date: Tue, 17 Dec 2013 15:25:29 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: Re: =?UTF-8?B?44CQeGZzX21ldGFkdW1wICAgeGZzX21kcmVzdG9yZSAgeGZzZHU=?=
	=?UTF-8?B?bXAgIHhmc3Jlc3RvcmXjgJE=?=
References: <tencent_316F3CDD1B9D21DF326147BD@qq.com>
In-Reply-To: <tencent_316F3CDD1B9D21DF326147BD@qq.com>
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
To: Stor?? <289471341@qq.com>, xfs <xfs@oss.sgi.com>

On 12/17 2013 14:46 PM, Stor?? wrote:
> hi:
>   xfsdump and xfs_metadump difference
> xfs_mdrestore and xfsrestore difference
Please ask man page for details.

In short, xfsdump is used to perform an incremental dump of an XFS file
system.  corresponding, xfsrestore is used to restore the file system back
from the dumps.

xfs_metadump/xfs_mdrestore are used to dump/restore filesystems metadatas,
but they are used for debug purpose only.

Thanks,
-Jeff

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
