Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6KCbb6V020347 for <xfs@oss.sgi.com>; Tue, 20 Jul 2010 07:37:37 -0500
Received: from firestarter.dermichi.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6532915C3F79
	for <xfs@oss.sgi.com>; Tue, 20 Jul 2010 05:47:19 -0700 (PDT)
Received: from firestarter.dermichi.com (firestarter.dermichi.com
	[78.41.115.230]) by cuda.sgi.com with ESMTP id KZMEfjZtzEyth7b3
	for <xfs@oss.sgi.com>; Tue, 20 Jul 2010 05:47:19 -0700 (PDT)
Received: from cl-840.mbx-01.si.sixxs.net ([2001:15c0:65ff:347::2])
	by firestarter.dermichi.com with esmtpsa
	(TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32) (Exim 4.72)
	(envelope-from <mw@dermichi.com>) id 1ObC7e-0001dp-BO
	for xfs@oss.sgi.com; Tue, 20 Jul 2010 14:40:34 +0200
Message-ID: <4C459941.70206@dermichi.com>
Date: Tue, 20 Jul 2010 14:40:33 +0200
From: Michael Weissenbacher <mw@dermichi.com>
MIME-Version: 1.0
Subject: Re: Calculating swidth On A RAID6 Volume
References: <3C5E029826A0704DB5998577FCFF46F0094DA1AD69@dagobah>
In-Reply-To: <3C5E029826A0704DB5998577FCFF46F0094DA1AD69@dagobah>
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

> finally the question - would the swidth for a RAID6 volume be "sunit x
> (# disks in stripe -2)?
Yep, correct

> If that is the case, then here is what I would expect my values to be:
> sunit = 512
> swidth = 4608
>  
> Would that be correct?  Thanks in advance for your help in this matter!
Correct too, AFAICT

hth,
Michael

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
