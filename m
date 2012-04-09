Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q394wPcv029940 for <xfs@oss.sgi.com>; Sun, 8 Apr 2012 23:58:25 -0500
Received: from oproxy1-pub.bluehost.com (oproxy1-pub.bluehost.com
	[66.147.249.253]) by cuda.sgi.com with SMTP id ZEXMlVwTHWg27qxV
	for <xfs@oss.sgi.com>; Sun, 08 Apr 2012 21:58:24 -0700 (PDT)
From: "Vyacheslav Dubeyko" <slava@dubeyko.com>
Subject: Re: detecting case-insensitivity
Date: Mon,  9 Apr 2012 09:01:11 +0400
Message-ID: <LBVkglc6jtb7.r3bLKBnl@host202.hostmonster.com>
MIME-Version: 1.0
Content-Language: i-default
Reply-To: Vyacheslav Dubeyko <slava@dubeyko.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: "J. Bruce Fields" <bfields@fieldses.org>, xfs@oss.sgi.com


Initial message
> Subject: Re: detecting case-insensitivity
> From: Dave Chinner <david@fromorbit.com>
> Date: 09.04.2012 03.30
> 
> On Sat, Apr 07, 2012 at 10:00:29AM -0400, J. Bruce Fields wrote:
> > Is there a generic way to detect whether a given filesystem is
> > case-insensitive?  If not, how should it be done?  (A bit in s_flags?)
> 
> I don't think there is a generic flag for it. We could trivially add
> one, I think, as it is generally a fixed property for the entire
> filesystem....
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

But why does it need to detect that filesystem case-insensitive or not? In what use-case does it need to make such detection?

With the best regards,
Vyacheslav Dubeyko.
slava@dubeyko.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
