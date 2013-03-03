Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 21E4F801E
	for <xfs@oss.sgi.com>; Sun,  3 Mar 2013 11:08:24 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 0FEFB304039
	for <xfs@oss.sgi.com>; Sun,  3 Mar 2013 09:08:21 -0800 (PST)
Received: from mail-pa0-f51.google.com (mail-pa0-f51.google.com
	[209.85.220.51]) by cuda.sgi.com with ESMTP id 1ySZAo9tbuXuE9bE
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 03 Mar 2013 09:08:17 -0800 (PST)
Received: by mail-pa0-f51.google.com with SMTP id hz1so2683568pad.38
	for <xfs@oss.sgi.com>; Sun, 03 Mar 2013 09:08:16 -0800 (PST)
Date: Mon, 4 Mar 2013 01:23:21 +0800
From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH 09/10] xfstest: add defragmentation stress tests for ext4
Message-ID: <20130303172321.GA5608@gmail.com>
References: <1361356935-29153-1-git-send-email-dmonakhov@openvz.org>
	<1361356935-29153-10-git-send-email-dmonakhov@openvz.org>
	<20130303164342.GB30459@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130303164342.GB30459@gmail.com>
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
To: Dmitry Monakhov <dmonakhov@openvz.org>, xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, dchinner@redhat.com

On Mon, Mar 04, 2013 at 12:43:42AM +0800, Zheng Liu wrote:
> On Wed, Feb 20, 2013 at 02:42:14PM +0400, Dmitry Monakhov wrote:
> > Perform various regression tests for ext4defrag  subsystem
> > 
> >  299'th Test1: Defragment file while other task does direct AIO
> 
> Hi Dmitry,
> 
> I couldn't run this testcase in my sandbox.  I got the following error
> message.
> 
> FSTYP         -- ext4
> PLATFORM      -- Linux/x86_64 lz-desktop 3.8.0
> MKFS_OPTIONS  -- /dev/sda2
> MOUNT_OPTIONS -- -o acl,user_xattr /dev/sda2 /mnt/sda2
> 
> 299      [not run] /usr/local/bin/fio too old
> Not run: 299
> Passed all 0 tests
> 
> My fio version is fio-2.0.14-23-g9c63.  It seems that there are some
> errors in fio config file.

I just notice Rich's reply.  After adding 'NUM_JOBS=$((4*LOAD_FACTOR))',
the testcase can run.  Sorry for the noisy.

Regards,
                                                - Zheng

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
