Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 18 Sep 2006 16:24:41 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k8INOVZd007935
	for <xfs@oss.sgi.com>; Mon, 18 Sep 2006 16:24:35 -0700
Received: from ext.agami.com (64.221.212.177.ptr.us.xo.net [64.221.212.177])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 04462D17674E
	for <xfs@oss.sgi.com>; Mon, 18 Sep 2006 15:14:22 -0700 (PDT)
Received: from agami.com ([192.168.168.132])
	by ext.agami.com (8.12.5/8.12.5) with ESMTP id k8IME52c012758
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Mon, 18 Sep 2006 15:14:05 -0700
Received: from mx1.agami.com (mx1.agami.com [10.123.10.30])
	by agami.com (8.12.11/8.12.11) with ESMTP id k8IME04g021516
	for <xfs@oss.sgi.com>; Mon, 18 Sep 2006 15:14:00 -0700
Message-ID: <450F1A1F.1020204@agami.com>
Date: Tue, 19 Sep 2006 03:43:51 +0530
From: Shailendra Tripathi <stripathi@agami.com>
MIME-Version: 1.0
Subject: Re: swidth with mdadm and RAID6
References: <Pine.LNX.4.10.10609181639000.1732-100000@limpet.umeoce.maine.edu>
In-Reply-To: <Pine.LNX.4.10.10609181639000.1732-100000@limpet.umeoce.maine.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: cousins@umit.maine.edu
Cc: "\"xfs@oss.sgi.com\" <xfs@oss.sgi.com>" <xfs@oss.sgi.com>

Hi Steve,
             Your guess appears to be correct. md_ioctl returns nr which 
is total number of disk in the array including the spare disks. However, 
XFS function md_get_vol_stripe does not take spare disk into account. It 
needs to subtract spare_disks as well.
     However, md.spare_disks returned by the call returns spare + parity 
(both). So, one way could be substract spare_disks directly. Otherwise, 
the xfs should rely on md.raid_disks. This does not include spare_disks 
and nr.disks should be changed for that.
    
When I run my program md_info on  raid5 array with 5 devices and 2 
spares, I get
[root@ga09 root]# ./a.out /dev/md11
Level 5, disks=7 spare_disks=3 raid_disks=5

Steve can you please compile the pasted program and run on your system 
with md prepared. It takes /dev/md<no> as input.
In your case, you should get above line as:
Level 6, disks=11 spare disks=3 raid_disks=10

       nr=working=active=failed=spare=0;
        ITERATE_RDEV(mddev,rdev,tmp) {
                nr++;
                if (rdev->faulty)
                        failed++;
                else {
                        working++;
                        if (rdev->in_sync)
                                active++;
                        else
                                spare++;
                }
        }

        info.level         = mddev->level;
        info.size          = mddev->size;
        info.nr_disks      = nr;
       ....
        info.active_disks  = active;
        info.working_disks = working;
        info.failed_disks  = failed;
        info.spare_disks   = spare;

-shailendra
The program is pasted below:
md_info.c. Takes /dev/md<no> as name. For example, /dev/md11.

#include<stdio.h>
#include<fcntl.h>
#include<sys/ioctl.h>
#ifndef MD_MAJOR
#define MD_MAJOR                9
#endif

#define GET_ARRAY_INFO          _IOR (MD_MAJOR, 0x11, struct md_array_info)


struct md_array_info {
__uint32_t major_version;
__uint32_t minor_version;
__uint32_t patch_version;
__uint32_t ctime;
__uint32_t level;
__uint32_t size;
__uint32_t nr_disks;
__uint32_t raid_disks;
__uint32_t md_minor;
__uint32_t not_persistent;
/*
* Generic state information
*/
__uint32_t utime;         /*  0 Superblock update time            */
__uint32_t state;         /*  1 State bits (clean, ...)           */
__uint32_t active_disks;  /*  2 Number of currently active disks  */
__uint32_t working_disks; /*  3 Number of working disks           */
__uint32_t failed_disks;  /*  4 Number of failed disks            */
__uint32_t spare_disks;   /*  5 Number of spare disks             */
/*
* Personality information
*/
__uint32_t layout;        /*  0 the array's physical layout       */
__uint32_t chunk_size;    /*  1 chunk size in bytes   */

};

int main(int argc, char *argv[])
{
        struct md_array_info    md;
        int                     fd;


        /* Open device */
        fd = open(argv[1], O_RDONLY);
        if (fd == -1) {
                printf("Could not open %s\n", argv[1]);
                exit(1);
        }
        if (ioctl(fd, GET_ARRAY_INFO, &md)) {
                printf("Error getting MD array info from %s\n", argv[1]);
                exit(1);
        }
        close(fd);
        printf("Level %d, disks=%d spare_disks=%d raid_disks=%d\n", 
md.level, md.nr_disks,
                md.spare_disks, md.raid_disks);
        return 0;
}
