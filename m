Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oACMgmmZ168124 for <xfs@oss.sgi.com>; Fri, 12 Nov 2010 16:42:48 -0600
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 90CBD1C3AF82
	for <xfs@oss.sgi.com>; Fri, 12 Nov 2010 14:44:18 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id pEjRERkpfx1UUc3q for
	<xfs@oss.sgi.com>; Fri, 12 Nov 2010 14:44:18 -0800 (PST)
Message-ID: <4CDDC2E0.3060000@sandeen.net>
Date: Fri, 12 Nov 2010 16:42:40 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: reducing imaxpct on linux
References: <1289561141.20961.24.camel@sekli>
	<201011121401.52477@zmi.at>	<1289571841.20961.44.camel@sekli>
	<201011121618.09040@zmi.at>
In-Reply-To: <201011121618.09040@zmi.at>
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
Cc: "CZEH, Istvan" <iczeh@virusbuster.hu>, xfs@oss.sgi.com

On 11/12/2010 09:18 AM, Michael Monnerie wrote:
> On Freitag, 12. November 2010 CZEH, Istvan wrote:
>> I already made the things written in the FAQ (question 32.) but still
>> having the problem. Maybe I should find the oldest data again? It
>> won't be easy...
> 
> I guess the FAQ is a bit wrong here:
> 
> http://xfs.org/index.php/XFS_FAQ#Q:_Why_do_I_receive_No_space_left_on_device_after_xfs_growfs.3F
> 
> Because it is not the "oldest" data, but the data that is within the 
> space in the first TeraByte of the partition.
> 
> Dave Chinner explained to me, that XFS will split data equally amongst 
> all AGs. So if you have a partition with 4TB and 4 AGs, and you put 1TB 
> data on that partition, each AG will have around 250GB data, meaining 
> you still have 750GB free within the first TB.
> When you do NOT use the inode64 option, all inodes will be placed in the 
> first TB *only*. Even when later you use the inode64 option, it might 
> not succeed in finding space for the inodes.

I don't think that follows; when you mount with inode64, inodes can
be allocated anywhere.  Even if you previously mounted without it.

What is required, though, is some contiguous space to allocate an
inode cluster into.  That could be the problem.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
