Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id A30FD7F37
	for <xfs@oss.sgi.com>; Mon, 22 Apr 2013 17:31:20 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 824A7304067
	for <xfs@oss.sgi.com>; Mon, 22 Apr 2013 15:31:17 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id I3SxPlRvamy5lsMX for
	<xfs@oss.sgi.com>; Mon, 22 Apr 2013 15:31:16 -0700 (PDT)
Date: Mon, 22 Apr 2013 15:31:14 -0700
From: Zach Brown <zab@redhat.com>
Subject: Re: [PATCH] xfstests 311: test fsync with dm flakey
Message-ID: <20130422223114.GD25389@lenny.home.zabbo.net>
References: <1366665213-17894-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1366665213-17894-1-git-send-email-jbacik@fusionio.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Josef Bacik <jbacik@fusionio.com>
Cc: linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

> +static void drop_all_caches()
> +{
> +	int value = 3;
> +	int fd;
> +
> +	if ((fd = open("/proc/sys/vm/drop_caches", O_WRONLY)) < 0) {
> +		fprintf(stderr, "Error opening drop caches: %d\n", errno);
> +		return;
> +	}
> +
> +	write(fd, &value, sizeof(int));
> +	close(fd);
> +}

fwiw drop_caches takes an ascii string, not a native int:

  open("/proc/sys/vm/drop_caches", O_WRONLY) = 3
  write(3, "\3\0\0\0", 4)                 = -1 EINVAL (Invalid argument)

--- test.c.busted	2013-04-22 15:22:57.593575545 -0700
+++ test.c	2013-04-22 15:29:25.358072087 -0700
@@ -7,7 +7,7 @@
 
 static void drop_all_caches()
 {
-	int value = 3;
+	char value[] = "3\n";
 	int fd;
 
 	if ((fd = open("/proc/sys/vm/drop_caches", O_WRONLY)) < 0) {
@@ -15,7 +15,7 @@
                return;
 	}
 
-	write(fd, &value, sizeof(int));
+	write(fd, value, sizeof(value) - 1);
 	close(fd);
 }
 
  open("/proc/sys/vm/drop_caches", O_WRONLY) = 3
  write(3, "3\n", 2)                      = 2

and all this makes me think that the write() return should probably have
been checked :).

- z

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
