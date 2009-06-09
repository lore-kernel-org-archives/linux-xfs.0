Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n59G7rmv046515 for <xfs@oss.sgi.com>; Tue, 9 Jun 2009 11:07:54 -0500
Received: from mail.sigil.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1679D88D800
	for <xfs@oss.sgi.com>; Tue,  9 Jun 2009 09:15:18 -0700 (PDT)
Received: from mail.sigil.org (tx1-250.intrameta.com [69.13.51.250]) by
	cuda.sgi.com with ESMTP id 2oUPbgIcbbx8dzNC for
	<xfs@oss.sgi.com>; Tue, 09 Jun 2009 09:15:18 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by mail.sigil.org (Postfix) with ESMTP id E684DB3F8
	for <xfs@oss.sgi.com>; Tue,  9 Jun 2009 11:07:06 -0500 (CDT)
Received: from mail.sigil.org ([127.0.0.1])
	by localhost (mail.sigil.org [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id W9R+mOllhfXU for <xfs@oss.sgi.com>;
	Tue,  9 Jun 2009 11:07:05 -0500 (CDT)
Received: from magus.portal.sigil.org (ip72-202-157-83.ks.ks.cox.net
	[72.202.157.83])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mail.sigil.org (Postfix) with ESMTPSA id 55217B38D
	for <xfs@oss.sgi.com>; Tue,  9 Jun 2009 11:07:05 -0500 (CDT)
Date: Tue, 9 Jun 2009 11:06:22 -0500
From: Richard Kolkovich <richard@intrameta.com>
Subject: Re: [PATCH] xfs_repair: catch bad depth in traverse_int_dir2block
Message-ID: <20090609160622.GE63930@magus.portal.sigil.org>
References: <4A2C8AD8.9030107@sandeen.net>
	<20090608074230.GA28066@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20090608074230.GA28066@infradead.org>
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

Guys,

After applying the patch, we get much further.  xfs_repair then fails in phase 7:


xfs_repair: phase7.c:47: set_nlinks: Assertion `fs_inode_nlink' failed.

Aborted


Any ideas on that one?  Thanks!


-- 

Richard Kolkovich
IntraMeta Corporation
richard@intrameta.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
