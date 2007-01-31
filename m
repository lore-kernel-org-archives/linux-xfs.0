Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 30 Jan 2007 17:39:14 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l0V1d4qw003791
	for <xfs@oss.sgi.com>; Tue, 30 Jan 2007 17:39:05 -0800
Message-ID: <45BFF357.3010806@sgi.com>
Date: Wed, 31 Jan 2007 12:39:35 +1100
From: Vlad Apostolov <vapo@sgi.com>
MIME-Version: 1.0
Subject: Re: Review: Fix bulkstat block count units
References: <20070131012915.GO33919298@melbourne.sgi.com>
In-Reply-To: <20070131012915.GO33919298@melbourne.sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs-dev@sgi.com, xfs@oss.sgi.com

The patch is looking good Dave.

Regards,
Vlad

David Chinner wrote:
> The recent bulkstat improvements introduced a minor
> regression - they changed the units of the dt_count field
> from 512 byte blocks to filesystem blocks. This changes
> the userspace visible fields and can break existing applications
> that use bulkstat.
>
> Comments?
>
> Cheers,
>
> Dave.
>   
