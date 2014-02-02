Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id D8D8F7F8E
	for <xfs@oss.sgi.com>; Sun,  2 Feb 2014 09:21:09 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 69ACCAC001
	for <xfs@oss.sgi.com>; Sun,  2 Feb 2014 07:21:09 -0800 (PST)
Received: from mail.parisc-linux.org (palinux.external.hp.com [192.25.206.14])
	by cuda.sgi.com with ESMTP id 2BvwDydgJzyq7rCB (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 02 Feb 2014 07:21:08 -0800 (PST)
Date: Sun, 2 Feb 2014 08:21:06 -0700
From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH RESEND 0/10] fs: Introduce new
	flag(FALLOC_FL_COLLAPSE_RANGE) for fallocate
Message-ID: <20140202152106.GL20939@parisc-linux.org>
References: <1391319694-3089-1-git-send-email-linkinjeon@gmail.com>
	<20140202151624.GK20939@parisc-linux.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140202151624.GK20939@parisc-linux.org>
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
Cc: tytso@mit.edu, Namjae Jeon <namjae.jeon@samsung.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, bpm@sgi.com, adilger.kernel@dilger.ca, viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org, jack@suse.cz, linux-ext4@vger.kernel.org, mtk.manpages@gmail.com

On Sun, Feb 02, 2014 at 08:16:24AM -0700, Matthew Wilcox wrote:
> On Sun, Feb 02, 2014 at 02:41:34PM +0900, Namjae Jeon wrote:
> > The semantics of this flag are following:
> > 1) It collapses the range lying between offset and length by removing any data
> >    blocks which are present in this range and than updates all the logical
> >    offsets of extents beyond "offset + len" to nullify the hole created by
> >    removing blocks. In short, it does not leave a hole.
> > 2) It should be used exclusively. No other fallocate flag in combination.
> > 3) Offset and length supplied to fallocate should be fs block size aligned
> >    in case of xfs and ext4.
> > 4) Collaspe range does not work beyond i_size.
> 
> What if the file is mmaped at the time somebody issues this command?
> Seems to me we should drop pagecache pages that overlap with the
> removed blocks.  If the removed range is not a multiple of PAGE_SIZE,
> then we should also drop any pagecache pages after the removed range.

Oops, forgot to add "and if it is a multiple of page size, then we need
to update the offsets of any pages after the removed page".  We should
probably start easy though; just drop all pages that overlap the beginning
of the affected range to the end of the file.  At some later point,
if there's demand, we can add the optimisation to adjust the offsets of
pages still in the cache.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
