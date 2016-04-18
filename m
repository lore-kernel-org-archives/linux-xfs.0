Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 92D287CA0
	for <xfs@oss.sgi.com>; Mon, 18 Apr 2016 13:54:38 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 662598F8033
	for <xfs@oss.sgi.com>; Mon, 18 Apr 2016 11:54:38 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id LPMTcY86LH0eXY43 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 18 Apr 2016 11:54:37 -0700 (PDT)
Received: from int-mx14.intmail.prod.int.phx2.redhat.com
	(int-mx14.intmail.prod.int.phx2.redhat.com [10.5.11.27])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.redhat.com (Postfix) with ESMTPS id BE08780F6B
	for <xfs@oss.sgi.com>; Mon, 18 Apr 2016 18:54:36 +0000 (UTC)
Received: from redhat.com (vpn-55-87.rdu2.redhat.com [10.10.55.87])
	by int-mx14.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id u3IIsZiC005954
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=NO) for <xfs@oss.sgi.com>; Mon, 18 Apr 2016 14:54:36 -0400
Date: Mon, 18 Apr 2016 20:54:29 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: "xfs_log_force: error 5 returned." for drive that was removed.
Message-ID: <20160418185429.GA6730@redhat.com>
References: <CACo5E_6fz+BV7prpyo35jzH2_dwgswZ4ZkZ26XP9czbdT3g6vw@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CACo5E_6fz+BV7prpyo35jzH2_dwgswZ4ZkZ26XP9czbdT3g6vw@mail.gmail.com>
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
To: xfs@oss.sgi.com

On Sun, Apr 17, 2016 at 09:33:27AM -0500, Joe Wendt wrote:
>    Hello! This may be a silly question or an interesting one...
>    We had a drive fail in a production server, which spawned this error in
>    the logs:
>    XFS (sde1): xfs_log_force: error 5 returned.
>    The dead array was lazy-unmounted, and the drive was hot-swapped, but
>    when the RAID array was rebuilt, it came online as /dev/sdk instead of
>    /dev/sde.
>    Now /dev/sde1 doesn't exist in the system, but we still see this
>    message every 30 seconds. I'm assuming a reboot will clear out whatever
>    is still trying to access sde1, but I'm trying to avoid that if
>    possible. Could someone point me in the direction of what XFS might
>    still be trying to do with that device?
>    lsof hasn't given me any clues. I can't run xfs_repair on a volume that
>    isn't there. I haven't been able to find anything similar yet online.
>    Any help would be greatly appreciated!
>    Thanks,
>    Joe

I believe this is the same problem being discussed in this thread:

XFS hung task in xfs_ail_push_all_sync() when unmounting FS after disk
failure/recovery.

Can you get a stack dump of the system (sysrq-t) and post it in some pastebin?


> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs


-- 
Carlos

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
