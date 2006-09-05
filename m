Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 05 Sep 2006 16:41:25 -0700 (PDT)
Received: from wx-out-0506.google.com (wx-out-0506.google.com [66.249.82.236])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k85NfFDW004087
	for <xfs@oss.sgi.com>; Tue, 5 Sep 2006 16:41:15 -0700
Received: by wx-out-0506.google.com with SMTP id h29so2351472wxd
        for <xfs@oss.sgi.com>; Tue, 05 Sep 2006 16:40:41 -0700 (PDT)
Message-ID: <2260b150609051640y288629cbtcbc133d05b2b40dd@mail.gmail.com>
Date: Wed, 6 Sep 2006 09:40:41 +1000
From: "Chris Seufert" <seufert@gmail.com>
Subject: XFS Journal on md device
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Hey,

I currently have a 2.1Tb xfs partition, sitting on a hardware SATA raid card.

However i also have 2 hdd's (for OS etc) in software raid1, with a md
device for the xfs log file. Its a 100mb RAID1 (under /dev/md4), now
when i halt/reboot the box, even after the xfs partition is unmounted
(as part of the shutdown sequence as normal on debian etch) the
/dev/md4 device cant be cleanly stopped.

Is having the log on a redundant partition a good idea or is it better
to leave it as an internal log or is there another way round this
problem.

-Chris
