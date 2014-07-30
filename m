Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E53B57F75
	for <xfs@oss.sgi.com>; Wed, 30 Jul 2014 16:43:38 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 7FED2AC003
	for <xfs@oss.sgi.com>; Wed, 30 Jul 2014 14:43:38 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	XnUCmAKXi2Xk0pea for <xfs@oss.sgi.com>;
	Wed, 30 Jul 2014 14:43:36 -0700 (PDT)
Date: Thu, 31 Jul 2014 07:43:34 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 4/4] xfs: dquot recovery needs verifiers
Message-ID: <20140730214334.GN20518@dastard>
References: <1406684929-11133-1-git-send-email-david@fromorbit.com>
	<1406684929-11133-5-git-send-email-david@fromorbit.com>
	<CA+o=1OWqWXXLGLB9-TgkmBUDfFs0GpmQS=4to3tO6-R0FvgLuA@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CA+o=1OWqWXXLGLB9-TgkmBUDfFs0GpmQS=4to3tO6-R0FvgLuA@mail.gmail.com>
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
To: Fanael Linithien <fanael4@gmail.com>
Cc: xfs@oss.sgi.com

On Wed, Jul 30, 2014 at 02:30:11PM +0200, Fanael Linithien wrote:
> 2014-07-30 3:48 GMT+02:00 Dave Chinner <david@fromorbit.com>:
> > +       if (!mp->m_qflags == 0)
> > +               return false;
> 
> Is it a typo, or is it intentionally obfuscated mp->m_qflags != 0?

Ugh. Two patches in the series that weren't properly uptodate. I'll
resend the series....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
