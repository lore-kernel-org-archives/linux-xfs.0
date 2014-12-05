Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 7A55D7F3F
	for <xfs@oss.sgi.com>; Thu,  4 Dec 2014 23:49:54 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 4BFC58F8050
	for <xfs@oss.sgi.com>; Thu,  4 Dec 2014 21:49:51 -0800 (PST)
Received: from mail-wi0-f175.google.com (mail-wi0-f175.google.com
	[209.85.212.175]) by cuda.sgi.com with ESMTP id
	pUja3QCSC7N7HNHm (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Thu, 04 Dec 2014 21:49:49 -0800 (PST)
Received: by mail-wi0-f175.google.com with SMTP id l15so344566wiw.8
	for <xfs@oss.sgi.com>; Thu, 04 Dec 2014 21:49:48 -0800 (PST)
Date: Fri, 5 Dec 2014 06:49:46 +0100
From: Iustin Pop <iustin@k1024.org>
Subject: Re: [PATCH] xfs: fix behaviour of XFS_IOC_FSSETXATTR on directories
Message-ID: <20141205054946.GA24934@teal.hq.k1024.org>
References: <20140829004607.GX20518@dastard>
	<1417666466-31820-1-git-send-email-iustin@k1024.org>
	<20141205001148.GS9561@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20141205001148.GS9561@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Fri, Dec 05, 2014 at 11:11:48AM +1100, Dave Chinner wrote:
> On Thu, Dec 04, 2014 at 05:14:26AM +0100, Iustin Pop wrote:
> > Currently, the ioctl handling code for XFS_IOC_FSSETXATTR treats all
> > targets as regular files: it refuses to change the extent size if
> > extents are allocated. This is wrong for directories, as there the
> > extent size is only used as a default for children.
> > 
> > The patch fixes this issue and improves validation of flag
> > combinations:
> > 
> > - only disallow extent size changes after extents have been allocated
> >   for regular files
> > - only allow XFS_XFLAG_EXTSIZE for regular files
> > - only allow XFS_XFLAG_EXTSZINHERIT for directories
> > - automatically clear the flags if the extent size is zero
> > 
> > Thanks to Dave Chinner for guidance on the proper fix for this issue.
> 
> I'll have to remind myself of the context again - I think I have
> some patches in my local queue that I never finished that kill a lot
> of the mess around this code. I put that at the head of next week's
> queue...

Yep, I had forgotten myself what was the status, and had to reread
through the old email thread. That's what happens when you leave a patch
"rot" for so long :)

And yes, the code in this function is a bit hard to follow, since the
various checks are spread around. Cleaning this up would be good; I only
care that when next time I run an xfsrestore, it won't fail to set the
extent sizes correctly on directories :)

thanks!
iustin

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
