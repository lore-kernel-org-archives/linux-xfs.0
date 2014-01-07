Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 3DAA97F3F
	for <xfs@oss.sgi.com>; Tue,  7 Jan 2014 15:20:20 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 29B50304092
	for <xfs@oss.sgi.com>; Tue,  7 Jan 2014 13:20:17 -0800 (PST)
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com
	[67.231.153.30]) by cuda.sgi.com with ESMTP id tERIOl749DUCGwUZ
	for <xfs@oss.sgi.com>; Tue, 07 Jan 2014 13:20:16 -0800 (PST)
From: Chris Mason <clm@fb.com>
Subject: Re: [PATCH] xfstests: kill lib/random.c
Date: Tue, 7 Jan 2014 21:20:12 +0000
Message-ID: <1389129641.23310.20.camel@ret.masoncoding.com>
References: <1389038323-8304-1-git-send-email-jbacik@fb.com>
	<52CB20ED.1010705@redhat.com> <52CB2336.2060009@fb.com>
	<52CB2452.70507@redhat.com> <20140107200135.GD1935@sgi.com>
	<52CC5F27.1090602@sandeen.net> <20140107204015.GJ10553@sgi.com>
	<52CC6F00.3060907@fb.com>
In-Reply-To: <52CC6F00.3060907@fb.com>
Content-Language: en-US
Content-ID: <F387C06A977AEF4BA2AAAF621CB5D097@fb.com>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============2610713659020005810=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Josef Bacik <jbacik@fb.com>
Cc: "sandeen@redhat.com" <sandeen@redhat.com>, "bpm@sgi.com" <bpm@sgi.com>, "sandeen@sandeen.net" <sandeen@sandeen.net>, "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

--===============2610713659020005810==
Content-Language: en-US
Content-Type: text/plain; charset="utf-7"
Content-ID: <F387C06A977AEF4BA2AAAF621CB5D097@fb.com>
Content-Transfer-Encoding: quoted-printable

On Tue, 2014-01-07 at 16:17 -0500, Josef Bacik wrote:
+AD4- On 01/07/2014 03:40 PM, Ben Myers wrote:
+AD4- +AD4- On Tue, Jan 07, 2014 at 02:10:15PM -0600, Eric Sandeen wrote:
+AD4- +AD4APg- On 1/7/14, 2:01 PM, Ben Myers wrote:
+AD4- +AD4APgA+- Hey Gents,
+AD4- +AD4APgA+-
+AD4- +AD4APgA+- On Mon, Jan 06, 2014 at 03:46:58PM -0600, Eric Sandeen wro=
te:
+AD4- +AD4APgA+AD4- On 1/6/14, 3:42 PM, Josef Bacik wrote:
+AD4- +AD4APgA+AD4APg- On 01/06/2014 04:32 PM, Eric Sandeen wrote:
+AD4- +AD4APgA+AD4APgA+- On 1/6/14, 1:58 PM, Josef Bacik wrote:
+AD4- +AD4APgA+AD4APgA+AD4- I was trying to reproduce something with fsx an=
d I noticed that no matter what
+AD4- +AD4APgA+AD4APgA+AD4- seed I set I was getting the same file.  Come t=
o find out we are overloading
+AD4- +AD4APgA+AD4APgA+AD4- random() with our own custom horribleness for s=
ome unknown reason.  So nuke the
+AD4- +AD4APgA+AD4APgA+AD4- damn thing from orbit and rely on glibc's rando=
m().  With this fix the -S option
+AD4- +AD4APgA+AD4APgA+AD4- actually does something with fsx.  Thanks,
+AD4- +AD4APgA+AD4APgA+- Hm, old comments seem to indicate that this was do=
ne +ADw-handwave+AD4- to make random
+AD4- +AD4APgA+AD4APgA+- behave the same on different architectures (i.e. s=
ame result from same seed,
+AD4- +AD4APgA+AD4APgA+- I guess?)  I . . . don't know if that is true of g=
libc's random(), is it?
+AD4- +AD4APgA+AD4APgA+-
+AD4- +AD4APgA+AD4APgA+- I'd like to dig into the history just a bit before=
 we yank this, just to
+AD4- +AD4APgA+AD4APgA+- be sure.
+AD4- +AD4APgA+AD4APg- I think that if we need the output to match based on=
 a predictable
+AD4- +AD4APgA+AD4APg- random() output then we've lost already. We shouldn'=
t be checking for
+AD4- +AD4APgA+AD4APg- specific output (like inode numbers or sizes etc) th=
at are dependant
+AD4- +AD4APgA+AD4APg- on random()'s behaviour, and if we are we need to fi=
x those tests. So
+AD4- +AD4APgA+AD4APg- even if that is why it was put in place originally I=
'd say it is high
+AD4- +AD4APgA+AD4APg- time we ripped it out and fixed up any tests that re=
ly on this
+AD4- +AD4APgA+AD4APg- behaviour. Thanks,
+AD4- +AD4APgA+AD4- Yeah, you're probably right.  And the ancient xfstests =
history seems to
+AD4- +AD4APgA+AD4- be lost in the mists of time, at least as far as I can =
see.  So I'm ok
+AD4- +AD4APgA+AD4- with this but let's let Dave +ACY- SGI chime in too jus=
t to be certain.
+AD4- +AD4APgA+- I did not have success locating the history prior to what =
we have posted on
+AD4- +AD4APgA+- oss.  I agree that it was likely added so that tests that =
expose output from
+AD4- +AD4APgA+- random into golden output files will have the same results=
 across arches.
+AD4- +AD4APgA+- Maybe this is still of concern for folks who use a differe=
nt c library with the
+AD4- +AD4APgA+- kernel.
+AD4- +AD4APgA+-
+AD4- +AD4APgA+- Looks there are quite a few callers.  IMO if we're going t=
o remove this we
+AD4- +AD4APgA+- should fix the tests first.
+AD4- +AD4APg- Or first, determine if they really need fixing.  Did you fin=
d tests which
+AD4- +AD4APg- actually contain the random results in the golden output?
+AD4- +AD4- At one point random.c was modified because it was returning dif=
ferent test
+AD4- +AD4- results on i386 and ia64 with test 007.  Looks like nametest.c =
is a good
+AD4- +AD4- candidate.
+AD4- +AD4-
+AD4-=20
+AD4- Ugh you're right.  Just ignore this patch for now, I'll be in the cor=
ner=20
+AD4- banging my head against the wall.  Thanks,

For now we can just use srandom?

-chris


--===============2610713659020005810==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============2610713659020005810==--
