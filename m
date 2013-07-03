Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id BB8FF7F8A
	for <xfs@oss.sgi.com>; Wed,  3 Jul 2013 04:54:13 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 43593AC005
	for <xfs@oss.sgi.com>; Wed,  3 Jul 2013 02:54:13 -0700 (PDT)
Received: from labridge.com (perches-mx.perches.com [206.117.179.246]) by
	cuda.sgi.com with ESMTP id O8jYpesVlxtWyI0n (version=SSLv3
	cipher=DES-CBC3-SHA bits=168 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 03 Jul 2013 02:54:11 -0700 (PDT)
Message-ID: <1372845250.2048.7.camel@joe-AO722>
Subject: Re: [PATCH] MAINTAINERS: xfs@oss.sgi.com is a list
From: Joe Perches <joe@perches.com>
Date: Wed, 03 Jul 2013 02:54:10 -0700
In-Reply-To: <5e9d66217e0fa968863177d73dd492b1@meuh.org>
References: <1372777248-4114-1-git-send-email-ydroneaud@opteya.com>
	<20130703064026.GL14996@dastard>
	<c229feab100a72240128ef81297680a1@meuh.org>
	<20130703092406.GM14996@dastard>
	<5e9d66217e0fa968863177d73dd492b1@meuh.org>
Mime-Version: 1.0
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
To: Yann Droneaud <ydroneaud@opteya.com>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Wed, 2013-07-03 at 11:36 +0200, Yann Droneaud wrote:
> In the output of ./scripts/get_maintainer.pl:
> 
> Ben Myers <bpm@sgi.com> (supporter:XFS FILESYSTEM)
> Alex Elder <elder@kernel.org> (supporter:XFS FILESYSTEM)
> xfs@oss.sgi.com (supporter:XFS FILESYSTEM)
> linux-kernel@vger.kernel.org (open list)
> 
> [If having the mailing list listed as the maintainer/supporter is 
> correct,
>   could ./scripts/get_maintainer.pl also report the mailing list as a 
> list ?]

It does when you ask for just the lists...

$ ./scripts/get_maintainer.pl -f -l -nom fs/xfs
xfs@oss.sgi.com (open list:XFS FILESYSTEM)
linux-kernel@vger.kernel.org (open list)

If it bothers you that the same email address
doesn't get reported as both a maintainer and
a mailing list, you're free to submit a patch
to get_maintainer.pl. (look at sub add_role)

It doesn't bother me.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
