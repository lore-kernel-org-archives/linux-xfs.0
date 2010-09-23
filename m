Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8NEw1lb131927 for <xfs@oss.sgi.com>; Thu, 23 Sep 2010 09:58:01 -0500
Received: from moutng.kundenserver.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 85677961AA
	for <xfs@oss.sgi.com>; Thu, 23 Sep 2010 07:58:54 -0700 (PDT)
Received: from moutng.kundenserver.de (moutng.kundenserver.de
	[212.227.126.186]) by cuda.sgi.com with ESMTP id
	7yptlP7dC1Emx1UN for <xfs@oss.sgi.com>;
	Thu, 23 Sep 2010 07:58:54 -0700 (PDT)
Message-ID: <4C9B6B27.5050606@open-e.com>
Date: Thu, 23 Sep 2010 16:58:47 +0200
From: Slawomir Nowakowski <slawomir.nowakowski@open-e.com>
MIME-Version: 1.0
Subject: Re: Problem with file system on iSCSI FileIO
References: <4C9B5786.4010205@open-e.com> <20100923143221.GA1989@infradead.org>
In-Reply-To: <20100923143221.GA1989@infradead.org>
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
Cc: Artur Piechocki <artur.piechocki@open-e.com>, =?UTF-8?B?xYF1a2FzeiBXaXR0aWc=?= <lukasz.wittig@open-e.com>, 'Ryszard Stawiarski' <ryszard.stawiarski@open-e.com>, xfs@oss.sgi.com


If you have any more questions, please do not hesitate to contact me.

Best Regards

Slawomir Nowakowski
Technical Support Engineer
-------------------------------------------------------
Open-E GmbH
e-mail: slawomir.nowakowski@open-e.com
http://www.open-e.com/
-------------------------------------------------------


W dniu 23.09.2010 16:32, Christoph Hellwig pisze:
> On Thu, Sep 23, 2010 at 03:35:02PM +0200, Slawomir Nowakowski wrote:
>    
>> Dear Sir,
>>
>> We are using iSCSI FileIO on the LVM. The file (called lun) has been
>>      
> What is iSCSI FileIO?
>
>    
iSCSI FileIO is using struct file that serves it as block level device 
via iSCSI technology:

http://en.wikipedia.org/wiki/ISCSI

>> initialized with:
>> dd if=/dev/zero of=/dev/vg+vg00/lv+i+lv0000 bs=1M conv=notrunc
>>
>> on the XFS formatted logical volume.
>>
>> Additionally, we use 2.6.27-39 kernel  and xfs-tools 2.10.1
>>
>> After some time, without any additional errors, we are not able
>> mount the volume. After mount command we get:
>>      
> Please describe the full storage topology.  But most likely it's an
> issue with your underlying storage.
>
>    
There are RAID level 6 unit on the Areca RAID controller (1680). On the 
unit is created a volume group. In the volume group we have several 
logical volumes. The iSCSI FileIO volume is mounted and the file (lun) 
is served via SCST target as iSCSI LUN.

We have checked RAM with memtest+ and verified RAID unit health and no 
issues were found.

Cheers

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
