Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oAIAmtvb141614 for <xfs@oss.sgi.com>; Thu, 18 Nov 2010 04:48:56 -0600
Received: from firestarter.dermichi.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8B9E813D1E49
	for <xfs@oss.sgi.com>; Thu, 18 Nov 2010 02:50:28 -0800 (PST)
Received: from firestarter.dermichi.com (firestarter.dermichi.com
	[78.41.115.230]) by cuda.sgi.com with ESMTP id Ffe6iQ08O455ssTh
	for <xfs@oss.sgi.com>; Thu, 18 Nov 2010 02:50:28 -0800 (PST)
Received: from cl-840.mbx-01.si.sixxs.net ([2001:15c0:65ff:347::2])
	by firestarter.dermichi.com with esmtpsa
	(TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32) (Exim 4.72)
	(envelope-from <mw@dermichi.com>) id 1PJ24Q-0002bx-G2
	for xfs@oss.sgi.com; Thu, 18 Nov 2010 11:50:26 +0100
Message-ID: <4CE504F1.3010305@dermichi.com>
Date: Thu, 18 Nov 2010 11:50:25 +0100
From: Michael Weissenbacher <mw@dermichi.com>
MIME-Version: 1.0
Subject: Re: vmap allocation for size 1048576 failed
References: <4CD924A6.6040200@dermichi.com>
	<20101109120701.GN2715@dastard>	<4CDA54E3.308@dermichi.com>
	<20101110123052.GW2715@dastard>
In-Reply-To: <20101110123052.GW2715@dastard>
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

Hi Dave!
> 
> Ok, thanks for the info. I'm struggling to work out what is actually
> consuming vmap space given what you are doing and the storage
> config. None of the operations you are doing should be triggering
> mapping of multipage metadata buffers given the filesystem
> configuration....
> 
I've set vmalloc=768M and haven't seen the problem since. Maybe the
vmalloc/vmap problem has to do with the fact that i'm running
iscsi_target on the same machine? As long as the problem doesn't occur
again i'm ok with setting the vmalloc parameter.

Thanks for your help,
Michael

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
