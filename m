Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qAR7VwO3022920 for <xfs@oss.sgi.com>; Tue, 27 Nov 2012 01:31:58 -0600
Received: from fgwmail6.fujitsu.co.jp (fgwmail6.fujitsu.co.jp [192.51.44.36])
	by cuda.sgi.com with ESMTP id iJ5otKgetx5gGj9r (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 26 Nov 2012 23:34:13 -0800 (PST)
Received: from m2.gw.fujitsu.co.jp (unknown [10.0.50.72])
	by fgwmail6.fujitsu.co.jp (Postfix) with ESMTP id 325DB3EE0BD
	for <xfs@oss.sgi.com>; Tue, 27 Nov 2012 16:34:12 +0900 (JST)
Received: from smail (m2 [127.0.0.1])
	by outgoing.m2.gw.fujitsu.co.jp (Postfix) with ESMTP id 1B2DA45DE4E
	for <xfs@oss.sgi.com>; Tue, 27 Nov 2012 16:34:12 +0900 (JST)
Received: from s2.gw.fujitsu.co.jp (s2.gw.fujitsu.co.jp [10.0.50.92])
	by m2.gw.fujitsu.co.jp (Postfix) with ESMTP id F3E7845DD78
	for <xfs@oss.sgi.com>; Tue, 27 Nov 2012 16:34:11 +0900 (JST)
Received: from s2.gw.fujitsu.co.jp (localhost.localdomain [127.0.0.1])
	by s2.gw.fujitsu.co.jp (Postfix) with ESMTP id E64711DB803A
	for <xfs@oss.sgi.com>; Tue, 27 Nov 2012 16:34:11 +0900 (JST)
Received: from g01jpexchkw12.g01.fujitsu.local
	(g01jpexchkw12.g01.fujitsu.local [10.0.194.51])
	by s2.gw.fujitsu.co.jp (Postfix) with ESMTP id 80DD01DB8040
	for <xfs@oss.sgi.com>; Tue, 27 Nov 2012 16:34:11 +0900 (JST)
Message-ID: <50B46CDF.6020807@jp.fujitsu.com>
Date: Tue, 27 Nov 2012 16:33:51 +0900
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs: Remove the description about nodelaylog mount option
	from, the xfs document.
References: <50B30B41.8040400@jp.fujitsu.com> <20121126155511.GF27055@sgi.com>
	<20121126220736.GG27055@sgi.com>
In-Reply-To: <20121126220736.GG27055@sgi.com>
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
To: Ben Myers <bpm@sgi.com>
Cc: xfs ML <xfs@oss.sgi.com>

(2012/11/27 7:07), Ben Myers wrote:
> Hey Satoru,
> 
> On Mon, Nov 26, 2012 at 09:55:11AM -0600, Ben Myers wrote:
>> On Mon, Nov 26, 2012 at 03:25:05PM +0900, Satoru Takeuchi wrote:
>>> From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
>>>
>>> nodelaylog mount option is removed by commit 93b8a585. But there still be
>>> the description about it in the xfs document. This patch removes it.
>>>
>>> Signed-off-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
>>> ---
>>>  Documentation/filesystems/xfs.txt |    2 +-
>>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>>
>>> diff --git a/Documentation/filesystems/xfs.txt b/Documentation/filesystems/xfs.txt
>>> index 3fc0c31..860b845 100644
>>> --- a/Documentation/filesystems/xfs.txt
>>> +++ b/Documentation/filesystems/xfs.txt
>>> @@ -43,7 +43,7 @@ When mounting an XFS filesystem, the following options are accepted.
>>>         Issue command to let the block device reclaim space freed by the
>>>         filesystem.  This is useful for SSD devices, thinly provisioned
>>>         LUNs and virtual machine images, but may have a performance
>>> -       impact.  This option is incompatible with the nodelaylog option.
>>> +       impact.
>>
>> Looks good.
>>
>> Reviewed-by: Ben Myers <bpm@sgi.com>
> 
> This has been committed to git://oss.sgi.com/xfs/xfs.git, master and for-next
> branches.  It seems like your mailer replaced tabs with spaces so I cleaned
> that up.  Just a heads-up... you may want to look into that.

I apologize to you. I copy-and-past this patch from my terminal and it converts
tab to spaces. I'll be careful from now on.

Thanks,
Satoru

> 
> Thanks!
> 	Ben
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
