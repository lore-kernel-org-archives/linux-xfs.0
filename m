Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 11 Sep 2007 22:17:32 -0700 (PDT)
Received: from amanpulo.fs3.ph (amanpulo.fs3.ph [72.51.42.241])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l8C5HJ4p032031
	for <linux-xfs@oss.sgi.com>; Tue, 11 Sep 2007 22:17:21 -0700
Received: from localhost (localhost [127.0.0.1])
	by amanpulo.fs3.ph (Postfix) with ESMTP id 826321E0D5976
	for <linux-xfs@oss.sgi.com>; Wed, 12 Sep 2007 13:17:20 +0800 (PHT)
Message-ID: <20070912131711.t31p9zm3y8ssoks0@mail.fs3.ph>
Date: Wed, 12 Sep 2007 13:17:11 +0800
From: Federico Sevilla III <jijo@fs3.ph>
Subject: Re: Attempt to Access Beyond End of Device
References: <1189432747.4385.27.camel@auctoritas.fs3.ph>
	<46E5670E.9000703@sandeen.net>
	<1189439689.18040.17.camel@auctoritas.fs3.ph>
	<46E570C4.6080303@sandeen.net>
	<cc7060690709111208u3e0842f9rd6edff16539b8a28@mail.gmail.com>
In-Reply-To: <cc7060690709111208u3e0842f9rd6edff16539b8a28@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset=ISO-8859-1;
	DelSp="Yes";
	format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com
Cc: Alec Joseph Rivera <agi@fs3.ph>

Hi,

Quoting Bhagi rathi <jahnu77@gmail.com>:
>  I hope your problem with xfs_repair is resolved.

It wasn't an XFS-centric problem, after all. Running cfdisk on the  
system would likewise fail because the partition had been set beyond  
the disk boundary. I'm not sure about how this happened. Either the  
controller reported a large size to Debian during installation, or  
Debian mis-read the reported size on installation. At any rate,  
redoing the entire installation (including RAID setup) with the same  
procedure resulted in the correct (ie: smaller) disk boundaries, so  
the server is back up with the new size.

> Please set your incore log buffer size as a sub-multiple of your log size,
> log size % in core buffer size should be zero (modulo is the operator). This
> is advisable, though not mandatory. Having huge incore buffer size is of no
> help if your on disk log size isn't big. This might solve your problem with
> repair and recovery after some reboots. Make sure that total incore buffer
> size is less than on disk logsize.

Previously, we were using version=1 logs with size=32768b, and then  
mounted using logbufs=8,logbsize=32768.

Now, we are using version=2 logs with size=32768b, and then mounted  
using logbufs=8,logbsize=256k.

If I understand your advise correctly, I should not mount with  
logbsize > 32k, or I should create the filesystem using version=2 logs  
with size=256k. Is this understanding correct?

Are there generic optimization suggestions for I/O-intensive servers  
in general, as far as on-disk and in-memory log buffer sizes are  
concerned?

Please advise.

Thank you very much.

-- 
Federico Sevilla III
F S 3 Consulting Inc.
http://www.fs3.ph
