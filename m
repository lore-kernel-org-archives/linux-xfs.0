Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mB99vQtM013774
	for <linux-xfs@oss.sgi.com>; Tue, 9 Dec 2008 03:57:26 -0600
Received: from mail.lichtvoll.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5C1E016F3664
	for <linux-xfs@oss.sgi.com>; Tue,  9 Dec 2008 01:57:24 -0800 (PST)
Received: from mail.lichtvoll.de (mondschein.lichtvoll.de [194.150.191.11]) by
	cuda.sgi.com with ESMTP id 1nKDw2KbXFGMAtB3 for
	<linux-xfs@oss.sgi.com>; Tue, 09 Dec 2008 01:57:24 -0800 (PST)
Received: from shambala.of.teamix.net (blackhole.teamix.net [194.150.191.251])
	by mail.lichtvoll.de (Postfix) with ESMTPSA id 4EBB35ADF2
	for <linux-xfs@oss.sgi.com>; Tue,  9 Dec 2008 10:56:52 +0100 (CET)
From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: [patch 1/5] replace b_fspriv with b_mount
Date: Tue, 9 Dec 2008 10:56:47 +0100
References: <20081209094729.939583000@bombadil.infradead.org>
	<20081209094801.116064000@bombadil.infradead.org>
	(sfid-20081209_105430_370632_621C9505)
In-Reply-To: <20081209094801.116064000@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200812091056.48281.Martin@lichtvoll.de>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: linux-xfs@oss.sgi.com

Am Dienstag 09 Dezember 2008 schrieb Christoph Hellwig:
> Replace the b_fspriv pointer and it's ugly accessors with a properly
> types xfs_mount pointer.  Also switch log reocvery over to it instead
> of using b_fspriv for the mount pointer.

s/reocvery/recovery

Can't comment on code ;)

-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
