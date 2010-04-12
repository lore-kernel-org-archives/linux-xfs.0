Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3D1InbA177974 for <xfs@oss.sgi.com>; Mon, 12 Apr 2010 20:18:49 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A5FFC2BA417
	for <xfs@oss.sgi.com>; Mon, 12 Apr 2010 18:20:42 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail13.adl6.internode.on.net
	[150.101.137.98]) by cuda.sgi.com with ESMTP id
	O8Evl1Pew6YGXoAp for <xfs@oss.sgi.com>;
	Mon, 12 Apr 2010 18:20:42 -0700 (PDT)
Date: Mon, 12 Apr 2010 16:21:58 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] enable inode64 by default when possible
Message-ID: <20100412062158.GF2493@dastard>
References: <4B7309D7.5090800@sandeen.net> <1270850499.7840.25.camel@doink>
	<4BBFE478.3090901@hardwarefreak.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4BBFE478.3090901@hardwarefreak.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: xfs@oss.sgi.com

On Fri, Apr 09, 2010 at 09:37:44PM -0500, Stan Hoeppner wrote:
> Alex Elder put forth on 4/9/2010 5:01 PM:
> 
> > OK, it's been about two months since Eric proposed this, and
> > I'm finally getting around to writing up a response.
> > 
> > I discussed this with a few people within SGI, and there were
> > two main concerns that were mentioned:
> > - This may be a problem for some NFS clients
> > - This may be a problem for some backup software
> > We don't believe there are any direct issues with DMF or CXFS
> > in making this change.
> > 
> > I understand that the change is only in the default behavior,
> > and that forcing 32-bit inodes will still be an available
> > option.
> 
> Hi Alex,
> 
> How will this change affect those people running 32bit CPUs and kernels, if
> at all?  Or is this change related not to the word width of the hardware/OS
> but to the size of the filesystem and/or number of files/inodes contained
> within?  You mentioned possible issues with NFS.  Are there any issues with
> Samba?
> 
> Intel Atom (32bit x86) CPUs

No, I think Atom is 64 bit.

/me checks his mailserver

Yup, it's running a 64 bit kernel and 64 bit userspace. No 32 bit
issues there....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
