Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 24 Mar 2008 06:59:46 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m2ODxbxq010695
	for <xfs@oss.sgi.com>; Mon, 24 Mar 2008 06:59:38 -0700
Received: from slurp.thebarn.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4C9E5CE4F4B
	for <xfs@oss.sgi.com>; Mon, 24 Mar 2008 07:00:10 -0700 (PDT)
Received: from slurp.thebarn.com (cattelan-host202.dsl.visi.com [208.42.117.202]) by cuda.sgi.com with ESMTP id y9Pv9PXDtAqvupZf for <xfs@oss.sgi.com>; Mon, 24 Mar 2008 07:00:10 -0700 (PDT)
Message-ID: <47E7B3E4.1020205@thebarn.com>
Date: Mon, 24 Mar 2008 09:00:04 -0500
From: Russell Cattelan <cattelan@thebarn.com>
MIME-Version: 1.0
Subject: Re: Poor VMWare disk performance on XFS partition
References: <876423.51989.qm@web52006.mail.re2.yahoo.com> <Pine.LNX.4.64.0803240126501.4354@alienAngel.home.sk>
In-Reply-To: <Pine.LNX.4.64.0803240126501.4354@alienAngel.home.sk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Jan Derfinak <ja@mail.upjs.sk>
Cc: "Hendrik ." <chasake@yahoo.com>, xfs@oss.sgi.com

Jan Derfinak wrote:
> On Sun, 23 Mar 2008, Hendrik . wrote:
>
>   
>> I've been converting some of my drives from EXT3 to
>> XFS a while ago. Now I notice poor disk performance
>> when using XFS as underlying filesystem for a VMware
>> virtual drive. I did some experiments and it really
>> seems to be the XFS filesystem 'trashing' the speed of
>> a VMware Windows XP guest.
>>     
>
> Mount XFS partition with "nobarrier" option. I'm using also
> logbufs=8,logbsize=256k for vmware.
>
> jan
>
>   
I can verify that ... barriers are killers when running vmware guest 
disk/memory images.

The preallocation would also help out quite bit if you don't mind 
dedicating the
disk space vs the sparse file method, which allow for over subscribing 
the physical
space. Going through once in a while and shutting down the guests and 
defragmenting
it a good idea.

I would be interested to find out the results of seekwatcher on shutdown
but I have also seen the long shutdowns.

-Russell
