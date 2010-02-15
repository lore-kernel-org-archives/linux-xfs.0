Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o1FEkppN065600 for <xfs@oss.sgi.com>; Mon, 15 Feb 2010 08:46:53 -0600
Date: Mon, 15 Feb 2010 09:48:07 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: using the scalable vmapi API again
Message-ID: <20100215144807.GA9932@infradead.org>
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
To: Alex Elder <aelder@sgi.com>
Cc: xfs@oss.sgi.com

Hi Alex,

I've worked with Nick to make sure the regressions introduced by Nick's
scalable vmap API are fixed, so we an start using it again after we
had to disable it after a brief period in early 2009.

Can you make sure commits d2859751cd0bf586941ffa7308635a293f943c17 and
95f8e302c04c0b0c6de35ab399a5551605eeb006 get re-aplied to the XFS
tree, or maybe re-revert their revert commits
3a011a171906a3a51a43bb860fb7c66a64cab140 and
cf7dab801796b9ee52a6dc99888a66bf476538ec.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
