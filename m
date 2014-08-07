Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C14687F82
	for <xfs@oss.sgi.com>; Thu,  7 Aug 2014 15:14:45 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 50900AC010
	for <xfs@oss.sgi.com>; Thu,  7 Aug 2014 13:14:41 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id MvgSBxDYFusQaGwJ for <xfs@oss.sgi.com>;
	Thu, 07 Aug 2014 13:14:36 -0700 (PDT)
Message-ID: <53E3DE2B.6080205@sandeen.net>
Date: Thu, 07 Aug 2014 15:14:35 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [DISCUSS] Moving from oss.sgi.com to kernel.org
References: <20140807000922.GA26465@dastard>
In-Reply-To: <20140807000922.GA26465@dastard>
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
To: Dave Chinner <david@fromorbit.com>, xfs@oss.sgi.com
Cc: fstests@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 8/6/14, 7:09 PM, Dave Chinner wrote:
> Hi folks,

<rationale>

> It should be no surprise that since this conversation I've been
> looking at what is involved in moving everything XFS off oss.sgi.com
> to kernel.org.  Right now I have the main XFS repositories up to
> date on kernel.org.  For userspace I've simply pushed the current
> trees and tags to the pre-existing repositories here:
> 
> 	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git
> 	git://git.kernel.org/pub/scm/fs/xfs/xfsdump-dev.git
> 	git://git.kernel.org/pub/scm/fs/xfs/xfstests-dev.git
> 
> These trees currently have the same content as the trees on
> oss.sgi.com.  I may rename these as a result of discussions here
> (e.g. some people don't like the -dev suffix on the trees) so it's
> best for people to continue to use the trees on oss.sgi.com until
> this disucssion comes to a conclusion.

I agree with the move to kernel.org; they have paid staff with time
and resources to look after this stuff; it's a resource we should use,
and it'll save us all time and/or money.

But I'm one of the "some people" who don't want to re-use the -dev
trees; let's just get properly named repos up there.  These served
a different purpose, long ago.

If you want to rename to fstests, that's ok with me, but that's
potentially a different scope; depending on how much content in
the tree needs to be updated etc, I could see doing that a bit later
if needed.

If/when you get the names truly settled, let me know and I'll help
with updating the wiki etc if you like.

As for the old tarballs - they do claim to be signed, right?  So
if we can verify their identity, I see no harm in keeping them around.

As for mailing lists, is it possible to forward for a while, and
also send a reply back about the address change?  That might be most
foolproof, then eventually stop the forwarding and just add a reply
about the list move, and leave that there until oss crumbles into
dust.  ;)

Thanks, and "May the source be with you" ;)
- -Eric
-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.17 (Darwin)
Comment: GPGTools - http://gpgtools.org
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIbBAEBAgAGBQJT494qAAoJECCuFpLhPd7gJm4P93Eas7qaiftU6WF4qKkvkKpD
0MzWk/b17wBR2cHqG9eLnw6Y4AuXCuYb3DTa77B1+8G+v7RBL1NWzbHAJBfc8KUe
mfVNbNfGfTBdgUC7FAyvYZtPlHotcG5ghv8pkdIZNT1aazgZ0Eztjkbfz1NnF5Ia
RwlqGdCyRNB3NsKn+rWypIPaIfUXcCwiSp94YfTiIPvuYIwRnBY4MjKzQa1i+eBl
qNjziJDxNLuHdsnCRClxiDubnLbxlBoQiu4hHNblA+ogC+xvdjAknqbmq2oF825R
9P1BM8gwYJIqvZtoDT1P1NFSPt4NpSYL41Eakn5d8KoprbB3FWwsnYV/biX6UyMX
692Vw5GTtKD6wLeu7Ovi4C8JA+zCFHuMbd8wdmji1IwylRrTvGyGFOdel+caD9ua
sWoTgJfA8ZZBFgbzmEb6jRJe8x8zx5jobaS1w1KxR2gHXL39/8WOGQ7/TukQnzeE
omZ2QFqfJTaCbPlns01qrNOvZJHgX7XUPFZ1BxL7kSfptDfCMYnGiACxjhYiWrFf
H/wPEq4F4itgn2L+eyIpiSlLfLZffsqUFAUKot/raV9+SwjXHfp3zFlbw5Mbw/Co
H6krvTY0ZN4OzgyrT/16BsC8JUjKMSsN05oTDHfB0ldl2gaFGOuDYv20yzHAKN5m
WJLBciq+9DFYsBiOnIw=
=nbLn
-----END PGP SIGNATURE-----

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
