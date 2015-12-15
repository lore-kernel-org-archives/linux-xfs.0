Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 946117F37
	for <xfs@oss.sgi.com>; Tue, 15 Dec 2015 07:16:16 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 75527304039
	for <xfs@oss.sgi.com>; Tue, 15 Dec 2015 05:16:13 -0800 (PST)
Received: from mail-wm0-f41.google.com (mail-wm0-f41.google.com
	[74.125.82.41]) by cuda.sgi.com with ESMTP id BfkYYJDDeMol6fSy
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 15 Dec 2015 05:16:11 -0800 (PST)
Received: by mail-wm0-f41.google.com with SMTP id n186so93951747wmn.0
	for <xfs@oss.sgi.com>; Tue, 15 Dec 2015 05:16:11 -0800 (PST)
Received: from sauron (agpz34.neoplus.adsl.tpnet.pl. [217.99.25.34])
	by smtp.gmail.com with ESMTPSA id c4sm1379131wjs.36.2015.12.15.05.16.09
	for <xfs@oss.sgi.com> (version=TLSv1/SSLv3 cipher=OTHER);
	Tue, 15 Dec 2015 05:16:09 -0800 (PST)
Date: Tue, 15 Dec 2015 14:16:05 +0100
From: =?UTF-8?B?TWljaGHFgg==?= Pecio <michal.pecio@gmail.com>
Subject: Fixing XFS RAID - does XFS ever issue non-aligned discards?
Message-ID: <20151215141605.5b60d336@sauron>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Hi,

I'm using XFS with bsize=4096 on RAID0 of two Intel 320 SSDs under
Linux 3.18 LTS. I'm wondering if it's correct to assume that discards
issued by XFS will always be multiples of 4k and 4k-aligned?

I'm asking because I need to fix damage caused by the infamous RAID0
bug from May 2015, which, if I'm reading the code correctly, basically
permuted discard requests between component disks, i.e. sda discarded
offsets which were supposed to be discarded by sdb and vice-versa.

The only backup I have is very slow so I'm trying to minimize copying.
The list of files with 4k-aligned blocks of zeros is small and worth
reviewing manually, but there is much more files with smaller holes
and I'd like to know if I should be bothered by them. Fwiw, I checked
few and they've all been false positives so far.

Thanks for any help,
MP

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
