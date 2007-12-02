Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 02 Dec 2007 14:31:14 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id lB2MV6kc029272
	for <xfs@oss.sgi.com>; Sun, 2 Dec 2007 14:31:10 -0800
Date: Mon, 3 Dec 2007 09:31:05 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: ACL limit
Message-ID: <20071202223105.GS119954183@sgi.com>
References: <Pine.LNX.4.64.0711301902360.18767@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0711301902360.18767@fbirervta.pbzchgretzou.qr>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: xfs@oss.sgi.com

On Fri, Nov 30, 2007 at 07:07:26PM +0100, Jan Engelhardt wrote:
> Hi,
> 
> 
> is there any way to raise the number of ACLs that can be stored? The 
> current limit of 25 is quite tight, where ext3 allows 124 and jfs 8192.
> Would increasing XFS_ACL_MAX_ENTRIES work (yes, using potentially more 
> memory), i.e. not interfering with the on-disk format?

It would be an on disk format change - older kernels would error out
(-EINVAL) on > 25 ACLs and not check any of them. Hence we'd
probably need a superblock feature bit to indicate that >25 ACEs are
supported in a given ACL.

But we can work around that (superblock feature bit) and should
be able to extend this out to ~8190 entries. We're doing an ACL
rework ATM, so > 25 entry support should fall out of that....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
