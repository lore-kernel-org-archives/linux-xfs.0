Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 23 Jan 2007 08:40:37 -0800 (PST)
Received: from evaldomino.Falconstor.com (mail1.falconstor.com [216.223.47.230])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l0NGePqw006501
	for <xfs@oss.sgi.com>; Tue, 23 Jan 2007 08:40:26 -0800
Message-ID: <45B63097.7020504@falconstor.com>
Date: Tue, 23 Jan 2007 10:58:15 -0500
From: "Geir A. Myrestrand" <geir.myrestrand@falconstor.com>
Reply-To: geir.myrestrand@falconstor.com
MIME-Version: 1.0
Subject: Re: how to sync / commit data to disk?
References: <d55656c10701230716x1ae7cf49kd8a854fd73429c4f@mail.gmail.com>
In-Reply-To: <d55656c10701230716x1ae7cf49kd8a854fd73429c4f@mail.gmail.com>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com
Cc: Peter Gervai <grinapo@gmail.com>

Peter Gervai wrote:
> Hello,
> 
> [Tried to search archieves, found nothing, probably my keywords are bad. 
> :-)]
> 
> What is the recommended way to make sure that a file is written
> physically to the disk? (apart from the cache of the disk.)
> 
> This problem seem to have arisen in grub bootloader under Debian linux
> (and most probably everywhere else): it must be sure that the copied
> files are there, and can be addressed by C/H/S and modified there, at
> the given sector address.
> 
> My educated guess would be
> xfs_freeze -f
> sync
> xfs_freeze -u
> 
> but I give a large chance to be wrong about it.
> 
> Ideas?
> 
> Please cc on me if possible. Thanks.

Call the sync before you freeze the file system, not after. You can't 
write to the file system when it is frozen, so it makes no sense to call 
sync after a freeze.

I don't think you have any control of whether the data is written 
physically to the disk or is still in the disk(s) buffer, the buffer you 
can flush is on the software side. Call sync and freeze.

-- 

Geir A. Myrestrand
