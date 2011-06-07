Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p577uqv6012832 for <xfs@oss.sgi.com>; Tue, 7 Jun 2011 02:56:52 -0500
MIME-Version: 1.0
In-Reply-To: <201106070943.21004@zmi.at>
References: <BANLkTinX_BO94CdQsdmj=atFc-typqr0xg@mail.gmail.com>
	<BANLkTi=y2V4ZUyP02p_r_scqdSbprjbLsQ@mail.gmail.com>
	<201106070943.21004@zmi.at>
From: Drunkard Zhang <gongfan193@gmail.com>
Date: Tue, 7 Jun 2011 15:56:30 +0800
Message-ID: <BANLkTikrmbe9X3Weyb8ikhn1RX_Tn_NuAg@mail.gmail.com>
Subject: Re: bug in xfs: can't recovery metadata log
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Michael Monnerie <michael.monnerie@is.it-management.at>
Cc: xfs-masters@oss.sgi.com, Alex Elder <aelder@sgi.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

2011/6/7 Michael Monnerie <michael.monnerie@is.it-management.at>:
> On Dienstag, 7. Juni 2011 Drunkard Zhang wrote:
>> With 2.6.39.1 too, output not the same thing.
>
> I'm not a developer, but have you tries xfs_repair -n ? As you crashed,
> probably the xfs log is damaged, needing a "xfs_repair -L", but wait for
> a more competent answer before you do this.
>
Oops, I already did "xfs_repair -L", successed. It's in production
environment, didn't have too much time to figure out why :-(

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
