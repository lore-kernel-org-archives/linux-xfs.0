Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6KEAVl8024108 for <xfs@oss.sgi.com>; Tue, 20 Jul 2010 09:10:32 -0500
Received: from firestarter.dermichi.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C12A61E2DCBD
	for <xfs@oss.sgi.com>; Tue, 20 Jul 2010 07:13:31 -0700 (PDT)
Received: from firestarter.dermichi.com (firestarter.dermichi.com
	[78.41.115.230]) by cuda.sgi.com with ESMTP id RD5ZPlXmCMSHBOMA
	for <xfs@oss.sgi.com>; Tue, 20 Jul 2010 07:13:31 -0700 (PDT)
Received: from cl-840.mbx-01.si.sixxs.net ([2001:15c0:65ff:347::2])
	by firestarter.dermichi.com with esmtpsa
	(TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32) (Exim 4.72)
	(envelope-from <mw@dermichi.com>) id 1ObDZa-0005GV-I1
	for xfs@oss.sgi.com; Tue, 20 Jul 2010 16:13:30 +0200
Message-ID: <4C45AF09.5090901@dermichi.com>
Date: Tue, 20 Jul 2010 16:13:29 +0200
From: Michael Weissenbacher <mw@dermichi.com>
MIME-Version: 1.0
Subject: Re: Calculating swidth On A RAID6 Volume
References: <3C5E029826A0704DB5998577FCFF46F0094DA1AD69@dagobah>
	<201007201522.39455@zmi.at>
In-Reply-To: <201007201522.39455@zmi.at>
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

Michael,
>> If that is the case, then here is what I would expect my values to
>>  be: sunit = 512
>> swidth = 4608
>  
> I think sunit should be as big as the RAID controllers stripe size, as 
> it describes the smallest I/O XFS should do. So sunit=512 would make it 
> possible that XFS writes a single sector, while the RAID controller 
> needs to read/write 256KB with your stripe size, resulting in 
> performance degradation. But I'm no XFS dev, so maybe wait for a 
> clearing from someone who has deeper XFS knowledge than me.
> 
> sunit=262144
> swidth=9
> 
> Would be my suggestion for your setup.
> 
IIRC sunit and swidth are both specified in units of 512 bytes (don't
ask me why) so a sunit value of 512 would mean 256KB stripe size which
is correct :-)

If i am right, the FAQ should be corrected (hopefully some dev can
confirm/deny it)

cheers,
Michael

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
