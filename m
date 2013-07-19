Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id EB0637F83
	for <xfs@oss.sgi.com>; Fri, 19 Jul 2013 07:51:52 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 70035AC001
	for <xfs@oss.sgi.com>; Fri, 19 Jul 2013 05:51:52 -0700 (PDT)
Received: from mail.ud10.udmedia.de (ud10.udmedia.de [194.117.254.50]) by
	cuda.sgi.com with ESMTP id bp3drXxVixqNwDJX (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 19 Jul 2013 05:51:50 -0700 (PDT)
Date: Fri, 19 Jul 2013 14:51:49 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
Subject: Re: [Bisected] Corruption of root fs during git bisect of drm system
	hang
Message-ID: <20130719125149.GB360@x4>
References: <20130713090523.GA362@x4> <20130712070721.GA359@x4>
	<20130715022841.GH5228@dastard> <20130715064734.GA361@x4>
	<20130719122235.GA360@x4>
	<CAAxjCExBi-4Qgf6-=MBzdkzBmMtu=GTURu46DoD2CzpnF2dinw@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAAxjCExBi-4Qgf6-=MBzdkzBmMtu=GTURu46DoD2CzpnF2dinw@mail.gmail.com>
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
To: Stefan Ring <stefanrin@gmail.com>
Cc: Ben Myers <bpm@sgi.com>, Mark Tinguely <tinguely@sgi.com>, Stan Hoeppner <stan@hardwarefreak.com>, Linux fs XFS <xfs@oss.sgi.com>

On 2013.07.19 at 14:41 +0200, Stefan Ring wrote:
> > I've bisected this issue to the following commit:
> >
> >  commit cca9f93a52d2ead50b5da59ca83d5f469ee4be5f
> >  Author: Dave Chinner <dchinner@redhat.com>
> >  Date:   Thu Jun 27 16:04:49 2013 +1000
> >
> >      xfs: don't do IO when creating an new inode
> >
> > Reverting this commit on top of the Linus tree "solves" all problems for
> > me. IOW I no longer loose my KDE and LibreOffice config files during a
> > crash. Log recovery now works fine and xfs_repair shows no issues.
> >
> > So users of 3.11.0-rc1 beware. Only run this version if you have
> > up-to-date backups handy.
> 
> What I miss in this thread is a distinction between filesystem
> corruption on the one hand and a few zeroed files on the other. The
> latter may be a nuisance, but it is expected behavior, while the
> former should never happen, period, if I'm not mistaken.

Well, it is natural that fs developers at first try to blame userspace.
Unfortunately it turned out that in this case there is filesystem
corruption. (Fortunately this normally happens only very rarely on rc1
kernels).

-- 
Markus

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
