Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 2513B29DF8
	for <xfs@OSS.SGI.com>; Sun, 30 Jun 2013 14:08:47 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id A4B9AAC004
	for <xfs@OSS.SGI.com>; Sun, 30 Jun 2013 12:08:43 -0700 (PDT)
Received: from anakin.london.02.net (anakin.london.02.net [87.194.255.134]) by
	cuda.sgi.com with ESMTP id SDw94jC1Kv0ws6lD for
	<xfs@OSS.SGI.com>; Sun, 30 Jun 2013 12:08:39 -0700 (PDT)
Received: from ty.sabi.co.UK (78.86.80.54) by anakin.london.02.net (8.5.140)
	id 50D100E1039DF2DE for xfs@OSS.SGI.com; Sun, 30 Jun 2013 20:08:38 +0100
Received: from from [127.0.0.1] (helo=tree.ty.sabi.co.uk)
	by ty.sabi.co.UK with esmtp(Exim 4.76 #1) id 1UtMzD-0007wA-94
	for <xfs@OSS.SGI.com>; Sun, 30 Jun 2013 20:08:35 +0100
MIME-Version: 1.0
Message-ID: <20944.33331.145353.851055@tree.ty.sabi.co.uk>
Date: Sun, 30 Jun 2013 20:08:35 +0100
Subject: Re: swidth in RAID
In-Reply-To: <557F888F-34EA-4669-B861-C0B684DAD13D@gmail.com>
References: <557F888F-34EA-4669-B861-C0B684DAD13D@gmail.com>
From: pg@xf2.for.sabi.co.UK (Peter Grandi)
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Linux fs XFS <xfs@OSS.SGI.com>

> I understand swidth should = #data disks.  And the docs say
> for RAID 6 of 8 disks, that means 6. [ ... ] 8 disks/spindles
> working for you and a bit of parity on each. So shouldn't
> swidth equal disks in raid when its concerning distributed
> parity raid?

The main goal is trying to the reduce the probability of
read-modify-write.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
