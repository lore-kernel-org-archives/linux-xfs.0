Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 13 Feb 2007 10:10:40 -0800 (PST)
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l1DIAXm7010078
	for <linux-xfs@oss.sgi.com>; Tue, 13 Feb 2007 10:10:35 -0800
Message-ID: <45D1FF16.8080808@sandeen.net>
Date: Tue, 13 Feb 2007 10:10:30 -0800
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: mkfs and mount tips?
References: <20070213103533.C89F519311@mail.edu.haifa.ac.il>
In-Reply-To: <20070213103533.C89F519311@mail.edu.haifa.ac.il>
Content-Type: text/plain; charset=windows-1255; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Leon Kolchinsky <leonk@construct.haifa.ac.il>
Cc: 'Justin Piszcz' <jpiszcz@lucidpixels.com>, linux-xfs@oss.sgi.com

Leon Kolchinsky wrote:

> What about "osyncisdsync" mount option, can someone recommend this based on
> its own experience?

[esandeen@neon linux-2.6.20]$ grep -r osyncisdsync fs/xfs/xfs_vfsops.c
                 } else if (!strcmp(this_char, "osyncisdsync")) {
         "XFS: osyncisdsync is now the default, option is deprecated.");
[esandeen@neon linux-2.6.20]$

-Eric
