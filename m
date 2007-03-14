Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 14 Mar 2007 13:33:03 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l2EKWv6p015177
	for <xfs@oss.sgi.com>; Wed, 14 Mar 2007 13:32:59 -0700
Message-ID: <45F85BFA.1070505@sandeen.net>
Date: Wed, 14 Mar 2007 15:32:58 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Strange XFS issue on tiny-NAS ARM NFS server
References: <EXNANE01iR9Odutox7n000000c6@exnane01.hq.netapp.com>
In-Reply-To: <EXNANE01iR9Odutox7n000000c6@exnane01.hq.netapp.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "Talpey, Thomas" <Thomas.Talpey@netapp.com>
Cc: xfs@oss.sgi.com

Talpey, Thomas wrote:
> This might be pilot error, but a *very* strange thing happens with
> an XFS filesystem on an NFS server I'm experimenting with. This is
> an NSLU2 ARM-based machine, running 2.6.20.1 and an XFS filesystem
> freshly built on a usb-attached 2.5" drive.
> 
> Running Connectathon 04 basic tests against the server, things are
> fine with an EXT-formatted filesystem. However, reformatting the
> export as a default XFS filesystem (mkfs.xfs -f /dev/sda3), the
> following occurs:

arm compiler has bugs that miscompile xfs... I think if you google arm + 
xfs and maybe search the list archives, you'll find a possible workaround.

-Eric
