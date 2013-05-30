Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 52EF17F37
	for <xfs@oss.sgi.com>; Thu, 30 May 2013 14:57:29 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 206BF304066
	for <xfs@oss.sgi.com>; Thu, 30 May 2013 12:57:26 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id HGxPe71RQcreDosI for <xfs@oss.sgi.com>;
	Thu, 30 May 2013 12:57:24 -0700 (PDT)
Date: Thu, 30 May 2013 21:57:23 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 2/3] 285: Fix file syncing
Message-ID: <20130530195723.GB586@quack.suse.cz>
References: <1369917939-22660-1-git-send-email-jack@suse.cz>
	<1369917939-22660-2-git-send-email-jack@suse.cz>
	<51A75872.4080909@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <51A75872.4080909@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>, xfs@oss.sgi.com

On Thu 30-05-13 08:47:30, Eric Sandeen wrote:
> On 5/30/13 7:45 AM, Jan Kara wrote:
> > The intention of tests 08 and 09 in test generic/285 is to sync the
> > whole file before checking for data and holes. However the helper is
> > called with nbytes argument set to 0 which results in not syncing
> > anything. Set nbytes properly.
> 
> Hm, are you sure? (Is the man page wrong, or is the sync_file_range
> implementation wrong?)
> 
> DESCRIPTION
>        sync_file_range()  permits  fine  control when synchronizing the
>        open file referred to by the file descriptor fd with disk.
> 
>        offset is the starting byte of the file  range  to  be  synchro-
>        nized.   nbytes specifies the length of the range to be synchro-
>        nized, in bytes; if nbytes is zero, then all bytes  from  offset
>        through to the end of file are synchronized.
  My fault that I didn't read the manpage carefully enough. Scratch this
patch.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
