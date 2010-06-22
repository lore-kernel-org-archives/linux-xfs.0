Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o5MFRLLL243421 for <xfs@oss.sgi.com>; Tue, 22 Jun 2010 10:27:22 -0500
Received: from firestarter.dermichi.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3E02C15A07E8
	for <xfs@oss.sgi.com>; Tue, 22 Jun 2010 08:34:13 -0700 (PDT)
Received: from firestarter.dermichi.com (firestarter.dermichi.com
	[78.41.115.230]) by cuda.sgi.com with ESMTP id mlzrTbMwSzdVBlsW
	for <xfs@oss.sgi.com>; Tue, 22 Jun 2010 08:34:13 -0700 (PDT)
Received: from cl-840.mbx-01.si.sixxs.net ([2001:15c0:65ff:347::2])
	by firestarter.dermichi.com with esmtpsa
	(TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32) (Exim 4.72)
	(envelope-from <mw@dermichi.com>) id 1OR5QF-0002O1-N4
	for xfs@oss.sgi.com; Tue, 22 Jun 2010 17:29:59 +0200
Message-ID: <4C20D6F6.5020208@dermichi.com>
Date: Tue, 22 Jun 2010 17:29:58 +0200
From: Michael Weissenbacher <mw@dermichi.com>
MIME-Version: 1.0
Subject: Re: advice for repair after IO error on raid device
References: <cone.1277217402.916517.87295.1001@bork.lsof.org>
	<cone.1277218412.674723.87295.1001@bork.lsof.org>
In-Reply-To: <cone.1277218412.674723.87295.1001@bork.lsof.org>
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

Hi Roel!
> Trying to answer my own question. I _think_ this is the way to go:
> 
> 1) Mount and unmount the fs, in order to replay the log.
> 2) Run xfs_repair -n
> 3) Run xfs_repair
> 
> If someone could confirm (or reject) that, that would be great.

This is a sound plan, i always do a "xfs_repair -n" first. If you're
lucky it will find no problems and you can skip step 3).
If "xfs_repair -n" does find problems you can ask for more advice here.

good luck,
Michael

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
