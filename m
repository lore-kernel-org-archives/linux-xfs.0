Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 3A6DD7FAC
	for <xfs@oss.sgi.com>; Mon, 14 Jul 2014 11:27:36 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id AD405AC001
	for <xfs@oss.sgi.com>; Mon, 14 Jul 2014 09:27:32 -0700 (PDT)
Received: from mail-la0-f43.google.com (mail-la0-f43.google.com
	[209.85.215.43]) by cuda.sgi.com with ESMTP id 5ikt2fwRIsC82HHz
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 14 Jul 2014 09:27:30 -0700 (PDT)
Received: by mail-la0-f43.google.com with SMTP id hr17so2568324lab.2
	for <xfs@oss.sgi.com>; Mon, 14 Jul 2014 09:27:28 -0700 (PDT)
From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: RE: [PATCH 2/3] xfs: Add support IOC_MOV_DATA ioctl
In-Reply-To: <001801cf9b3f$ad786ff0$08694fd0$@samsung.com>
References: <003f01cf9aa4$1e9e5240$5bdaf6c0$@samsung.com>
	<20140708121500.GA518@infradead.org>
	<001801cf9b3f$ad786ff0$08694fd0$@samsung.com>
Date: Mon, 14 Jul 2014 20:27:26 +0400
Message-ID: <87ha2jsy6p.fsf@openvz.org>
MIME-Version: 1.0
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
To: Namjae Jeon <namjae.jeon@samsung.com>, 'Christoph Hellwig' <hch@infradead.org>
Cc: 'Theodore Ts'o' <tytso@mit.edu>, 'Brian Foster' <bfoster@redhat.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, 'Ashish Sangwan' <a.sangwan@samsung.com>, linux-fsdevel@vger.kernel.org, 'Luk?? Czerner' <lczerner@redhat.com>, 'linux-ext4' <linux-ext4@vger.kernel.org>

On Wed, 09 Jul 2014 15:33:21 +0900, Namjae Jeon <namjae.jeon@samsung.com> wrote:
> > 
> > On Tue, Jul 08, 2014 at 08:59:49PM +0900, Namjae Jeon wrote:
> > > This patch implements fs ioctl's IOC_MOV_DATA for XFS.
> > 
> > Shouldn't this share code with the XFS_IOC_SWAPEXT implementation?
> Lukas has raised the same question for ext4.
> Both xfs(XFS_IOC_SWAPEXT) and ext4(EXT4_IOC_MOVE_EXT) has ioctls which uses
> almost similar kind of structure as struct mov_data.
> As such, there seems to be possiblity for sharing basic code (I will try)
> used for sanity checking in IOC_MOV_DATA to be shared with these ioctls
> but the core functionality code will remain different.
> 
> Thanks!
Actually they are differ. EXT4_IOC_MOVE_EXT copy data inside kernel,
but XFS_IOC_SWAPEXT live this job to userpsace see:
http://oss.sgi.com/cgi-bin/gitweb.cgi?p=xfs/cmds/xfsprogs.git;a=blob;f=fsr/xfs_fsr.c packfile
And I'll vote to make EXT4_IOC_MOVE_EXT deprecated, and implement EXT4_IOC_SWAPEXT
as XFS does that.
Ted, Lukas what do you think about that?

> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
