Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 082DC7F94
	for <xfs@oss.sgi.com>; Sat,  6 Apr 2013 08:17:14 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id CF6F98F8040
	for <xfs@oss.sgi.com>; Sat,  6 Apr 2013 06:17:10 -0700 (PDT)
Received: from mail.parisc-linux.org (palinux.external.hp.com [192.25.206.14])
	by cuda.sgi.com with ESMTP id e5C9PSznQKyTmMLZ (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sat, 06 Apr 2013 06:17:06 -0700 (PDT)
Date: Sat, 6 Apr 2013 07:17:03 -0600
From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH 2/4] fsfreeze: manage kill signal when sb_start_write
	is called
Message-ID: <20130406131703.GC28744@parisc-linux.org>
References: <515FF344.8040705@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <515FF344.8040705@gmail.com>
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
To: Marco Stornelli <marco.stornelli@gmail.com>
Cc: Chris Mason <chris.mason@fusionio.com>, Jan Kara <jack@suse.cz>, Mike Snitzer <snitzer@redhat.com>, linux-mm@kvack.org, Andreas Dilger <adilger.kernel@dilger.ca>, Alasdair G Kergon <agk@redhat.com>, linux-cifs@vger.kernel.org, Miklos Szeredi <miklos@szeredi.hu>, linux-ext4@vger.kernel.org, fuse-devel@lists.sourceforge.net, Mark Fasheh <mfasheh@suse.com>, xfs@oss.sgi.com, Ben Myers <bpm@sgi.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Anton Altaparmakov <anton@tuxera.com>, Alex Elder <elder@kernel.org>, Theodore Ts'o <tytso@mit.edu>, linux-ntfs-dev@lists.sourceforge.net, samba-technical@lists.samba.org, linux-kernel@vger.kernel.org, Steve French <sfrench@samba.org>, ocfs2-devel@oss.oracle.com, Linux FS Devel <linux-fsdevel@vger.kernel.org>, linux-btrfs@vger.kernel.org, Joel Becker <jlbec@evilplan.org>

On Sat, Apr 06, 2013 at 12:04:52PM +0200, Marco Stornelli wrote:
> In every place where sb_start_write was called now we must manage
> the error code and return -EINTR.

If we must manage the error code, then these functions should be marked
__must_check.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
