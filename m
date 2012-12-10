Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qBA1t38x167449 for <xfs@oss.sgi.com>; Sun, 9 Dec 2012 19:55:04 -0600
Received: from fgwmail5.fujitsu.co.jp (fgwmail5.fujitsu.co.jp [192.51.44.35])
	by cuda.sgi.com with ESMTP id 3Ro3w5GVf45k0VmD (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 09 Dec 2012 17:57:31 -0800 (PST)
Received: from m3.gw.fujitsu.co.jp (unknown [10.0.50.73])
	by fgwmail5.fujitsu.co.jp (Postfix) with ESMTP id 1FDF73EE0BC
	for <xfs@oss.sgi.com>; Mon, 10 Dec 2012 10:57:29 +0900 (JST)
Received: from smail (m3 [127.0.0.1])
	by outgoing.m3.gw.fujitsu.co.jp (Postfix) with ESMTP id 0192745DEBA
	for <xfs@oss.sgi.com>; Mon, 10 Dec 2012 10:57:29 +0900 (JST)
Received: from s3.gw.fujitsu.co.jp (s3.gw.fujitsu.co.jp [10.0.50.93])
	by m3.gw.fujitsu.co.jp (Postfix) with ESMTP id D9A2645DEB5
	for <xfs@oss.sgi.com>; Mon, 10 Dec 2012 10:57:28 +0900 (JST)
Received: from s3.gw.fujitsu.co.jp (localhost.localdomain [127.0.0.1])
	by s3.gw.fujitsu.co.jp (Postfix) with ESMTP id C2E751DB803F
	for <xfs@oss.sgi.com>; Mon, 10 Dec 2012 10:57:28 +0900 (JST)
Received: from g01jpexchkw11.g01.fujitsu.local
	(g01jpexchkw11.g01.fujitsu.local [10.0.194.50])
	by s3.gw.fujitsu.co.jp (Postfix) with ESMTP id 804661DB8041
	for <xfs@oss.sgi.com>; Mon, 10 Dec 2012 10:57:28 +0900 (JST)
Message-ID: <50C54176.3060901@jp.fujitsu.com>
Date: Mon, 10 Dec 2012 10:57:10 +0900
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
MIME-Version: 1.0
Subject: Re: [PATCH 1/2] XFS: remove a unused sysctl related enum definition.
References: <50C521B2.1030001@jp.fujitsu.com> <20121210012141.GJ15784@dastard>
In-Reply-To: <20121210012141.GJ15784@dastard>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs ML <xfs@oss.sgi.com>

(2012/12/10 10:21), Dave Chinner wrote:
> On Mon, Dec 10, 2012 at 08:41:38AM +0900, Satoru Takeuchi wrote:
>> From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
>>
>> There is a unused sysctl related enum definition
>> in fs/xfs/xfs_sysctl.h. This patch removes it.
> 
> Is it?
> 
> AFAICT, kernel/sysctl_binary.c uses it when CONFIG_SYSCTL_SYSCALL=y.

I just checked fs/xfs/*. Sorry for noize.

Thanks,
Satoru


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
