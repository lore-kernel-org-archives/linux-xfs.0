Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5241BIq168441 for <xfs@oss.sgi.com>; Wed, 1 Jun 2011 23:01:12 -0500
Received: from test.thunk.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 091D1495EB5
	for <xfs@oss.sgi.com>; Wed,  1 Jun 2011 21:01:10 -0700 (PDT)
Received: from test.thunk.org (li9-11.members.linode.com [67.18.176.11]) by
	cuda.sgi.com with ESMTP id maNjylzvYsQONeGL for
	<xfs@oss.sgi.com>; Wed, 01 Jun 2011 21:01:10 -0700 (PDT)
Date: Wed, 1 Jun 2011 21:47:04 -0400
From: "Ted Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH] xfstests: add support for ext4dev FSTYP
Message-ID: <20110602014704.GA16306@thunk.org>
References: <BANLkTimBnAgiXZnvS56eAzEdJ=kw1zVGsg@mail.gmail.com>
	<4DE5C1FE.8080006@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4DE5C1FE.8080006@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, Ext4 Developers List <linux-ext4@vger.kernel.org>, Sergey Ivanov <sergey57@gmail.com>, Amir Goldstein <amir73il@gmail.com>, XFS <xfs@oss.sgi.com>

On Tue, May 31, 2011 at 11:37:18PM -0500, Eric Sandeen wrote:
> 
> I'm less certain of the change from fsck -t $FSTYP to fsck.$FSTYP
> 
> What issue are you avoiding?  wouldn't fsck -t ext4dev invoke
> fsck.ext4dev anyway?

This is a change I make locally when I've been debugging my bigalloc
code as well.  There reason for that is because I want to override the
fsck.ext4 that would get used by using path hacking.  The problem was
that fsck -t ext4 will look for /sbin/fsck.ext4, where as I wanted it
to use the fsck.ext4 that was first in the PATH.

So I changed "/sbin/fsck -t $FSTYP" to "fsck.$FSTYP" and made sure
/sbin was tacked onto the path. 

It might be that the right answer is that fsck should have an
environment variable or some other way of controlling the search path
it uses to find the fsck.XXX binary.

						- Ted

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
