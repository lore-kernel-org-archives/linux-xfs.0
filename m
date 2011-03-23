Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with SMTP id
	p2NMUG3s119654
	for <linux-xfs@oss.sgi.com>; Wed, 23 Mar 2011 17:30:22 -0500
Received: from mx3.twosigma.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with SMTP id C2CE5140FF88
	for <linux-xfs@oss.sgi.com>; Wed, 23 Mar 2011 15:33:07 -0700 (PDT)
Received: from mx3.twosigma.com (mx3.twosigma.com [208.77.213.34]) by
	cuda.sgi.com with SMTP id ADknmrP1q28gmrO7 for
	<linux-xfs@oss.sgi.com>; Wed, 23 Mar 2011 15:33:07 -0700 (PDT)
From: Sean Noonan <Sean.Noonan@twosigma.com>
Date: Wed, 23 Mar 2011 18:33:04 -0400
Subject: RE: XFS memory allocation deadlock in 2.6.38
Message-ID: <081DDE43F61F3D43929A181B477DCA95639B532D@MSXAOA6.twosigma.com>
References: <081DDE43F61F3D43929A181B477DCA95639B52E8@MSXAOA6.twosigma.com>
	<20110322232504.GC15270@dastard>
	<081DDE43F61F3D43929A181B477DCA95639B532C@MSXAOA6.twosigma.com>
	<20110323220345.GD26611@dastard>
In-Reply-To: <20110323220345.GD26611@dastard>
Content-Language: en-US
MIME-Version: 1.0
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
To: 'Dave Chinner' <david@fromorbit.com>
Cc: "'linux-xfs@oss.sgi.com'" <linux-xfs@oss.sgi.com>, Martin Bligh <Martin.Bligh@twosigma.com>, Trammell Hudson <Trammell.Hudson@twosigma.com>

> So why would creating a 16GB file cause and OOM condition if you
> have 48GB RAM? That doesn't make a whole lot of sense to me. Is
> that memory free, of are other things running and consuming memory?

As far as I know this isn't an OOM condition.  It is a bug, which is why I sent a patch that fixes this specific case earlier today.

Sean

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
