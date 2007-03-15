Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 15 Mar 2007 08:23:45 -0700 (PDT)
Received: from smtp-ft5.fr.colt.net (smtp-ft5.fr.colt.net [213.41.78.197])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l2FFNb6p020428
	for <xfs@oss.sgi.com>; Thu, 15 Mar 2007 08:23:38 -0700
Date: Thu, 15 Mar 2007 16:23:33 +0100
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: Should xfs_repair take this long?
Message-ID: <20070315162333.72f34d58@harpe.intellique.com>
In-Reply-To: <45F96150.50001@stsci.edu>
References: <45F92D8C.3090708@stsci.edu>
	<20070315150422.7bc5d178@harpe.intellique.com>
	<45F952F2.6000008@stsci.edu>
	<20070315160309.652a6e0c@harpe.intellique.com>
	<45F96150.50001@stsci.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Thomas Walker <walker@stsci.edu>, xfs@oss.sgi.com

Le Thu, 15 Mar 2007 11:08:00 -0400
Thomas Walker <walker@stsci.edu> écrivait:

>     So if I see I/O activity and cpu activity, which I do, should I 
> assume that eventually the repair should return? 

The repair _MAY_ return, unfortunately...

>  We are thinking of 
> interrupting it and trying to add more memory and restarting it.
> Maybe we should just let it go. 

Yes, let it go now...

> If you think it might finish some
> time, even if it's going to be another day or two, then I'm willing
> to be patient. I'm just worried it might be going around in circles.
> 

It should finish if you're testing the right device, and the LV is
properly assembled. If it reach the end of the device and find nothing,
you should restart LVM first to check that your PV/VG/LV are correctly
set up, and retry.
If it doesn't work after that, backup will be your last friend.

-- 
----------------------------------------
Emmanuel Florac     |   Intellique
----------------------------------------
