Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9FG4g7a116194
	for <linux-xfs@oss.sgi.com>; Sat, 15 Oct 2011 11:04:43 -0500
Received: from mail-ey0-f181.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0449C1E9439B
	for <linux-xfs@oss.sgi.com>; Sat, 15 Oct 2011 09:04:41 -0700 (PDT)
Received: from mail-ey0-f181.google.com (mail-ey0-f181.google.com
	[209.85.215.181]) by cuda.sgi.com with ESMTP id
	JQEIUUHjDdJRAxQb for <linux-xfs@oss.sgi.com>;
	Sat, 15 Oct 2011 09:04:41 -0700 (PDT)
Received: by eyx24 with SMTP id 24so2357759eyx.26
	for <linux-xfs@oss.sgi.com>; Sat, 15 Oct 2011 09:04:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <j7bu8k$gv1$1@dough.gmane.org>
References: <j7bs98$5bs$1@dough.gmane.org>
	<j7bu8k$gv1$1@dough.gmane.org>
Date: Sat, 15 Oct 2011 21:34:40 +0530
Message-ID: <CADDb1s3pG3JPg4nceVjbs4QiCsRY+y+juY_w3eHaup=1KVMC3A@mail.gmail.com>
Subject: Re: tasks hangs in D state while writing to xfs
From: Amit Sahrawat <amit.sahrawat83@gmail.com>
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
To: Marcin M <gmane@mejor.pl>
Cc: linux-xfs@oss.sgi.com

Hi Marcin,
Can you share the Free blocks for the disk at the time of this
issue(df -k)? It seems that the disk do not have enough free space to
reserve a transaction.
Also, the logs also seems to be mixed. The stucked position really seems to be :
Function: xlog_grant_log_space()
	/* Is there space or do we need to sleep? */
	spin_lock(&log->l_grant_lock);
Is there any other activity which was done on the disk before you
observed these hang traces?At first it does seems to hang XFS, next if
you issue a 'sync' you will observe that sync will also turn to
TASK_UNINTERRUPTIBLE 'D' state.

Thanks & Regards,
Amit Sahrawat

On Sat, Oct 15, 2011 at 5:58 PM, Marcin M <gmane@mejor.pl> wrote:
> One more thing, probably doesn't have matter, this is Xen HVM.
>
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
