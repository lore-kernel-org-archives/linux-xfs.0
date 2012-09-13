Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8D2NgVw093058 for <xfs@oss.sgi.com>; Wed, 12 Sep 2012 21:23:42 -0500
Received: from imap.thunk.org (li9-11.members.linode.com [67.18.176.11]) by
	cuda.sgi.com with ESMTP id ka6LlmidcJ4sq6K8 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 12 Sep 2012 19:24:47 -0700 (PDT)
Date: Wed, 12 Sep 2012 22:24:42 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
Subject: Re: Ubuntu Ext4 regression testing
Message-ID: <20120913022442.GB27544@thunk.org>
References: <50511241.2090603@canonical.com> <5051142D.1050603@redhat.com>
	<5051177E.6000903@canonical.com> <505126D4.5030106@redhat.com>
	<50512BB1.5010605@canonical.com> <50513C1A.9020504@redhat.com>
	<50513F22.3040201@canonical.com> <50514061.2050801@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <50514061.2050801@redhat.com>
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
Cc: Brad Figg <brad.figg@canonical.com>, linux-ext4@vger.kernel.org, xfs-oss <xfs@oss.sgi.com>

On Wed, Sep 12, 2012 at 09:09:37PM -0500, Eric Sandeen wrote:
> 
> Ah, I didn't know that autotest had a snapshot.  I wonder if there's
> a way to tease that back out, and pull down xfstests from git daily.
> 
> FWIW, it's a little confusing - we have 2 repos:
> 
> git://oss.sgi.com/xfs/cmds/xfstests.git
> git://git.kernel.org/pub/scm/fs/xfs/xfstests-dev.git

This may be helpful; I have a xfstests build environment here:

git://git.kernel.org/pub/scm/fs/ext2/xfstests-bld.git

It will automatically pull down the xfstests and xfsprogs from
git.kernel.org, and builds xfstests in a hermetic environment (i.e.,
it doesn't depend on version of xfsprogs, libacl, libaio,
etc. installed on the build system).  I set this up back when I was
doing most of my work using Ubuntu LTS 10.04, and the positively
ancient versions of libacl, libaio, xfsprogs-dev, etc., weren't
compatible with the bleeding edge of xfstests.

So I used this build environment so I wasn't dependent on the
vagrancies of whatever happened to be in Ubunutu LTS 10.04.

The makefiles in xfstests-bld will also generate a tar file containing
the necessary xfstests and xfsprogs binaries which I could then drop
into a debootstrap environment (I'm currently using a x86-32 Debian
unstable chroot) which I then use in my KVM image.  So it allows me to
get and build the very latest version of xfstests from git.kernel.org
in a highly automated fashion.

Regards,

						- Ted

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
