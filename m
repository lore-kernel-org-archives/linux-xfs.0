Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 05 Aug 2008 21:51:50 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m764pdlM023520
	for <xfs@oss.sgi.com>; Tue, 5 Aug 2008 21:51:41 -0700
Received: from wr-out-0506.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4C8BDF06DC4
	for <xfs@oss.sgi.com>; Tue,  5 Aug 2008 21:52:51 -0700 (PDT)
Received: from wr-out-0506.google.com (wr-out-0506.google.com [64.233.184.230]) by cuda.sgi.com with ESMTP id oxDAuK1IIEXj7dIP for <xfs@oss.sgi.com>; Tue, 05 Aug 2008 21:52:51 -0700 (PDT)
Received: by wr-out-0506.google.com with SMTP id 57so2248136wri.12
        for <xfs@oss.sgi.com>; Tue, 05 Aug 2008 21:52:51 -0700 (PDT)
Message-ID: <cc7060690808052152j6ec3d411g7bfbc7bb1a1a770c@mail.gmail.com>
Date: Wed, 6 Aug 2008 10:22:49 +0530
From: "Bhagi rathi" <jahnu77@gmail.com>
Subject: Re: xfs_force_shutdown - file fs/xfs/xfs_rw.c
In-Reply-To: <05BB196AB3DA6C4BBE11AB6C957581FE0E61DA47@sfo-exch-01.dolby.net>
MIME-Version: 1.0
References: <05BB196AB3DA6C4BBE11AB6C957581FE0E61DA47@sfo-exch-01.dolby.net>
Content-Type: text/plain
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "Martinez, Sergio" <sergio.martinez@dolby.com>
Cc: xfs@oss.sgi.com

You can just run without raid controller and rule out XFS  issue.

If the file-system meta-data/log-flush update meets an error, the
file-system will
be marked for shutdown. The reason for this seems to be xfs_bwrite failure.
Investigate on xfs_bwrite failure.

-Bhagi.

On Wed, Aug 6, 2008 at 7:32 AM, Martinez, Sergio
<sergio.martinez@dolby.com>wrote:

>
> I'm running into a force shutdown issue on a system running
> linux-2.6.25.  The xfs partition is 2 GB and we're using a hardware
> RAID-5 for storage.
>
> dmesg shows this error:
>
> xfs_force_shutdown(sda2,0x1) called from line 420 of file
> fs/xfs/xfs_rw.c.  Return address = 0xc02ddebc
>
> An XFS_bwrite() calls is failing.
>
> Any suggestions on how to debug this?  I'm suspecting that there's a
> problem with the RAID controller firmware, but I'd like to eliminate the
> possibility of a file system bug.
>
> Thanks,
> Sergio
>
>
>
>
>
> -----------------------------------------
> This message (including any attachments) may contain confidential
> information intended for a specific individual and purpose.  If you
> are not the intended recipient, delete this message.  If you are
> not the intended recipient, disclosing, copying, distributing, or
> taking any action based on this message is strictly prohibited.
>
> [[HTML alternate version deleted]]
>
>
>


[[HTML alternate version deleted]]
