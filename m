Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 18 Sep 2006 22:12:09 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k8J5BwaG031273
	for <xfs@oss.sgi.com>; Mon, 18 Sep 2006 22:12:00 -0700
Message-ID: <450F7C1E.5020300@sgi.com>
Date: Tue, 19 Sep 2006 15:11:58 +1000
From: Timothy Shimmin <tes@sgi.com>
MIME-Version: 1.0
Subject: Re: swidth with mdadm and RAID6
References: <Pine.LNX.4.10.10609181639000.1732-100000@limpet.umeoce.maine.edu> <450F1A1F.1020204@agami.com>
In-Reply-To: <450F1A1F.1020204@agami.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Shailendra Tripathi <stripathi@agami.com>
Cc: cousins@umit.maine.edu, "\"xfs@oss.sgi.com\" <xfs@oss.sgi.com>" <xfs@oss.sgi.com>

Hi Shailendra and Steve,

Shailendra Tripathi wrote:
> Hi Steve,
>             Your guess appears to be correct. md_ioctl returns nr which 
> is total number of disk in the array including the spare disks. However, 
> XFS function md_get_vol_stripe does not take spare disk into account. It 
> needs to subtract spare_disks as well.
>     However, md.spare_disks returned by the call returns spare + parity 
> (both). So, one way could be substract spare_disks directly. Otherwise, 
> the xfs should rely on md.raid_disks. This does not include spare_disks 
> and nr.disks should be changed for that.
>    When I run my program md_info on  raid5 array with 5 devices and 2 
> spares, I get
> [root@ga09 root]# ./a.out /dev/md11
> Level 5, disks=7 spare_disks=3 raid_disks=5
> 
> Steve can you please compile the pasted program and run on your system 
> with md prepared. It takes /dev/md<no> as input.
> In your case, you should get above line as:
> Level 6, disks=11 spare disks=3 raid_disks=10
> 
>       nr=working=active=failed=spare=0;
>        ITERATE_RDEV(mddev,rdev,tmp) {
>                nr++;
>                if (rdev->faulty)
>                        failed++;
>                else {
>                        working++;
>                        if (rdev->in_sync)
>                                active++;
>                        else
>                                spare++;
>                }
>        }
> 
>        info.level         = mddev->level;
>        info.size          = mddev->size;
>        info.nr_disks      = nr;
>       ....
>        info.active_disks  = active;
>        info.working_disks = working;
>        info.failed_disks  = failed;
>        info.spare_disks   = spare;
> 
> -shailendra

I'm not that au fait with RAID and md, but looking at what you wrote,
Shailendra, and the md code, instead of your suggestions
(what I think are your suggestions:) of:

(1) subtracting parity from md.raid_disk (instead of md.nr_disks)
     where we work out parity by switching on md.level
or
(2) using directly: (md.nr_disks - md.spares);

that instead we could use:
(3) using directly:  md.active_disks

i.e.
*swidth = *sunit * md.active_disks;
I presume that active is the working non spares and non-parity.

Does that make sense?

--Tim
