Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n0SKPC1V150992 for <xfs@oss.sgi.com>; Wed, 28 Jan 2009 14:25:12 -0600
Received: from mail.lichtvoll.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4E030C538C
	for <xfs@oss.sgi.com>; Wed, 28 Jan 2009 12:24:30 -0800 (PST)
Received: from mail.lichtvoll.de (mondschein.lichtvoll.de [194.150.191.11]) by
	cuda.sgi.com with ESMTP id NMpU1X8CqirBzRTp for
	<xfs@oss.sgi.com>; Wed, 28 Jan 2009 12:24:30 -0800 (PST)
Received: from shambhala.lichtvoll.home
	(DSL01.212.114.235.144.ip-pool.NEFkom.net [212.114.235.144])
	by mail.lichtvoll.de (Postfix) with ESMTPSA id 189715AE91
	for <xfs@oss.sgi.com>; Wed, 28 Jan 2009 21:24:29 +0100 (CET)
From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: [PATCH 02/17] xfs: make sure to free the real-time inodes in the
	mount error path
Date: Wed, 28 Jan 2009 21:24:50 +0100
References: <20090126073136.384490000@bombadil.infradead.org>
	<20090126073200.151836000@bombadil.infradead.org>
	(sfid-20090126_100302_189307_83B952B0)
In-Reply-To: <20090126073200.151836000@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200901282124.50505.Martin@lichtvoll.de>
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
To: xfs@oss.sgi.com

Am Montag 26 Januar 2009 schrieb Christoph Hellwig:
> When mount failes after allocating the real-time inodes we currently
> leak them.  Add a new helper to free the real-time inodes which can be
> used by both the mount and unmount path.

Typo in description: s/failes/fails

-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
