Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 11 Dec 2007 14:16:05 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id lBBMFtvx002837
	for <xfs@oss.sgi.com>; Tue, 11 Dec 2007 14:16:00 -0800
Date: Wed, 12 Dec 2007 09:15:55 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: mkfs.xfs ... lazy-count=1 ... not mountable by older kernels?
Message-ID: <20071211221554.GC4612@sgi.com>
References: <475EE83A.3060607@ca.sophos.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <475EE83A.3060607@ca.sophos.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Sparks <dave@ca.sophos.com>
Cc: xfs@oss.sgi.com

On Tue, Dec 11, 2007 at 11:42:50AM -0800, David Sparks wrote:
> Hi all,
> 
> Is it expected that filesystems made with lazy-count=1 are not mountable by
> older kernels?

That is expected. lazy-count is a mkfs option because it changes the on-disk
format slightly, and older kernels do not understand that format. Hence
mkfs sets a superblock feature bit to prevent the filesystem from being
mounted on kernels that don't understand the slightly different disk format.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
