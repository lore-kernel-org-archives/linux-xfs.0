Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0ICxlmS129235 for <xfs@oss.sgi.com>; Tue, 18 Jan 2011 06:59:48 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 26918161FB17
	for <xfs@oss.sgi.com>; Tue, 18 Jan 2011 05:02:05 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id jhEO1ZSJdi4HIDae for
	<xfs@oss.sgi.com>; Tue, 18 Jan 2011 05:02:05 -0800 (PST)
Date: Tue, 18 Jan 2011 08:02:05 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 12/12] xfs: kill support/debug.[ch]
Message-ID: <20110118130205.GB23988@infradead.org>
References: <1294792553-8378-1-git-send-email-david@fromorbit.com>
	<1294792553-8378-13-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1294792553-8378-13-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

>  # Objects in support/
>  xfs-y				+= $(addprefix support/, \
> -				   debug.o \
>  				   uuid.o)

This can become just:

xfs-y					+= support/uuid.o

unless, of course we managed to kill off uuid.c as well.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
