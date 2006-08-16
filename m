Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 15 Aug 2006 17:13:02 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k7G0CIDW026231
	for <xfs@oss.sgi.com>; Tue, 15 Aug 2006 17:12:30 -0700
Date: Wed, 16 Aug 2006 10:11:22 +1000
From: Nathan Scott <nathans@sgi.com>
Subject: Re: kernel BUG at <bad filename>:50307!
Message-ID: <20060816101122.E2740551@wobbly.melbourne.sgi.com>
References: <44E1D9CA.30805@uni-hd.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <44E1D9CA.30805@uni-hd.de>; from mbraun@uni-hd.de on Tue, Aug 15, 2006 at 04:27:22PM +0200
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Martin Braun <mbraun@uni-hd.de>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com

Hi Martin,

On Tue, Aug 15, 2006 at 04:27:22PM +0200, Martin Braun wrote:
> ...
> What does this bug mean?
> ...
> Aug 15 15:01:02 pers109 kernel: Access to block zero: fs: <sdc1> inode:
> 254474718 start_block : 0 start_off : c0a0b0e8a099
> 0 blkcnt : 90000 extent-state : 0
> Aug 15 15:01:02 pers109 kernel: ------------[ cut here ]------------
> Aug 15 15:01:02 pers109 kernel: kernel BUG at <bad filename>:50307!

It means XFS detected ondisk corruption in inode# 254474718, and
paniced your system (stupidly; a fix for this is around, will be
merged with the next mainline update).  For me, a more interesting
question is how that inode got into this state... have you had any
crashes recently (i.e. has the filesystem journal needed to be
replayed recently?)  Can you send the output of:

	# xfs_db -c 'inode 254474718' -c print /dev/sdc1

You'll need to run xfs_repair on that filesystem to fix this up,
but please send us that output first.

thanks.

-- 
Nathan
