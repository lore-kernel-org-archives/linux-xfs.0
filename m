Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oAH9T9A6218962 for <xfs@oss.sgi.com>; Wed, 17 Nov 2010 03:29:09 -0600
Received: from idcmail-mo2no.shaw.ca (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1153E188771
	for <xfs@oss.sgi.com>; Wed, 17 Nov 2010 01:30:42 -0800 (PST)
Received: from idcmail-mo2no.shaw.ca (idcmail-mo2no.shaw.ca [64.59.134.9]) by
	cuda.sgi.com with ESMTP id mhl2NyyQWiepxCTg for
	<xfs@oss.sgi.com>; Wed, 17 Nov 2010 01:30:42 -0800 (PST)
Subject: Re: [PATCH 1/6] fs: add hole punching to fallocate
Mime-Version: 1.0 (Apple Message framework v1081)
From: Andreas Dilger <adilger@dilger.ca>
In-Reply-To: <20101117023456.GD5618@dhcp231-156.rdu.redhat.com>
Date: Wed, 17 Nov 2010 03:30:40 -0600
Message-Id: <23A45B17-C23C-45DA-8C51-1CF315C851E2@dilger.ca>
References: <1289840723-3056-1-git-send-email-josef@redhat.com>
	<1289840723-3056-2-git-send-email-josef@redhat.com>
	<20101116111611.GA4757@quack.suse.cz>
	<20101116114346.GB4757@quack.suse.cz>
	<20101116125249.GB31957@dhcp231-156.rdu.redhat.com>
	<20101116131451.GH4757@quack.suse.cz>
	<18ACAA85-8847-4B12-9839-F99FB6C7B3E4@dilger.ca>
	<20101117021150.GL22876@dastard>
	<20101117022814.GB5618@dhcp231-156.rdu.redhat.com>
	<20101117023456.GD5618@dhcp231-156.rdu.redhat.com>
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
To: Josef Bacik <josef@redhat.com>
Cc: Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, cluster-devel@redhat.com, cmm@us.ibm.com, ocfs2-devel@oss.oracle.com, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org

On 2010-11-16, at 20:34, Josef Bacik wrote:
> FWIW I agree with Dave, the only question at this point is do we force users to specify KEEP_SIZE with PUNCH_HOLE?  On one hand it makes the interface a bit more consistent, on the other hand it makes the documentation a little weird
> 
> "We have mode here, but if you want to use PUNCH_HOLE you also have to specify KEEP_SIZE, so really it's like a flags field it's just named poorly"

Even if this is the case, and we decide today that PUNCH_HOLE without KEEP_SIZE is not desirable to implement, it would be better to just return -EOPNOTSUPP if both flags are not set than assume one or the other is what the user wanted.  That allows the ability to implement this in the future without breaking every application, while if it is assumed that KEEP_SIZE is always implicit there will never be a way to add that functionality without something awful like a separate CHANGE_SIZE flag for PUNCH_HOLE.

One option is to define FALLOC_FL_PUNCH_HOLE as 0x3 (so that KEEP_SIZE is always passed) and in the future we can define some new flag name like TRUNCATE_HOLE (or whatever) that is 0x2 only.

Cheers, Andreas





_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
