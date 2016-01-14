Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 10C497F47
	for <xfs@oss.sgi.com>; Thu, 14 Jan 2016 08:37:04 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 000D58F8040
	for <xfs@oss.sgi.com>; Thu, 14 Jan 2016 06:37:00 -0800 (PST)
Received: from mout.web.de (mout.web.de [212.227.17.11]) by cuda.sgi.com with
	ESMTP id ODv2hxYcOMUZBV0u (version=TLSv1.2
	cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 14 Jan 2016 06:36:59 -0800 (PST)
Date: Thu, 14 Jan 2016 15:36:52 +0100
From: Julian Wollrath <jwollrath@web.de>
Subject: Re: Suspend does not work with v4.4-rc8
Message-ID: <20160114153652.49598601@saldaea>
In-Reply-To: <20160104194014.GD19802@dastard>
References: <20160104202611.5b100540@saldaea> <20160104194014.GD19802@dastard>
MIME-Version: 1.0
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
Cc: Jiri Kosina <jkosina@suse.cz>, xfs@oss.sgi.com

Hi,

> The freezer detection is broken. The thread is sleeping in schedule
> until a wakeup occurs some time in the future, which means it cannot
> "enter then freezer" because it's not a running thread. This is a
> problem introduced by commit 24ba16b ("xfs: clear PF_NOFREEZE for
> xfsaild kthread").
reverting this commit gets rid of the problem and lets me suspend my
machine again.


Cheers,
Julian

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
