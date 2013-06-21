Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id E25947F37
	for <xfs@oss.sgi.com>; Fri, 21 Jun 2013 13:39:12 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id DBEEE8F804C
	for <xfs@oss.sgi.com>; Fri, 21 Jun 2013 11:39:12 -0700 (PDT)
Received: from mail-qc0-f177.google.com (mail-qc0-f177.google.com
	[209.85.216.177]) by cuda.sgi.com with ESMTP id
	OBeYrOzNBE5sg8ke (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Fri, 21 Jun 2013 11:39:12 -0700 (PDT)
Received: by mail-qc0-f177.google.com with SMTP id n1so4880306qcx.36
	for <xfs@oss.sgi.com>; Fri, 21 Jun 2013 11:39:11 -0700 (PDT)
Received: from [192.168.0.129] (rrcs-97-78-60-146.se.biz.rr.com.
	[97.78.60.146])
	by mx.google.com with ESMTPSA id ds7sm7961758qab.13.2013.06.21.11.39.10
	for <xfs@oss.sgi.com>
	(version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
	Fri, 21 Jun 2013 11:39:11 -0700 (PDT)
Message-ID: <51C49DCD.50507@gmail.com>
Date: Fri, 21 Jun 2013 14:39:09 -0400
From: "Michael L. Semon" <mlsemon35@gmail.com>
MIME-Version: 1.0
Subject: Test/review request for older Jeff Liu MAX_LFS_FILESIZE patch
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

Hi!  I've been using a helpful patch on 32-bit x86 and I'm fairly 
sure it's this one:

xfs: fix s_max_bytes to MAX_LFS_FILESIZE if needed

http://oss.sgi.com/archives/xfs/2013-04/msg00273.html

What is its status?  The patch gets 32-bit x86 past generic/308 
and hasn't caused additional problems in extended testing and 
normal use.  I have not tested it on other platforms.

Maybe the patch is already in the kernel, but it applied without 
issue against Dave's latest work, so I'm guessing it's not in 
there.

Might somebody give this patch a try on other platforms, to see 
that it's okay there, too?

Thanks!

Michael

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
