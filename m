Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id ABF5B7FB7
	for <xfs@oss.sgi.com>; Tue,  3 Nov 2015 20:28:07 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 248CFAC001
	for <xfs@oss.sgi.com>; Tue,  3 Nov 2015 18:28:07 -0800 (PST)
Received: from mail-lb0-f179.google.com (mail-lb0-f179.google.com
	[209.85.217.179]) by cuda.sgi.com with ESMTP id
	88WBnwZmPhskWlPV (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 03 Nov 2015 18:28:05 -0800 (PST)
Received: by lbbkw15 with SMTP id kw15so46747lbb.0
	for <xfs@oss.sgi.com>; Tue, 03 Nov 2015 18:28:03 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <06282344-726E-49AD-936B-7BFF8F43B967@dilger.ca>
References: <1446563847-14005-1-git-send-email-agruenba@redhat.com>
	<1446563847-14005-22-git-send-email-agruenba@redhat.com>
	<06282344-726E-49AD-936B-7BFF8F43B967@dilger.ca>
Date: Wed, 4 Nov 2015 03:28:03 +0100
Message-ID: <CAHc6FU46EuDQ0S9TPYuLosHvppsqcqOF_oxxgTFHr+uXj59Drg@mail.gmail.com>
Subject: Re: [PATCH v13 21/51] ext4: Add richacl feature flag
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
To: Andreas Dilger <adilger@dilger.ca>
Cc: linux-cifs@vger.kernel.org, Linux NFS Mailing List <linux-nfs@vger.kernel.org>, Theodore Ts'o <tytso@mit.edu>, Linux API <linux-api@vger.kernel.org>, Trond Myklebust <trond.myklebust@primarydata.com>, LKML <linux-kernel@vger.kernel.org>, XFS Developers <xfs@oss.sgi.com>, "J. Bruce Fields" <bfields@fieldses.org>, Andreas Dilger <adilger.kernel@dilger.ca>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Jeff Layton <jlayton@poochiereds.net>, linux-ext4 <linux-ext4@vger.kernel.org>, Anna Schumaker <anna.schumaker@netapp.com>, "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>

Andreas,

On Wed, Nov 4, 2015 at 3:18 AM, Andreas Dilger <adilger@dilger.ca> wrote:
> This patch confuses me.  I thought the whole point of INCOMPAT_RICHACL
> was that the filesystem should never, ever be mounted without ACL support
> because the ACLs will get confused without it.  In that case, it doesn't
> make sense to have a mount option that _has_ to be specified to mount the
> filesystem, and returns an error when trying to disable it.
>
> It makes more sense to just enable "acl" by default if INCOMPAT_RICHACL
> is set in the superblock and not need the mount option at all.

It's the commit message that's misleading here, I'll fix it. On
richacl filesystems, the acl mount option is always on. It's only on
POSIX ACL filesystems that the mount option can be used to turn POSIX
ACLs off (which arguably wasn't such a good idea, but there we have
it).

Thanks,
Andreas

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
