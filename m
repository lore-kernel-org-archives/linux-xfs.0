Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 06 Jul 2008 03:43:29 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m66AhR8E013778
	for <xfs@oss.sgi.com>; Sun, 6 Jul 2008 03:43:27 -0700
Received: from smtp-out002.kontent.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 39CD51882073
	for <xfs@oss.sgi.com>; Sun,  6 Jul 2008 03:44:31 -0700 (PDT)
Received: from smtp-out002.kontent.com (smtp-out002.kontent.com [81.88.40.216]) by cuda.sgi.com with ESMTP id SBVX9VOjGAw0wrj1 for <xfs@oss.sgi.com>; Sun, 06 Jul 2008 03:44:31 -0700 (PDT)
Message-ID: <4870A20C.7080802@theendofthetunnel.de>
Date: Sun, 06 Jul 2008 12:44:28 +0200
From: Hannes Dorbath <light@theendofthetunnel.de>
MIME-Version: 1.0
Subject: Re: Lots of con-current I/O = resets SATA link? (2.6.25.10)
References: <fa.u8J+BqAcxU1mg8ob9pMBJaAHBPo@ifi.uio.no> <486FBFAB.5050303@shaw.ca> <alpine.DEB.1.10.0807051527210.8002@p34.internal.lan> <48700228.7060904@shaw.ca> <alpine.DEB.1.10.0807051923380.23222@p34.internal.lan> <alpine.DEB.1.10.0807060447180.5005@p34.internal.lan>
In-Reply-To: <alpine.DEB.1.10.0807060447180.5005@p34.internal.lan>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Alan Piszcz <ap@solarrain.com>
Cc: xfs@oss.sgi.com

Justin Piszcz wrote:
> In short, utilizing Raptors (especially veliciraptors)+NCQ on the ICH8 
> w/AHCI & other cards in a RAID 5 configuration is a death trap (a good 
> way to lose your data), it appears unsafe to use NCQ w/raptors in a RAID 5
> configuration.  I've defaulted back to disabling it like I always do
> and my RAID5 is rebuilding now.

To my knowledge NCQ and Raptors is completely broken. Besides that, I 
have really bad experiences with the reliability of those drives.


-- 
Best regards,
Hannes Dorbath
