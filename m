Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 20 Apr 2008 17:33:54 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m3L0XLh1012893
	for <xfs@oss.sgi.com>; Sun, 20 Apr 2008 17:33:23 -0700
Date: Mon, 21 Apr 2008 10:33:43 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: likely and unlikely was: Re: [PATCH] split xfs_ioc_xattr
Message-ID: <20080421003343.GL108924158@sgi.com>
References: <20080319204014.GA23644@lst.de> <ncciqylf7q0.fsf@sgi.com> <20080414032940.GA10579@lst.de> <ncclk3ejwam.fsf@sgi.com> <20080416063712.GN108924158@sgi.com> <4805A589.7080906@sgi.com> <87ve2i5kbs.fsf@basil.nowhere.org> <4808488A.7010204@sgi.com> <4808AAA5.1060201@sandeen.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4808AAA5.1060201@sandeen.net>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Timothy Shimmin <tes@sgi.com>, Andi Kleen <andi@firstfloor.org>, David Chinner <dgc@sgi.com>, Niv Sardi <xaiki@cxhome.ath.cx>, Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

On Fri, Apr 18, 2008 at 09:05:25AM -0500, Eric Sandeen wrote:
> ISTR that the dir2 code on Irix had tons of compiler pragmas for likely
> and unlikely paths, and that it actually was well-profiled and tested.
> Did that ever get translated into Linux hints?

The Irix code (#pragma mips_frequency_hint [FREQUENT|NEVER|INIT])
only controllered physical placement of code, it never issued
branch hints. i.e. a "never" block gets moved out of line,
while a "frequent" block is left inline. Realistically, the way
this is used in the Irix dir2 code is completely useless - code like
this:

        if (namelen >= MAXNAMELEN) {
#pragma mips_frequency_hint NEVER
                return XFS_ERROR(EINVAL);
        }
        if (rval = xfs_dir_ino_validate(tp->t_mountp, inum)) {
#pragma mips_frequency_hint NEVER
                return rval;
        }

Never needed those hints in the first place, it's damn messy, and
the places where it might actually be useful it doesn't get used.
I'd prefer to avoid the hints unless we really have a performance
critical path that we want to have as much straight line code as
possible. That will require profiling to get right....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
