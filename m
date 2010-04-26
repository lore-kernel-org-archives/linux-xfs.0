Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3QKqEHH108770
	for <linux-xfs@oss.sgi.com>; Mon, 26 Apr 2010 15:52:15 -0500
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5958C8D423E
	for <linux-xfs@oss.sgi.com>; Mon, 26 Apr 2010 13:54:18 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id LmYpGvtg1DGyaacC for
	<linux-xfs@oss.sgi.com>; Mon, 26 Apr 2010 13:54:18 -0700 (PDT)
Message-ID: <4BD5FD72.2070106@sandeen.net>
Date: Mon, 26 Apr 2010 15:54:10 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Attempt to Access Beyond End of Device
References: <26132521.11272313223159.JavaMail.root@wombat>
In-Reply-To: <26132521.11272313223159.JavaMail.root@wombat>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: willis@arlut.utexas.edu
Cc: linux-xfs@oss.sgi.com

On 04/26/2010 03:20 PM, willis@arlut.utexas.edu wrote:
> Federico Sevilla III wrote: "It wasn't an XFS-centric problem, after
> all"
> 
> Adding Federico's comment... Some Adadptec Controller firmware
> versions will pass incorrect device parameters to the linux kernel.
> The kernel log output misled me to believe is was a corrupt
> filesystem or partition map, however it was just an adaptec bug.
> 
> Adaptac has a fix procedure for this at:
> http://ask.adaptec.com/scripts/adaptec_tic.cfg/php.exe/enduser/std_adp.php?p_faqid=16914

Thanks for the followup; we've seen this a couple times, and it
has always stumped me.

-Eric

>  Below is the my kernel's dmesg output. After following Adaptec's
> procedure, the errors went away and I was able to mount the
> filesystem and see all of my existing data. ----- mount: /dev/sda:
> can't read superblock Mount Error at /dev/sdj. Is filesystem
> realtime? Need a File System? attempt to access beyond end of device 
> sda: rw=0, want=YYYY, limit=XXXX I/O error in filesystem ("sda")
> meta-data dev sdj block 0xZZZZ ("xfs_read_buf") error 5 buf count
> 512 XFS: size check 2 failed -----
> 
> Regards,
> 
> Michael Willis
> 
> 
> 
> 
> 
> -- Eric Sandeen wrote : Federico Sevilla III wrote:
>> Hi,
>> 
>> We've set up Debian GNU/Linux 4.0 "Etch" on an IBM x3400 machine
>> with two 73.4GB SAS hard drives in hardware RAID 1 with a
>> battery-backed cache. We are using the stock Debian 2.6.18-4-686
>> kernel.
> 
> can you send along the results of:
> 
> # xfs_db -r -c "sb 0" -c "print" /dev/sda8?
> 
> and # cat /proc/partitions
> 
> ... and does the hardware raid have a funky sector size?
> 
> -Eric
> 
> 
> 
> -- This message was sent on behalf of willis@arlut.utexas.edu at
> openSubscriber.com 
> http://www.opensubscriber.com/message/linux-xfs@oss.sgi.com/7550412.html
>
>  _______________________________________________ xfs mailing list 
> xfs@oss.sgi.com http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
