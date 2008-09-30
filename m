Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 29 Sep 2008 21:24:08 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8U4O6PJ003810
	for <xfs@oss.sgi.com>; Mon, 29 Sep 2008 21:24:06 -0700
Received: from ipmail04.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3DA72496526
	for <xfs@oss.sgi.com>; Mon, 29 Sep 2008 21:25:42 -0700 (PDT)
Received: from ipmail04.adl2.internode.on.net (ipmail04.adl2.internode.on.net [203.16.214.57]) by cuda.sgi.com with ESMTP id fIzfMLFSgnU0E9H4 for <xfs@oss.sgi.com>; Mon, 29 Sep 2008 21:25:42 -0700 (PDT)
Date: Tue, 30 Sep 2008 14:25:26 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] Increase the default size of the reserved blocks pool
Message-ID: <20080930042526.GB23915@disturbed>
References: <48E097B5.3010906@sgi.com> <48E19C59.7090303@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48E19C59.7090303@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Mark Goodwin <markgw@sgi.com>
Cc: lachlan@sgi.com, xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Tue, Sep 30, 2008 at 01:26:17PM +1000, Mark Goodwin wrote:
>
>
> Lachlan McIlroy wrote:
>> The current default size of the reserved blocks pool is easy to deplete
>> with certain workloads, in particular workloads that do lots of concurrent
>> delayed allocation extent conversions.  If enough transactions are running
>> in parallel and the entire pool is consumed then subsequent calls to
>> xfs_trans_reserve() will fail with ENOSPC.  Also add a rate limited
>> warning so we know if this starts happening again.
>>
>
> Should we also change the semantics of the XFS_SET_RESBLKS ioctl
> so that the passed in value is the minimum required by the caller,
> i.e. silently succeed if the current value is more than that?

No. If we are asked to reduce the size of the pool, then we should
do so. The caller might have reason for wanting the pool size
reduced. e.g. using it to trigger early ENOSPC notification so that
there is always room to write critical application data when the
filesystem fills up....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
