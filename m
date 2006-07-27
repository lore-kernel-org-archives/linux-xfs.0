Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 27 Jul 2006 16:44:18 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k6RNhcDW014579
	for <xfs@oss.sgi.com>; Thu, 27 Jul 2006 16:43:49 -0700
Date: Fri, 28 Jul 2006 09:42:54 +1000
From: Nathan Scott <nathans@sgi.com>
Subject: Re: XFS / Quota Bug in  2.6.17.x and 2.6.18x
Message-ID: <20060728094254.F2196410@wobbly.melbourne.sgi.com>
References: <44C8A5F1.7060604@profihost.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <44C8A5F1.7060604@profihost.com>; from s.priebe@profihost.com on Thu, Jul 27, 2006 at 01:39:29PM +0200
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: ProfiHost - Stefan Priebe <s.priebe@profihost.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com

Hi Stefan,

On Thu, Jul 27, 2006 at 01:39:29PM +0200, ProfiHost - Stefan Priebe wrote:
> Hello!
> 
> The crash only occurs if you use quota and IDE without barrier support.
> 
> The Problem is, that on a new mount of a root filesystem - the flag 
> VFS_RDONLY is set - and so no barrier check is done before checking 
> quota. With this patch barrier check is done always. The partition 
> should not be mounted at that moment. For mount -o remount, rw or 
> something like this it uses another function where VFS_RDONLY is checked.

Ah, I see.  The patch isn't quite right, I think we will now need to
also add a test to xfs_mountfs_check_barriers() to ensure the device
beneath us is not bdev_read_only().

I'll add that and get the fix merged, thanks.

cheers.

-- 
Nathan
