Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 03 Jun 2007 22:24:16 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l545OAWt006541
	for <xfs@oss.sgi.com>; Sun, 3 Jun 2007 22:24:13 -0700
Message-ID: <4663A283.2030205@sgi.com>
Date: Mon, 04 Jun 2007 15:26:27 +1000
From: Vlad Apostolov <vapo@sgi.com>
MIME-Version: 1.0
Subject: Re: Review: xfs_bmapi does not update previous extent pointer correctly
References: <20070604051944.GQ85884050@sgi.com>
In-Reply-To: <20070604051944.GQ85884050@sgi.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

It is looking good Dave,

Regards,
Vlad

David Chinner wrote:
> When looping across multiple extents, xfs_bmapi will fail to
> update the previous extent pointer which is used in subsequent
> loops.
>
> As a result, we can end up with the second loop in xfs_bmapi trying
> to use an incorrect previous extent pointer and assert failures or
> corrupted in-memory extent lists will result.
>
> Correctly update the previous extent at the end of each loop so that
> we DTRT when processing multiple map requests.
>
> Cheers,
>
> Dave.
>   
