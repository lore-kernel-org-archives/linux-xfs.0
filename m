Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id AE2907F4E
	for <xfs@oss.sgi.com>; Mon, 20 Oct 2014 18:32:32 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 9B36530404E
	for <xfs@oss.sgi.com>; Mon, 20 Oct 2014 16:32:32 -0700 (PDT)
Received: from mail-wg0-f47.google.com (mail-wg0-f47.google.com
	[74.125.82.47]) by cuda.sgi.com with ESMTP id Sbqqqes3HSWsatWr
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 20 Oct 2014 16:32:31 -0700 (PDT)
Received: by mail-wg0-f47.google.com with SMTP id x13so62852wgg.30
	for <xfs@oss.sgi.com>; Mon, 20 Oct 2014 16:32:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20141020230840.GP17506@dastard>
References: <648473255763364B961A02AC3BE1060D03C7940C13@MX19A.corp.emc.com>
	<20141020014750.GL7169@dastard> <54448313.7040602@sandeen.net>
	<30CA1845-C213-49EA-8809-F1E7A98AE7F9@gmail.com>
	<54451427.9060306@sandeen.net> <20141020230840.GP17506@dastard>
From: Greg Freemyer <greg.freemyer@gmail.com>
Date: Mon, 20 Oct 2014 19:31:50 -0400
Message-ID: <CAGpXXZJ1A=Zq74KGveo5D=uAr6GTdA_1=DqXYwm2x9rG8ggDBA@mail.gmail.com>
Subject: Re: Can't build RPM of xfstests
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
To: Dave Chinner <david@fromorbit.com>
Cc: "Kaul, Yaniv" <Yaniv.Kaul@emc.com>, Eric Sandeen <sandeen@sandeen.net>, Eric Sandeen <esandeen@redhat.com>, fstests@vger.kernel.org, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

--
Greg Freemyer


On Mon, Oct 20, 2014 at 7:08 PM, Dave Chinner <david@fromorbit.com> wrote:
> On Mon, Oct 20, 2014 at 08:54:47AM -0500, Eric Sandeen wrote:
>> On 10/20/14 6:55 AM, Greg Freemyer wrote:
>>
>> > Opensuse is building rpms of 1.1.1 so the build infrastructure isn't
>> > too badly broken.  I don't know if they are following FHS, but I
>> > doubt they use /opt.
>>
>> The build works fine, it's the "Makepkgs" that I think is a bit odd,
>> at least for RPM packaging.
>
> It's just odd, regardless of what it is packaging.
>
>> Also, if we really want to encourage packaging, we should probably start
>> sticking official version numbers on it.  "1.1.1" was tagged in Dec 2012,
>> and there have been no "releases" since.
>
> There are more recent tags than that. There were some linux-v3.[6-8]
> tags added when kernels v3.[6-8] we released. Those tags are
> basically meaningless from a release perspective, though.
>
> As it is, for the purpose of the discussion I'll argue that we don't
> need official release versions or tarballs and that anyone who needs
> packages for xfstests is Doing it Wrong(tm).

A potential use case with openSUSE and why I "think" they packaged it
is to include a subset of xfstest in there automated testing.

As of the last 9 months openSUSE's "factory" release has adopted a
rolling release mechanism similar to rawhide, but possibly a little
more reliable.

Many submissions to factory (the rawhide equivalent) are pushed
through a ring of automated QA tests.

Separately on a daily basis the entire current factory release is
pushed through a series of automated QA tests.

If all QA tests pass, then a full factory snapshot is automatically
released for end-user incorporation.

My hope is that xfstests is packaged by openSUSE so it can easily be
incorporated into that series of automated tests.

If they are not yet doing that, then having xfstests packaged
simplifies the future incorporation of xfstests into the auto-QA
cycle.

Overview: https://openqa.opensuse.org/tests/

Table of automated test results:
https://openqa.opensuse.org/tests/

Notice for example that ext4 is a testsuite selection in the testsuite
pull down.  I assume that testsuite uses xfstests to exercise ext4
prior to an automated release of factory.

The 2014-10-17 build of a couple days ago is an example of a build
that failed the ext4 testsuite:
https://openqa.opensuse.org/tests/27955

The 2014-10-18 build on the otherhand worked:
https://openqa.opensuse.org/tests/28263

It is interesting to look through the various screen shots captured by
the automated test system.

I don't see automated tests for xfs or btrfs which is a surprise since
both of them are default filesystem choices for factory.  (btrfs is
the default choice for / and xfs is the default for /home).

Note: openSUSE still will do formal releases and the next one is
openSUSE 13.2 due out next month.  13.2 should be getting lots of
manual testing in addition to the automated QA testing.

Greg

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
