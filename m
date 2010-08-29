Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o7T4IwTC188306 for <xfs@oss.sgi.com>; Sat, 28 Aug 2010 23:18:58 -0500
Received: from master.debian.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1242F3128A
	for <xfs@oss.sgi.com>; Sat, 28 Aug 2010 21:19:34 -0700 (PDT)
Received: from master.debian.org (master.debian.org [70.103.162.29]) by
	cuda.sgi.com with ESMTP id qK7oIDssuo9T8ozI for
	<xfs@oss.sgi.com>; Sat, 28 Aug 2010 21:19:34 -0700 (PDT)
Date: Sun, 29 Aug 2010 14:19:24 +1000
From: =?iso-8859-1?Q?An=EDbal?= Monsalve Salazar <anibal@debian.org>
Subject: Re: xfsprogs Debian mantainaince
Message-ID: <20100829041924.GB2648@mapuche.apana.org.au>
References: <20100814111513.GA8214@infradead.org>
	<1697333467.18161281921959476.JavaMail.root@mail-au.aconex.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1697333467.18161281921959476.JavaMail.root@mail-au.aconex.com>
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
Cc: anibal@debian.org, nathans@debian.org, xfs@oss.sgi.com, Nathan Scott <nathans@aconex.com>

On Mon, Aug 16, 2010 at 11:25:59AM +1000, Nathan Scott wrote:
>----- "Christoph Hellwig" <hch@infradead.org> wrote:
>
>>Hi Nathan, hi Anibal,
>>
>>if seen the constant flipping between native and non-native uploads
>>for the xfsprogs Debian packages between the two of you and it's
>>slightly annoying.  I know Nathan likes maintaining the Debian
>>packages in git, which also makes life for us XFS developers trying to
>>build debian packages a lot easier.

Sorry about the unintended nuisance. When I had access to the SGI ptools
repo it was very easy to keep my uploads to Debian with an updated
debian directory. 

>>What about a compromise?  We'll add a debian-<dist> branches to the
>>xfsprogs-dev repository where we can track the exact packages uploaded
>>to Debian, including the -2/-3 etc packages revisions that only get
>>uploaded to Debian,
>
>IMO, the -2 and -3 revisions are unnecessary and there's really no need
>for a separate branch ... if Anibal had a kernel.org account and merged
>changes in before uploading, there'd be no issue, I think - Anibal?  It
>would make life simpler, for sure.

I agree.

On the same subject, I talked to Andreas during LinuxCon2010 in Boston
about getting access to the acl and attr git repos to update the debian
directory before uploading packages to Debian. He was very positive
about that.

>>And one last request, any chance to get xfsprogs for -testing rebuilt
>>against libblkid now that util-linux-2.17 has finally made it into
>>testing?  Beeing able to use blkid for alignment detection will be
>>very important so that XFS on Debian can deal with 4k sector disks and
>>hardware RAID arrays out of the box.
>
>Sure, I'll take a look at that for next upload.
>
>cheers.
>
>-- 
>Nathan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
