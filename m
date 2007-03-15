Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 15 Mar 2007 02:16:51 -0700 (PDT)
Received: from mail.edu.haifa.ac.il (mail.edu.haifa.ac.il [132.74.40.10])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l2F9Gi6p028910
	for <xfs@oss.sgi.com>; Thu, 15 Mar 2007 02:16:46 -0700
Received: from localhost (localhost [127.0.0.1])
	by mail.edu.haifa.ac.il (Postfix) with ESMTP id 61C0314BA0C
	for <xfs@oss.sgi.com>; Thu, 15 Mar 2007 11:22:20 +0200 (IST)
Received: from mail.edu.haifa.ac.il ([127.0.0.1])
	by localhost (mail.edu.haifa.ac.il [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id Pycjp+m-uYkd for <xfs@oss.sgi.com>;
	Thu, 15 Mar 2007 11:22:20 +0200 (IST)
Received: from kozanostra (leon.edu.haifa.ac.il [132.74.41.33])
	(using TLSv1 with cipher RC4-MD5 (128/128 bits))
	(No client certificate requested)
	by mail.edu.haifa.ac.il (Postfix) with ESMTP id 1B09B193FE
	for <xfs@oss.sgi.com>; Thu, 15 Mar 2007 11:22:20 +0200 (IST)
From: "Leon Kolchinsky" <leonk@construct.haifa.ac.il>
Subject: cache+barriers vs cache+nobarriers vs disabled cache+barriers vs disabled cache+nobarriers
Date: Thu, 15 Mar 2007 11:16:38 +0200
MIME-Version: 1.0
Content-Type: text/plain;
	charset="windows-1255"
Content-Transfer-Encoding: 7bit
Message-Id: <20070315092220.1B09B193FE@mail.edu.haifa.ac.il>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Hello All,


After reading http://oss.sgi.com/projects/xfs/faq.html#wcache 
and some posts on the list I've got the following question:

If I have disabled write cache on the disk (hdparm -W0 /dev/hda) and by
default FS is mounted with "barrier" enabled, Is there any taste in enabling
"barrier"(by default) because write cache is disabled anyway or may be it's
a good idea to mount with "nobarriers" in this case?

Or may be I'm wrong here and write cache has nothing to do with "barrier"
option?

I thought that "barrier" is on by default to somewhat minimize potential
dangers of enabled write cache? But if write cache is disabled, would
"barrier" option just slow down the FS performance (which is already slowed
down by "hdparm -W0 /dev/had" anyway)?

Any inside wisdom on the subject of this mail would be much appreciated :)



Best Regards,
Leon Kolchinsky
