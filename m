Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 15 Jun 2008 21:51:33 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5G4pTpk009428
	for <xfs@oss.sgi.com>; Sun, 15 Jun 2008 21:51:30 -0700
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 35B8F17C87A7
	for <xfs@oss.sgi.com>; Sun, 15 Jun 2008 21:52:25 -0700 (PDT)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id hWPmPQ7MJ5DPm0bg for <xfs@oss.sgi.com>; Sun, 15 Jun 2008 21:52:25 -0700 (PDT)
Date: Mon, 16 Jun 2008 14:52:21 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS errors / BUG / panic, with 2.6.25.7-queue (and older
	2.6.25.y)
Message-ID: <20080616045221.GJ3700@disturbed>
References: <6101e8c40806141241h4a23f7a6ka5366c84130f1291@mail.gmail.com> <48547604.9060700@sandeen.net> <6101e8c40806150538h4372dcedob2ab9c45aa01741c@mail.gmail.com> <48553C11.2060606@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48553C11.2060606@sandeen.net>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Oliver Pinter <oliver.pntr@gmail.com>, xfs@oss.sgi.com

On Sun, Jun 15, 2008 at 10:58:09AM -0500, Eric Sandeen wrote:
> Oliver Pinter wrote:
> > this mistake shutdownkor comes out, remount launched because he
> > panics, only Alt+Sysrq+foo works
> 
> I'm not sure I follow.
> 
> Assuming that :
> http://students.zipernowsky.hu/~oliverp/upload/xfs_error/dsc00775.jpg
> 
> is the first event of interest, it is hitting an assertion on the
> remount path:
> 
>         ASSERT_ALWAYS(atomic_read(&mp->m_active_trans) == 0);
> 
> in xfs_attr_quiesce.

That's caused by a race condition in the VFS w.r.t setting the MS_RDONLY
flag. It should be fixed in 2.6.26.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
