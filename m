Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 14 Oct 2008 19:45:37 -0700 (PDT)
Received: from relay.sgi.com (relay1.corp.sgi.com [192.26.58.214])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9F2jZSZ012209
	for <xfs@oss.sgi.com>; Tue, 14 Oct 2008 19:45:35 -0700
Message-ID: <48F567BA.5040607@sgi.com>
Date: Wed, 15 Oct 2008 13:47:06 +1000
From: Peter Leckie <pleckie@sgi.com>
MIME-Version: 1.0
Subject: Re: crash with latest code drop.
References: <48F54C20.8060704@sgi.com> <20081015011857.GS10716@disturbed>
In-Reply-To: <20081015011857.GS10716@disturbed>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Peter Leckie <pleckie@sgi.com>, xfs@oss.sgi.com

Dave Chinner wrote:
> Can you confirm that the xfs_inode has either the I_RECLAIM or
> I_RECLAIMABLE flag set on it when the panic occurred? If this
> is the case, then the patch below will probably fix it.
>   
Yep XFS_IRECLAIMABLE is set, I'll give the patch a test and get back to you.

Thanks,
Pete
