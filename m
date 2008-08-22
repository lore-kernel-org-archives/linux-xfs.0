Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 22 Aug 2008 00:08:54 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m7M78n9x021047
	for <xfs@oss.sgi.com>; Fri, 22 Aug 2008 00:08:50 -0700
Received: from sca-es-mail-1.sun.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0319EF9E0DC
	for <xfs@oss.sgi.com>; Fri, 22 Aug 2008 00:10:04 -0700 (PDT)
Received: from sca-es-mail-1.sun.com (sca-es-mail-1.Sun.COM [192.18.43.132]) by cuda.sgi.com with ESMTP id sSI1lOk99utbSCBb for <xfs@oss.sgi.com>; Fri, 22 Aug 2008 00:10:04 -0700 (PDT)
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m7M7A4BD002352
	for <xfs@oss.sgi.com>; Fri, 22 Aug 2008 00:10:04 -0700 (PDT)
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0K5Z00001QK32R00@fe-sfbay-09.sun.com> (original mail from adilger@sun.com)
 for xfs@oss.sgi.com; Fri, 22 Aug 2008 00:10:04 -0700 (PDT)
Date: Fri, 22 Aug 2008 01:09:58 -0600
From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH 1/3] Implement generic freeze feature
In-reply-to: <20080821125841.a04a706f.akpm@linux-foundation.org>
Message-id: <20080822070958.GU3392@webber.adilger.int>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7BIT
Content-disposition: inline
References: <20080818212819t-sato@mail.jp.nec.com>
 <20080821125841.a04a706f.akpm@linux-foundation.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Takashi Sato <t-sato@yk.jp.nec.com>, linux-fsdevel@vger.kernel.org, dm-devel@redhat.com, viro@ZenIV.linux.org.uk, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, hch@infradead.org, axboe@kernel.dk, mtk.manpages@googlemail.com, linux-kernel@vger.kernel.org

On Aug 21, 2008  12:58 -0700, Andrew Morton wrote:
> >  #define FIGETBSZ   _IO(0x00,2)	/* get the block size used for bmap */
> > +#define FIFREEZE	_IOWR('X', 119, int)	/* Freeze */
> > +#define FITHAW		_IOWR('X', 120, int)	/* Thaw */
> 
> FIFREEZE is 119, but a few lines above we have
> 
> #define BLKDISCARD _IO(0x12,119)
>
> Should we be using 120 and 121 here?

No, because 'X' != 0x12...  The 'X' is used because this ioctl is compatible
with the XFS implementation of this feature.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.
