Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7BM7MRT008164 for <xfs@oss.sgi.com>; Thu, 11 Aug 2011 17:07:22 -0500
Received: from mail.nethype.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EA55E18AF3C4
	for <xfs@oss.sgi.com>; Thu, 11 Aug 2011 15:07:21 -0700 (PDT)
Received: from mail.nethype.de (mail.nethype.de [78.47.73.129]) by
	cuda.sgi.com with ESMTP id xcwI9CMFwaLCoBHs for
	<xfs@oss.sgi.com>; Thu, 11 Aug 2011 15:07:21 -0700 (PDT)
Date: Fri, 12 Aug 2011 00:07:19 +0200
From: Marc Lehmann <schmorp@schmorp.de>
Subject: Re: frequent kernel BUG and lockups - 2.6.39 + xfs_fsr
Message-ID: <20110811220719.GC12808@schmorp.de>
References: <20110806122556.GB20341@schmorp.de> <20110807102625.GJ3162@dastard>
	<20110808190222.GB7087@schmorp.de> <201108091210.50204@zmi.at>
	<20110809111526.GA7631@schmorp.de> <20110810141619.GA26978@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110810141619.GA26978@dastard>
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
Cc: Michael Monnerie <michael.monnerie@is.it-management.at>, xfs@oss.sgi.com

On Thu, Aug 11, 2011 at 12:16:19AM +1000, Dave Chinner <david@fromorbit.com> wrote:
> > As has been reported on this list, this option is really harmful on
> > current xfs - in my case, it lead to xfs causing ENOSPC even when the disk
> > was 40% empty (~188gb).
> 
> Seeing you keep stating this is a problem,

I can only go by what _you_ told me earlier, namely that this works as
designed and no change is needed. If you changed your mind without telling
me, how should I find out?

If you say one thing and do another, you shouldn't be surprised when
people trust you and go by what you say.

> commit 778e24b ("xfs: reset inode per-lifetime state when recycling
> it") fixed this problem for you?

If you tell me in which kernel version this is included, I can find out
easily.

-- 
                The choice of a       Deliantra, the free code+content MORPG
      -----==-     _GNU_              http://www.deliantra.net
      ----==-- _       generation
      ---==---(_)__  __ ____  __      Marc Lehmann
      --==---/ / _ \/ // /\ \/ /      schmorp@schmorp.de
      -=====/_/_//_/\_,_/ /_/\_\

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
