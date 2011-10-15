Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9FHjZZ6122750
	for <linux-xfs@oss.sgi.com>; Sat, 15 Oct 2011 12:45:35 -0500
Received: from meteor.mejor.pl (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A0F621E94549
	for <linux-xfs@oss.sgi.com>; Sat, 15 Oct 2011 10:45:33 -0700 (PDT)
Received: from meteor.mejor.pl (meteor.mejor.pl [88.198.102.195]) by
	cuda.sgi.com with ESMTP id tdnIETtqQ28m1tP2 for
	<linux-xfs@oss.sgi.com>; Sat, 15 Oct 2011 10:45:33 -0700 (PDT)
Message-ID: <4E99C6B5.6070205@mejor.pl>
Date: Sat, 15 Oct 2011 19:45:25 +0200
From: =?ISO-8859-2?Q?Marcin_Miros=B3aw?= <marcin@mejor.pl>
MIME-Version: 1.0
Subject: Re: tasks hangs in D state while writing to xfs
References: <j7bs98$5bs$1@dough.gmane.org> <j7bu8k$gv1$1@dough.gmane.org>
	<CADDb1s3pG3JPg4nceVjbs4QiCsRY+y+juY_w3eHaup=1KVMC3A@mail.gmail.com>
In-Reply-To: <CADDb1s3pG3JPg4nceVjbs4QiCsRY+y+juY_w3eHaup=1KVMC3A@mail.gmail.com>
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
To: Amit Sahrawat <amit.sahrawat83@gmail.com>
Cc: linux-xfs@oss.sgi.com, Marcin M <gmane@mejor.pl>

W dniu 2011-10-15 18:04, Amit Sahrawat pisze:
> Hi Marcin,
> Can you share the Free blocks for the disk at the time of this
> issue(df -k)? It seems that the disk do not have enough free space to
> reserve a transaction.
> Also, the logs also seems to be mixed. The stucked position really seems to be :
> Function: xlog_grant_log_space()
> 	/* Is there space or do we need to sleep? */
> 	spin_lock(&log->l_grant_lock);
> Is there any other activity which was done on the disk before you
> observed these hang traces?At first it does seems to hang XFS, next if
> you issue a 'sync' you will observe that sync will also turn to
> TASK_UNINTERRUPTIBLE 'D' state.

Hi Amit.
#  df -kT /dev/sda11
Filesystem    Type   1K-blocks      Used Available Use% Mounted on
/dev/sda11     xfs     3840937   2354891   1486046  62% /mnt/cdrom

No, i only run rsync to partition located at /dev/sda11. Meseems the
main information is size of log. Maybe there is board case when log is
minimal size (such small as mkfs allow).
Regards.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
