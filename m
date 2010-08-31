Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o7VLGCel083266 for <xfs@oss.sgi.com>; Tue, 31 Aug 2010 16:16:13 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D34211BF6ADF
	for <xfs@oss.sgi.com>; Tue, 31 Aug 2010 14:16:51 -0700 (PDT)
Received: from mail.sandeen.net (64-131-60-146.usfamily.net [64.131.60.146])
	by cuda.sgi.com with ESMTP id uSfO3h6ZVB9Fm9o4 for
	<xfs@oss.sgi.com>; Tue, 31 Aug 2010 14:16:51 -0700 (PDT)
Message-ID: <4C7D7141.4070406@sandeen.net>
Date: Tue, 31 Aug 2010 16:16:49 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: 4K drives, sectsz=512, bsize=4096
References: <201008300956.21264@zmi.at> <201008312301.38103@zmi.at>
In-Reply-To: <201008312301.38103@zmi.at>
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
To: Michael Monnerie <michael.monnerie@is.it-management.at>
Cc: xfs@oss.sgi.com

Michael Monnerie wrote:
> On Montag, 30. August 2010 Michael Monnerie wrote:
>> Will there be any real difference if I re-format with sectsz=4096? 
>> AFAIK, XFS will do I/O based on block size, so the sector size
>>  doesn't  do any harm. Is that correct?
>  
> Nobody? Is my assumption correct that a change in sectsz from 512 to 
> 4096 would be of no difference for the filesystem?
> 

Just be sure your first sector of your top-level block device
is 4k aligned, and then yes you'll want to set sector size to 4k
so that xfs will do all log IO in 4k blocks as well.

If you do it right (and especially vs. if you do it wrong) it should
be a bit faster if all IOs are 4k aligned on the disk.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
