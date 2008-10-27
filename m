Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 27 Oct 2008 04:20:43 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9RBKV2k011495
	for <xfs@oss.sgi.com>; Mon, 27 Oct 2008 04:20:32 -0700
Received: from smtp.welcomes-you.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1D70BADDB61
	for <xfs@oss.sgi.com>; Mon, 27 Oct 2008 04:20:30 -0700 (PDT)
Received: from smtp.welcomes-you.com (welcomes-you.com [85.214.50.128]) by cuda.sgi.com with ESMTP id Jy4i0yFxe3XrPnqr for <xfs@oss.sgi.com>; Mon, 27 Oct 2008 04:20:30 -0700 (PDT)
Message-ID: <4905A3FB.6080709@aei.mpg.de>
Date: Mon, 27 Oct 2008 12:20:27 +0100
From: Carsten Aulbert <carsten.aulbert@aei.mpg.de>
MIME-Version: 1.0
Subject: Map a disk LBA to filename?
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Hi all,

I have not found it in the archive, thus my question to all:

Along the lines of this doc
http://smartmontools.sourceforge.net/BadBlockHowTo.txt

I would like to find out if that's also possible for XFS, i.e. I have a
disk which tells me, that there is a problem with LBA x and I identify
that this block is within the range of a largish XFS file system.

Now, I would like to identify the file which is possibly broken and
repair it if I can without taking the machine down for hours running the
manufacturers DOS tools. With simple ext[23] this is possible, but I'm
not getting anywhere with reading xfs_db and xfs_ncheck man pages to get
there.

Anyone here with a brief recipe I can get along with?

Cheers

Carsten

-- 
Dr. Carsten Aulbert - Max Planck Institute for Gravitational Physics
Callinstrasse 38, 30167 Hannover, Germany
Phone/Fax: +49 511 762-17185 / -17193
http://www.top500.org/system/9234 | http://www.top500.org/connfam/6/list/31
