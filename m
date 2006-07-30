Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 30 Jul 2006 16:46:07 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k6UNjFDW029944
	for <xfs@oss.sgi.com>; Sun, 30 Jul 2006 16:45:27 -0700
Date: Mon, 31 Jul 2006 09:44:24 +1000
From: Nathan Scott <nathans@sgi.com>
Subject: Re: XFS Bug null pointer dereference in xfs_free_ag_extent
Message-ID: <20060731094424.E2280998@wobbly.melbourne.sgi.com>
References: <44BF29CD.1000809@l4x.org> <44CB0BF7.6030204@idccenter.cn> <44CB1303.7010303@l4x.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <44CB1303.7010303@l4x.org>; from jdi@l4x.org on Sat, Jul 29, 2006 at 09:49:23AM +0200
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Jan Dittmer <jdi@l4x.org>, kernel <linux@idccenter.cn>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com

Hi there,

On Sat, Jul 29, 2006 at 09:49:23AM +0200, Jan Dittmer wrote:
> kernel schrieb:
> > I have the same problem, but it seems not have a patch right now.
> 
> No, I got zero feedback, but let's cc the correct
> mailing list. I also filed bug 6877 at kernel.org
> 

Is this easily reproducible for you?  I've not seen it before, and
the only possibly related recent changes I can think of are these:

http://git.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=e63a3690013a475746ad2cea998ebb534d825704

http://git.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=d210a28cd851082cec9b282443f8cc0e6fc09830

Could you try reverting each of those to see if either is the cause?

thanks.

-- 
Nathan
