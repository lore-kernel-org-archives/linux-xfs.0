Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 10 Jul 2008 19:47:15 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m6B2lBQq029130
	for <xfs@oss.sgi.com>; Thu, 10 Jul 2008 19:47:12 -0700
Message-ID: <4876C9EB.7060601@sgi.com>
Date: Fri, 11 Jul 2008 12:48:11 +1000
From: Mark Goodwin <markgw@sgi.com>
Reply-To: markgw@sgi.com
MIME-Version: 1.0
Subject: Re: deadlocked xfs
References: <4876C667.608@sandeen.net>
In-Reply-To: <4876C667.608@sandeen.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-oss <xfs@oss.sgi.com>

Thanks for the report Eric. This looks very similar to a
deadlock Lachlan recently hit in the patch for
"Use atomics for iclog reference counting"
http://oss.sgi.com/archives/xfs/2008-02/msg00130.html

It seems this patch can cause deadlocks under heavy log traffic.
I don't think anyone has a fix yet ... Lachlan is out this week,
but Tim can follow-up here ...

Cheers
-- Mark

Eric Sandeen wrote:
> while running fs_mark:
> 
> fs_mark -d /mnt/test -D 256 -n 100000 -t 4 -s 20480 -F -S 0
> 
> which runs 4 threads making 20k files,things got stuffed up in the log,
> see sysrq-w output at:
> 
> http://sandeen.fedorapeople.org/xfs/deadxfs
> 
> 2 threads down this path:
> 
>  [<ffffffffa03c89f5>] :xfs:xlog_state_get_iclog_space+0x83/0x187
>  [<ffffffffa03c8c1a>] :xfs:xlog_write+0x121/0x486
>  [<ffffffffa03c9043>] :xfs:xfs_log_write+0x2a/0x50
> 
> this is on a 4 cpu AMD.
> 
> I made the fs with:
> 
> mkfs.xfs -dsize=1t,agcount=32 -l lazy-count=1 -f /dev/sdb
> 
> and mounted with:
> 
> mount -o nobarrier,logbsize=256k,logbufs=8,inode64 /dev/sdb /mnt/test
> 
> has this been seen before?
> 
> Thanks,
> 
> -Eric
> 
> 

-- 

  Mark Goodwin                                  markgw@sgi.com
  Engineering Manager for XFS and PCP    Phone: +61-3-99631937
  SGI Australian Software Group           Cell: +61-4-18969583
-------------------------------------------------------------
