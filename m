Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 13 Apr 2008 22:14:25 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m3E5E0Mq019707
	for <xfs@oss.sgi.com>; Sun, 13 Apr 2008 22:14:05 -0700
Date: Mon, 14 Apr 2008 15:15:24 +1000
Subject: Re: lost+found Delete Error
From: "Barry Naujok" <bnaujok@sgi.com>
Content-Type: text/plain; format=flowed; delsp=yes; charset=utf-8
MIME-Version: 1.0
References: <efe536470804111935q262008b4va3cf8143804936ed@mail.gmail.com> <op.t9k4kbas3jf8g2@pc-bnaujok.melbourne.sgi.com> <efe536470804132208p4c0f2a04ye187ea6d7c62a4d2@mail.gmail.com>
Content-Transfer-Encoding: 7bit
Message-ID: <op.t9k4vyxx3jf8g2@pc-bnaujok.melbourne.sgi.com>
In-Reply-To: <efe536470804132208p4c0f2a04ye187ea6d7c62a4d2@mail.gmail.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Robert Navarro <crshman@gmail.com>, xfs@oss.sgi.com

On Mon, 14 Apr 2008 15:08:59 +1000, Robert Navarro <crshman@gmail.com>  
wrote:

> Hello Barry,
>
> Thanks for your response, I am indeed using the latest version 2.9.7

Hmm... can you get the inode number for the undeletable directories
(56_Sim_Lane & hl2/materials/Decals) and then run xfs_db on that device
with those inodes (including 2453227806):

xfs_db> inode <num>
xfs_db> print
xfs_db> dblock 0
xfs_db> print        (if the dblock 0 command succeeds)
xfs_db> dblock 1
xfs_db> print        (as above)

Thanks.
Barry.

 
