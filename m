Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 12 Nov 2008 02:05:37 -0800 (PST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id mACA5MKM002027
	for <xfs@oss.sgi.com>; Wed, 12 Nov 2008 02:05:22 -0800
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 20FFD15459C2
	for <xfs@oss.sgi.com>; Wed, 12 Nov 2008 02:05:22 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34]) by cuda.sgi.com with ESMTP id vzcO5reyXa46rCdZ for <xfs@oss.sgi.com>; Wed, 12 Nov 2008 02:05:22 -0800 (PST)
Date: Wed, 12 Nov 2008 05:04:20 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfstests: fix dbtest build
Message-ID: <20081112100420.GA32567@infradead.org>
References: <490F8380.6020706@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <490F8380.6020706@redhat.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs mailing list <xfs@oss.sgi.com>

On Mon, Nov 03, 2008 at 05:04:32PM -0600, Eric Sandeen wrote:
> At least on my x86_64 RHEL5 box, if gdbm-devel is installed, then the
> xfstests build fails with:

Still doesn't build even with libgdbm-dev installed on debian, despite
having a /usr/include/gdbm.h.  Even when manually including that one it
doesn't define DBM.  Which of the three headers does actually get used
on RHEL?
