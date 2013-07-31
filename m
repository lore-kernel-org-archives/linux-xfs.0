Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id F011A7CBF
	for <xfs@oss.sgi.com>; Wed, 31 Jul 2013 15:34:25 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C214E30408C
	for <xfs@oss.sgi.com>; Wed, 31 Jul 2013 13:34:25 -0700 (PDT)
Date: Wed, 31 Jul 2013 16:34:16 -0400 (EDT)
From: Nathan Scott <nathans@redhat.com>
Message-ID: <74641529.7203019.1375302856174.JavaMail.root@redhat.com>
In-Reply-To: <51F90B6A.6050809@sgi.com>
References: <51F90B6A.6050809@sgi.com>
Subject: Re: [pcp] Suggestions for SGI ICE where we need to get quota
	information
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
To: Jeff Hanson <jhanson@sgi.com>, mikeh@sgi.com
Cc: XFS <xfs@oss.sgi.com>, PCP <pcp@oss.sgi.com>

Hi guys,

----- Original Message -----
> In SGI's ICE product we have a script that uses pcp to gather quota
> information to feed to ganglia and to alert the admin if a project is
> over quota.  With newer pcp where pmcd is run as user pcp and not as
> root we get failures to obtain the quota information.  Changing back
> to root or other similar techniques works (as expected).  Since the
> hosts that run this are cluster infrastructure nodes this may be the
> hack we decide on but we'd like other suggestions.

[ http://oss.sgi.com/bugzilla/show_bug.cgi?id=985 ]

Hmm, interesting - sorry about that, its unintended fallout and it did
not occur to me that the XFS quota metrics would be affected.  I would
strongly recommend not going back to running pmcd as root, kittens will
surely die (although it is likely to be your only solution currently).

There is a better way we can tackle this - we should isolate those
parts that need to run as root, and run them that way.  This means we
need to transition these quota metrics into a new PMDA which runs as
root, separately to pmcd.

In a quirky twist, I happened to come across a very similar problem
recently with the xfs.control.reset metric - this needs root access
too in order to function (it provides a reset-stats-back-to-zero
mechanism by writing to a procfs file), so it also was an unintended
victim of the unprivileged-pmcd changes.

Thus, I propose we abstract out the xfs.* and quota.* (which, despite
being generically named "quota" metrics, are all XFS-specific) into a
new pmdaxfs which we run as root, in exactly the same way pmdaproc is
now run as root.  We will need to manage the PMID transition (domain
number on these metrics will change) via pmlogrewrite, but that is a
well-trod path now and happily pmdaproc is an existence-proof that we
can successfully make these transitions.

If we do it correctly, we should be able to do this transparently so
that nobody notices.  However, Murphy being Murphy ... I've CC'd the
XFS list to let 'em know this is coming.

cheers.

--
Nathan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
