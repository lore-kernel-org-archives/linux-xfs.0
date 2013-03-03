Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 11DF57F93
	for <xfs@oss.sgi.com>; Sun,  3 Mar 2013 10:28:41 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D7DD3304043
	for <xfs@oss.sgi.com>; Sun,  3 Mar 2013 08:28:37 -0800 (PST)
Received: from mail-da0-f49.google.com (mail-da0-f49.google.com
	[209.85.210.49]) by cuda.sgi.com with ESMTP id DncaROxvNRSpBDcz
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 03 Mar 2013 08:28:36 -0800 (PST)
Received: by mail-da0-f49.google.com with SMTP id t11so2112200daj.8
	for <xfs@oss.sgi.com>; Sun, 03 Mar 2013 08:28:36 -0800 (PST)
Date: Mon, 4 Mar 2013 00:43:42 +0800
From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH 09/10] xfstest: add defragmentation stress tests for ext4
Message-ID: <20130303164342.GB30459@gmail.com>
References: <1361356935-29153-1-git-send-email-dmonakhov@openvz.org>
	<1361356935-29153-10-git-send-email-dmonakhov@openvz.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1361356935-29153-10-git-send-email-dmonakhov@openvz.org>
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
To: Dmitry Monakhov <dmonakhov@openvz.org>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, dchinner@redhat.com, xfs@oss.sgi.com

On Wed, Feb 20, 2013 at 02:42:14PM +0400, Dmitry Monakhov wrote:
> Perform various regression tests for ext4defrag  subsystem
> 
>  299'th Test1: Defragment file while other task does direct AIO

Hi Dmitry,

I couldn't run this testcase in my sandbox.  I got the following error
message.

FSTYP         -- ext4
PLATFORM      -- Linux/x86_64 lz-desktop 3.8.0
MKFS_OPTIONS  -- /dev/sda2
MOUNT_OPTIONS -- -o acl,user_xattr /dev/sda2 /mnt/sda2

299      [not run] /usr/local/bin/fio too old
Not run: 299
Passed all 0 tests

My fio version is fio-2.0.14-23-g9c63.  It seems that there are some
errors in fio config file.

Regards,
                                                - Zheng

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
