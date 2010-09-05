Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o85AmFxO111374 for <xfs@oss.sgi.com>; Sun, 5 Sep 2010 05:48:16 -0500
Received: from 1wt.eu (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C79884DA7D
	for <xfs@oss.sgi.com>; Sun,  5 Sep 2010 03:48:54 -0700 (PDT)
Received: from 1wt.eu (1wt.eu [62.212.114.60]) by cuda.sgi.com with ESMTP id
	14muDhELgJAEonrq for <xfs@oss.sgi.com>;
	Sun, 05 Sep 2010 03:48:54 -0700 (PDT)
Date: Sun, 5 Sep 2010 12:47:39 +0200
From: Willy Tarreau <w@1wt.eu>
Subject: Re: XFS status update for August 2010
Message-ID: <20100905104739.GC27623@1wt.eu>
References: <20100902145959.GA27887@infradead.org>
	<20100905074457.GC16004@1wt.eu> <201009051137.07678@zmi.at>
Mime-Version: 1.0
Content-Disposition: inline
In-Reply-To: <201009051137.07678@zmi.at>
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
To: Michael Monnerie <michael.monnerie@is.it-management.at>
Cc: xfs@oss.sgi.com

On Sun, Sep 05, 2010 at 11:37:03AM +0200, Michael Monnerie wrote:
> On Sonntag, 5. September 2010 Willy Tarreau wrote:
> > I've just installed 2.6.35.4
> 
> Try the following mount options: 
> relatime,logbufs=8,logbsize=256k,attr2,barrier,largeio,swalloc,delaylog

Ah thanks for the info Michael, indeed it's a *lot* better: down from 57s
to 1.3s !

I will experiment with that.

Thanks again,
Willy

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
