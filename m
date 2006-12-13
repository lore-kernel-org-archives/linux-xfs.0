Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 13 Dec 2006 07:07:33 -0800 (PST)
Received: from py-out-1112.google.com (py-out-1112.google.com [64.233.166.178])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id kBDF7Qqw017753
	for <xfs@oss.sgi.com>; Wed, 13 Dec 2006 07:07:27 -0800
Received: by py-out-1112.google.com with SMTP id p76so112532pyb
        for <xfs@oss.sgi.com>; Wed, 13 Dec 2006 07:06:35 -0800 (PST)
Message-ID: <5d96567b0612130640s5bae22c8kdc6acad72661932b@mail.gmail.com>
Date: Wed, 13 Dec 2006 16:40:03 +0200
From: "Raz Ben-Jehuda(caro)" <raziebe@gmail.com>
Subject: xfs over linux raid5 perffered blocksize
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Hello

I need to create a writer which creates files over linux software raid5.
the files must be aligned by the stripe unit and so as the extents.

If an extent SIZE is not a factor of the stripe unit it is as if i have
done nothing.

I have learned by reading the documentatiom that the preffered io size
is the stripe width. that seems to work. I am reserving space and writing
3MB size buffers to raid5 with 1MB stripe unit over 4 disks.

my question:
Can I rely on it ?
Can I enforce this behaviour ?

thank you
-- 
Raz
