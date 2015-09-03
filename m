Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 32C0C7F9E
	for <xfs@oss.sgi.com>; Thu,  3 Sep 2015 15:34:05 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 14B45304048
	for <xfs@oss.sgi.com>; Thu,  3 Sep 2015 13:34:01 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id yYJN5EJLmcLTFVEp for <xfs@oss.sgi.com>;
	Thu, 03 Sep 2015 13:33:59 -0700 (PDT)
Subject: Re: [PATCH 0/3] xfs: new global stats in sysfs
References: <1441298187-29064-1-git-send-email-billodo@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <55E8AEB7.6050006@sandeen.net>
Date: Thu, 3 Sep 2015 15:33:59 -0500
MIME-Version: 1.0
In-Reply-To: <1441298187-29064-1-git-send-email-billodo@redhat.com>
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
To: billodo <billodo@redhat.com>, xfs@oss.sgi.com

On 9/3/15 11:36 AM, billodo wrote:
> 
> Hi all-
> Here is a first pass at a series to add new global stats to sysfs.
> As a part of that, the /proc/fs/xfs/stat file becomes a symlink to
> the sysfs stats entry. The patch provides the beginnings of the
> infrastructure for per-fs stats (in addition to global accumulative
> stats).

To flesh this out a little more:

We already have per-fs information in /sys, so it makes sense to
have per-fs stats there too.  As a first step, moving existing
global stats infrastructure to /sys will allow us to re-use that
sysfs code for per-fs stats as well.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
