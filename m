Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBAEZSC1008868 for <xfs@oss.sgi.com>; Fri, 10 Dec 2010 08:35:28 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 23AF91DD3D2
	for <xfs@oss.sgi.com>; Fri, 10 Dec 2010 06:37:18 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id PL7wRchtucD3EIRQ for
	<xfs@oss.sgi.com>; Fri, 10 Dec 2010 06:37:18 -0800 (PST)
Date: Fri, 10 Dec 2010 09:37:17 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: xfstests: fix 108 through config mechanism
Message-ID: <20101210143717.GB1415@infradead.org>
References: <1291905612.3196.49.camel@dhcp-31-190.brq.redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1291905612.3196.49.camel@dhcp-31-190.brq.redhat.com>
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
To: Boris Ranto <branto@redhat.com>
Cc: xfs@oss.sgi.com

I don't rally like the per-test option.  What about adding a
_filter_xfs_quota helper that uses sed to output a canonical
number of whitespaces?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
