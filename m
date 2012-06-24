Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q5OMFfLG112935 for <xfs@oss.sgi.com>; Sun, 24 Jun 2012 17:15:41 -0500
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id qWdFEbX35pgJhyp7
	for <xfs@oss.sgi.com>; Sun, 24 Jun 2012 15:15:40 -0700 (PDT)
Message-ID: <4FE7918C.5000203@hardwarefreak.com>
Date: Sun, 24 Jun 2012 17:15:40 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: mkfs.xfs states log stripe unit is too large
References: <D3F781FA-CEB0-4896-9441-772A9E533354@2012.bluespice.org>
	<20120623234445.GZ19223@dastard> <4FE67970.2030008@sandeen.net>
	<4FE710B7.5010704@hardwarefreak.com>
	<4954261F-D4FB-4589-BE18-2BFCEC05E9B4@2012.bluespice.org>
	<4FE76A50.2010902@hardwarefreak.com>
	<563739BF-6A66-41F0-8EA2-CF2171E85B06@2012.bluespice.org>
In-Reply-To: <563739BF-6A66-41F0-8EA2-CF2171E85B06@2012.bluespice.org>
Reply-To: stan@hardwarefreak.com
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: =?ISO-8859-1?Q?Ingo_J=FCrgensmann?= <ij@2012.bluespice.org>
Cc: xfs@oss.sgi.com

On 6/24/2012 2:51 PM, Ingo J=FCrgensmann wrote:
> Am 24.06.2012 um 21:28 schrieb Stan Hoeppner:
> =

>> Thus, I'd guess that the metadata format changed from 0.90 to 1.2 with a
>> very recent release of mdadm.  Are you using distro supplied mdadm, a
>> backported more recent mdadm, or did you build mdadm from the most
>> recent source?
> =

> As I already wrote, I'm using Debian unstable, therefore distro supplied =
mdadm. Otherwise I'd have said this. =


Yes, you did mention SID, and I missed it.

SID is the problem here, or I should say, the cause of the error
message.  SID is leading (better?) edge, and is obviously using a recent
mdadm release, which defaults to metadata 1.2, and chunk of 512KB.

As more distros adopt newer mdadm, reports of this will be more
prevalent.  So Eric's idea is likely preferable than mine.  XFS making a
recommendation against an md default would fly like a lead balloon...

> I don't think that Debian unstable is bleeding edge. =


It's apparently close enough in the case of mdadm, given you're the
first to report this, AFAIK.

> I find it strange that you've misinterpreted citing the mdadm man page as=
 "sandbagging us". =3D:-O

Sandbagging simply means holding something back, withholding
information.  Had you actually not mentioned your OS/version, this would
have been an accurate take on the situation.  But again, youd did, and I
simply missed it.  So again, my apologies for missing your mention of
SID in your opening email.  That would have prevented my skeptical demeanor.

-- =

Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
