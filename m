Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 09 Mar 2008 17:45:02 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m2A0ihbF016842
	for <xfs@oss.sgi.com>; Sun, 9 Mar 2008 17:44:44 -0700
Received: from wf-out-1314.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D8B4B1201540
	for <xfs@oss.sgi.com>; Sun,  9 Mar 2008 17:45:06 -0700 (PDT)
Received: from wf-out-1314.google.com (wf-out-1314.google.com [209.85.200.171]) by cuda.sgi.com with ESMTP id NZvM7x6AZN6m91nc for <xfs@oss.sgi.com>; Sun, 09 Mar 2008 17:45:06 -0700 (PDT)
Received: by wf-out-1314.google.com with SMTP id 29so1628576wff.32
        for <xfs@oss.sgi.com>; Sun, 09 Mar 2008 17:45:06 -0700 (PDT)
Message-ID: <2db2c6b80803091738o20dc80b2p82c5bf7246a8c560@mail.gmail.com>
Date: Mon, 10 Mar 2008 01:38:50 +0100
From: Rekrutacja119 <rekrutacja119@gmail.com>
Subject: Re: xfs for free hosting on linux ? performance questions
In-Reply-To: <18388.31367.314074.624135@tree.ty.sabi.co.uk>
MIME-Version: 1.0
References: <47D45926.5070806@gmail.com>
	 <18388.31367.314074.624135@tree.ty.sabi.co.uk>
Content-Type: text/plain
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

>
> There are several reasons why ReiserFS is better suited for
> large directory tree with lots of small files; one of them is
> that it was designed for that :-).



but reiserfs is slow for me too, maybe i have some other problems? i made
array like this mdadm --create /dev/md0 --verbose --level=5 --raid-devices=5
/dev/sd{b,c,d,e,f}1 --assume-clean

then just mkfs.reiserfs /dev/md0 and then mount /dev/md0 to /array and run
postmark with these:
set numbers 20000
set transactions 10000
set subdirectories 20000
set location /array/

results i got:

Time:
    287 seconds total
    118 seconds of transactions (84 per second)

Files:
    25014 created (87 per second)
        Creation alone: 20000 files (168 per second)
        Mixed with transactions: 5014 files (42 per second)
    5026 read (42 per second)
    4971 appended (42 per second)
    25014 deleted (87 per second)
        Deletion alone: 20028 files (400 per second)
        Mixed with transactions: 4986 files (42 per second)

Data:
    26.48 megabytes read (94.47 kilobytes per second)
    136.18 megabytes written (485.89 kilobytes per second)


is there something wrong with my system?? LA is 0.50 right now (i'm testing
it at night), hdparm is showing that every HD from the array is doing
100MB/s at least, so why these numbers?


[[HTML alternate version deleted]]
