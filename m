Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 4677C7F66
	for <xfs@oss.sgi.com>; Thu, 19 Feb 2015 13:04:35 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 25175304053
	for <xfs@oss.sgi.com>; Thu, 19 Feb 2015 11:04:31 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id kWV41IkbmHVMim60 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 19 Feb 2015 11:04:31 -0800 (PST)
Date: Thu, 19 Feb 2015 17:04:19 -0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH] xfs: Introduce permanent async buffer write IO failures
Message-ID: <20150219190419.GA8862@hades.maiolino.org>
References: <1424298740-25821-1-git-send-email-david@fromorbit.com>
	<54E51CC7.8040709@sandeen.net> <20150218235220.GQ4251@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150218235220.GQ4251@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

> 
> Well, the switch is simple characterisation. What we do with that
> error type can be much more complex, and that's why I haven't tried
> to address those issues here. When we've sorted out what we need
> and how we are going to configure the error handling, then we can
> add it.
> 
> e.g. if we need configurable error handling, it needs to be
> configurable for different error types, and it needs to be
> configurable on a per-mount basis. And it needs to be configurable
> at runtime, not just at mount time. That kind of leads to using
> sysfs for this. e.g. for each error type we ned to handle different
> behaviour for:
> 
> $ cat /sys/fs/xfs/vda/meta_write_errors/enospc/type
> [transient] permanent
> $ cat /sys/fs/xfs/vda/meta_write_errors/enospc/perm_timeout_seconds
> 300
> $ cat /sys/fs/xfs/vda/meta_write_errors/enospc/perm_max_retry_attempts
> 50
> $ cat /sys/fs/xfs/vda/meta_write_errors/enospc/transient_fail_at_umount
> 1
> 
> And then have generic infrastructure to set it up and handle the
> buffer errors according to the config?
> 
> > (I think that's accurately summing up irc-and-side-channel discussions) ;)
> 
> Pretty much.
> 

talking about possible configurable error handlers, what about leave this choice
of failure to the sysadmin? Instead a time or type based configuration what
about something that the administrator could just say "next IO to device X
should fail permanently"?
Anyway, I know it would not be automatic, but it adds some flexibility to the
current behavior.

Anyway, just my 2 cents.

-- 
Carlos

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
