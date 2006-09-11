Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 11 Sep 2006 05:31:01 -0700 (PDT)
Received: from rapidforum.com (www.rapidforum.com [80.237.244.2])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k8BCUfDW005382
	for <xfs@oss.sgi.com>; Mon, 11 Sep 2006 05:30:45 -0700
Message-ID: <450556AF.6030201@rapidforum.com>
Date: Mon, 11 Sep 2006 14:29:35 +0200
From: Christian Schmid <webmaster@rapidforum.com>
MIME-Version: 1.0
Subject: Re: Critical xfs bug in 2.6.17.11?
References: <4504151F.6050704@rapidforum.com> <20060911005429.GK10950339@melbourne.sgi.com>
In-Reply-To: <20060911005429.GK10950339@melbourne.sgi.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs@oss.sgi.com

Unfortunately after this error I did a mkfs.xfs on this device, because its just a /tmp fs.

David Chinner wrote:
> On Sun, Sep 10, 2006 at 03:37:35PM +0200, Christian Schmid wrote:
> 
>>Hello.
>>
>>Instead of a tmpfs, I use a raid 10 softraid. Unfortunately it crashed 
>>after 10 hours of extreme activities (read/block-writes with up to 250 
>>streams/deletes)
>>
>>12 gb memory-test successful. 2 cpu xeon smp system.
>>
>>Tell me if this helps you:
>>
>>Sep  9 18:08:49 inode430 kernel: [87433.143498] 0x0: 58 41 47 46 00 00 00 
>>01 00 00 00 00 00 04 34 a0 
>>Sep  9 18:08:49 inode430 kernel: [87433.143672] Filesystem "md5": XFS 
>>internal error xfs_alloc_read_agf at line 2176 of file fs/xfs/xfs_alloc.c.  
>>Caller 0xffffffff80314069 
> 
> 
> Hmm - bad read of the AGF during allocation, which causes a shutdown
> due to cancelling a dirty transaction.
> 
> If you run "xfs_check -n /dev/md5" and "xfs_repair -n /dev/md5" do
> they warn about any AGF related corruption?
> 
> Cheers,
> 
> Dave.
