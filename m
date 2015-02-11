Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 42CB17F54
	for <xfs@oss.sgi.com>; Wed, 11 Feb 2015 10:08:22 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C5EB3AC004
	for <xfs@oss.sgi.com>; Wed, 11 Feb 2015 08:08:18 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id 5KUv5mrattXXW0Hg for <xfs@oss.sgi.com>;
	Wed, 11 Feb 2015 08:08:16 -0800 (PST)
Message-ID: <54DB7E70.3060709@sandeen.net>
Date: Wed, 11 Feb 2015 10:08:16 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: XFS buffer IO performance is very poor
References: <tencent_39AFE52BC5E06F89B6B2B3ED@qq.com>
In-Reply-To: <tencent_39AFE52BC5E06F89B6B2B3ED@qq.com>
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
To: yy <yy@xspring.net>, xfs <xfs@oss.sgi.com>

On 2/11/15 1:39 AM, yy wrote:

<snip>

(In addition to Brian's questions):

> XFS format parametes:
> 
> #mkfs.xfs -d su=256k,sw=5 /dev/sdb1
> 
> #cat /proc/mounts
> 
> /dev/sdb1 /data1 xfs rw,noatime,attr2,delaylog,nobarrier,logbsize=256k,sunit=512,swidth=2560,noquota 0 0
> 
> #fdisk -ul
> Device Boot      Start         End      Blocks   Id  System
> /dev/sdb1             128  2929356359  1464678116   83  Linux

so 128*512 = 64k; your partition doesn't start on a 256k stripe unit boundary,
right?  Shouldn't it do so?

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
