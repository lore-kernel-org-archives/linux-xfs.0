Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 29 Sep 2008 20:25:01 -0700 (PDT)
Received: from relay.sgi.com (relay2.corp.sgi.com [192.26.58.22])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8U3OvrP032326
	for <xfs@oss.sgi.com>; Mon, 29 Sep 2008 20:24:57 -0700
Message-ID: <48E19C59.7090303@sgi.com>
Date: Tue, 30 Sep 2008 13:26:17 +1000
From: Mark Goodwin <markgw@sgi.com>
Reply-To: markgw@sgi.com
MIME-Version: 1.0
Subject: Re: [PATCH] Increase the default size of the reserved blocks pool
References: <48E097B5.3010906@sgi.com>
In-Reply-To: <48E097B5.3010906@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: lachlan@sgi.com
Cc: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>



Lachlan McIlroy wrote:
> The current default size of the reserved blocks pool is easy to deplete
> with certain workloads, in particular workloads that do lots of concurrent
> delayed allocation extent conversions.  If enough transactions are running
> in parallel and the entire pool is consumed then subsequent calls to
> xfs_trans_reserve() will fail with ENOSPC.  Also add a rate limited
> warning so we know if this starts happening again.
> 

Should we also change the semantics of the XFS_SET_RESBLKS ioctl
so that the passed in value is the minimum required by the caller,
i.e. silently succeed if the current value is more than that?

Cheers
-- Mark
