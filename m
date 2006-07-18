Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 18 Jul 2006 15:59:02 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k6IMwJDW014951
	for <xfs@oss.sgi.com>; Tue, 18 Jul 2006 15:58:31 -0700
Date: Wed, 19 Jul 2006 08:57:31 +1000
From: Nathan Scott <nathans@sgi.com>
Subject: Re: XFS breakage in 2.6.18-rc1
Message-ID: <20060719085731.C1935136@wobbly.melbourne.sgi.com>
References: <20060718222941.GA3801@stargate.galaxy>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20060718222941.GA3801@stargate.galaxy>; from torsten@debian.org on Wed, Jul 19, 2006 at 12:29:41AM +0200
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Torsten Landschoff <torsten@debian.org>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Wed, Jul 19, 2006 at 12:29:41AM +0200, Torsten Landschoff wrote:
> Hi friends, 

Hi Torsten,

> I upgraded to 2.6.18-rc1 on sunday, with the following results (taken
> from my /var/log/kern.log), which ultimately led me to reinstall my 
> system:
> 
> Jul 17 07:33:53 pulsar kernel: xfs_da_do_buf: bno 16777216
> Jul 17 07:33:53 pulsar kernel: dir: inode 54526538

I suspect you had some residual directory corruption from using the
2.6.17 XFS (which is known to have a lurking dir2 corruption issue,
fixed in the latest -stable point release).

> of programs fail in mysterious ways. I tried to recover using xfs_repair
> but I feel that my partition is thorougly borked. Of course no data was 
> lost due to backups but still I'd like this bug to be fixed ;-)

2.6.18-rc1 should be fine (contains the corruption fix).  Did you
mkfs and restore?  Or at least get a full repair run?  If you did,
and you still see issues in .18-rc1, please let me know asap.

thanks.

-- 
Nathan
