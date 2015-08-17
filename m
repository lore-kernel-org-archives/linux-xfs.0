Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id BA1A17F37
	for <xfs@oss.sgi.com>; Mon, 17 Aug 2015 15:00:43 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id A24C9304077
	for <xfs@oss.sgi.com>; Mon, 17 Aug 2015 13:00:43 -0700 (PDT)
Received: from mail-io0-f181.google.com (mail-io0-f181.google.com
	[209.85.223.181]) by cuda.sgi.com with ESMTP id
	BeT3CFjsnFBfUz1W (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 17 Aug 2015 13:00:41 -0700 (PDT)
Received: by iodb91 with SMTP id b91so164052462iod.1
	for <xfs@oss.sgi.com>; Mon, 17 Aug 2015 13:00:41 -0700 (PDT)
Date: Mon, 17 Aug 2015 16:00:34 -0400
From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH block/for-linus] writeback: fix syncing of I_DIRTY_TIME
	inodes
Message-ID: <20150817200034.GF21075@mtj.duckdns.org>
References: <20150812101204.GE17933@dhcp-13-216.nay.redhat.com>
	<20150813004435.GN3902@dastard>
	<20150813224415.GG4496@mtj.duckdns.org>
	<20150814111408.GB8710@quack.suse.cz>
	<20150814151401.GA6906@brouette>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150814151401.GA6906@brouette>
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
To: Damien Wyart <damien.wyart@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, Jan Kara <jack@suse.cz>, Eryu Guan <eguan@redhat.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, axboe@fb.com, Jan Kara <jack@suse.com>, linux-fsdevel@vger.kernel.org, kernel-team@fb.com

Hello, Damien.

On Fri, Aug 14, 2015 at 05:14:01PM +0200, Damien Wyart wrote:
> I had an unstable system when running latest Linus tree with Tejun's
> patch applied on top. Nothing fishy in the logs after rebooting without
> the patch, but remote access with ssh when patch applied did not work
> (as if /home partition could not be read). This system has / as ext4 and
> other partitions (including /home) as XFS. Trying to login on tty
> instead of X resulted in hang of X. I could reboot with sysrq, but can't
> do further tests at the moment.
> 
> Back to same tree without the patch resulted in normal system.
> 
> So just a heads up the patch doesn't seem OK in its current state.

Have you been able to reproduce the failure?  That sounds like an
unlikely failure mode for the patch.

Thanks.

-- 
tejun

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
