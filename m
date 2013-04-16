Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 317697F37
	for <linux-xfs@oss.sgi.com>; Tue, 16 Apr 2013 14:19:56 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 1357B8F8081
	for <linux-xfs@oss.sgi.com>; Tue, 16 Apr 2013 12:19:53 -0700 (PDT)
Received: from a.mx.filmlight.ltd.uk (a.mx.filmlight.ltd.uk [77.107.81.250])
	by cuda.sgi.com with SMTP id FTwhP6JA0HBZipfK for
	<linux-xfs@oss.sgi.com>; Tue, 16 Apr 2013 12:19:51 -0700 (PDT)
Subject: Re: xfs_repair misses an fs error?
From: Roger Willcocks <roger@filmlight.ltd.uk>
In-Reply-To: <6qi04axkbr.ln2@goaway.wombat.san-francisco.ca.us>
References: <k5gu3axace.ln2@goaway.wombat.san-francisco.ca.us>
	<20130416162557.GD13938@destitution>
	<6qi04axkbr.ln2@goaway.wombat.san-francisco.ca.us>
Date: Tue, 16 Apr 2013 20:19:50 +0100
Message-Id: <1366139990.4522.97.camel@montana.filmlight.ltd.uk>
Mime-Version: 1.0
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
To: Keith Keller <kkeller@wombat.san-francisco.ca.us>
Cc: linux-xfs@oss.sgi.com

On Tue, 2013-04-16 at 11:44 -0700, Keith Keller wrote:
> On 2013-04-16, Dave Chinner <david@fromorbit.com> wrote:
> >
> > Not recently. What version of xfs_repair are you using?
> 
> Hmm, perhaps this is a difference.  I believe (though, again I did very
> poor logging, and I apologize) that the initial repair used 3.1.1.  The
> recent successful repair definitely used 3.1.10.  Is it possible 3.1.1
> is old enough that it might not have caught the issues I reported from
> the 3.1.10 log?
> 

Yes, we had a system here for which xfs_repair 3.1.6 reported for 30 or
so files:

   data fork in regular inode 3238731555 claims used block 1080914355
   correcting nblocks for inode 3238731555, was 304 - counted 0

in phase three, and 

   correcting nblocks for inode 3238731555, was 0 - counted 304

in phase four, so the filesystem ended up back where it started. Version
3.1.8 fixed this, reporting instead e.g.:

   data fork in regular inode 3238731617 claims used block 1080933203
   correcting nextents for inode 3238731617
   correcting nblocks for inode 3238731617, was 304 - counted 0
   correcting nextents for inode 3238731617, was 1 - counted 0

> 
-- 
Roger Willcocks <roger@filmlight.ltd.uk>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
