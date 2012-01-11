Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0BErghm176728 for <xfs@oss.sgi.com>; Wed, 11 Jan 2012 08:53:42 -0600
Message-ID: <4F0DA272.7010209@sgi.com>
Date: Wed, 11 Jan 2012 08:53:38 -0600
From: Bill Kendall <wkendall@sgi.com>
MIME-Version: 1.0
Subject: Re: xfsdump 3.0.6, ERROR: xfs_quota failed with exit status: -1
References: <CAGdb-8fyseE+ARMUWaQYcx1VCnmph=xL7XeTBUXg2wSSdF_7hw@mail.gmail.com>
In-Reply-To: <CAGdb-8fyseE+ARMUWaQYcx1VCnmph=xL7XeTBUXg2wSSdF_7hw@mail.gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Tommy Wu <wu.tommy@gmail.com>
Cc: xfs@oss.sgi.com

On 01/09/2012 08:42 PM, Tommy Wu wrote:
> Hi!
>
> when I use xfsdump 3.0.6, it always got ERROR for xfs_quota like this:
>
> /sbin/xfsdump: using file dump (drive_simple) strategy
> /sbin/xfsdump: version 3.0.6 (dump format 3.0) - Running single-threaded
> /sbin/xfsdump: saving user quota information for: /var/www
> /sbin/xfsdump: ERROR: xfs_quota failed with exit status: -1
> /sbin/xfsdump: ERROR: failed to save user quota information, continuing
> /sbin/xfsdump: level 0 dump of fw1.teatime.com.tw:/var/www
> /sbin/xfsdump: dump date: Tue Jan 10 10:34:24 2012
>
> downgrade to 3.0.5, same command (also same xfsprogs 3.1.7), no any error:
>
> /sbin/xfsdump: using file dump (drive_simple) strategy
> /sbin/xfsdump: version 3.0.5 (dump format 3.0) - Running single-threaded
> /sbin/xfsdump: saving user quota information for: /var/www
> /sbin/xfsdump: level 0 dump of fw1.teatime.com.tw:/var/www
> /sbin/xfsdump: dump date: Tue Jan 10 10:30:36 2012
>
> But even it got error for xfs_quota, the xfsdump_quotas file was
> created successful, I check the command used in xfsdump, the same
> xfs_quota command work fine without any error in shell script (I also
> write a simple C program to use system() to execute it, also no error
> for such command).
>

In 3.0.6 SIGCHLD is explicitly ignored so that librmt processes are
automatically cleaned up if they exit early. Evidently this prevents
system() from retrieving the exit status. I'll work up a patch to
fix this.

Thanks,
Bill

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
