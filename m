Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id DB7967F63
	for <xfs@oss.sgi.com>; Thu, 30 Jan 2014 13:42:30 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 61CDAAC00A
	for <xfs@oss.sgi.com>; Thu, 30 Jan 2014 11:42:27 -0800 (PST)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id s822VRq2SUCORFbH (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 30 Jan 2014 11:42:26 -0800 (PST)
Date: Thu, 30 Jan 2014 20:42:24 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: [RFC] A draft for making ext4 support project quota
Message-ID: <20140130194224.GA22955@quack.suse.cz>
References: <20140128064248.GA8653@gmail.com>
	<20140128143514.GB13676@quack.suse.cz>
	<20140129034824.GA12757@gmail.com>
	<A5AD0D66-C4F5-4177-9F87-E3BC59B348B8@dilger.ca>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <A5AD0D66-C4F5-4177-9F87-E3BC59B348B8@dilger.ca>
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
To: Andreas Dilger <adilger@dilger.ca>
Cc: Theodore Ts'o <tytso@mit.edu>, Zheng Liu <gnehzuil.liu@gmail.com>, xfs@oss.sgi.com, Ben Myers <bpm@sgi.com>, Dmitry Monakhov <dmonakhov@openvz.org>, Li Xi <pkuelelixi@gmail.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Jan Kara <jack@suse.cz>, linux-ext4 <linux-ext4@vger.kernel.org>

On Thu 30-01-14 11:57:10, Andreas Dilger wrote:
> On Jan 28, 2014, at 8:48 PM, Zheng Liu <gnehzuil.liu@gmail.com> wrote:
> > On Tue, Jan 28, 2014 at 03:35:14PM +0100, Jan Kara wrote:
> >> On Tue 28-01-14 14:42:49, Zheng Liu wrote:
> >>> For project quota, the key issue is how to handle link(2)/rename(2).  We
> >>> summarize the behaviour in xfs as following.
> >>> 
> >>> *Note*
> >>> + unaccounted dir
> >>> x accounted dir
> >>> 
> >>> link(2)
> >>> -------
> >>> 		+		x
> >>> +		ok		error (EXDEV)
> >>> x		ok		error (EXDEV)
> 
> Presumably this accounted-to-accounted link() is only an error if
> it is between directories of two different projects?
  Yes, I understand it that way.

> >>> rename(2)
> >>> ---------
> >>> 		+		x
> >>> +		ok		ok
> >>> x		wrong		ok
> >> 
> >>  So moving unaccounted file/dir into an accounted dir would be OK? How is
> >> that?
> > 
> > Actually xfs will return EXDEV error when we try to move unaccounted
> > file/dir into an accounted dir.  Then userspace tools (e.g. mv(1)) will
> > use create(2)/read(2)/write(2) syscalls to create these files/dirs from
> > scratch, and get the same id from their parent.
> 
> Why wouldn't renaming an unaccounted file into an accounted directory
> just be implemented by doing the equivalent of chown() to change the
> project ID and setting the quota?  That could avoid a HUGE amount of
> data copying for large files.
  Well, the trouble is not so much with a file but with a directory. If you
move an unaccounted directory in an accounted dir, you would have to
recursively go through it and account each file. That isn't possible to do
reliably from the kernel... And allowing files but disallowing dirs seems
inconsistent so I'm in favor of a simple API.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
