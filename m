Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7E0u82W062416 for <xfs@oss.sgi.com>; Thu, 13 Aug 2009 19:56:19 -0500
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D6F1D3CB21B
	for <xfs@oss.sgi.com>; Thu, 13 Aug 2009 17:56:54 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [66.187.233.31]) by cuda.sgi.com
	with ESMTP id C9jIQgmNj6sBHP2z for <xfs@oss.sgi.com>;
	Thu, 13 Aug 2009 17:56:54 -0700 (PDT)
Date: Thu, 13 Aug 2009 20:56:52 -0400 (EDT)
From: Lachlan McIlroy <lmcilroy@redhat.com>
Message-ID: <318271513.1935011250211412750.JavaMail.root@zmail05.collab.prod.int.phx2.redhat.com>
In-Reply-To: <139598026.1934901250211190252.JavaMail.root@zmail05.collab.prod.int.phx2.redhat.com>
Subject: Re: [PATCH] xfs_io: actually issue 0 size writes
MIME-Version: 1.0
Reply-To: Lachlan McIlroy <lmcilroy@redhat.com>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs mailing list <xfs@oss.sgi.com>


----- "Eric Sandeen" <sandeen@sandeen.net> wrote:

> Felix Blyakher wrote:
> > On Aug 13, 2009, at 5:15 PM, Eric Sandeen wrote:
> > 
> >> While testing some stuff in generic_write_checks() in the
> >> kernel I realized that you can't actually use xfs_io to send
> >> a 0-byte write in.  This is actually a condition worth testing:
> >>
> >>       If  count  is zero and fd refers to a regular file,
> >>       then write() may return a failure status if one  of
> >>       the  errors  below  is  detected.  If no errors are
> >>       detected, 0 will be returned  without  causing  any
> >>       other  effect.
> > 
> > As I understand the desire to be able to issue 0 size writes
> > from xfs_io is to test the possibility of writing to a given fd.
> > What kind of errors would you expect to test for?
> 
> In general EFBIG or ENOSPC.
> 
> This sort of thing in generic_write_checks():
> 
>         if (unlikely(*pos >= inode->i_sb->s_maxbytes)) {
>                 if (*count || *pos > inode->i_sb->s_maxbytes) {
>                      return -EFBIG;
>                 }
>                 /* zero-length writes at ->s_maxbytes are OK */
>         }
> 
> Although I'm a little confused about why "*pos == s_maxbytes" is ok;
> I
> thought s_maxbytes was a count/size whereas pos is an offset, so it
> seems to me that pos == s_maxbytes is one past the max.  But anyway,
> that's mostly unrelated to the patch in this thread.  :)
pos == s_maxbytes is only okay if count == 0 also.  So even though we
are writing at the limit we are not actually going to write anything.
At s_maxbytes-1 we are allowed to write one byte and at s_maxbytes we
are allowed to write nothing - literally.

> 
> -Eric
> 
> > Otherwise looks good.
> > 
> > Felix
> 
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
