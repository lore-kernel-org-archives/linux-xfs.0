Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 5EADD7F3F
	for <xfs@oss.sgi.com>; Wed, 14 May 2014 11:05:00 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 4A9E130404E
	for <xfs@oss.sgi.com>; Wed, 14 May 2014 09:04:57 -0700 (PDT)
Received: from imap.thunk.org (imap.thunk.org [74.207.234.97]) by cuda.sgi.com
	with ESMTP id TMZ4dOsISpoq2CBY (version=TLSv1 cipher=AES128-SHA
	bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 14 May 2014 09:04:52 -0700 (PDT)
Date: Wed, 14 May 2014 16:04:47 +0000
From: tytso@mit.edu
Subject: Re: Separate mailing list for xfstests
Message-ID: <20140514160447.GA3974@thunk.org>
References: <alpine.LFD.2.00.1405141508150.9727@localhost.localdomain>
	<53738316.20601@redhat.com> <53738597.70305@fb.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <53738597.70305@fb.com>
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
To: Chris Mason <clm@fb.com>
Cc: Eric Sandeen <sandeen@redhat.com>, xfs@oss.sgi.com, dchinner@redhat.com, linux-fsdevel@vger.kernel.org, =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>, linux-ext4@vger.kernel.org

On Wed, May 14, 2014 at 11:02:47AM -0400, Chris Mason wrote:
> >> linux-fsdevel might seem as a good candidate for it, but still I
> >> think that it deserves a separate ML to point people to.

I'm personally in favor of using linux-fsdevel since it might
encourage more fs developers who aren't using xfstests yet to start
using it.

For example, we started investigating using xfstests to test unionfs,
and pretty quickly found problems.  (I suspect the same problem exists
in AUFS, BTW, but I've been focusing on unionfs because it's simpler
and less scary.)  The patches to enable the use of xfstests to test
unionfs are still pretty rough, but hopefully we'll get those sent to
Dave once they are cleaned up a bit.

					- Ted

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
