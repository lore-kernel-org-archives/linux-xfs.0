Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nBLEEkt8046625 for <xfs@oss.sgi.com>; Mon, 21 Dec 2009 08:14:46 -0600
MIME-Version: 1.0
In-Reply-To: <20091221123654.GA9201@lst.de>
References: <4B2F6153.8010609@gmail.com> <20091221123654.GA9201@lst.de>
Date: Mon, 21 Dec 2009 22:15:26 +0800
Message-ID: <b3657a100912210615q1d55c334g73667e1c3a97ce05@mail.gmail.com>
Subject: Re: [PATCHv2 00/12]posix_acl: Add the check items
From: liu weni <qingshenlwy@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@lst.de>
Cc: adilger@sun.com, jack@suse.cz, neilb@suse.de, jeffm@suse.com, joel.becker@oracle.com, bfields@fieldses.org, linux-mtd@lists.infradead.org, onlyflyer@gmail.com, tiger.yang@oracle.com, strongzgy@gmail.com, ffilzlnx@us.ibm.com, sandeen@sandeen.net, jmorris@namei.org, cluster-devel@redhat.com, bharrosh@panasas.com, cjb@laptop.org, mfasheh@suse.com, aelder@sgi.com, reiserfs-devel@vger.kernel.org, xfs@oss.sgi.com, xfs-masters@oss.sgi.com, viro@zeniv.linux.org.uk, swhiteho@redhat.com, chris.mason@oracle.com, linux-nfs@vger.kernel.org, linux-ext4@vger.kernel.org, tytso@mit.edu, dwmw2@infradead.xn.org.cpa, linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, serue@us.ibm.com, akpm@linux-foundation.org, ocfs2-devel@oss.oracle.com

Thanks for your suggestion.

In my opinion the null point is a incorrect state for the acl, then I
return -EINVAL.

I will check this state transition in XFS.

2009/12/21 Christoph Hellwig <hch@lst.de>:
> I like taking these checks into posix_acl_valid, but I think the patch
> submission needs a bit more work.
>
> All the patches are extremly whitespace mangled. =A0And I don't think
> splitting them up makes a whole lot of sense, when we do API changes
> like this we usually fix up all callers. =A0So please try to fix your
> mailer, merged them all into one, and maybe also chose a more
> descriptive subject line, e.g.
>
> Subject: take checks for NULL and error pointers into posix_acl_valid()
>
>
> And btw, at least the XFS change seems incorrect - previously we
> returned NULL acl pointer and this patch changes it to -EINVAL.
>
>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
