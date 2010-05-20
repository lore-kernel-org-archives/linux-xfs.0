Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4KF9BJW212233 for <xfs@oss.sgi.com>; Thu, 20 May 2010 10:09:11 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6404C35FB88
	for <xfs@oss.sgi.com>; Thu, 20 May 2010 08:11:31 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 5mMs9b2IoJIQqFyq for
	<xfs@oss.sgi.com>; Thu, 20 May 2010 08:11:31 -0700 (PDT)
Date: Thu, 20 May 2010 11:11:30 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/7] Test basic quota enforcement
Message-ID: <20100520151130.GC27124@infradead.org>
References: <1274276289-8839-1-git-send-email-jack@suse.cz>
	<1274276289-8839-4-git-send-email-jack@suse.cz>
MIME-Version: 1.0
In-Reply-To: <1274276289-8839-4-git-send-email-jack@suse.cz>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============2834966458863200912=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Jan Kara <jack@suse.cz>
Cc: hch@infradead.org, xfs@oss.sgi.com

--===============2834966458863200912==
Content-Type: text/plain; charset=unknown-8bit
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

The golden output contains "/local/test1/file5" which appaears
to be in your test fs.  You need to do something like

	sed -e "s,$SCRATCH_MNT,SCRATCH_MNT,g"

or

	sed -e "s,$T“T_MNT,TEST_MNT,g"

to make the test portable.  This probably applies to the other tests
as well.


--===============2834966458863200912==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============2834966458863200912==--
