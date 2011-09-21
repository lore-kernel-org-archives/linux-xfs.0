Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8LKFCUt173460 for <xfs@oss.sgi.com>; Wed, 21 Sep 2011 15:15:12 -0500
Received: from xmail.sgi.com (pv-excas3-dc21.corp.sgi.com [137.38.102.206])
	by relay3.corp.sgi.com (Postfix) with ESMTP id B59E3AC003
	for <xfs@oss.sgi.com>; Wed, 21 Sep 2011 13:15:11 -0700 (PDT)
Subject: Re: [PATCH] xfstests: simplify TRIM_OFF_LEN() in "ltp/fsx.c"
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <1316632273.5872.20.camel@doink>
References: <201107202310.p6KNAtQa026739@stout.americas.sgi.com>
	<1316632273.5872.20.camel@doink>
Date: Wed, 21 Sep 2011 15:15:10 -0500
Message-ID: <1316636110.5872.26.camel@doink>
MIME-Version: 1.0
Reply-To: aelder@sgi.com
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
To: xfs@oss.sgi.com

On Wed, 2011-09-21 at 14:11 -0500, Alex Elder wrote:
> Can someone review this please?		-Alex
> 
> On Wed, 2011-07-20 at 18:10 -0500, Alex Elder wrote:
> > A recent commit added a TRIM_OFF_LEN() macro in "ltp/fsx.c":
> >     5843147e xfstests: fsx fallocate support is b0rked
> > A later commit fixed a problem with that macro:
> >     c47d7a51 xfstests: fix modulo-by-zero error in fsx
> > 

Nevermind.  I found a problem so I'm re-posting this
shortly.

					-Alex

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
