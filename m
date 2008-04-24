Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 23 Apr 2008 17:45:51 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m3O0jMsQ029323
	for <xfs@oss.sgi.com>; Wed, 23 Apr 2008 17:45:24 -0700
Date: Thu, 24 Apr 2008 10:45:56 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: [PATCH] fix xfs kernel so  2GiB logs work
Message-ID: <20080424004556.GU103491721@sgi.com>
References: <480FC7AA.5060401@agami.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <480FC7AA.5060401@agami.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Michael Nishimoto <miken@agami.com>
Cc: XFS Mailing List <xfs@oss.sgi.com>

On Wed, Apr 23, 2008 at 04:35:06PM -0700, Michael Nishimoto wrote:
> I hope that I've got everything now.

Almost ;)

> Ensure that 2 GiB xfs logs work properly.
> 
> We found this while experimenting with 2GiB xfs logs.
> The previous code never assumed that xfs logs would
> ever get so large.
> 
> Signed-off-by: Michael Nishimoto <miken@agami.com>
> ===========================================================
> --- xfs_log.2.c 2008-04-01 11:55:45.000000000 -0700
> +++ xfs_log.3.c 2008-04-01 11:56:53.000000000 -0700

We normally diff from the root of the kernel tree between a
pristine tree and a modified tree such that:

--- 2.6.x-xfs-new.orig/fs/xfs/xfs_log.c 2008-04-23 09:31:29.000000000 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_log.c      2008-04-24 10:39:15.696830268 +1000
@@ -226,20 +226,24 @@ xlog_grant_sub_space(struct log *log, in
 static void
 xlog_grant_add_space_write(struct log *log, int bytes)
....

is the path in the patch and you apply it via 'patch -p1 < file'
in the root of the kernel tree.

> @@ -230,20 +230,24 @@
>  static void
>  xlog_grant_add_space_write(struct log *log, int bytes)
>  {
> -       log->l_grant_write_bytes += bytes;
> -       if (log->l_grant_write_bytes > log->l_logsize) {
   ^^^^^^^

And it looks like your mailer has converted tabs to spaces.

Don't worry about either of those things for this patch, I've
fixed them up when applying them to my test tree.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
