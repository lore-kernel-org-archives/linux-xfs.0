Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 30F077F5A
	for <xfs@oss.sgi.com>; Wed,  2 Dec 2015 20:56:25 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 09DA58F804B
	for <xfs@oss.sgi.com>; Wed,  2 Dec 2015 18:56:24 -0800 (PST)
Received: from mail-wm0-f53.google.com (mail-wm0-f53.google.com
	[74.125.82.53]) by cuda.sgi.com with ESMTP id RzYuUqJl4Q3xItFh
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 02 Dec 2015 18:56:23 -0800 (PST)
Received: by wmww144 with SMTP id w144so3719024wmw.1
	for <xfs@oss.sgi.com>; Wed, 02 Dec 2015 18:56:22 -0800 (PST)
Date: Thu, 3 Dec 2015 03:56:20 +0100
From: Iustin Pop <iustin@k1024.org>
Subject: Re: xfs_growfs can expand capacity, then how to reduce xfs filesystem
	capacity?
Message-ID: <20151203025620.GA1636@teal.hq.k1024.org>
References: <1CB94550540AE44E9CAAE8CD5AF40BF846D19CCC@H3CMLB12-EX.srv.huawei-3com.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1CB94550540AE44E9CAAE8CD5AF40BF846D19CCC@H3CMLB12-EX.srv.huawei-3com.com>
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
To: "zhao.mingyue@h3c.com" <zhao.mingyue@h3c.com>
Cc: "xfs-request@oss.sgi.com" <xfs-request@oss.sgi.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On 2015-12-03 02:33:47, zhao.mingyue@h3c.com wrote:
> hi,
>   I know that xfs_growfs can expand xfs capacity,now I want to reduce the capacity,but I don't know the command.can someone help me ?

xfsdump + mkfs.xfs + xfsrestore.

Search the list archives for more information.

regards,
iustin

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
