Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 26 Aug 2008 21:18:47 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m7R4Icoe017954
	for <xfs@oss.sgi.com>; Tue, 26 Aug 2008 21:18:38 -0700
Date: Wed, 27 Aug 2008 14:21:34 +1000
Subject: Re: REVIEW: xfs_repair fixes for bad directories
From: "Barry Naujok" <bnaujok@sgi.com>
Content-Type: text/plain; format=flowed; delsp=yes; charset=utf-8
MIME-Version: 1.0
References: <op.udlsirmx3jf8g2@pc-bnaujok.melbourne.sgi.com>
 <20080826193205.GA31105@infradead.org>
Content-Transfer-Encoding: 7bit
Message-ID: <op.ugi2d81d3jf8g2@pc-bnaujok.melbourne.sgi.com>
In-Reply-To: <20080826193205.GA31105@infradead.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Wed, 27 Aug 2008 05:32:05 +1000, Christoph Hellwig <hch@infradead.org>  
wrote:

> On Tue, Jul 01, 2008 at 06:00:17PM +1000, Barry Naujok wrote:
>
>> 2. An update a while ago to xfs_repair attempts to fix invalid
>>    ".." entries for subdirectories where there is a valid parent
>>    with the appropriate entry. It was a partial fix that never
>>    did the full job, especially if the subdirectory was short-
>>    form or it has already been processed.
>>
>>    Patch fix_dir_rebuild_without_dotdot_entry.patch creates a
>>    post-processing queue after the main scan to update any
>>    directories with an invalid ".." entry.
>
> Where is the existing attemp?  I can't find code doing anything like
> that removed in the patch.  But the actual patch looks good, while
> I had this mess with the tons of different boolean flags in repair
> converting these to a more descriptive bitmask should be a different
> patch.

A while ago, when we found some directories couldn't be deleted
as their "." and ".." entries were in different blocks, code was
added to detect this and fix it up, including restoring ".."
entries that were missing in phase 6:

  		} else if (parent == ip->i_ino)  {
  			add_inode_reached(irec, ino_offset);
  			add_inode_ref(current_irec, current_ino_offset);
+		} else if (parent == NULLFSINO) {
+			/* ".." was missing, but this entry refers to it,
+			   so, set it as the parent and mark for rebuild */
+			do_warn(_("entry \"%s\" in dir ino %llu doesn't have a"
+				" .. entry, will set it in ino %llu.\n"),
+				fname, ip->i_ino, inum);
+			set_inode_parent(irec, ino_offset, ip->i_ino);
+			add_inode_reached(irec, ino_offset);
+			add_inode_ref(current_irec, current_ino_offset);
  		} else  {
  			junkit = 1;
  			do_warn(


It didn't quite work in the end depending on the order of inode scanning!

So, this patch added that post-processing queue to make sure it always  
works.
