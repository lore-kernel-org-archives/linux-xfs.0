Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8OBAZbI178403 for <xfs@oss.sgi.com>; Fri, 24 Sep 2010 06:10:36 -0500
Received: from moutng.kundenserver.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1A8A999C4D
	for <xfs@oss.sgi.com>; Fri, 24 Sep 2010 04:11:30 -0700 (PDT)
Received: from moutng.kundenserver.de (moutng.kundenserver.de [212.227.17.9])
	by cuda.sgi.com with ESMTP id nBE6zysy4zl8H6cg for
	<xfs@oss.sgi.com>; Fri, 24 Sep 2010 04:11:30 -0700 (PDT)
Message-ID: <4C9C875D.9050308@open-e.com>
Date: Fri, 24 Sep 2010 13:11:25 +0200
From: Slawomir Nowakowski <slawomir.nowakowski@open-e.com>
MIME-Version: 1.0
Subject: Re: Problem with file system on iSCSI FileIO
References: <4C9B5786.4010205@open-e.com> <20100923143221.GA1989@infradead.org>
	<4C9B6B27.5050606@open-e.com>
	<20100924075505.GA24664@infradead.org>
In-Reply-To: <20100924075505.GA24664@infradead.org>
Reply-To: slawomir.nowakowski@open-e.com
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com


>> iSCSI FileIO is using struct file that serves it as block level
>> device via iSCSI technology:
>>
>> http://en.wikipedia.org/wiki/ISCSI
>>      
> Thanks, I know ISCSI very well.  But what is "iSCSI FileIO" ?  The above
> sounds like it's an iscsi target, is that correct?
>
>    
Yes, it is iSCSI target that is served for another server. The FileIO 
serves a file as iSCSI target.
>> There are RAID level 6 unit on the Areca RAID controller (1680). On
>> the unit is created a volume group. In the volume group we have
>> several logical volumes. The iSCSI FileIO volume is mounted and the
>> file (lun) is served via SCST target as iSCSI LUN.
>>
>> We have checked RAM with memtest+ and verified RAID unit health and
>> no issues were found.
>>      
> I still can't make any sense of the actual setups.
>
> The above seems to be the backend storage.  Then there's SCST somewhere
> in which is in a out of tree kernel module.  And then you use XFS
> somewhere.  Please provide a full description of the setup.
>
>    
So once again. We have created a RAID unit level 6. On the top of the 
unit there is an LVM architecture, I mean a volume group that contains 
logical volumes. The logical volume is formatted with XFS and it 
contains one big file that takes almost all of the space on the LV. 
There is some free space left in order to be able expand the LV and FS 
in the future. The LV is mounted and the file is served as iSCSI target. 
The iSCSI Initiator (MS Initiator from Windows 2k3) connects to iSCSI 
target. The iSCSI disk is formatted with the NTFS.


But we believe the problem is with the XFS. With unknown reason we are 
not able to mount the LV and after running xfs_repair the file is 
missing from the LV. Do you have any ideas how we can try to fix the 
broken XFS?

Cheers
Slawek

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
