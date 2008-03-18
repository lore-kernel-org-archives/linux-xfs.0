Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 17 Mar 2008 17:28:00 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m2I0Rkdu003853
	for <xfs@oss.sgi.com>; Mon, 17 Mar 2008 17:27:51 -0700
Message-ID: <47DF0C9D.1010602@sgi.com>
Date: Tue, 18 Mar 2008 11:28:13 +1100
From: Timothy Shimmin <tes@sgi.com>
MIME-Version: 1.0
Subject: Re: 2.6.24.3 nfs server on xfs keeps producing nfsd: non-standard
 errno: -117
References: <47DEFE5E.4030703@decisionsoft.co.uk>
In-Reply-To: <47DEFE5E.4030703@decisionsoft.co.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: strr-debian@decisionsoft.co.uk
Cc: xfs@oss.sgi.com

Hi Stuart,

Stuart Rowan wrote:
> Hi,
> 
> Firstly thanks for the great filesystem and apologies if this ends up 
> being NFS rather than XFS being weird! I'm not subscribed so please do 
> keep me CC'd.
> 
> I have *millions* of lines of (>200k per minute according to syslog):
> nfsd: non-standard errno: -117
> being sent out of dmesg
> 
> Now errno 117 is
> #define EUCLEAN         117     /* Structure needs cleaning */
> which seems to be only used from a quick grep by XFS and JFFS and smbfs.
> 
> 
In XFS we mapped EFSCORRUPTED to EUCLEAN as EFSCORRUPTED
didn't exist on Linux.
However, normally if this error is encountered in XFS then
we output an appropriate msg to the syslog.
Our default error level is 3 and most reports are rated at 1
so should show up I would have thought.

--Tim

> My nfs server export two locations
> /home
> /home/archive
> both of these are XFS partitions, hence my suspicion that the -117 is 
> coming from XFS.
> 
> xfs_repair -n says the filesystems are clean
> xfs_repair has been run multiple times to completion on the filesystems, 
> all is fine.
> 
> The XFS partitions are lvm volumes as follows
> data/home 900G
> data/archive 400G
> The volume group, data, is sda3
> sda3 is a 6 drive 3ware 9550SXU-8LP RAID10 array
> 
> The NFS server is currently in use (indeed the message only starts once 
> clients connect) and works absolutely fine.
> 
> How do I find out what (if anything) is wrong with my filesystem / 
> appropriately silence this message?
> 
> Many thanks,
> Stu.
> 
