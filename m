Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 18 Jan 2008 07:58:58 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m0IFwqaK023963
	for <xfs@oss.sgi.com>; Fri, 18 Jan 2008 07:58:54 -0800
Received: from lucidpixels.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B44C1C85BA9
	for <xfs@oss.sgi.com>; Fri, 18 Jan 2008 07:59:11 -0800 (PST)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66]) by cuda.sgi.com with ESMTP id shQ94LuUH2OkjxBO for <xfs@oss.sgi.com>; Fri, 18 Jan 2008 07:59:11 -0800 (PST)
Date: Fri, 18 Jan 2008 10:58:40 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Linux Software RAID 5 + XFS Multi-Benchmarks / 10 Raptors
 Again
In-Reply-To: <29a863790801180743y2e90e37aj70c556dc9192a15d@mail.gmail.com>
Message-ID: <alpine.DEB.0.999999.0801181057260.23565@p34.internal.lan>
References: <alpine.DEB.0.999999.0801161105510.16168@p34.internal.lan>  <29a863790801180735n379a27f1t4987686b2ec1aa50@mail.gmail.com>  <alpine.DEB.0.999999.0801181036260.23565@p34.internal.lan> <29a863790801180743y2e90e37aj70c556dc9192a15d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Greg Cormier <gcormier@gmail.com>
Cc: linux-raid@vger.kernel.org, xfs@oss.sgi.com, Alan Piszcz <ap@solarrain.com>



On Fri, 18 Jan 2008, Greg Cormier wrote:

>> Also, don't use ext*, XFS can be up to 2-3x faster (in many of the
>> benchmarks).
>
> I'm going to swap file systems and give it a shot right now! :)
>
> How is stability of XFS? I heard recovery is easier with ext2/3 due to
> more people using it, more tools available, etc?
>
> Greg
>

Recovery is actually easier with XFS because the repair filesystem code is 
built-into the kernel (you dont need a utility to fix it)-- however, there 
is xfs_repair (if) the in-kernel-tree part could not fix it.

I have been using it for > 4-5 years? now.

Also, with CoRaids (ATA over Ethernet) many of them are above 8TB and ext3 
only works up to 8TB, so its not even an option any longer.

Justin.
