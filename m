Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n67KJuec171954
	for <linux-xfs@oss.sgi.com>; Tue, 7 Jul 2009 15:19:56 -0500
Received: from netezza.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 11B2934AF29
	for <linux-xfs@oss.sgi.com>; Tue,  7 Jul 2009 13:20:30 -0700 (PDT)
Received: from netezza.com (mta.netezza.com [12.148.248.132]) by cuda.sgi.com
	with ESMTP id qWdMH5VVSE2QeaW9 for <linux-xfs@oss.sgi.com>;
	Tue, 07 Jul 2009 13:20:30 -0700 (PDT)
Subject: Re: [2.6.27.25] assfail in xfs_attr_quiesce() during umount
From: Paul Smith <paul@mad-scientist.net>
In-Reply-To: <20090707190643.GA32467@infradead.org>
References: <MAIL10OSN4RHlLx5ERz0002f238@mail1.netezza.com>
	<20090707190643.GA32467@infradead.org>
Date: Tue, 07 Jul 2009 16:18:43 -0400
Message-Id: <1246997925.2984.1.camel@psmith-ubeta.netezza.com>
Mime-Version: 1.0
Reply-To: paul@mad-scientist.net
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
To: Christoph Hellwig <hch@infradead.org>
Cc: Linux XFS <linux-xfs@oss.sgi.com>, david chinner <dgc@sgi.com>, linux-kernel@vger.kernel.org, christoph hellwig <hch@ifradead.org>

On Tue, 2009-07-07 at 15:06 -0400, Christoph Hellwig wrote:
> It looks somehwat dangerous for me.  For now I would just comment
> out the assert or change it to a WARN_ON as in the newer kernels.

Hah!  :-).  OK, that works for me.

Thanks Christoph.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
