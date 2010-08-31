Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o7VMEpxm085856 for <xfs@oss.sgi.com>; Tue, 31 Aug 2010 17:14:51 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DC89A1239E63
	for <xfs@oss.sgi.com>; Tue, 31 Aug 2010 15:26:01 -0700 (PDT)
Received: from mail.sandeen.net (64-131-60-146.usfamily.net [64.131.60.146])
	by cuda.sgi.com with ESMTP id x0NcMDNIcysW6HaZ for
	<xfs@oss.sgi.com>; Tue, 31 Aug 2010 15:26:01 -0700 (PDT)
Message-ID: <4C7D7F01.1070003@sandeen.net>
Date: Tue, 31 Aug 2010 17:15:29 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: 4K drives, sectsz=512, bsize=4096
References: <201008300956.21264@zmi.at>
	<201008312301.38103@zmi.at>	<4C7D7141.4070406@sandeen.net>
	<201009010007.23899@zmi.at>
In-Reply-To: <201009010007.23899@zmi.at>
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
> On Dienstag, 31. August 2010 Eric Sandeen wrote:
>> Just be sure your first sector of your top-level block device
>> is 4k aligned, and then yes you'll want to set sector size to 4k
>> so that xfs will do all log IO in 4k blocks as well.
> 
> I can only hope LVM does it right, I have no idea how it aligns.
>  
>> If you do it right (and especially vs. if you do it wrong) it should
>> be a bit faster if all IOs are 4k aligned on the disk.
>  
> And that's what's interesting me: why? Won't XFS do all I/Os at minimum 
> for a given block size? Or is it possible XFS does write only a single 
> sector? I'd expect the smallest I/O size to be the block size, but it 
> seems I'm wrong?

the log can do things on sector size boundaries.
 
> I guess there's no way to "convert" an existing XFS with 
> sectsz=512,bsize=4096 to sectsz=4096,bsize=4096? Maybe that's only a 
> flag that can be changed?

I don't think so ...

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
