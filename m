Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id CC0CE7CA0
	for <xfs@oss.sgi.com>; Thu,  5 May 2016 05:05:31 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 920FF8F8033
	for <xfs@oss.sgi.com>; Thu,  5 May 2016 03:05:28 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id mnh4WaO1dtPv83yV (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 05 May 2016 03:05:27 -0700 (PDT)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.redhat.com (Postfix) with ESMTPS id A6A8D37E64
	for <xfs@oss.sgi.com>; Thu,  5 May 2016 10:05:26 +0000 (UTC)
Received: from redhat.com (unused [10.10.51.18] (may be forged))
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id u45A5Not026089
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=NO) for <xfs@oss.sgi.com>; Thu, 5 May 2016 06:05:26 -0400
Date: Thu, 5 May 2016 12:05:23 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: "xfs_log_force: error 5 returned." for drive that was removed.
Message-ID: <20160505100523.GA9359@redhat.com>
References: <CACo5E_6fz+BV7prpyo35jzH2_dwgswZ4ZkZ26XP9czbdT3g6vw@mail.gmail.com>
	<20160418185429.GA6730@redhat.com>
	<CACo5E_7rcRdsQW00jO7FTfdHY7eyJDoFDTftA_YNh_nZ0rjsQg@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CACo5E_7rcRdsQW00jO7FTfdHY7eyJDoFDTftA_YNh_nZ0rjsQg@mail.gmail.com>
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

On Wed, May 04, 2016 at 10:48:13AM -0500, Joe Wendt wrote:
>    Thanks for the reply, and I'm sorry for the delay. Another admin
>    rebooted the server before I had a chance to collect more info. I'll
>    take a look at the other thread in case it comes up again. I think
>    we'll avoid the lazy-unmount in the future though.
>    Thanks again!
>    -Joe
> 

It certainly looks the same problem, which should be fixed by the patchset we
are working on, to add a configurable behavior for different kinds of errors.

>    On Mon, Apr 18, 2016 at 1:54 PM, Carlos Maiolino
>    <[1]cmaiolino@redhat.com> wrote:
> 
>    On Sun, Apr 17, 2016 at 09:33:27AM -0500, Joe Wendt wrote:
>    >    Hello! This may be a silly question or an interesting one...
>    >    We had a drive fail in a production server, which spawned this
>    error in
>    >    the logs:
>    >    XFS (sde1): xfs_log_force: error 5 returned.
>    >    The dead array was lazy-unmounted, and the drive was hot-swapped,
>    but
>    >    when the RAID array was rebuilt, it came online as /dev/sdk
>    instead of
>    >    /dev/sde.
>    >    Now /dev/sde1 doesn't exist in the system, but we still see this
>    >    message every 30 seconds. I'm assuming a reboot will clear out
>    whatever
>    >    is still trying to access sde1, but I'm trying to avoid that if
>    >    possible. Could someone point me in the direction of what XFS
>    might
>    >    still be trying to do with that device?
>    >    lsof hasn't given me any clues. I can't run xfs_repair on a volume
>    that
>    >    isn't there. I haven't been able to find anything similar yet
>    online.
>    >    Any help would be greatly appreciated!
>    >    Thanks,
>    >    Joe
> 
>      I believe this is the same problem being discussed in this thread:
>      XFS hung task in xfs_ail_push_all_sync() when unmounting FS after
>      disk
>      failure/recovery.
>      Can you get a stack dump of the system (sysrq-t) and post it in some
>      pastebin?
>      > _______________________________________________
>      > xfs mailing list
>      > [2]xfs@oss.sgi.com
>      > [3]http://oss.sgi.com/mailman/listinfo/xfs
>      --
>      Carlos
>      _______________________________________________
>      xfs mailing list
>      [4]xfs@oss.sgi.com
>      [5]http://oss.sgi.com/mailman/listinfo/xfs
> 
> References
> 
>    1. mailto:cmaiolino@redhat.com
>    2. mailto:xfs@oss.sgi.com
>    3. http://oss.sgi.com/mailman/listinfo/xfs
>    4. mailto:xfs@oss.sgi.com
>    5. http://oss.sgi.com/mailman/listinfo/xfs

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
