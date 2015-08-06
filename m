Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id DF3E97F61
	for <xfs@oss.sgi.com>; Thu,  6 Aug 2015 02:11:01 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B8F708F8037
	for <xfs@oss.sgi.com>; Thu,  6 Aug 2015 00:10:58 -0700 (PDT)
Received: from mx3-phx2.redhat.com (mx3-phx2.redhat.com [209.132.183.24]) by
	cuda.sgi.com with ESMTP id axmumAUCl2GIHTZj (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 06 Aug 2015 00:10:56 -0700 (PDT)
Date: Thu, 6 Aug 2015 03:10:42 -0400 (EDT)
From: Nathan Scott <nathans@redhat.com>
Message-ID: <207352255.5354564.1438845042677.JavaMail.zimbra@redhat.com>
In-Reply-To: <20150806002105.GZ16638@dastard>
References: <55BB9271.6000300@gmx.net> <20150802221301.GO3902@dastard>
	<55C0D916.1010102@linux.vnet.ibm.com>
	<20150804225819.GV16638@dastard>
	<55C208D2.4060907@linux.vnet.ibm.com>
	<20150805134729.GX16638@dastard>
	<55C23152.3030801@linux.vnet.ibm.com>
	<20150806002105.GZ16638@dastard>
Subject: Re: Bug#793495: xfsprogs fails to build on debian ppc64el
MIME-Version: 1.0
Reply-To: Nathan Scott <nathans@redhat.com>
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
To: Dave Chinner <david@fromorbit.com>, 793495@bugs.debian.org, Fernando Seiti Furusato <ferseiti@linux.vnet.ibm.com>
Cc: Breno Leitao <brenohl@br.ibm.com>, Daniel Bast <daniel.bast@gmx.net>, xfs@oss.sgi.com



----- Original Message -----
> On Wed, Aug 05, 2015 at 12:52:50PM -0300, Fernando Seiti Furusato wrote:
> > [...]
> > It is the Debian source package that fails, exclusively.
> [...]
> That hunk shows why it is failing - no ppc64le:Linux match in the
> old script. Nathan is already looking into it...

So, yeah, its definitely got something to do with the local setup here
inserting configure-generated files that are dated.  I build the .debs
from a tagged git repo checkout (without the generated files initially)
so they do get inserted locally.

Having re-installed all autoconf-related packages now on that machine,
as well as constructing an entirely new unstable VM for builds :P  ...
the problem has resolved itself and I see config.sub with ppc64le bits
too.

I'll do a build and upload (source-unchanged) 3.2.4-1 package to make
sure its resolved on the build servers.

Thanks to all for looking into it so closely!

cheers.

--
Nathan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
