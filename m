Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o7G1PqJq209966 for <xfs@oss.sgi.com>; Sun, 15 Aug 2010 20:25:52 -0500
Received: from postoffice2.aconex.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2EA53CB2D65
	for <xfs@oss.sgi.com>; Sun, 15 Aug 2010 18:35:11 -0700 (PDT)
Received: from postoffice2.aconex.com (mail.aconex.com [203.89.202.182]) by
	cuda.sgi.com with ESMTP id OJa3xV9vkfgxhaHa for
	<xfs@oss.sgi.com>; Sun, 15 Aug 2010 18:35:11 -0700 (PDT)
Date: Mon, 16 Aug 2010 11:25:59 +1000 (EST)
From: Nathan Scott <nathans@aconex.com>
Message-ID: <1697333467.18161281921959476.JavaMail.root@mail-au.aconex.com>
In-Reply-To: <20100814111513.GA8214@infradead.org>
Subject: Re: xfsprogs Debian mantainaince
MIME-Version: 1.0
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
To: Christoph Hellwig <hch@infradead.org>
Cc: nathans@debian.org, anibal@debian.org, xfs@oss.sgi.com


----- "Christoph Hellwig" <hch@infradead.org> wrote:

> Hi Nathan, hi Anibal,
> 
> if seen the constant flipping between native and non-native uploads
> for the xfsprogs Debian packages between the two of you and it's
> slightly annoying.  I know Nathan likes maintaining the Debian
> packages
> in git, which also makes life for us XFS developers trying to build
> debian packages a lot easier.
> 
> What about a compromise?  We'll add a debian-<dist> branches to the
> xfsprogs-dev repository where we can track the exact packages
> uploaded
> to Debian, including the -2/-3 etc packages revisions that only get
> uploaded to Debian,

IMO, the -2 and -3 revisions are unnecessary and there's really no need
for a separate branch ... if Anibal had a kernel.org account and merged
changes in before uploading, there'd be no issue, I think - Anibal?  It
would make life simpler, for sure.

> And one last request, any chance to get xfsprogs for -testing rebuilt
> against libblkid now that util-linux-2.17 has finally made it into
> testing?  Beeing able to use blkid for alignment detection will be
> very important so that XFS on Debian can deal with 4k sector disks
> and hardware RAID arrays out of the box.

Sure, I'll take a look at that for next upload.

cheers.

-- 
Nathan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
