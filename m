Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p41IADvx187092 for <xfs@OSS.SGI.com>; Sun, 1 May 2011 13:10:14 -0500
Received: from hermes2.dur.ac.uk (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 49A4A15D1362
	for <xfs@OSS.SGI.com>; Sun,  1 May 2011 11:13:48 -0700 (PDT)
Received: from hermes2.dur.ac.uk (hermes2.dur.ac.uk [129.234.248.2]) by
	cuda.sgi.com with ESMTP id k0aAv51Bi6Po3Shf for
	<xfs@OSS.SGI.com>; Sun, 01 May 2011 11:13:48 -0700 (PDT)
Received: from smtphost2.dur.ac.uk (smtphost2.dur.ac.uk [129.234.252.2])
	by hermes2.dur.ac.uk (8.13.8/8.13.7) with ESMTP id p41IDVeJ022836
	for <xfs@OSS.SGI.com>; Sun, 1 May 2011 19:13:35 +0100
Received: from ty.sabi.co.UK (o1.phyip3.dur.ac.uk [129.234.186.1])
	by smtphost2.dur.ac.uk (8.13.8/8.13.7) with ESMTP id p41IDG2h025047
	(version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=NO)
	for <xfs@OSS.SGI.com>; Sun, 1 May 2011 19:13:16 +0100
Received: from from [127.0.0.1] (helo=tree.ty.sabi.co.UK)
	by ty.sabi.co.UK with esmtp(Exim 4.71 #1) id 1QGa4h-00051b-49
	for <xfs@OSS.SGI.com>; Sun, 01 May 2011 18:04:51 +0100
MIME-Version: 1.0
Message-ID: <19901.37553.911967.287089@tree.ty.sabi.co.UK>
Date: Sun, 1 May 2011 18:04:49 +0100
Subject: Re: xfs performance problem
In-Reply-To: <201105011732.56226@zmi.at>
References: <4DB72084.8020205@inf.ethz.ch> <20110501084919.GE13542@dastard>
	<19901.28769.553575.864887@tree.ty.sabi.co.UK>
	<201105011732.56226@zmi.at>
From: pg_xf2@xf2.for.sabi.co.UK (Peter Grandi)
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
To: Linux fs XFS <xfs@oss.sgi.com>

[ ... ]

> [ ... ] With ext3, the user can start "make menuconfig" much
> earlier than with xfs. In this specific case, the user is
> not interested if it's  safer, or already on disk, or
  =============================
> running in the background. [ ... ]

Usually I prefer to assume that the user is merely not aware of
the tradeoff between different levels of safety and time, and
thus they need to be discussed and expectations driven to
realistic levels, even if admittedly often it is time wasted,
also because so many people seduce users by selling 'O_PONIES'.

Thus sometimes I don't like to assume that the user is a "couldn't
care less" type of moron, as that seems condescending to me:

> The user want's to do his work, period.

I have heard something like that several times from salesmen...

Or perhaps this recent Dilbert strip is appropriate:

  http://www.dilbert.com/strips/comic/2011-04-29/

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
