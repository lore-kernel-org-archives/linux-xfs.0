Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 19 Sep 2007 15:39:31 -0700 (PDT)
Received: from postoffice.aconex.com (mail.app.aconex.com [203.89.192.138])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l8JMdLuw028435
	for <xfs@oss.sgi.com>; Wed, 19 Sep 2007 15:39:26 -0700
Message-ID: <33249.192.168.3.1.1190241583.squirrel@mail.aconex.com>
In-Reply-To: <46F1A3D7.5090805@sandeen.net>
References: <728b8e3b0709191129j27b7c319h2efd51ffc9cb64f3@mail.gmail.com>
    <46F17BBE.7060304@sandeen.net> <46F1A3D7.5090805@sandeen.net>
Date: Thu, 20 Sep 2007 08:39:43 +1000 (EST)
Subject: Re: Cant find sunit and swidth on luks encrypted raid6 device
From: nscott@aconex.com
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: "Jochen K." <jochen.f.k@googlemail.com>, xfs@oss.sgi.com

> Eric Sandeen wrote:
>
> 2b2d4c133680: Badness in key lookup (length)
> bp=(bno 13673620728, len 131072 bytes) key=(bno 13673620728, len 4096
> bytes)
>
> If we take out the pwrite that does the end-of-device zeroing, we don't
> get the error... but that's been there since forever, so again, I'm a
> bit confused here.

libxfs has been changing alot - most likely the problem lies in the buffer
caching
code there - Barry will probably recognise the error (when he gets online).

cheers.

--
Nathan
