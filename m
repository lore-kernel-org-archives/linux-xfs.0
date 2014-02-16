Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 888CB7F82
	for <xfs@oss.sgi.com>; Sun, 16 Feb 2014 16:28:22 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 562D1304053
	for <xfs@oss.sgi.com>; Sun, 16 Feb 2014 14:28:22 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	4vA8jflR8hmV491U for <xfs@oss.sgi.com>;
	Sun, 16 Feb 2014 14:28:20 -0800 (PST)
Date: Mon, 17 Feb 2014 09:28:11 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Tasks blocked in xlog_grant_log_space
Message-ID: <20140216222811.GW13647@dastard>
References: <532438291.2495843.1392394364516.JavaMail.zimbra@redhat.com>
	<461400101.2501294.1392394773671.JavaMail.zimbra@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <461400101.2501294.1392394773671.JavaMail.zimbra@redhat.com>
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
To: Laurence Oberman <loberman@redhat.com>
Cc: Leonardo Menezes Vaz <lvaz@redhat.com>, xfs@oss.sgi.com

On Fri, Feb 14, 2014 at 11:19:33AM -0500, Laurence Oberman wrote:
> Hello
> 
> I have a customer seeing multiple tasks blocked in xlog_grant_log_space
> This lands up hitting the hungtask timer for pdflush.
> 
> I have seen on the list that this issue is still out there.
> I also don't see outstanding I/O requests on the XFS file system that experienced this block.
> 
> The last hung_task timeout was on dm-9 
> ffff81011c78c080 ffff81081a43bc00 xfs    /dev/vgautocomp/lv_autocomp /bb/autocomp
> 
> crash> gendisk ffff810814d24400 | grep in_flight
>   in_flight = 0, 
> 
> So just wondering if I am hitting an existing bug or if its a new one.
> 
> This is an older 2.6.18 kernel

There's been lots of problems fixed in this area in the past seven
years. Your best bet is to upgrade to a more recent 3.x based kernel
where the known issues in this area have been resolved.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
