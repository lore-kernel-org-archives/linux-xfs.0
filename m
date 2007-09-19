Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 19 Sep 2007 15:47:58 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [66.187.233.31])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l8JMlZuw029928
	for <xfs@oss.sgi.com>; Wed, 19 Sep 2007 15:47:53 -0700
Message-ID: <46F1A703.6040309@sandeen.net>
Date: Wed, 19 Sep 2007 17:47:31 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Cant find sunit and swidth on luks encrypted raid6 device
References: <728b8e3b0709191129j27b7c319h2efd51ffc9cb64f3@mail.gmail.com>    <46F17BBE.7060304@sandeen.net> <46F1A3D7.5090805@sandeen.net> <33249.192.168.3.1.1190241583.squirrel@mail.aconex.com>
In-Reply-To: <33249.192.168.3.1.1190241583.squirrel@mail.aconex.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: nscott@aconex.com
Cc: "Jochen K." <jochen.f.k@googlemail.com>, xfs@oss.sgi.com

nscott@aconex.com wrote:
>> Eric Sandeen wrote:
>>
>> 2b2d4c133680: Badness in key lookup (length)
>> bp=(bno 13673620728, len 131072 bytes) key=(bno 13673620728, len 4096
>> bytes)
>>
>> If we take out the pwrite that does the end-of-device zeroing, we don't
>> get the error... but that's been there since forever, so again, I'm a
>> bit confused here.
> 
> libxfs has been changing alot - most likely the problem lies in the buffer
> caching
> code there - Barry will probably recognise the error (when he gets online).

--- xfs-cmds/xfsprogs/libxfs/rdwr.c	2007/02/21 14:37:52	1.34
+++ xfs-cmds/xfsprogs/libxfs/rdwr.c	2007/07/16 15:55:26	1.35
@@ -24,6 +24,8 @@
 #define BDSTRAT_SIZE	(256 * 1024)
 #define min(x, y)	((x) < (y) ? (x) : (y))

+#define IO_BCOMPARE_CHECK
+

Yep.... :)

-Eric

> cheers.
> 
> --
> Nathan
> 
> 
