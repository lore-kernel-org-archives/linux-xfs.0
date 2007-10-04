Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 04 Oct 2007 15:38:39 -0700 (PDT)
Received: from wr-out-0506.google.com (wr-out-0506.google.com [64.233.184.231])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id l94McWQW022309
	for <xfs@oss.sgi.com>; Thu, 4 Oct 2007 15:38:36 -0700
Received: by wr-out-0506.google.com with SMTP id c48so277022wra
        for <xfs@oss.sgi.com>; Thu, 04 Oct 2007 15:38:33 -0700 (PDT)
Message-ID: <d55656c10710041510y79cac2abv1c4d30d3afe1949f@mail.gmail.com>
Date: Fri, 5 Oct 2007 00:10:49 +0200
From: "Peter Gervai" <grinapo@gmail.com>
Subject: xfs_repair phase6 repeatedly dies : name create failed in lost+found (117), filesystem may be out of space
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Hello,

xfs_repair in Debian sid (v2.9.0) repeatedly dies on a poor filesystem
with that message:

fatal error -- name create failed in lost+found (117), filesystem may
be out of space

The filesystem is not out of space:

Filesystem                          1K-blocks     Used      Available
Use% Mounted on
/dev/mapper/vg0-backup    419379200 144029144 275350056  35% /var/lib/backuppc

I tried to find error 117 but it seems to be well hidden. :-) I try
newer xfs_repair but I doubt it'll help. Any idea?

Thanks,
Peter
