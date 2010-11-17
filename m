Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oAH0LJ2a138138 for <xfs@oss.sgi.com>; Tue, 16 Nov 2010 18:21:19 -0600
Received: from idcmail-mo2no.shaw.ca (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0662613C6FC0
	for <xfs@oss.sgi.com>; Tue, 16 Nov 2010 16:22:51 -0800 (PST)
Received: from idcmail-mo2no.shaw.ca (idcmail-mo2no.shaw.ca [64.59.134.9]) by
	cuda.sgi.com with ESMTP id QoARADh55GPdQkN1 for
	<xfs@oss.sgi.com>; Tue, 16 Nov 2010 16:22:51 -0800 (PST)
Subject: Re: [PATCH 1/6] fs: add hole punching to fallocate
Mime-Version: 1.0 (Apple Message framework v1081)
From: Andreas Dilger <adilger@dilger.ca>
In-Reply-To: <20101116131451.GH4757@quack.suse.cz>
Date: Tue, 16 Nov 2010 18:22:47 -0600
Message-Id: <18ACAA85-8847-4B12-9839-F99FB6C7B3E4@dilger.ca>
References: <1289840723-3056-1-git-send-email-josef@redhat.com>
	<1289840723-3056-2-git-send-email-josef@redhat.com>
	<20101116111611.GA4757@quack.suse.cz>
	<20101116114346.GB4757@quack.suse.cz>
	<20101116125249.GB31957@dhcp231-156.rdu.redhat.com>
	<20101116131451.GH4757@quack.suse.cz>
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
To: Jan Kara <jack@suse.cz>
Cc: ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, cluster-devel@redhat.com, cmm@us.ibm.com, Josef Bacik <josef@redhat.com>, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org

On 2010-11-16, at 07:14, Jan Kara wrote:
>> Yeah I went back and forth on this.  KEEP_SIZE won't change the behavior of PUNCH_HOLE since PUNCH_HOLE implicitly means keep the size.  I figured since its "mode" and not "flags" it would be ok to make either way accepted, but if you prefer PUNCH_HOLE means you have to have KEEP_SIZE set then I'm cool with that, just let me know one way or the other.
> 
> So we call it "mode" but speak about "flags"? Seems a bit inconsistent.  
> I'd maybe lean a bit at the "flags" side and just make sure that only one of FALLOC_FL_KEEP_SIZE, FALLOC_FL_PUNCH_HOLE is set (interpreting FALLOC_FL_KEEP_SIZE as allocate blocks beyond i_size). But I'm not sure what others think.

IMHO, it makes more sense for consistency and "get what users expect" that these be treated as flags.  Some users will want KEEP_SIZE, but in other cases it may make sense that a hole punch at the end of a file should shrink the file (i.e. the opposite of an append).

Cheers, Andreas





_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
