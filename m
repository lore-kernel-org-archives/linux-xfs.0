Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 4376D7F53
	for <xfs@oss.sgi.com>; Mon, 26 Oct 2015 18:52:18 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 06F2C304032
	for <xfs@oss.sgi.com>; Mon, 26 Oct 2015 16:52:14 -0700 (PDT)
Received: from mail-lf0-f51.google.com (mail-lf0-f51.google.com
	[209.85.215.51]) by cuda.sgi.com with ESMTP id GVmQsNaJg2TZENxi
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 26 Oct 2015 16:52:12 -0700 (PDT)
Received: by lfaz124 with SMTP id z124so164948423lfa.1
	for <xfs@oss.sgi.com>; Mon, 26 Oct 2015 16:52:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20151026213228.GI8773@dastard>
References: <CAHc6FU5gS4BA+iTRHo1oHJMVHkLs4aa0eYd5T1ftLC9biRaxrg@mail.gmail.com>
	<20151024125659.GA8095@bfoster.bfoster>
	<CAHc6FU6eVn=KpKvhD2N8hvAgdFQVdBHHS9tUgaVQJf5wnipY=g@mail.gmail.com>
	<20151024152254.GA22232@bfoster.bfoster>
	<20151026213228.GI8773@dastard>
Date: Tue, 27 Oct 2015 00:52:10 +0100
Message-ID: <CAHc6FU68MYTGWKM5S14_dQBqXeebd2GwQcKj4RztLvPWL2eksA@mail.gmail.com>
Subject: Re: Inconsistencies with trusted.SGI_ACL_{FILE,DEFAULT}
From: Andreas Gruenbacher <agruenba@redhat.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Brian Foster <bfoster@redhat.com>, xfs@oss.sgi.com

On Mon, Oct 26, 2015 at 10:32 PM, Dave Chinner <david@fromorbit.com> wrote:
> Really, I'm struggling to understand what the problem is with XFS
> doing translation to it's own special xattr names for ACLs
> underneath the posix layer.

Right now, setting one of the SGI_ACL attributes leads to stale i_acl
/ i_default_acl fields and in the case of SGI_ACL_FILE, possibly to
outdated permissions in i_mode. You would get different information
from getfacl than what's stored on disk.

> Yes, there's a caching issue when someone directly manipulates
> the underlying xattr,

"Directly manipulating" could be doing a setxattr of an attribute that
was previously retrieved by getxattr, like restoring a backup.

> but you need root to shoot yourself in the foot that way, and that is easily
> solveable.

What do you mean, it's easily solvable?

Thanks,
Andreas

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
