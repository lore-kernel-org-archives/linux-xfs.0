Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 669F37F82
	for <xfs@oss.sgi.com>; Fri, 19 Jul 2013 07:41:32 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id E4E03AC006
	for <xfs@oss.sgi.com>; Fri, 19 Jul 2013 05:41:31 -0700 (PDT)
Received: from mail-wg0-f44.google.com (mail-wg0-f44.google.com
	[74.125.82.44]) by cuda.sgi.com with ESMTP id 7YlW8sY0X951tP3C
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 19 Jul 2013 05:41:30 -0700 (PDT)
Received: by mail-wg0-f44.google.com with SMTP id m15so3870253wgh.11
	for <xfs@oss.sgi.com>; Fri, 19 Jul 2013 05:41:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20130719122235.GA360@x4>
References: <20130713090523.GA362@x4> <20130712070721.GA359@x4>
	<20130715022841.GH5228@dastard> <20130715064734.GA361@x4>
	<20130719122235.GA360@x4>
Date: Fri, 19 Jul 2013 14:41:29 +0200
Message-ID: <CAAxjCExBi-4Qgf6-=MBzdkzBmMtu=GTURu46DoD2CzpnF2dinw@mail.gmail.com>
Subject: Re: [Bisected] Corruption of root fs during git bisect of drm system
	hang
From: Stefan Ring <stefanrin@gmail.com>
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
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: Ben Myers <bpm@sgi.com>, Mark Tinguely <tinguely@sgi.com>, Stan Hoeppner <stan@hardwarefreak.com>, Linux fs XFS <xfs@oss.sgi.com>

> I've bisected this issue to the following commit:
>
>  commit cca9f93a52d2ead50b5da59ca83d5f469ee4be5f
>  Author: Dave Chinner <dchinner@redhat.com>
>  Date:   Thu Jun 27 16:04:49 2013 +1000
>
>      xfs: don't do IO when creating an new inode
>
> Reverting this commit on top of the Linus tree "solves" all problems for
> me. IOW I no longer loose my KDE and LibreOffice config files during a
> crash. Log recovery now works fine and xfs_repair shows no issues.
>
> So users of 3.11.0-rc1 beware. Only run this version if you have
> up-to-date backups handy.

What I miss in this thread is a distinction between filesystem
corruption on the one hand and a few zeroed files on the other. The
latter may be a nuisance, but it is expected behavior, while the
former should never happen, period, if I'm not mistaken.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
