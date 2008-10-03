Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 03 Oct 2008 08:23:25 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m93FM58H030968
	for <xfs@oss.sgi.com>; Fri, 3 Oct 2008 08:22:06 -0700
Received: from ey-out-1920.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 216864ABC79
	for <xfs@oss.sgi.com>; Fri,  3 Oct 2008 08:23:43 -0700 (PDT)
Received: from ey-out-1920.google.com (ey-out-1920.google.com [74.125.78.150]) by cuda.sgi.com with ESMTP id HFHJoRQZ5AzuDxbs for <xfs@oss.sgi.com>; Fri, 03 Oct 2008 08:23:43 -0700 (PDT)
Received: by ey-out-1920.google.com with SMTP id 21so501973eyc.32
        for <xfs@oss.sgi.com>; Fri, 03 Oct 2008 08:23:42 -0700 (PDT)
Message-ID: <25446eb90810030823g70506145o9aef9ed3832abfe@mail.gmail.com>
Date: Fri, 3 Oct 2008 16:23:41 +0100
From: "James Braid" <jamesb@loreland.org>
Subject: Re: what is the FS size limit for xfs_repair ?
In-Reply-To: <20081003170452.50a7ec78@harpe.intellique.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081003170452.50a7ec78@harpe.intellique.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Emmanuel Florac <eflorac@intellique.com>
Cc: xfs@oss.sgi.com

2008/10/3 Emmanuel Florac <eflorac@intellique.com>:
> I thought the limit would be at 16TB (32 bits limit for a filesystem)
> but obviously this isn't the case. Is the limitation higher (like 32
> TB) or is it a bug of etch 4.0r4 xfs_repair?

The limit is how much memory a 32-bit process can allocate - it's not
a limit of xfs_repair itself.

xfs_repair uses different amounts of memory depending on the
filesystem characteristics (number of inodes etc) - so a 32-bit
xfs_repair might work fine on an empty filesystem but not on a
filesystem with loads of files on it. e.g. we had a ~2TB filesystem
with millions of inodes and 32-bit xfs_repair failed.
