Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id F338B7F54
	for <xfs@oss.sgi.com>; Wed,  7 Jan 2015 04:17:27 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D25F28F8037
	for <xfs@oss.sgi.com>; Wed,  7 Jan 2015 02:17:27 -0800 (PST)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id zFqLJZjHvpUeDF3b (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 07 Jan 2015 02:17:23 -0800 (PST)
Date: Wed, 7 Jan 2015 11:17:17 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: File type is occasionally wrong
Message-ID: <20150107101717.GC23069@quack.suse.cz>
References: <20150106135608.GB15729@quack.suse.cz>
	<20150106142331.GD5874@bfoster.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150106142331.GD5874@bfoster.bfoster>
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
To: Brian Foster <bfoster@redhat.com>
Cc: Jan Kara <jack@suse.cz>, xfs@oss.sgi.com

On Tue 06-01-15 09:23:31, Brian Foster wrote:
> On Tue, Jan 06, 2015 at 02:56:08PM +0100, Jan Kara wrote:
> >   Hello,
> > 
> >   I've got two reports of XFS filesystem corruption where file type is
> > wrong. Both machines are running fairly recent kernels (currently
> > 3.19-rc2) but it's hard to say when the corruption started to happen since
> > it isn't easily observable.
> > 
> 
> No theories off the top of my head, but is some kind of unclean shutdown
> involved? I ask because the repair output also warns of populated agi
> unlinked buckets. IIRC, that should all be cleaned up on umount.
  Yeah, I've noticed those as well. The guy said he isn't sure whether the
fs was cleanly unmounted or not - maybe it got stuck on something during
shutdown for fsck and watchdog rebooted it after a while.

								Honza

> > Attached is xfs_repair log. The interesting part there is:
> > would fix ftype mismatch (7/1) in directory/child inode 805307401/805388292
> > would fix ftype mismatch (1/7) in directory/child inode 805307401/805388295
> > would fix ftype mismatch (7/1) in directory/child inode 939525153/939541565
> > would fix ftype mismatch (7/1) in directory/child inode 939525153/939540212
> > would fix ftype mismatch (7/1) in directory/child inode 939525153/939539662
> > would fix ftype mismatch (7/1) in directory/child inode 939525153/939525162
> > would fix ftype mismatch (7/1) in directory/child inode 939525153/939525165
> > would fix ftype mismatch (7/1) in directory/child inode 939525153/939529260
> > would fix ftype mismatch (7/1) in directory/child inode 939525153/939540177
> > would fix ftype mismatch (1/7) in directory/child inode 939525153/939539749
> > would fix ftype mismatch (1/7) in directory/child inode 939525153/939529266
> > would fix ftype mismatch (1/7) in directory/child inode 939525153/939541566
> > would fix ftype mismatch (1/7) in directory/child inode 939525153/939540205
> > would fix ftype mismatch (1/7) in directory/child inode 939525153/939540211
> > would fix ftype mismatch (1/7) in directory/child inode 939525153/939525182
> > would fix ftype mismatch (1/7) in directory/child inode 939525153/939540269
> > 
> > So it seems that the file type between a regular file and a symlink gets
> > swapped. Since both directories where corruption happens are relatively
> > large (13 and 9 blocks respectively - they are /usr/bin and
> > /usr/share/man/man8) it seems as if file type wasn't properly updated when
> > the directory entry tree is updated or something like that. I have briefly
> > looked into the code but from a first look everything looks fine there...
> > 
> > I have also metadump without obfuscated names available so I can
> > provide that on request. Interestingly, in the second directory all the
> > directory entries for regular files that have file type set as symlink are
> > in the first directory block while inconsistency in other direction is in
> > other directory blocks.
> > 
> > I will be looking into this further but if some more knowledgeable has an
> > idea it would be welcome.
> > 
> > 								Honza
> > 
> > -- 
> > Jan Kara <jack@suse.cz>
> > SUSE Labs, CR
> 
> > Phase 1 - find and verify superblock...
> >         - reporting progress in intervals of 15 minutes
> > Phase 2 - using internal log
> >         - scan filesystem freespace and inode maps...
> > agi unlinked bucket 47 is 73775 in ag 15 (inode=2013339695)
> > agi unlinked bucket 49 is 73777 in ag 15 (inode=2013339697)
> > agi unlinked bucket 52 is 73780 in ag 15 (inode=2013339700)
> > agi unlinked bucket 53 is 73781 in ag 15 (inode=2013339701)
> >         - 09:47:30: scanning filesystem freespace - 32 of 32 allocation groups done
> >         - found root inode chunk
> > Phase 3 - for each AG...
> >         - scan (but don't clear) agi unlinked lists...
> >         - 09:47:30: scanning agi unlinked lists - 32 of 32 allocation groups done
> >         - process known inodes and perform inode discovery...
> >         - agno = 0
> >         - agno = 30
> >         - agno = 15
> >         - agno = 16
> >         - agno = 1
> >         - agno = 31
> >         - agno = 17
> >         - agno = 2
> >         - agno = 18
> >         - agno = 3
> >         - agno = 19
> >         - agno = 4
> >         - agno = 20
> >         - agno = 5
> >         - agno = 21
> >         - agno = 22
> >         - agno = 6
> >         - agno = 23
> >         - agno = 7
> >         - agno = 24
> >         - agno = 8
> >         - agno = 9
> >         - agno = 25
> >         - agno = 10
> >         - agno = 26
> >         - agno = 11
> >         - agno = 27
> >         - agno = 28
> >         - agno = 12
> >         - agno = 29
> >         - agno = 13
> >         - agno = 14
> >         - 09:47:38: process known inodes and inode discovery - 133312 of 133312 inodes done
> >         - process newly discovered inodes...
> >         - 09:47:38: process newly discovered inodes - 32 of 32 allocation groups done
> > Phase 4 - check for duplicate blocks...
> >         - setting up duplicate extent list...
> >         - 09:47:38: setting up duplicate extent list - 32 of 32 allocation groups done
> >         - check for inodes claiming duplicate blocks...
> >         - agno = 0
> >         - agno = 1
> >         - agno = 2
> >         - agno = 3
> >         - agno = 4
> >         - agno = 5
> >         - agno = 6
> >         - agno = 7
> >         - agno = 8
> >         - agno = 9
> >         - agno = 10
> >         - agno = 11
> >         - agno = 12
> >         - agno = 13
> >         - agno = 14
> >         - agno = 15
> >         - agno = 16
> >         - agno = 17
> >         - agno = 18
> >         - agno = 19
> >         - agno = 20
> >         - agno = 21
> >         - agno = 22
> >         - agno = 23
> >         - agno = 24
> >         - agno = 25
> >         - agno = 26
> >         - agno = 27
> >         - agno = 28
> >         - agno = 29
> >         - agno = 30
> >         - agno = 31
> >         - 09:47:38: check for inodes claiming duplicate blocks - 133312 of 133312 inodes done
> > No modify flag set, skipping phase 5
> > Phase 6 - check inode connectivity...
> >         - traversing filesystem ...
> > would fix ftype mismatch (7/1) in directory/child inode 805307401/805388292
> > would fix ftype mismatch (1/7) in directory/child inode 805307401/805388295
> > would fix ftype mismatch (7/1) in directory/child inode 939525153/939541565
> > would fix ftype mismatch (7/1) in directory/child inode 939525153/939540212
> > would fix ftype mismatch (7/1) in directory/child inode 939525153/939539662
> > would fix ftype mismatch (7/1) in directory/child inode 939525153/939525162
> > would fix ftype mismatch (7/1) in directory/child inode 939525153/939525165
> > would fix ftype mismatch (7/1) in directory/child inode 939525153/939529260
> > would fix ftype mismatch (7/1) in directory/child inode 939525153/939540177
> > would fix ftype mismatch (1/7) in directory/child inode 939525153/939539749
> > would fix ftype mismatch (1/7) in directory/child inode 939525153/939529266
> > would fix ftype mismatch (1/7) in directory/child inode 939525153/939541566
> > would fix ftype mismatch (1/7) in directory/child inode 939525153/939540205
> > would fix ftype mismatch (1/7) in directory/child inode 939525153/939540211
> > would fix ftype mismatch (1/7) in directory/child inode 939525153/939525182
> > would fix ftype mismatch (1/7) in directory/child inode 939525153/939540269
> >         - traversal finished ...
> >         - moving disconnected inodes to lost+found ...
> > disconnected inode 2013339695, would move to lost+found
> > disconnected inode 2013339697, would move to lost+found
> > disconnected inode 2013339700, would move to lost+found
> > disconnected inode 2013339701, would move to lost+found
> > Phase 7 - verify link counts...
> > would have reset inode 2013339695 nlinks from 0 to 1
> > would have reset inode 2013339697 nlinks from 0 to 1
> > would have reset inode 2013339700 nlinks from 0 to 1
> > would have reset inode 2013339701 nlinks from 0 to 1
> > No modify flag set, skipping filesystem flush and exiting.
> 
> > _______________________________________________
> > xfs mailing list
> > xfs@oss.sgi.com
> > http://oss.sgi.com/mailman/listinfo/xfs
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
