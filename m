Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2CHnHGZ114627 for <xfs@oss.sgi.com>; Mon, 12 Mar 2012 12:49:17 -0500
Received: from smtprelay06.ispgateway.de (smtprelay06.ispgateway.de
	[80.67.31.95]) by cuda.sgi.com with ESMTP id Vk8zVo3oIGN248w2
	for <xfs@oss.sgi.com>; Mon, 12 Mar 2012 10:49:15 -0700 (PDT)
Received: from [62.43.225.238] (helo=[192.168.30.191])
	by smtprelay06.ispgateway.de with esmtpsa (TLSv1:AES256-SHA:256)
	(Exim 4.68) (envelope-from <richard.ems@cape-horn-eng.com>)
	id 1S79Mw-0001Bo-IE
	for xfs@oss.sgi.com; Mon, 12 Mar 2012 18:49:14 +0100
Message-ID: <4F5E371A.4000004@cape-horn-eng.com>
Date: Mon, 12 Mar 2012 18:49:14 +0100
From: Richard Ems <richard.ems@cape-horn-eng.com>
MIME-Version: 1.0
Subject: Re: 3.2.9 and locking problem
References: <201203092028.47177.arekm@maven.pl> <20120312005325.GX5091@dastard>
	<201203121443.59217.arekm@maven.pl>
	<20120312161425.GA23815@infradead.org>
In-Reply-To: <20120312161425.GA23815@infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Hi Christoph,

On 03/12/2012 05:14 PM, Christoph Hellwig wrote:
> In the 3.2 version xfs_sync_flags does a double unlock of the ilock -
> change the last argument of xfs_trans_ijoin from XFS_ILOCK_EXCL to 0
> will fix this.  The 3.0 version doesn't have this bug.

Is there already a fix or will there be one for 3.2.10 ?

I am already using 3.2.x on 4 servers in production ...

Thanks,
Richard


-- =

Richard Ems       mail: Richard.Ems@Cape-Horn-Eng.com

Cape Horn Engineering S.L.
C/ Dr. J.J. D=F3mine 1, 5=BA piso
46011 Valencia
Tel : +34 96 3242923 / Fax 924
http://www.cape-horn-eng.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
