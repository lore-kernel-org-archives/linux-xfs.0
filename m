Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 7B9257FC3
	for <xfs@oss.sgi.com>; Tue, 20 Aug 2013 08:50:21 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 5E44230408A
	for <xfs@oss.sgi.com>; Tue, 20 Aug 2013 06:50:21 -0700 (PDT)
Received: from dkim1.fusionio.com (dkim1.fusionio.com [66.114.96.53]) by
	cuda.sgi.com with ESMTP id QR96HDlVa5TvVvVB (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 20 Aug 2013 06:50:19 -0700 (PDT)
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 587717C0447
	for <xfs@oss.sgi.com>; Tue, 20 Aug 2013 07:50:19 -0600 (MDT)
Date: Tue, 20 Aug 2013 09:50:17 -0400
From: Josef Bacik <jbacik@fusionio.com>
Subject: Re: [PATCH] xfstests: add regression test for kernel bz 60673 V2
Message-ID: <20130820135017.GE3990@localhost.localdomain>
References: <1376945597-2202-1-git-send-email-jbacik@fusionio.com>
	<5213338D.3000205@giantdisaster.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5213338D.3000205@giantdisaster.de>
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
To: Stefan Behrens <sbehrens@giantdisaster.de>
Cc: linux-btrfs@vger.kernel.org, Josef Bacik <jbacik@fusionio.com>, xfs@oss.sgi.com

On Tue, Aug 20, 2013 at 11:14:53AM +0200, Stefan Behrens wrote:
> On Mon, 19 Aug 2013 16:53:17 -0400, Josef Bacik wrote:
> > There was a problem with send trying to overwrite a file that wasn't actually
> > the same.  This is a test to check this particular case where receive fails when
> > it should succeed properly.  I tested this to verify it fails without my fix and
> > passes with my fix.  Thanks,
> 
> I tested this xfstest but for me it passes with and without the fix
> ("Btrfs: check our parent dir when doing a compare send").
>

Try again, I just tested myself and got

[root@destiny xfstests-dev]# cat /root/xfstests-dev/results//btrfs/010.full
Create subvolume '/mnt/btrfs-test/send_temp_010/send'
Create a readonly snapshot of '/mnt/btrfs-test/send_temp_010/send' in
'/mnt/btrfs-test/send_temp_010/snap1'
At subvol /mnt/btrfs-test/send_temp_010/snap1
At subvol snap1
Create a readonly snapshot of '/mnt/btrfs-test/send_temp_010/send' in
'/mnt/btrfs-test/send_temp_010/snap2'
At subvol /mnt/btrfs-test/send_temp_010/snap2
At snapshot snap2
ERROR: rename test/foo -> o260-953-0 failed. No such file or directory
failed second receive

Thanks,

Josef 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
