Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 30 Aug 2006 20:22:47 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k7V3MIDW010218
	for <xfs@oss.sgi.com>; Wed, 30 Aug 2006 20:22:30 -0700
Date: Thu, 31 Aug 2006 13:21:07 +1000
From: Nathan Scott <nathans@sgi.com>
Subject: Re: Review: Prevent free space oversubscription
Message-ID: <20060831132107.I3208450@wobbly.melbourne.sgi.com>
References: <20060830021532.GF5737019@melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20060830021532.GF5737019@melbourne.sgi.com>; from dgc@sgi.com on Wed, Aug 30, 2006 at 12:15:32PM +1000
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs-dev@sgi.com, xfs@oss.sgi.com, Stephane Doyon <sdoyon@max-t.com>, Luciano Chavez <lnx1138@us.ibm.com>

On Wed, Aug 30, 2006 at 12:15:32PM +1000, David Chinner wrote:
> ...
> The following patch reserves space for the free lists in all AGs
> plus the inode bmap btree which prevents oversubscription. It also
> prevents those blocks from being reported as free space (as they can
> never be used) and makes the SMP in-core superblock accounting code and
> the reserved block ioctl respect this requirement.

Makes sense to me & patch looks good.

cheers.

-- 
Nathan
