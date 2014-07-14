Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E7A477F5F
	for <xfs@oss.sgi.com>; Mon, 14 Jul 2014 16:26:33 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D7A27304051
	for <xfs@oss.sgi.com>; Mon, 14 Jul 2014 14:26:30 -0700 (PDT)
Received: from imap.thunk.org (imap.thunk.org [74.207.234.97]) by cuda.sgi.com
	with ESMTP id OLVC9JEFgVnCmKdv (version=TLSv1 cipher=AES128-SHA
	bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 14 Jul 2014 14:26:23 -0700 (PDT)
Date: Mon, 14 Jul 2014 17:25:39 -0400
From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/3] xfs: Add support IOC_MOV_DATA ioctl
Message-ID: <20140714212539.GH8935@thunk.org>
References: <003f01cf9aa4$1e9e5240$5bdaf6c0$@samsung.com>
	<20140708121500.GA518@infradead.org>
	<001801cf9b3f$ad786ff0$08694fd0$@samsung.com>
	<87ha2jsy6p.fsf@openvz.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <87ha2jsy6p.fsf@openvz.org>
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
Cc: Namjae Jeon <namjae.jeon@samsung.com>, 'Brian Foster' <bfoster@redhat.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, 'Christoph Hellwig' <hch@infradead.org>, 'Ashish Sangwan' <a.sangwan@samsung.com>, linux-fsdevel@vger.kernel.org, 'Luk?? Czerner' <lczerner@redhat.com>, 'linux-ext4' <linux-ext4@vger.kernel.org>

On Mon, Jul 14, 2014 at 08:27:26PM +0400, Dmitry Monakhov wrote:
> Actually they are differ. EXT4_IOC_MOVE_EXT copy data inside kernel,
> but XFS_IOC_SWAPEXT live this job to userpsace see:
> http://oss.sgi.com/cgi-bin/gitweb.cgi?p=xfs/cmds/xfsprogs.git;a=blob;f=fsr/xfs_fsr.c packfile
> And I'll vote to make EXT4_IOC_MOVE_EXT deprecated, and implement EXT4_IOC_SWAPEXT
> as XFS does that.
> Ted, Lukas what do you think about that?

The reason why EXT4_IOC_MOVE_EXT moves the data via the cache is to
avoid being subject to races if the file happens to mmap'ed and being
actively modified at the time of the defrag operation.  

I'm not sure how XFS handles that case, but if it's not somehow
locking the file against mmap's before it starts the userspace copy,
it would seem to me to be fairly dangerous in terms of prevent
potential data loss in this scenario.  Unless they are doing some
especially clever?

Regards,

						- Ted

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
