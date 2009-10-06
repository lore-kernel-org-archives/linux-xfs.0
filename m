Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n96FfSaC075037 for <xfs@oss.sgi.com>; Tue, 6 Oct 2009 10:41:28 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9061D1743B11
	for <xfs@oss.sgi.com>; Tue,  6 Oct 2009 08:42:54 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id LupRs0QKTY311nco for
	<xfs@oss.sgi.com>; Tue, 06 Oct 2009 08:42:54 -0700 (PDT)
Date: Tue, 6 Oct 2009 11:42:49 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: moving libhandle to /usr
Message-ID: <20091006154249.GA1411@infradead.org>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: vapier@gentoo.org, nathans@debian.org, sandeen@sandeen.net, xfs@oss.sgi.com

Currently we install the versioned libhandle into /lib by default,
and all other libraries into /usr.  Given that no program in / actually
uses libhandle this seems rather awkward to me.  From Mike's comments
in the past I think Gentoo already installs it into /usr anyway.

Is there anything speaking against moving all libraries to /usr and
switching Debian/Fedora to that aswell? 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
