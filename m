Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qA3MNTO3039222 for <xfs@oss.sgi.com>; Sat, 3 Nov 2012 17:23:29 -0500
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	GLU89MV0XRODW5kO for <xfs@oss.sgi.com>;
	Sat, 03 Nov 2012 15:25:22 -0700 (PDT)
Date: Sun, 4 Nov 2012 09:25:18 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs filesystem corruption with kernel 2.6.37
Message-ID: <20121103222518.GH29378@dastard>
References: <CAC=U0a2T_J9Y6WzvWyFfbBSDy__Pr7f4gfQBie2o0VhAm2jCaQ@mail.gmail.com>
	<20121025224713.GF29378@dastard> <34630253.post@talk.nabble.com>
	<20121102012728.GT29378@dastard> <34633803.post@talk.nabble.com>
	<20121102225509.GZ29378@dastard>
	<37CBCD87-5B71-4B9C-8FAE-5BBF85804983@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <37CBCD87-5B71-4B9C-8FAE-5BBF85804983@gmail.com>
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
To: Kamal Dasu <kdasu.kdev@gmail.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Fri, Nov 02, 2012 at 09:57:27PM -0400, Kamal Dasu wrote:
> Dave,
> 
> 
> > 
> > 0x780dbd80007f248
> > 
> > Once again it's corruption in the upper 32 bits of the 64 bit number.
> > Those bits should be zero. Perhaps looking at all the trace events
> > from recovery might give you a closer approximation of where the bad
> > extent records is found....
> 
> I have been trying to use the xfs_db xfs_logprint, how ever
> xfs_logprint bails out when it finds an error.

$ man xfs_logprint
....
	-c     Attempt to continue when an error is detected.

> How do I look at
> trace events ?.

Documentation/trace/events.txt

Or better yet, use trace-cmd as suggested in the FAQ:

http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_reporting_a_problem.3F

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
