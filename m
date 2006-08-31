Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 30 Aug 2006 20:20:39 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k7V3KADW009025
	for <xfs@oss.sgi.com>; Wed, 30 Aug 2006 20:20:22 -0700
Date: Thu, 31 Aug 2006 13:19:02 +1000
From: Nathan Scott <nathans@sgi.com>
Subject: Re: [PATCH 2/2] Fix i_state of inode is changed after the inode is freed [try #2]
Message-ID: <20060831131902.H3208450@wobbly.melbourne.sgi.com>
References: <20060824171653.C3003989@wobbly.melbourne.sgi.com> <20060831114423m-saito@mail.aom.tnes.nec.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20060831114423m-saito@mail.aom.tnes.nec.co.jp>; from m-saito@tnes.nec.co.jp on Thu, Aug 31, 2006 at 11:44:23AM +0900
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Masayuki Saito <m-saito@tnes.nec.co.jp>
Cc: David Chinner <dgc@sgi.com>, xfs@oss.sgi.com, linux-kernel@vger.kernel.org

On Thu, Aug 31, 2006 at 11:44:23AM +0900, Masayuki Saito wrote:
> Hi, Nathan
> 
> Are the patches going to be merged?

Yep, they're queued up for 2.6.19.  Since it was a race found
only on testing with a ramdisk (iirc) it didn't really seem to
me like they needed to be rushed through for a 2.6.18-rc.  The
race has also been there for the entire lifetime of the Linux
XFS port... so, not urgent (and not risk free either).

cheers.

-- 
Nathan
