Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 18 Sep 2008 11:29:07 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8IISVq1003947
	for <xfs@oss.sgi.com>; Thu, 18 Sep 2008 11:28:31 -0700
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E34CA455C95
	for <xfs@oss.sgi.com>; Thu, 18 Sep 2008 11:30:03 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id Ix1yy643LrvBC0Ch for <xfs@oss.sgi.com>; Thu, 18 Sep 2008 11:30:03 -0700 (PDT)
Message-ID: <59243.131.252.241.230.1221762601.squirrel@sandeen.net>
In-Reply-To: <48D218AE.9090400@sgi.com>
References: <48D19A83.4040608@thebarn.com> <48D1CD46.4010104@sgi.com>
    <48D1DCD5.7040502@thebarn.com> <48D218AE.9090400@sgi.com>
Date: Thu, 18 Sep 2008 13:30:01 -0500 (CDT)
Subject: Re: REVIEW: Fix for incore extent corruption.
From: "Eric Sandeen" <sandeen@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: lachlan@sgi.com
Cc: Russell Cattelan <cattelan@thebarn.com>, xfs@oss.sgi.com

Lachlan McIlroy wrote:
> Russell, this fixes xfs_iext_irec_compact_full().  If we don't move
> all the records from the next page into the current page then we need
> to update the er_extoff of the modified page as we move the remaining
> extents up.  Would you mind giving it a go?
>
> --- a/fs/xfs/xfs_inode.c	2008-09-18 18:48:46.000000000 +1000
> +++ b/fs/xfs/xfs_inode.c	2008-09-18 18:57:18.000000000 +1000
> @@ -4623,6 +4623,7 @@ xfs_iext_irec_compact_full(
>  					(XFS_LINEAR_EXTS -
>  						erp_next->er_extcount) *
>  					sizeof(xfs_bmbt_rec_t));
> +				erp_next->er_extoff += ext_diff;
>  			}
>  		}

Lachlan, I concur.  I spent way too long last night looking at this and
arrived at the same conclusion about the root cause of the problem, but
didn't hae *quite* the right solution.  I blame it on 2am ;)  Your fix
looks right.

(though I'd probably move the erp_next changes into the else clause? 
Otherwise you're changing it then freeing it.)

-Eric
