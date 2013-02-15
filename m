Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E8BE5803C
	for <xfs@oss.sgi.com>; Fri, 15 Feb 2013 06:31:30 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D21D630404E
	for <xfs@oss.sgi.com>; Fri, 15 Feb 2013 04:31:27 -0800 (PST)
Received: from mail-ie0-f175.google.com (mail-ie0-f175.google.com
	[209.85.223.175]) by cuda.sgi.com with ESMTP id
	SJm9vGVnIk6DH8Eh (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Fri, 15 Feb 2013 04:31:26 -0800 (PST)
Received: by mail-ie0-f175.google.com with SMTP id c12so4702395ieb.34
	for <xfs@oss.sgi.com>; Fri, 15 Feb 2013 04:31:26 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20130215084733.GH28997@carfax.org.uk>
References: <1360909755-2966-1-git-send-email-hemanthkumar51@gmail.com>
	<20130215084733.GH28997@carfax.org.uk>
Date: Fri, 15 Feb 2013 18:01:26 +0530
Message-ID: <CAG_LFoASuEYa4TqTcj-mosQ54Jt7DWqJBDNLHJ-va0qt7d7cfQ@mail.gmail.com>
Subject: Re: [test] comments removed
From: Hemanth Kumar <hemanthkumar51@gmail.com>
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
To: Hugo Mills <hugo@carfax.org.uk>, Hemanth Kumar <hemanthkumar51@gmail.com>, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com, skjmca51@gmail.com, ganeshkumar14@gmail.com, kirantpatil@gmail.com, praneethu.u@gmail.com, chetahan.casey@gmail.com, sensille@gmx.net, bo.li.liu@oracle.com, sandeen@redhat.com

Thanks for the instructions will follow it without fail.

On Fri, Feb 15, 2013 at 2:17 PM, Hugo Mills <hugo@carfax.org.uk> wrote:
>
> On Fri, Feb 15, 2013 at 11:59:15AM +0530, Hemanth Kumar wrote:
>
>    No description of what the patch does. You should probably also put
> [btrfs-progs] in the subject line, if you're patching against
> btrfs-progs (and in that case, you probably don't need to cc the xfs
> people).
>
>    More comments below.
>
>    Hugo.
>
> > Signed-off-by: Hemanth Kumar <hemanthkumar51@gmail.com>
> > ---
> >  0001-heirarchical-quotas-test-case.patch | 44 ++++++++++++++++++++++++++++++++
>         hierarchical
>
> >  hquotas.sh                               |  2 --
> >  2 files changed, 44 insertions(+), 2 deletions(-)
> >  create mode 100644 0001-heirarchical-quotas-test-case.patch
> >
> > diff --git a/0001-heirarchical-quotas-test-case.patch b/0001-heirarchical-quotas-test-case.patch
>
>     And here
>
> > new file mode 100644
> > index 0000000..c6577e0
> > --- /dev/null
> > +++ b/0001-heirarchical-quotas-test-case.patch
>
>     And here
>
> > @@ -0,0 +1,44 @@
> > +From 9f49a870eab70ae37028f937331f9ec1b67dadb1 Mon Sep 17 00:00:00 2001
> > +From: Hemanth Kumar <hemanthkumar51@gmail.com>
> > +Date: Fri, 15 Feb 2013 11:21:03 +0530
> > +Subject: [test] heirarchical quotas test case
> > +
> > +
> > +Signed-off-by: Hemanth Kumar <hemanthkumar51@gmail.com>
>
>    You're sending a patch file that creates a patch file? This is wrong.
>
> > +---
> > + hquotas.sh | 8 ++++----
> > + 1 file changed, 4 insertions(+), 4 deletions(-)
> > +
> > +diff --git a/hquotas.sh b/hquotas.sh
> > +index 2eaae01..a870d4a 100644
> > +--- a/hquotas.sh
> > ++++ b/hquotas.sh
> > +@@ -1,7 +1,5 @@
> > + #! /bin/bash
> > +-# btrfs quotas test case
> > +-#owner=hemanthkumar51@gamil.com ganeshkumr14@gmail.com
> > +-
> > ++# btrfs hierarchical quotas test case
> > + #here=`pwd`
> > + #tmp=/sample
> > + status=1
> > +@@ -11,6 +9,8 @@ cleanup()
> > +     btrfs subvolume delete $TEST_DIR/vol1/vol2/vol3
> > +     btrfs subvolume delete $TEST_DIR/vol1/vol2
> > +     btrfs subvolume delete $TEST_DIR/vol1
> > ++    btrfs quota disable $TEST_DIR
> > ++    echo"quota disabled"
> > + }
> > +
> > + #trap "_cleanup ; exit \$status" 0 1 2 3 15
> > +@@ -25,6 +25,6 @@ btrfs qgroup limit 3m $TEST_DIR/vol1/vol2
> > + btrfs qgroup limit 1m $TEST_DIR/vol1/vol2/vol3
> > + dd if=$TEST_DEV of=$TEST_DIR/vol1/vol2/vol3/file3 bs=2M count=1
> > + dd if=$TEST_DEV of=$TEST_DIR/vol1/vol2/file2 bs=1M count=1
> > +-dd if=$TEST_DEV of=$TEST_DIR/vol1/file1 bs=5M count=1
> > ++dd if=$TEST_DEV of=$TEST_DIR/vol1/file1 bs=4M count=1
> > + cleanup
> > + exit
> > +--
> > +1.8.1.2
> > +
> > diff --git a/hquotas.sh b/hquotas.sh
> > index a870d4a..672b6d1 100644
> > --- a/hquotas.sh
> > +++ b/hquotas.sh
> > @@ -1,7 +1,5 @@
> >  #! /bin/bash
> >  # btrfs hierarchical quotas test case
> > -#here=`pwd`
> > -#tmp=/sample
> >  status=1
> >
> >  cleanup()
>
> --
> === Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
>   PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
>                     --- Beware geeks bearing GIFs ---




--
Thanks,
Hemanth Kumar H C

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
