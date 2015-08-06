Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 7C1E77FAE
	for <xfs@oss.sgi.com>; Wed,  5 Aug 2015 19:21:25 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 67304304032
	for <xfs@oss.sgi.com>; Wed,  5 Aug 2015 17:21:22 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	sjmuGXKPA79jkMVB for <xfs@oss.sgi.com>;
	Wed, 05 Aug 2015 17:21:19 -0700 (PDT)
Date: Thu, 6 Aug 2015 10:21:05 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Bug#793495: xfsprogs fails to build on debian ppc64el
Message-ID: <20150806002105.GZ16638@dastard>
References: <55BB9271.6000300@gmx.net> <55BBEF4F.6070809@linux.vnet.ibm.com>
	<20150801225230.GR16638@dastard>
	<41BF7556-AAAB-4F22-B8C2-8991A0917DE2@gmx.net>
	<20150802221301.GO3902@dastard>
	<55C0D916.1010102@linux.vnet.ibm.com>
	<20150804225819.GV16638@dastard>
	<55C208D2.4060907@linux.vnet.ibm.com>
	<20150805134729.GX16638@dastard>
	<55C23152.3030801@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <55C23152.3030801@linux.vnet.ibm.com>
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
To: Fernando Seiti Furusato <ferseiti@linux.vnet.ibm.com>
Cc: xfs@oss.sgi.com, 793495@bugs.debian.org, Breno Leitao <brenohl@br.ibm.com>, Daniel Bast <daniel.bast@gmx.net>

On Wed, Aug 05, 2015 at 12:52:50PM -0300, Fernando Seiti Furusato wrote:
> Hi Dave!
> 
> On 08/05/2015 10:47 AM, Dave Chinner wrote:
> 
> >make realclean also removes the .census file, so it appears that
> >the debian package build has a dependency on it. Still, that's a
> >side issue, because we still don't exactly what is causing the
> >configure script to fail.
> Right. The immediate reason is because config.guess and config.sub are not
> being updated. Once they are updated, configure will not fail. When I copy them,
> manually, from /usr/share/libtool/config/, the build does not fail.
> 
> >You seem to be talking about 2 different tarballs here.  The
> >tarballs I release most definitely have a configure script in them:
> >
> >$ tar tfv xfsprogs-4.2.0-rc1.tar.gz |grep configure
> >-rw-r--r-- dave/dave      3098 2015-08-04 11:16 xfsprogs-4.2.0-rc1/configure.ac
> >-rwxr-xr-x dave/dave    469084 2015-08-04 14:25 xfsprogs-4.2.0-rc1/configure
> >
> >So I don't know where you are getting xfsprogs tarballs without
> >configure scripts from.
> My apologies, it was a confusion of my part. I was looking at the git tree.
> The tarball does come with configure. But the config.{guess,sub} that come with
> it are up-to-date, differently of what comes with the debian src package.
> I generated a diff from them, which is attached.
> Also, the version I have here is not 4.2.0-rc1, it is the one found at the git
> repository I mentioned. Is that not correct?

I released 4.2.0-rc1 to the dev tree on kernel.org. I didn't update
the tree on oss.sgi.com or make an official release tarball because
it's a developer pre-release. And there's a couple of things under
discussion that that might require a rebase of the tree, so that's
another reason for not making an "official" release.

....

> A correction though: mine builds from the official xfsprogs source or tarballs
> without problems too.
> It is the Debian source package that fails, exclusively.

Ok, that clears up the confusion. Thanks for explaining what is
happening to the dummy in the audience (me).

> I am curious about something I have just noticed (while writing this e-mail).
> Running apt-get source xfsprogs gets a tarball xfsprogs_3.2.4.tar.gz
> Shouldn't it be the exact same file I get from:
> http://ftp.br.debian.org/debian/pool/main/x/xfsprogs/xfsprogs_3.2.4.tar.gz
> Because they differ. And the latter does not fail at all.

No idea - that's definitely a distro issue ;)

> make[1]: Entering directory '/home/xfsprogs/xfsprogs-3.2.4'
> ./configure $LOCAL_CONFIGURE_OPTIONS
> checking build system type... ./config.guess: unable to guess system type
> 
> This script, last modified 2012-02-10, has failed to recognize

This is what I found about an hour before reading this email. On
#xfs:

[06/08/15 09:32] <dchinner_> now that "last modified <$timestamp>" is important
[06/08/15 09:33] <dchinner_> because that tells us what version was used to generate the script
[06/08/15 09:34] <dchinner_> in the version shipped in the 3.2.4 tarball, it is:
[06/08/15 09:34] <dchinner_> timestamp='2014-03-23'
[06/08/15 09:34] <dchinner_> and it clearly has entries for ppc64le in it

>      ppc64:Linux:*:*)
> -	echo powerpc64-unknown-linux-gnu
> +	echo powerpc64-unknown-linux-${LIBC}
>  	exit ;;
>      ppc:Linux:*:*)
> -	echo powerpc-unknown-linux-gnu
> +	echo powerpc-unknown-linux-${LIBC}
> +	exit ;;
> +    ppc64le:Linux:*:*)
> +	echo powerpc64le-unknown-linux-${LIBC}
> +	exit ;;
> +    ppcle:Linux:*:*)
> +	echo powerpcle-unknown-linux-${LIBC}
>  	exit ;;

That hunk shows why it is failing - no ppc64le:Linux match in the
old script. Nathan is already looking into it...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
