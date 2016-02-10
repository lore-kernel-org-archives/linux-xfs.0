Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 647967CAC
	for <xfs@oss.sgi.com>; Wed, 10 Feb 2016 13:34:07 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 23DD68F8052
	for <xfs@oss.sgi.com>; Wed, 10 Feb 2016 11:34:06 -0800 (PST)
Received: from fieldses.org (fieldses.org [173.255.197.46]) by cuda.sgi.com
	with ESMTP id cDwZ5J0IivgZZOPc for <xfs@oss.sgi.com>;
	Wed, 10 Feb 2016 11:34:04 -0800 (PST)
Date: Wed, 10 Feb 2016 14:34:04 -0500
From: "J. Bruce Fields" <bfields@fieldses.org>
Subject: Re: richacl(7) man page review comments
Message-ID: <20160210193404.GA13989@fieldses.org>
References: <56B770B6.7040803@gmail.com>
 <56B77262.7090107@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <56B77262.7090107@gmail.com>
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
To: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Cc: Andreas Dilger <adilger@dilger.ca>, linux-cifs@vger.kernel.org, linux-nfs@vger.kernel.org, Andreas Gruenbacher <agruenba@redhat.com>, Linux API <linux-api@vger.kernel.org>, Trond Myklebust <trond.myklebust@primarydata.com>, lkml <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org, Jeff Layton <jlayton@poochiereds.net>, linux-ext4@vger.kernel.org, Anna Schumaker <anna.schumaker@netapp.com>

On Sun, Feb 07, 2016 at 05:35:46PM +0100, Michael Kerrisk (man-pages) wrote:
> > This permission is always implicitly granted.
> > .HP
> > .B write_attributes
> > .RB ( A ):
> > Change the times associated with a file or directory to an arbitrary value.
> > This permission is always implicitly granted to the file owner.
> > .HP
> > .B read_acl
> > .RB ( c ):
> > Read the ACL of a file or directory. This permission is always
> > implicitly granted.
> > .HP
> > .B write_acl
> > .RB ( C ):
> > Change the ACL or file mode of a file or directory.
> > .HP
> > .B write_owner
> > .RB ( o ):
> > Take ownership of a file or directory.  Change the owning group of a file or
> > directory to a group of which the calling process is a member.
> > .HP
> > .B read_named_attrs
> > .RB ( R ),
> > .B write_named_attrs
> > .RB ( W ),
> > .B synchronize
> > .RB ( S ),
> > .B write_retention
> > .RB ( e ),
> > .B write_retention_hold
> > .RB ( E ):
> > These permissions can be stored, but do not have a local meaning.
> 
> So, I thenk that a sentence here should explain why these permissions
> exist. Is if for future extension, because they are meaningful in NFS,
> or something else?

Yeah, "synchronize" is something only Windows clients care about, as I
understand it.  The others are for NFS features that nobody has tried to
implement yet.  It's useful to store those bits but they don't do
anything at this point.  We could provie FC references, I guess, but
it's probably not worth going into much detail about.

> > Automatic Inheritance allows permission changes to propagate from a directory
> > to files and subdirectories inside that directory, recursively.  Carrying out
> > this propagation of permissions is the responsibility of the process changing
> > the directory permissions (usually, setrichacl(1)).
> 
> I'm confused by the previous sentence. the feature is labeled "Automatic
> Inheritance", implying that the user/process need do nothing. The next
> sentence says "propagation ... is the responsibility of the process".
> These two points seem contradictory. I think something more needs to be
> said here.

Yeah, the "automatic" name is probably misleading, but I think we're
stuck with that name and just need to make the point a bit more
forcefully.

Userland utilities take responsibility for the actual recursive
propagation of changes, all the kernel does is provide a few bits which
help to do it correctly (e.g. to distinguish between ACEs that ewre
inherited inherited (and can be blown away by propagation) and those
that were added locally).

--b.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
