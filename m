Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 30 Jul 2006 17:37:15 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k6V0aaDW004720
	for <xfs@oss.sgi.com>; Sun, 30 Jul 2006 17:36:49 -0700
Date: Mon, 31 Jul 2006 10:35:50 +1000
From: Nathan Scott <nathans@sgi.com>
Subject: Re: Tree Quota error message suggestion
Message-ID: <20060731103550.H2280998@wobbly.melbourne.sgi.com>
References: <018a01c6b327$25bc6d40$0201a8c0@reykjavik>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <018a01c6b327$25bc6d40$0201a8c0@reykjavik>; from durchanek@gmail.com on Sat, Jul 29, 2006 at 05:53:34PM +0200
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Ladislav Durch?nek <durchanek@gmail.com>
Cc: xfs@oss.sgi.com

On Sat, Jul 29, 2006 at 05:53:34PM +0200, Ladislav Durch?nek wrote:
> Hi everybody,
> First at all I have to say that XFS is great. Especially its built-in quota
> support is really nice thing. I found tree quotas extremely useful for
> hosting servers where uploaded files are created with other owner than
> customer is.
> 
> But there is a one thing which could be done better I think: When I define
> tree quota and user tries to exceed id, error message returned is "No space
> left on device" which is not true - there is a plenty of space on device.

Thats by design - project quotas are basically trying to emulate
multiple little "virtual" filesystems within one large "actual"
filesystem.  So, they return ENOSPC on fullness and EXDEV when a
cross-device (project) link is attempted.

> Only when quota is totally full, next message is "Disk quota exceeded". I
> think it should be better if first message will be also "Disk quota
> exceeded".

Hmm, you should never see EDQUOT for project quota... are you sure
about that?  (are you using uquota too?)  Do you have a reproducible
test case to demonstrate this EDQUOT-on-pquota problem?

cheers.

-- 
Nathan
