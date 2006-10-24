Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 24 Oct 2006 11:08:04 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k9OI7laG016000
	for <xfs@oss.sgi.com>; Tue, 24 Oct 2006 11:07:49 -0700
Date: Tue, 24 Oct 2006 18:06:33 +0100
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] Freeze bdevs when freezing processes.
Message-ID: <20061024170633.GA17956@infradead.org>
References: <1161576735.3466.7.camel@nigel.suspend2.net> <200610231236.54317.rjw@sisk.pl> <20061024144446.GD11034@melbourne.sgi.com> <200610241730.00488.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200610241730.00488.rjw@sisk.pl>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: David Chinner <dgc@sgi.com>, Nigel Cunningham <ncunningham@linuxmail.org>, Andrew Morton <akpm@osdl.org>, LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>, xfs@oss.sgi.com

On Tue, Oct 24, 2006 at 05:29:59PM +0200, Rafael J. Wysocki wrote:
> Do you mean calling sys_sync() after the userspace has been frozen
> may not be sufficient?

No, that's definitly not enough.  You need to freeze_bdev to make sure
data is on disk in the place it's expected by the filesystem without
starting a log recovery.
