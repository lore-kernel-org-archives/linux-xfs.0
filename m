Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 11E9F29DF8
	for <xfs@oss.sgi.com>; Sun, 30 Jun 2013 13:43:22 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E74CF8F8033
	for <xfs@oss.sgi.com>; Sun, 30 Jun 2013 11:43:18 -0700 (PDT)
Received: from mail-gh0-f178.google.com (mail-gh0-f178.google.com
	[209.85.160.178]) by cuda.sgi.com with ESMTP id
	Okge02oZ97Cns7Bx (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Sun, 30 Jun 2013 11:43:18 -0700 (PDT)
Received: by mail-gh0-f178.google.com with SMTP id g15so1714419ghb.37
	for <xfs@oss.sgi.com>; Sun, 30 Jun 2013 11:43:17 -0700 (PDT)
Received: from [192.168.1.74] (75-63-29-182.lightspeed.irvnca.sbcglobal.net.
	[75.63.29.182])
	by mx.google.com with ESMTPSA id d68sm27683764yhk.7.2013.06.30.11.43.14
	for <xfs@oss.sgi.com>
	(version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
	Sun, 30 Jun 2013 11:43:15 -0700 (PDT)
From: aurfalien <aurfalien@gmail.com>
Subject: swidth in RAID
Date: Sun, 30 Jun 2013 11:43:12 -0700
Message-Id: <557F888F-34EA-4669-B861-C0B684DAD13D@gmail.com>
Mime-Version: 1.0 (Apple Message framework v1085)
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
To: xfs@oss.sgi.com

Hi,

I understand swidth should = #data disks.

And the docs say for RAID 6 of 8 disks, that means 6.

But parity is distributed and you actually have 8 disks/spindles working for you and a bit of parity on each.

So shouldn't swidth equal disks in raid when its concerning distributed parity raid?

- aurf
_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
