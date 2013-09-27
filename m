Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id DD9E07F52
	for <xfs@oss.sgi.com>; Fri, 27 Sep 2013 12:56:03 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C548930407A
	for <xfs@oss.sgi.com>; Fri, 27 Sep 2013 10:56:03 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id IxtTPekFiQSxjZ32 for
	<xfs@oss.sgi.com>; Fri, 27 Sep 2013 10:56:03 -0700 (PDT)
Date: Fri, 27 Sep 2013 10:55:59 -0700
From: Zach Brown <zab@redhat.com>
Subject: Re: [PATCH] xfstests: btrfs/015 regression test for prealloc with
	balance
Message-ID: <20130927175559.GV30372@lenny.home.zabbo.net>
References: <1380292053-8123-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1380292053-8123-1-git-send-email-jbacik@fusionio.com>
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

> +nr_csum_no_found=$(dmesg | grep -c "no csum found")
> +nr_csum_failed=$(dmesg | grep -c "csum failed")
> +
> +_check_csum_error()
> +{
> +	new_csum_no_found=$(dmesg | grep -c "no csum found")
> +	new_csum_failed=$(dmesg | grep -c "csum failed")
> +
> +	if [ $nr_csum_no_found -eq $new_csum_no_found -a \
> +	     $nr_csum_failed -eq $new_csum_failed ]; then
> +		return 0
> +	fi
> +	return 1
> +}

> +# This sucks but unfortunately it is the only way to be sure something didn't go
> +# wrong.
> +_check_csum_error || _fail "csum detected, please check dmesg"

In the future you could make them trace events and catch them for a
given invocation of a command with perf.

- z

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
