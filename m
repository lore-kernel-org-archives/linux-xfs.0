Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 15 Oct 2008 22:53:54 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9G5rpuu022370
	for <xfs@oss.sgi.com>; Wed, 15 Oct 2008 22:53:51 -0700
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3B21F503E01
	for <xfs@oss.sgi.com>; Wed, 15 Oct 2008 22:55:34 -0700 (PDT)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net [203.16.214.145]) by cuda.sgi.com with ESMTP id 6iK8hovC2IFGRtcD for <xfs@oss.sgi.com>; Wed, 15 Oct 2008 22:55:34 -0700 (PDT)
Date: Thu, 16 Oct 2008 16:55:30 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: crash with latest code drop.
Message-ID: <20081016055530.GE25906@disturbed>
References: <48F54C20.8060704@sgi.com> <20081015011857.GS10716@disturbed> <20081015022948.GA20966@infradead.org> <20081015031645.GA25906@disturbed> <20081015032431.GA7426@infradead.org> <20081015035116.GB25906@disturbed> <48F584B8.8060907@sgi.com> <20081015061917.GC25906@disturbed> <48F5A104.5060506@sgi.com> <48F6AA3E.8030902@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48F6AA3E.8030902@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Peter Leckie <pleckie@sgi.com>
Cc: xfs@oss.sgi.com

On Thu, Oct 16, 2008 at 12:43:10PM +1000, Peter Leckie wrote:
>
>>>  - it's the same as
>>> the first report - deferencing the linux inode without first having
>>> a refernce on it.
>>>   
>>
>> Yes it resolves the issue.
>
> I spoke to soon, Ooops as follows:
....

> Adding the following resolved the issue however you may wish to solve it  
> in another manner.
>
> @@ -102,7 +102,7 @@ xfs_sync_inodes_ag(
>                 * in reclaim. Leave it for the reclaim code to flush.
>                 */
>                inode = VFS_I(ip);
> -               if (!igrab(inode)) {
> +               if (!inode || !igrab(inode)) {
>                        read_unlock(&pag->pag_ici_lock);
>                        continue;
>                }

Yes, or you could simply apply the "combine linux/XFS inode" patch
series and then VFS_I(ip) will never, ever return NULL.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
