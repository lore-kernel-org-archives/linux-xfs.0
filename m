Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 29 Sep 2008 23:36:31 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8U6aQl4012037
	for <xfs@oss.sgi.com>; Mon, 29 Sep 2008 23:36:28 -0700
Received: from ipmail04.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 48C9D1AFD456
	for <xfs@oss.sgi.com>; Mon, 29 Sep 2008 23:38:02 -0700 (PDT)
Received: from ipmail04.adl2.internode.on.net (ipmail04.adl2.internode.on.net [203.16.214.57]) by cuda.sgi.com with ESMTP id U6xxkBENVxhs3DtG for <xfs@oss.sgi.com>; Mon, 29 Sep 2008 23:38:02 -0700 (PDT)
Date: Tue, 30 Sep 2008 16:37:58 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] Increase the default size of the reserved blocks pool
Message-ID: <20080930063758.GD23915@disturbed>
References: <48E097B5.3010906@sgi.com> <48E19C59.7090303@sgi.com> <20080930042526.GB23915@disturbed> <48E1C24F.3080209@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48E1C24F.3080209@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>
Cc: Mark Goodwin <markgw@sgi.com>, xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Tue, Sep 30, 2008 at 04:08:15PM +1000, Lachlan McIlroy wrote:
> Dave Chinner wrote:
>> On Tue, Sep 30, 2008 at 01:26:17PM +1000, Mark Goodwin wrote:
>>>
>>> Lachlan McIlroy wrote:
>>>> The current default size of the reserved blocks pool is easy to deplete
>>>> with certain workloads, in particular workloads that do lots of concurrent
>>>> delayed allocation extent conversions.  If enough transactions are running
>>>> in parallel and the entire pool is consumed then subsequent calls to
>>>> xfs_trans_reserve() will fail with ENOSPC.  Also add a rate limited
>>>> warning so we know if this starts happening again.
>>>>
>>> Should we also change the semantics of the XFS_SET_RESBLKS ioctl
>>> so that the passed in value is the minimum required by the caller,
>>> i.e. silently succeed if the current value is more than that?
>>
>> No. If we are asked to reduce the size of the pool, then we should
>> do so. The caller might have reason for wanting the pool size
>> reduced. e.g. using it to trigger early ENOSPC notification so that
>> there is always room to write critical application data when the
>> filesystem fills up....
>>
>
> We tossed around the idea of preventing applications from reducing the
> size of the reserved pool so that they could not weaken the integrity
> of the filesystem by removing critical resources.  We need to support
> reducing the pool size because we do so on unmount.

Some people so tightly control their use of disk space that even the
default needs to be reduced. We recently had someone come across this
very problem when upgrading from 2.6.18 to 2.6.25 - their app
preallocated almost he entire filesystem and so when the reserve
pool took it's blocks, the filesystem was permanently at ENOSPC.
The only way to fix this was to reduce the pool size and it was
obvious that in this configuration the reserve pool was superfluous
because it was a static layout.

So at one end of the scale we've got the problem of some workloads
when run at ENOSPC will exhaust the default pool size. At the other
end we've got some workloads where the default pool size is too
large. And we've got the vast middle ground where there are no
problems with the current pool size but may have issues with a
significant increase in pool size.

It's this vast middle ground where we'll get all the "I upgraded and
now I can't use my XFS filesystem" reports from. Let's not make more
trouble for ourselves than is necesary.  Hence it seems to me that
the default should not be changed, the various mitigation strategies
we talked about should be implemented, and SGI should tune the
reserve pool to suit their users in the Propack distro (like so many
other tunables are modified)....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
