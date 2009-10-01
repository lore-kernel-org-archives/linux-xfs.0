Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n91ED40j098655 for <xfs@oss.sgi.com>; Thu, 1 Oct 2009 09:13:04 -0500
Received: from knox.decisionsoft.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1FA0D496F65
	for <xfs@oss.sgi.com>; Thu,  1 Oct 2009 07:14:26 -0700 (PDT)
Received: from knox.decisionsoft.com (knox-be.decisionsoft.com
	[87.194.172.100]) by cuda.sgi.com with ESMTP id
	DaosbWWVPlOls2D2 for <xfs@oss.sgi.com>;
	Thu, 01 Oct 2009 07:14:26 -0700 (PDT)
Message-ID: <4AC4B940.6010004@corefiling.com>
Date: Thu, 01 Oct 2009 15:14:24 +0100
From: Stuart Rowan <strr@corefiling.com>
MIME-Version: 1.0
Subject: Re: Two XFS involving stack traces from Debian's 2.6.26-2-amd64
References: <4AC45B72.9060500@decisionsoft.co.uk> <200910011244.37489@zmi.at>
In-Reply-To: <200910011244.37489@zmi.at>
Reply-To: strr@corefiling.com
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
To: Michael Monnerie <michael.monnerie@is.it-management.at>
Cc: xfs@oss.sgi.com

Michael Monnerie wrote, on 01/10/09 11:44:
> On Donnerstag 01 Oktober 2009 Stuart Rowan wrote:
>> umount /tmp/$from ; /sbin/lvremove -f /dev/$vgroup/snap-shot ; rmdir
>> /tmp/$from
>
> Why don't you
> umount /tmp/$from&&  /sbin/lvremove -f /dev/$vgroup/snap-shot&&  rmdir
> /tmp/$from
> from your script so this won't happen again?
> Or make a loop around umount?
>
> mfg zmi

Thanks, I've changed it as you suggested. It's true a second call to umount 
does unmount it (well it disappears from /proc/mounts anyway).

However lvremove still does not succeed because it still believes the 
volume to be open.

Cheers,
Stu.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
