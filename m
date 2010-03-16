Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o2GIsMDi192301 for <xfs@oss.sgi.com>; Tue, 16 Mar 2010 13:54:22 -0500
Subject: PATCH [0/2] xfs: use the scalable vmap API
From: Alex Elder <aelder@sgi.com>
Date: Tue, 16 Mar 2010 13:55:52 -0500
Message-ID: <1268765752.1951.25.camel@doink>
Mime-Version: 1.0
Reply-To: aelder@sgi.com
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
To: XFS Mailing List <xfs@oss.sgi.com>
Cc: hch@lst.de

As requested, I am planning to re-apply Nick Piggin's commits that
replace XFS's vmap batching with the use of the scalable vmap API.
In order to avoid a later merge conflict, these patches apply
against v2.6.34-rc1 (I am going to update the XFS master branch
to that later today).

Though I made only minor modifications, I'm posting them for
review before recommitting them.

					-Alex

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
