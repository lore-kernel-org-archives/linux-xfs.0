Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 63A687F75
	for <xfs@oss.sgi.com>; Fri,  6 Nov 2015 10:54:17 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D4E1DAC005
	for <xfs@oss.sgi.com>; Fri,  6 Nov 2015 08:54:16 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id WhFdhqQ8eCWuILDH for <xfs@oss.sgi.com>;
	Fri, 06 Nov 2015 08:54:12 -0800 (PST)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id B89E06372A80
	for <xfs@oss.sgi.com>; Fri,  6 Nov 2015 10:54:11 -0600 (CST)
Subject: Re: Several bugs in xfs-progs when parsing invalid input
References: <20151105174732.2378bc35@pc1>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <563CDB33.5010704@sandeen.net>
Date: Fri, 6 Nov 2015 10:54:11 -0600
MIME-Version: 1.0
In-Reply-To: <20151105174732.2378bc35@pc1>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1



On 11/5/15 10:47 AM, Hanno B=F6ck wrote:
> Hi,
> =

> A while ago I reported a couple of bugs into your bugtracker about
> issues in xfs_repair that I found through fuzzing (with the tool
> american fuzzy lop).
> =

> http://oss.sgi.com/bugzilla/show_bug.cgi?id=3D1119
> null pointer access
> =

> http://oss.sgi.com/bugzilla/show_bug.cgi?id=3D1120
> out of bounds heap read access
> =

> http://oss.sgi.com/bugzilla/show_bug.cgi?id=3D1121
> http://oss.sgi.com/bugzilla/show_bug.cgi?id=3D1122
> 2x assert
> =

> When opening these bugs I got an error message. I then contacted your
> support and almost two months(!) later I got a reply telling me that I
> should not use bugzilla, instead I should report bugs to this mailing
> list.
> =

> Your webpage however clearly states that I should use bugzilla:
> http://oss.sgi.com/projects/xfs/

oss.sgi.com infrastructure is not well maintained, I'm sorry about that,
but it's up to SGI to fix anything that needs fixing, I'm afraid.

Which is a pity, because a well-maintained bug tracker would be pretty
useful.

That said, reporting to the list is also probably a good idea.

> This is all a bit ridiculous. If you don't want people to use your
> bugzilla don't say so on your webpage and preferrably disable the
> creation of new bugs.
> =

> Anyway: Please have a look at the bugs I reported (and once they're
> fixed I'll happily re-test the code to see if there are more issues
> that can be found via fuzzing).

You didn't say what version of xfsprogs you tested, but there have
been a few independent fuzz-related fixes recently; you might just retest
against what's currently in the git tree, and see if we got lucky.  ;)

Thanks,
- -Eric
-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.17 (Darwin)
Comment: GPGTools - http://gpgtools.org

iQIcBAEBAgAGBQJWPNsyAAoJECCuFpLhPd7gcIcP/26oNtf4LctRnyNwAQfqdp99
SCoJoCBnJLY8B8CI4ut1LkUzaCmGw3tC/sB5i+JxV9kU2U1IZ3D06mw3HMFrf2zB
/AXxTyZPejpNGmWsfn8XevaC0t2/qGqZp6cEyE7IeK7CCDfKl/ulmTg0np3uexTo
/FRTBkFJtM9TOgByvbuk0CAeW4zC9VUCBubV5KxXFgJgQIigHDZhdVPl6gFfPuov
+AZu8jNAK+zKcmlziUxZHr+xL/8T+IVGkao91pqxXYDW/p0OYC4XlOm8NCQ+Z7HQ
zuCWDyL8Y1lCwqJonkO+slFQ1YtF2K2zBmyT8HBzmqd294/9SP8pJcyZkm9JKbvC
on2AipTqrob90xHnMyyIrU9stbfa2vlFo2CDUzDwklY6M3dfViPoMrkAu+IRxjC0
aenoezYSYJ6H4blAfvWeSHwmfSUp9qtS+QR0ETPLqw+w1WARrbxjqcARw+ln4dOY
+0AgUJfc6UFmgGkulX2qQqFX8zNth9uE09TIU5q2Gy9/uY2hkK7mgQ4sVNQMVt7f
M2vooAh8vF59PrJt6fTOHeSMrTcScl1fi1N0sQgnWfDUWlh81gSCRBy3drg02JGB
nh3wcAJo4D726fyucRh7XSj+3k2CUas/Y87kDevX5A8xBBNNiT/S4ueYlg7BEPT4
5Y20B/KyIe0jQiLFLOMU
=3DVuhf
-----END PGP SIGNATURE-----

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
