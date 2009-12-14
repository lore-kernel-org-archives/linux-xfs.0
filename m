Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nBEHnHll164127
	for <linux-xfs@oss.sgi.com>; Mon, 14 Dec 2009 11:49:18 -0600
Received: from firestarter.dermichi.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9255F1974955
	for <linux-xfs@oss.sgi.com>; Mon, 14 Dec 2009 09:49:55 -0800 (PST)
Received: from firestarter.dermichi.com (firestarter.dermichi.com
	[78.41.115.230]) by cuda.sgi.com with ESMTP id dxn2Ik5sbZJ7q4BF
	for <linux-xfs@oss.sgi.com>; Mon, 14 Dec 2009 09:49:55 -0800 (PST)
Received: from [2001:15c0:6679:1:218:8bff:feb1:c9e8]
	by firestarter.dermichi.com with esmtpsa
	(TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32) (Exim 4.71)
	(envelope-from <mw@dermichi.com>) id 1NKF3Q-0004Tw-75
	for linux-xfs@oss.sgi.com; Mon, 14 Dec 2009 18:49:52 +0100
Message-ID: <4B267ABF.6090706@dermichi.com>
Date: Mon, 14 Dec 2009 18:49:51 +0100
From: Michael Weissenbacher <mw@dermichi.com>
MIME-Version: 1.0
Subject: Re: XFS and DPX files
References: <4AEC2CF4.8040703@aol.com>
	<200911021205.28006@zmi.at>	<200911022258.35164@zmi.at>
	<hg5oeo$bh2$1@osprey.mgras.de>
In-Reply-To: <hg5oeo$bh2$1@osprey.mgras.de>
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
To: linux-xfs@oss.sgi.com

Hi!
> 
> I've been under the impression that "modern disks" (TM), at minimum the
> server-type products, are supposed to re-use the remaining spin-energy
> for generating the required power and thus writing the content of their
> on-disk write cache to the disks.
> 
Nope, they don't. All disks do is use the remaining spin energy to
mechanically park the disk heads. Server-grade disks should always ship with
their drive write cache turned off per default.
The only thing possible imho would be a small ssd on disk for the cache, but
no disk manufacturer does this either.

cya,
  Michael

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
