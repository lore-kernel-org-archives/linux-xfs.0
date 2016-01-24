Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 5E9407F37
	for <xfs@oss.sgi.com>; Sun, 24 Jan 2016 09:56:27 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 4E833304032
	for <xfs@oss.sgi.com>; Sun, 24 Jan 2016 07:56:23 -0800 (PST)
Received: from mail.qboosh.pl (mail.qboosh.pl [217.73.31.61]) by cuda.sgi.com
	with ESMTP id xlI6nyz2P4GKYJvj (version=TLSv1
	cipher=DHE-RSA-AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 24 Jan 2016 07:56:15 -0800 (PST)
Date: Sun, 24 Jan 2016 16:58:53 +0100
From: Jakub Bogusz <qboosh@pld-linux.org>
Subject: Polish translation update + localization remark for xfsprogs 4.3.0
Message-ID: <20160124155853.GA10063@stranger.qboosh.pl>
MIME-Version: 1.0
Content-Disposition: inline
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
To: xfs@oss.sgi.com
Cc: Christoph Hellwig <hch@infradead.org>

Hello,

I've just updated Polish translation for xfsprogs 4.3.0, it's available
at:
http://qboosh.pl/pl.po/xfsprogs-4.3.0.pl.po

I have noticed untranslatable message part in repair/versions.c:228:

_("WARNING: you have a V1 inode filesystem. It %s be converted to a\n"
  "\tversion 2 inode filesystem. If you do not want this, run an older\n"
  "\tversion of xfs_repair.\n"), no_modify ? "would" : "will");

There are untranslatable "would"/"will" strings.
This code could look for example like this:

_("WARNING: you have a V1 inode filesystem. %s to a\n"
  "\tversion 2 inode filesystem. If you do not want this, run an older\n"
  "\tversion of xfs_repair.\n"),
  no_modify ? _("It would be converted") : _("It will be converted"));

(note: using _("would") : _("will") is not enough - these words are
untranslatable to many languages without wider context)


-- 
Jakub Bogusz    http://qboosh.pl/

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
