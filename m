Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 29 Sep 2008 22:57:33 -0700 (PDT)
Received: from relay.sgi.com (relay1.corp.sgi.com [192.26.58.214])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8U5vTNQ009332
	for <xfs@oss.sgi.com>; Mon, 29 Sep 2008 22:57:31 -0700
Message-ID: <48E1C24F.3080209@sgi.com>
Date: Tue, 30 Sep 2008 16:08:15 +1000
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
MIME-Version: 1.0
Subject: Re: [PATCH] Increase the default size of the reserved blocks pool
References: <48E097B5.3010906@sgi.com> <48E19C59.7090303@sgi.com> <20080930042526.GB23915@disturbed>
In-Reply-To: <20080930042526.GB23915@disturbed>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Mark Goodwin <markgw@sgi.com>, lachlan@sgi.com, xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

Dave Chinner wrote:
> On Tue, Sep 30, 2008 at 01:26:17PM +1000, Mark Goodwin wrote:
>>
>> Lachlan McIlroy wrote:
>>> The current default size of the reserved blocks pool is easy to deplete
>>> with certain workloads, in particular workloads that do lots of concurrent
>>> delayed allocation extent conversions.  If enough transactions are running
>>> in parallel and the entire pool is consumed then subsequent calls to
>>> xfs_trans_reserve() will fail with ENOSPC.  Also add a rate limited
>>> warning so we know if this starts happening again.
>>>
>> Should we also change the semantics of the XFS_SET_RESBLKS ioctl
>> so that the passed in value is the minimum required by the caller,
>> i.e. silently succeed if the current value is more than that?
> 
> No. If we are asked to reduce the size of the pool, then we should
> do so. The caller might have reason for wanting the pool size
> reduced. e.g. using it to trigger early ENOSPC notification so that
> there is always room to write critical application data when the
> filesystem fills up....
> 

We tossed around the idea of preventing applications from reducing the
size of the reserved pool so that they could not weaken the integrity
of the filesystem by removing critical resources.  We need to support
reducing the pool size because we do so on unmount.
