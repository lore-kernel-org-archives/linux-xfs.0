Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B6A247F3F
	for <xfs@oss.sgi.com>; Thu, 10 Dec 2015 16:35:59 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 47BA6AC002
	for <xfs@oss.sgi.com>; Thu, 10 Dec 2015 14:35:56 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	Dpp03svXuES0a8px for <xfs@oss.sgi.com>;
	Thu, 10 Dec 2015 14:35:53 -0800 (PST)
Date: Fri, 11 Dec 2015 09:35:51 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: handling device or resource busy errors.
Message-ID: <20151210223551.GI26718@dastard>
References: <CACQ+YcuwWv8g5zHk2sMfN_uRPGnW8Xb8WT6NGOLGigN2+0Toag@mail.gmail.com>
	<20151210021343.GI19802@dastard>
	<CACQ+Yct8ics=YebWFU=h4VHSdVEW3jcpdbZ8=niov9A+fL-HqQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CACQ+Yct8ics=YebWFU=h4VHSdVEW3jcpdbZ8=niov9A+fL-HqQ@mail.gmail.com>
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
To: Ed Peschko <horos22@gmail.com>
Cc: xfs@oss.sgi.com

On Wed, Dec 09, 2015 at 11:58:41PM -0800, Ed Peschko wrote:
> Dave,
> 
> futex comes from doing a simple strace, which showed the futex as the call
> that was being blocked. My fear is that it is a holdover from an old, dead
> process; we went through each process on the system and lsof -p'd it,
> didn't see anything.

Please show your working. i.e. attach the output of strace for
whatever process is tripping over this. I've still got no idea
what you are talking about, and I won't until I see the output
of the commands you are taling about.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
