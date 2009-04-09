Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n390hW1F140961 for <xfs@oss.sgi.com>; Wed, 8 Apr 2009 19:43:42 -0500
Received: from song.cn.fujitsu.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id AD70D1CA8BDE
	for <xfs@oss.sgi.com>; Wed,  8 Apr 2009 17:42:51 -0700 (PDT)
Received: from song.cn.fujitsu.com (cn.fujitsu.com [222.73.24.84]) by
	cuda.sgi.com with ESMTP id oWECQrkUtJ4zB3TZ for
	<xfs@oss.sgi.com>; Wed, 08 Apr 2009 17:42:51 -0700 (PDT)
Message-ID: <49DD44B5.9040702@cn.fujitsu.com>
Date: Thu, 09 Apr 2009 08:43:33 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
MIME-Version: 1.0
Subject: Re: [PATCH 4/6] xfs: use memdup_user()
References: <49DC4CC0.9050805@cn.fujitsu.com>	<49DC4D54.3020001@cn.fujitsu.com>	<20090408132254.GA5957@infradead.org>
	<adabpr76oia.fsf@cisco.com>
In-Reply-To: <adabpr76oia.fsf@cisco.com>
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
To: Roland Dreier <rdreier@cisco.com>
Cc: Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

Roland Dreier wrote:
>  > wouldn't NULL be a better error return for this kind of interface,
>  > matching kmalloc?
> 
> I guess returning an error code from memdup_user() lets callers
> distinguish between ENOMEM and EFAULT.  Not sure if that's important or
> not but there probably are at least some sites that care.
> 

Right, and this API is simlilar to strndup_user().

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
