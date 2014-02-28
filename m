Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id EF6F77F3F
	for <xfs@oss.sgi.com>; Thu, 27 Feb 2014 19:57:04 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D74C430406B
	for <xfs@oss.sgi.com>; Thu, 27 Feb 2014 17:57:04 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	VK8NImeiKvYifpdq for <xfs@oss.sgi.com>;
	Thu, 27 Feb 2014 17:57:03 -0800 (PST)
Date: Fri, 28 Feb 2014 12:57:01 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] metadump: don't verify metadata being dumped
Message-ID: <20140228015701.GI30131@dastard>
References: <1393548825-16499-1-git-send-email-david@fromorbit.com>
	<530FE9CD.4000701@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <530FE9CD.4000701@sandeen.net>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

On Thu, Feb 27, 2014 at 07:43:41PM -0600, Eric Sandeen wrote:
> On 2/27/14, 6:53 PM, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > The discontiguous buffer support series added a verifier check on
> > the metadata buffers before they go written to the metadump image.
> > If this failed, it returned an error, and the restul woul dbe that
> > we stopped processing the metadata and exited, resulting in a
> > truncated dump.
> > 
> > xfs_metadump is supposed to dump the metadata in the filesystem
> > for forensic analysis purposes, which means we actually want it to
> > retain any corruptions it finds in the filesystem. Hence running the
> > verifier - even to recalculate CRCs - is the wrong thing to be
> > doing. And stopping the dum pwhen we come across an error is even
> > worse.
> > 
> > Therefore remove the code tha truns the verifier and causes all
> > these problems and replace it with a comment explaining why we don't
> > want to run verifiers in the metadump process.
> 
> This leaves the net functional change from 
> 8ab75c db: enable metadump on CRC filesystems
> as:
> 
> @@ -1727,6 +1743,9 @@ copy_inode_chunk(
>  
>                 if (!process_inode(agno, agino + i, dip))
>                         goto pop_out;
> +
> +               /* calculate the new CRC for the inode */
> +               xfs_dinode_calc_crc(mp, dip);
>         }
>  skip_processing:
>         if (!write_buf(iocur_top))
> 
> which seems a) minimal, but also b) like we shouldn't be recalculating
> CRCs if the point is to copy out existing fs state...?
> 
> OTOH if we're obfuscating, we would HAVE to recalculate CRCs,
> but then would lose the info that the CRC was bad before.
> 
> So probably should skip CRC recalculating if the original CRC
> was bad, in the obfuscating case?

Yeah, you are right - I wasn't thinking of the obfuscation case
changing the metadata....

> Maybe this patch stands ok on its own but it seems like there's
> more work to do.  :)

I'll rework it.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
