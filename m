Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E7E957F37
	for <xfs@oss.sgi.com>; Sat, 22 Jun 2013 16:13:40 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 6702EAC004
	for <xfs@oss.sgi.com>; Sat, 22 Jun 2013 14:13:37 -0700 (PDT)
Received: from mail-yh0-f54.google.com (mail-yh0-f54.google.com
	[209.85.213.54]) by cuda.sgi.com with ESMTP id deygNyrnkIOuoBYz
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 22 Jun 2013 14:13:33 -0700 (PDT)
Received: by mail-yh0-f54.google.com with SMTP id f73so4132156yha.27
	for <xfs@oss.sgi.com>; Sat, 22 Jun 2013 14:13:32 -0700 (PDT)
Subject: Re: LVM + XFS + external log + snapshots
Mime-Version: 1.0 (Apple Message framework v1085)
From: aurfalien <aurfalien@gmail.com>
In-Reply-To: <51C55918.1030004@hardwarefreak.com>
Date: Sat, 22 Jun 2013 14:13:28 -0700
Message-Id: <5FF88D28-65DD-4E22-A382-8173C8969FDE@gmail.com>
References: <022467CC-8EB2-41E9-8AF6-46F781882F6B@gmail.com>
	<51C55918.1030004@hardwarefreak.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: stan@hardwarefreak.com
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

Many many thanks Stan.

It appears that I poorly architected the file system layout.

Will most likely move the log to another device, then LVM the original device (sdc1) and move it back.

Many many thanks for the info, very top tier expert level for sure.

- aurf
On Jun 22, 2013, at 12:58 AM, Stan Hoeppner wrote:

> Sorry for err aurfalien, first reply didn't make the list.
> 
> On 6/22/2013 12:30 AM, aurfalien wrote:
>> Hi all,
>> 
>> So I have an XFS file system within LVM  which has an external log.
> 
> Migrate to internal logs as snaps are easy.  Since delaylog (2.6.39+)
> external logs are generally no longer needed, provide little to no
> advantage as log bandwidth drops dramatically.  If RHEL or CentOS that's
> 6.2 or later.
> 
> ...
>> lvcreate -L250G -s -n datasnapshot /dev/vg_spock_data/lv_data
>> 
>> But when i try to mount the file system;
> 
> For now, to get past this current problem, you must snapshot both the
> filesystem and the log, during the same freeze.  You're currently
> cloning the Lone Ranger without cloning Tonto.  Ain't gonna work.  And
> it looks like the log device doesn't reside on LVM, so you're outta
> luck, can't snap it.
> 
>> logdev=/dev/sdc1
> 
> 
>> Am I doing something wrong or is this not possible?
> 
> Your first error was putting the log on raw storage instead of an LV.
> If your kernel is new enough to support delaylog, then your 2nd error
> was using an external log.  External logs were once useful for high
> metadata workloads, but since delaylog they are largely no longer needed.
> 
> xfsdump the filesytem, mkfs.xfs with an internal log, then xfsrestore.
> 
> Alternatively you could keep the external log:  Remount the live XFS
> using an alternate location for the log.  Put an LV on sdc1.  Then
> remount again using this new LV as the log location.  Then you can snap
> both XFS and the log, and mount the snap with the matching log.
> 
> -- 
> Stan
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
