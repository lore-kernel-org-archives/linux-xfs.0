Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o9111hg2257023 for <xfs@oss.sgi.com>; Thu, 30 Sep 2010 20:01:43 -0500
Received: from master.debian.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 30B471D99457
	for <xfs@oss.sgi.com>; Thu, 30 Sep 2010 18:02:42 -0700 (PDT)
Received: from master.debian.org (master.debian.org [70.103.162.29]) by
	cuda.sgi.com with ESMTP id H1fRFCe0v1bLGNPd for
	<xfs@oss.sgi.com>; Thu, 30 Sep 2010 18:02:42 -0700 (PDT)
Date: Fri, 1 Oct 2010 11:02:26 +1000
From: =?iso-8859-1?Q?An=EDbal?= Monsalve Salazar <anibal@debian.org>
Subject: Re: xfsprogs Debian mantainaince
Message-ID: <20101001010226.GB3066@master.debian.org>
References: <20100814111513.GA8214@infradead.org>
	<1697333467.18161281921959476.JavaMail.root@mail-au.aconex.com>
	<20100829041924.GB2648@mapuche.apana.org.au>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100829041924.GB2648@mapuche.apana.org.au>
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
Cc: nathans@debian.org, xfs@oss.sgi.com, Nathan Scott <nathans@aconex.com>

On Sun, Aug 29, 2010 at 02:19:24PM +1000, Anibal Monsalve Salazar wrote:
>On Mon, Aug 16, 2010 at 11:25:59AM +1000, Nathan Scott wrote:
>>----- "Christoph Hellwig" <hch@infradead.org> wrote:
>>
>>>Hi Nathan, hi Anibal,
>>>
>>>if seen the constant flipping between native and non-native uploads
>>>for the xfsprogs Debian packages between the two of you and it's
>>>slightly annoying.  I know Nathan likes maintaining the Debian
>>>packages in git, which also makes life for us XFS developers trying to
>>>build debian packages a lot easier.
>
>Sorry about the unintended nuisance. When I had access to the SGI ptools
>repo it was very easy to keep my uploads to Debian with an updated
>debian directory. 
>
>>>What about a compromise?  We'll add a debian-<dist> branches to the
>>>xfsprogs-dev repository where we can track the exact packages uploaded
>>>to Debian, including the -2/-3 etc packages revisions that only get
>>>uploaded to Debian,
>>
>>IMO, the -2 and -3 revisions are unnecessary and there's really no need
>>for a separate branch ... if Anibal had a kernel.org account and merged
>>changes in before uploading, there'd be no issue, I think - Anibal?  It
>>would make life simpler, for sure.
>
>I agree.

Hi Christoph and Nathan, :)

Any news about access to kernel.org to merge changes before uploading?

Having the xfsprogs Debian package as native is okay for me if that is
what you guys want. Some Debian maintainers think it isn't a good idea,
however.

Cheers.

>On the same subject, I talked to Andreas during LinuxCon2010 in Boston
>about getting access to the acl and attr git repos to update the debian
>directory before uploading packages to Debian. He was very positive
>about that.
>
>>>And one last request, any chance to get xfsprogs for -testing rebuilt
>>>against libblkid now that util-linux-2.17 has finally made it into
>>>testing?  Beeing able to use blkid for alignment detection will be
>>>very important so that XFS on Debian can deal with 4k sector disks and
>>>hardware RAID arrays out of the box.
>>
>>Sure, I'll take a look at that for next upload.
>>
>>cheers.
>>
>>-- 
>>Nathan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
