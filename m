Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3D9eu4V213577 for <xfs@oss.sgi.com>; Tue, 13 Apr 2010 04:40:57 -0500
Received: from moutng.kundenserver.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 32BBCFF6E71
	for <xfs@oss.sgi.com>; Tue, 13 Apr 2010 02:42:50 -0700 (PDT)
Received: from moutng.kundenserver.de (moutng.kundenserver.de [212.227.17.8])
	by cuda.sgi.com with ESMTP id NHHTrtlRL59awJqz for
	<xfs@oss.sgi.com>; Tue, 13 Apr 2010 02:42:50 -0700 (PDT)
From: "Hans-Peter Jansen" <hpj@urpla.net>
Subject: Re: 2.6.34-rc3: simple du (on a big xfs tree) triggers oom killer
	[bisected: 57817c68229984818fea9e614d6f95249c3fb098]
Date: Tue, 13 Apr 2010 11:42:33 +0200
References: <201004050049.17952.hpj@urpla.net>
	<201004131050.36395.hpj@urpla.net> <20100413091823.GD7544@dastard>
In-Reply-To: <20100413091823.GD7544@dastard>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <201004131142.33518.hpj@urpla.net>
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
Cc: opensuse-kernel@opensuse.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Tuesday 13 April 2010, 11:18:23 Dave Chinner wrote:
> On Tue, Apr 13, 2010 at 10:50:35AM +0200, Hans-Peter Jansen wrote:
> >
> > Dave, may I ask you kindly for briefly elaborating on the worst
> > consequences of just reverting this hunk, as I've done before?
>
> Well, given that is the new shrinker code generating the warnings,
> reverting/removing that hunk will render the patch useless :0

Excuse me, I didn't express myself well. I'm after the consequences of 
applying the revert, that I posted a few messages above. 

> I'll get you a working 2.6.33 patch tomorrow - it's dinner time
> now....

Cool, thanks. 

Have a nice dinner,
Pete



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
