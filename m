Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 8EE867CA4
	for <xfs@oss.sgi.com>; Tue,  3 May 2016 12:55:47 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 1F1D5AC005
	for <xfs@oss.sgi.com>; Tue,  3 May 2016 10:55:47 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id sQ94JxuHq4yDON9z (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 03 May 2016 10:55:46 -0700 (PDT)
Received: from int-mx14.intmail.prod.int.phx2.redhat.com
	(int-mx14.intmail.prod.int.phx2.redhat.com [10.5.11.27])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.redhat.com (Postfix) with ESMTPS id D7C9B7F09A
	for <xfs@oss.sgi.com>; Tue,  3 May 2016 17:55:45 +0000 (UTC)
Received: from zion.usersys.redhat.com (dhcp-26-103.brq.redhat.com
	[10.34.26.103])
	by int-mx14.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id u43HtiDP016424
	for <xfs@oss.sgi.com>; Tue, 3 May 2016 13:55:45 -0400
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: [PATCH 0/7] Configurable error behavior [V2]
Date: Tue,  3 May 2016 19:55:33 +0200
Message-Id: <1462298140-12411-1-git-send-email-cmaiolino@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Hi folks,

I spoke with Dave and to offload him a bit, I took over his patchset for enable
configurable error handlers.

Since he did most of the design, I kept his signed-off to the patches.

Here are core the changes I did from his last patchset to this one:

 - Removed fail_speed configuration
	According with what has been discussed, there is no real need to have a
fail_speed configuration, but instead, use the "max_retries" configuration to
get for how long the filesystem should retrying, with the only special case for
	"-1", which will make the filesystem to retry forever.

 - Fail at unmount is no longer a config option
	Having a filesystem stuck forever during unmount due errors is not a
	good thing, so just enforce it if we are trying to unmount a failed
	filesystem.

I reduced by now, the amount of patches into this patchset, once, our priority
here IMHO is to enable the possibility to shutdown the filesystem when we have
metadata errors, and I can work on disabling specific error configs and add
memory errors later, I hope that with a reduced amount of patches it can be
easier for people to review the core of the error handlers configuration and
speed up the inclusion of this patchset.


-- 
2.4.11

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
