Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 15 Mar 2007 08:27:56 -0700 (PDT)
Received: from donner.stsci.edu (donner.stsci.edu [130.167.251.65])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l2FFRo6p021727
	for <xfs@oss.sgi.com>; Thu, 15 Mar 2007 08:27:50 -0700
Message-ID: <45F965F3.10902@stsci.edu>
Date: Thu, 15 Mar 2007 11:27:47 -0400
From: Thomas Walker <walker@stsci.edu>
MIME-Version: 1.0
Subject: Re: Should xfs_repair take this long?
References: <45F92D8C.3090708@stsci.edu>	<20070315150422.7bc5d178@harpe.intellique.com>	<45F952F2.6000008@stsci.edu>	<20070315160309.652a6e0c@harpe.intellique.com>	<45F96150.50001@stsci.edu> <20070315162333.72f34d58@harpe.intellique.com>
In-Reply-To: <20070315162333.72f34d58@harpe.intellique.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Emmanuel Florac <eflorac@intellique.com>
Cc: xfs@oss.sgi.com


    I checked the status of the LVM before starting xfs_repair.  I can't 
promise it's all in order, but at least the various pvdisplay, 
vgdisplay, lvdisplay, etc all came back normal.  So... I'll just wait a 
few days and hope that xfs_repair comes back with something eventually.

    thanks for at least taking an interest, too bad that there's nothing 
we can really do about it.

    Thomas Walker

Emmanuel Florac wrote:

>Le Thu, 15 Mar 2007 11:08:00 -0400
>Thomas Walker <walker@stsci.edu> écrivait:
>
>  
>
>>    So if I see I/O activity and cpu activity, which I do, should I 
>>assume that eventually the repair should return? 
>>    
>>
>
>The repair _MAY_ return, unfortunately...
>
>  
>
>> We are thinking of 
>>interrupting it and trying to add more memory and restarting it.
>>Maybe we should just let it go. 
>>    
>>
>
>Yes, let it go now...
>
>  
>
>>If you think it might finish some
>>time, even if it's going to be another day or two, then I'm willing
>>to be patient. I'm just worried it might be going around in circles.
>>
>>    
>>
>
>It should finish if you're testing the right device, and the LV is
>properly assembled. If it reach the end of the device and find nothing,
>you should restart LVM first to check that your PV/VG/LV are correctly
>set up, and retry.
>If it doesn't work after that, backup will be your last friend.
>
>  
>
