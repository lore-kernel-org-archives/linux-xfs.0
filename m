Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7RA8vP4079649 for <xfs@oss.sgi.com>; Thu, 27 Aug 2009 05:09:07 -0500
Received: from moutng.kundenserver.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0E7DD402B30
	for <xfs@oss.sgi.com>; Thu, 27 Aug 2009 03:09:47 -0700 (PDT)
Received: from moutng.kundenserver.de (moutng.kundenserver.de [212.227.17.8])
	by cuda.sgi.com with ESMTP id XhZeBjs0CgCpzRBt for
	<xfs@oss.sgi.com>; Thu, 27 Aug 2009 03:09:47 -0700 (PDT)
Date: Thu, 27 Aug 2009 03:09:43 -0700 (PDT)
From: Christian Kujau <lists@nerdbynature.de>
Subject: RE: xfs data loss
In-Reply-To: <B9A7B002C7FAFC469D4229539E909760308DA65237@DU-EXC-MAIL.empa.emp-eaw.ch>
Message-ID: <alpine.DEB.2.01.0908270300530.5744@bogon.housecafe.de>
References: <B9A7B002C7FAFC469D4229539E909760308DA651DE@DU-EXC-MAIL.empa.emp-eaw.ch>
	<alpine.DEB.2.01.0908270232540.5744@bogon.housecafe.de>
	<B9A7B002C7FAFC469D4229539E909760308DA65237@DU-EXC-MAIL.empa.emp-eaw.ch>
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
To: "Passerone, Daniele" <Daniele.Passerone@empa.ch>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Thu, 27 Aug 2009 at 11:47, Passerone, Daniele wrote:
> Unfortunately xfs_ncheck was not killed, it went "D" state.
> The box has 16Gb.

"D" as in "waiting for I/O to complete". Were you able to confirm that, 
i.e. was there really noticable disk i/o happening during xfs_ncheck or 
was the process perhaps "stuck in D state"? I seem to remember that in 
those cases the output of sysrq-w could be interesting.

> Can I do something with my xfs_metadump [please be polite :-) ]

You've put the dump online, let's hope some XFS wizard finds time to have 
a look at this...I certainly can't read this :-\

Christian.
-- 
BOFH excuse #228:

That function is not currently supported, but Bill Gates assures us it will be featured in the next upgrade.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
