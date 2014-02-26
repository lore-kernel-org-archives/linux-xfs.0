Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 8ED107F3F
	for <xfs@oss.sgi.com>; Wed, 26 Feb 2014 10:48:41 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 571D08F8052
	for <xfs@oss.sgi.com>; Wed, 26 Feb 2014 08:48:38 -0800 (PST)
Date: Wed, 26 Feb 2014 11:48:28 -0500
From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v6] ext4: Add support FALLOC_FL_COLLAPSE_RANGE for
	fallocate
Message-ID: <20140226164827.GB11452@thunk.org>
References: <1392908861-3563-1-git-send-email-linkinjeon@gmail.com>
	<20140222170930.GE26637@thunk.org>
	<CAKYAXd9vTbjTnJOQ1Y=pi4QJSYj41fWsQgRD3Fkufskez2W-YA@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAKYAXd9vTbjTnJOQ1Y=pi4QJSYj41fWsQgRD3Fkufskez2W-YA@mail.gmail.com>
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
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: jack@suse.cz, Namjae Jeon <namjae.jeon@samsung.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, bpm@sgi.com, adilger.kernel@dilger.ca, mtk.manpages@gmail.com, Ashish Sangwan <a.sangwan@samsung.com>, linux-fsdevel@vger.kernel.org, lczerner@redhat.com, linux-ext4@vger.kernel.org, viro@zeniv.linux.org.uk

On Mon, Feb 24, 2014 at 10:22:10AM +0900, Namjae Jeon wrote:
> >> +	ret = ext4_es_remove_extent(inode, punch_start,
> >> +				    EXT_MAX_BLOCKS - punch_start - 1);
> >> +	if (ret) {
> >> +		up_write(&EXT4_I(inode)->i_data_sem);
> >> +		goto out_stop;
> >> +	}
> >
> > Doing this at first is probably a bad idea; you should do this at the
> > end, and then completely invalidate the es cache for that inode.  That
> > way, the right thing happens if you get an error in the middle
> > releasing the boxes and shifting the extents:
> Okay, I see.

Actually, thinking about this some more, we do want to do this first,
since if we error out, we do need to make sure the extent cache is
flushed.

> If there is error in the middle of extent shifting, the hole will
> present between the last shifted extent and the extent at which error
> happen so this will be consistent state.
> IMHO even if there is error in between the shift, filesystem will be
> in consistent state.
> Am I missing something?

No, I was wrong about that; you're right.  The file will be in an
inconsistent statement, which will probably be highly confusing for
the application, but the file system will be fine.

So I withdraw my complaints.  I'll do a bit more testing, but so far
the patch looks fine to me.  Thanks for your reply and your work!

					- Ted

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
