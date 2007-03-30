Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 29 Mar 2007 18:03:28 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l2U13M6p016348
	for <xfs@oss.sgi.com>; Thu, 29 Mar 2007 18:03:23 -0700
Message-ID: <460C5E38.5040006@sgi.com>
Date: Fri, 30 Mar 2007 10:47:52 +1000
From: Vlad Apostolov <vapo@sgi.com>
MIME-Version: 1.0
Subject: Re: Review: Make xfs_dm_sync_by_handle really sync data
References: <20070329233323.GM32597093@melbourne.sgi.com>
In-Reply-To: <20070329233323.GM32597093@melbourne.sgi.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

It is looking good Dave. I will test it today.

Regards,
Vlad

David Chinner wrote:
> xfs_dm_sync_by_handle doesn't sync data right now. Never has.
> It is supposed to work exactly like fsync(), except that it
> only ever calls XFS functions that log the inode and
> not the generic functions that actually sync out the data.
>
> Fix it.
>
>   
