Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 21 Nov 2006 21:16:25 -0800 (PST)
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id kAM5GFaG006202
	for <xfs@oss.sgi.com>; Tue, 21 Nov 2006 21:16:16 -0800
Message-ID: <4563DCE8.6050701@sandeen.net>
Date: Tue, 21 Nov 2006 23:15:20 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Review: Fix inverted quiet mount logic
References: <20061122044656.GS37654165@melbourne.sgi.com>
In-Reply-To: <20061122044656.GS37654165@melbourne.sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs-dev@sgi.com, xfs@oss.sgi.com

David Chinner wrote:
> Simple problem Noticed by Eric Sandeen at about the same time I did
> - we are not getting error messages in dmesg when certain checks
> fail during mount.  Turns out the XFS_MFSI_QUIET flag usage is
> inverted, so we suppress messages when we should be noisy and
> shout when we should be silent....
> 
> Cheers,
> 
> Dave.

ACK.

-Eric
