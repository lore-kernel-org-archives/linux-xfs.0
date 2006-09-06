Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 06 Sep 2006 07:23:40 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [66.187.233.31])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k86ENSDW015430
	for <xfs@oss.sgi.com>; Wed, 6 Sep 2006 07:23:30 -0700
Message-ID: <44FED9B3.5080308@sandeen.net>
Date: Wed, 06 Sep 2006 09:22:43 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Bad block on partition, how to deal with it?
References: <60fdb1ad0609060459k6132f8b8s40e4f20f51a746ed@mail.gmail.com>
In-Reply-To: <60fdb1ad0609060459k6132f8b8s40e4f20f51a746ed@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Vijay Gill <vijay.s.gill@gmail.com>
Cc: xfs@oss.sgi.com

Vijay Gill wrote:
> Hi,
> 
> Got this bad sector in a seagate 40G hard disk. 

You should buy a new disk for $20 or so :)

> Is there any tool
> under linux to scan the surface of the disk and mark the sectors bad
> in file system (or at even lower level like seatools does)?

xfs has no badblocks support.  If you can convince the drive to remap 
the block with vendor tools then maybe it's ok.  But modern drives remap 
on their own; if you have a block that can't be remapped then your drive 
is probably not long for this world.  Don't try to keep using it.

> Running Linux Fedora Core 5.
> 
> In the mean while I am doing a dd on that partition to copy the data
> and try to recover it from there.
> 
> Also I have run badblocks to get the number of the block which is bad,
> but how do I get it marked now so that the OS does not try to allocate
> it for data in future.

With xfs, you don't.  It's not worth it IMHO, just get a new disk.

-Eric
