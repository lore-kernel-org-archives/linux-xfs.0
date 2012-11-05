Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qA5DtuMX249001 for <xfs@oss.sgi.com>; Mon, 5 Nov 2012 07:55:57 -0600
Received: from smtp-tls.univ-nantes.fr (smtptls1-cha.cpub.univ-nantes.fr
	[193.52.103.113]) by cuda.sgi.com with ESMTP id
	kjOLVGNDCcqDEwig for <xfs@oss.sgi.com>;
	Mon, 05 Nov 2012 05:57:51 -0800 (PST)
Message-ID: <5097C5DD.3090305@univ-nantes.fr>
Date: Mon, 05 Nov 2012 14:57:49 +0100
From: Yann Dupont <Yann.Dupont@univ-nantes.fr>
MIME-Version: 1.0
Subject: Re: Problems with kernel 3.6.x (vm ?) (was : Is kernel 3.6.1 or
	filestreams option toxic ?)
References: <508554AF.5050005@univ-nantes.fr> <50865453.5080708@univ-nantes.fr>
	<508958FF.4000007@univ-nantes.fr> <20121025211047.GD29378@dastard>
	<508A600C.1020109@univ-nantes.fr> <508B092E.6070209@univ-nantes.fr>
	<20121028234802.GE4353@dastard> <20121029012540.GO29378@dastard>
	<20121029121851.GQ29378@dastard> <508E79D4.5090507@univ-nantes.fr>
	<20121030013309.GX29378@dastard>
In-Reply-To: <20121030013309.GX29378@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

Le 30/10/2012 02:33, Dave Chinner a =E9crit :
>
> Not really a huge chase, just a simple matter of isolation. The
> patch below should fix the problem.

Yes, it does.
Thanks a lot for the fast answer and this one-letter-patch !


> However, the fact that recovery succeeded on 3.4 means you may have
> a corrupted filesystem. The bug has been present since 3.0-rc1
> (which was a fix for vmap memory leaks), and recovery is trying to
> replay stale items from the previous log buffer. As such, it is
> possible that changes from a previous checkpoint to have overwritten
> more recent changes in the current checkpoint. As such, you should

Ouch.

> probably run xfs_repair -n over the filesystems that you remounted
> on 3.4 that failed on 3.6 just to make sure they are OK.
Will do.

As someone else pointed out, I think it should go to stable release.
Thanks a lot for your time,
Cheers

-- =

Yann Dupont - Service IRTS, DSI Universit=E9 de Nantes
Tel : 02.53.48.49.20 - Mail/Jabber : Yann.Dupont@univ-nantes.fr

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
