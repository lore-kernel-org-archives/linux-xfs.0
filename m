Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 612DE7F94
	for <xfs@oss.sgi.com>; Sat,  6 Apr 2013 10:03:42 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id E56DEAC003
	for <xfs@oss.sgi.com>; Sat,  6 Apr 2013 08:03:38 -0700 (PDT)
Received: from mail-ee0-f48.google.com (mail-ee0-f48.google.com
	[74.125.83.48]) by cuda.sgi.com with ESMTP id PPk1L4RB381oZILf
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 06 Apr 2013 08:03:37 -0700 (PDT)
Received: by mail-ee0-f48.google.com with SMTP id b15so1759715eek.21
	for <xfs@oss.sgi.com>; Sat, 06 Apr 2013 08:03:36 -0700 (PDT)
Message-ID: <51603799.9070008@gmail.com>
Date: Sat, 06 Apr 2013 16:56:25 +0200
From: Marco Stornelli <marco.stornelli@gmail.com>
MIME-Version: 1.0
Subject: Re: [PATCH 2/4] fsfreeze: manage kill signal when sb_start_write
	is called
References: <515FF344.8040705@gmail.com>
	<20130406131703.GC28744@parisc-linux.org>
In-Reply-To: <20130406131703.GC28744@parisc-linux.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Matthew Wilcox <matthew@wil.cx>
Cc: Chris Mason <chris.mason@fusionio.com>, Jan Kara <jack@suse.cz>, Mike Snitzer <snitzer@redhat.com>, linux-mm@kvack.org, Andreas Dilger <adilger.kernel@dilger.ca>, Alasdair G Kergon <agk@redhat.com>, linux-cifs@vger.kernel.org, Miklos Szeredi <miklos@szeredi.hu>, linux-ext4@vger.kernel.org, fuse-devel@lists.sourceforge.net, Mark Fasheh <mfasheh@suse.com>, xfs@oss.sgi.com, Ben Myers <bpm@sgi.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Anton Altaparmakov <anton@tuxera.com>, Alex Elder <elder@kernel.org>, Theodore Ts'o <tytso@mit.edu>, linux-ntfs-dev@lists.sourceforge.net, samba-technical@lists.samba.org, linux-kernel@vger.kernel.org, Steve French <sfrench@samba.org>, ocfs2-devel@oss.oracle.com, Linux FS Devel <linux-fsdevel@vger.kernel.org>, linux-btrfs@vger.kernel.org, Joel Becker <jlbec@evilplan.org>

Il 06/04/2013 15:17, Matthew Wilcox ha scritto:
> On Sat, Apr 06, 2013 at 12:04:52PM +0200, Marco Stornelli wrote:
>> In every place where sb_start_write was called now we must manage
>> the error code and return -EINTR.
>
> If we must manage the error code, then these functions should be marked
> __must_check.
>

Yep, good point.

Marco

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
