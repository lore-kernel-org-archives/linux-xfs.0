Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q4OJQco6074776 for <xfs@oss.sgi.com>; Thu, 24 May 2012 14:26:38 -0500
Received: from seven.medozas.de (seven.medozas.de [188.40.89.202]) by
	cuda.sgi.com with ESMTP id 14A6zAxb3tndS2YD (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 24 May 2012 12:26:33 -0700 (PDT)
Date: Thu, 24 May 2012 21:26:31 +0200 (CEST)
From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: xfsprogs: .lai files not found
In-Reply-To: <4FBE60F6.6050709@sandeen.net>
Message-ID: <alpine.LNX.2.01.1205241902160.16757@frira.zrqbmnf.qr>
References: <alpine.LNX.2.01.1205241517400.10834@frira.zrqbmnf.qr>
	<4FBE60F6.6050709@sandeen.net>
MIME-Version: 1.0
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com


On Thursday 2012-05-24 18:25, Eric Sandeen wrote:
>> 
>> (I frown upon using libtool directly and seek to replace it with an
>> assisted version using automake. There is however __quite__ some
>> cruft in the src tree.)
>
>Agreed that the build system could use love, do we have a volunteer? :)

Certainly.
Perhaps confirm that the following oddballs indeed
mark code that can be replaced:

- __psint_t/__psunsigned_t looks very much like a pre-C-standard attempt at
  intptr_t/uintptr_t [and should be changed accordingly]

- many files in include/ should actually be in include/xfs/
  (which does not exist at clone time)

- 'struct stat64' smells really like an implementation detail
  of how -D_FILE_OFFSET_BITS=64 (or the absence thereof) is handled.
  If the -D is given, isn't "struct stat" enough for all supported OSes?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
