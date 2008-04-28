Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 27 Apr 2008 22:59:08 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m3S5wkvZ005349
	for <xfs@oss.sgi.com>; Sun, 27 Apr 2008 22:58:55 -0700
Date: Mon, 28 Apr 2008 01:59:22 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] Don't initialise new inode generation numbers to zero
	V2
Message-ID: <20080428055922.GD3192@infradead.org>
References: <20080422015806.GU108924158@sgi.com> <480D641B.8060301@melbourne.sgi.com> <20080422050447.GV103491721@sgi.com> <20080425085750.GA6395@infradead.org> <20080428031120.GD103491721@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080428031120.GD103491721@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, Greg Banks <gnb@melbourne.sgi.com>, xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Mon, Apr 28, 2008 at 01:11:20PM +1000, David Chinner wrote:
> Ok, so is random32() good enough or does it need to be get_random_int()?

I'm not sure offhand what random32 actually is, but a not
cryptographically strong random number should be enough.
