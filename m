Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 8C28F7CB1
	for <xfs@oss.sgi.com>; Tue,  2 Aug 2016 12:34:44 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 5EE458F8037
	for <xfs@oss.sgi.com>; Tue,  2 Aug 2016 10:34:44 -0700 (PDT)
Received: from mail-wm0-f47.google.com (mail-wm0-f47.google.com
	[74.125.82.47]) by cuda.sgi.com with ESMTP id 8gfIXOriptECpeTX
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 02 Aug 2016 10:34:42 -0700 (PDT)
Received: by mail-wm0-f47.google.com with SMTP id o80so300991565wme.1
	for <xfs@oss.sgi.com>; Tue, 02 Aug 2016 10:34:42 -0700 (PDT)
Message-ID: <ABE0A526E635446AA644BBE8B0E83D69@dinulap>
From: "Lista Unx" <lista.unx@gmail.com>
References: <4278AB9734C1445A8E48635B155149F8@dinulap><20160729233524.GD16044@dastard><57CF7681619F42CCB4C0CF589E9686E5@dinulap>
	<alpine.LSU.2.20.1608011410500.18210@zvanf-gvevgu.inyvabe>
Subject: Re: partition 100% full No space left on device. looks like
	xfsiscorrupted or a bug
Date: Tue, 2 Aug 2016 20:34:41 +0300
MIME-Version: 1.0
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: "Carlos E. R." <robin.listas@telefonica.net>, XFS mailing list <xfs@oss.sgi.com>


----- Original Message ----- 
From: "Carlos E. R." <robin.listas@telefonica.net>
To: "XFS mailing list" <xfs@oss.sgi.com>
Sent: Monday, August 01, 2016 3:23 PM
Subject: Re: partition 100% full No space left on device. looks like 
xfsiscorrupted or a bug


> Dave refers to a unix/linux "feature". Files can be deleted, but if
> they are in use at the time, the contents are not deleted. Disk shows an
> ammount of free space that does not match the total - used space.
>

It haS been checked! See below a snip from my first post.

#lsof -nP |grep -i delete|wc -l
0
#find /proc/*/fd -ls | grep -i dele|wc -l
0

> However, a reboot clears this situation, and you did say in the original
> post you had rebooted the system.

Yes, tried also reboot which does not solve the problem.

Its obvious that till not run xfs_repair, we can't conclude more. This will 
happen next days ... 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
