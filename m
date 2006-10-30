Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 30 Oct 2006 14:21:23 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k9UMLBaG015997
	for <xfs@oss.sgi.com>; Mon, 30 Oct 2006 14:21:12 -0800
Received: from prod.aconex.com (mail.app.aconex.com [203.89.192.138])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9CA714DE475
	for <xfs@oss.sgi.com>; Mon, 30 Oct 2006 14:20:24 -0800 (PST)
Subject: Re: xfs_quota project + symlinks
From: Nathan Scott <nscott@aconex.com>
Reply-To: nscott@aconex.com
In-Reply-To: <2F2FC01C6C9DD207E49DFC0B@timothy-shimmins-power-mac-g5.local>
References: <Pine.LNX.4.64.0610261519250.30903@zaphod.blinkenlights.nl>
	 <Pine.LNX.4.64.0610261544020.31061@zaphod.blinkenlights.nl>
	 <2F2FC01C6C9DD207E49DFC0B@timothy-shimmins-power-mac-g5.local>
Content-Type: text/plain
Date: Tue, 31 Oct 2006 09:24:03 +1100
Message-Id: <1162247043.17754.160.camel@edge>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Timothy Shimmin <tes@sgi.com>
Cc: Sten Spans <sten@blinkenlights.nl>, xfs@oss.sgi.com

On Mon, 2006-10-30 at 15:39 +1000, Timothy Shimmin wrote:
> Hi,
> 
> > If path is a symlink, then the project id is applied to a file
> > potentially on another filesystem. Wouldn't it be better to
> > add O_NOFOLLOW here ?
> 
> You want it to error out if it is a symlink.
> 

Thats not ideal.  But some way to stay on the symlink's filesystem
is probably needed here, from the sound of it.

> I'm not that familiar with quotas (Nathan?, Donald?), but I would presume
> that since symlinks take up space depending on the symlink path, that they should
> have quota control on the space they take up.

If they require space to be allocated (i.e the symlink target is not 
stored in the inode literal area), then that space allocation will be
subject to quota IIRC.

> In which case, one would actually not want to follow the symlink but rather
> apply a limit to that actual symlink inode.

*nod*

> 
> But I agree, I doubt one wants to follow the symlinks - it would get rather
> confusing.

*nod*

cheers.

-- 
Nathan
