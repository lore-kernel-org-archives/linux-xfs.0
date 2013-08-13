Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B691D29DFB
	for <xfs@oss.sgi.com>; Tue, 13 Aug 2013 11:29:00 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 356BBAC003
	for <xfs@oss.sgi.com>; Tue, 13 Aug 2013 09:28:56 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id xRVJQiVhjiCgsIBI for <xfs@oss.sgi.com>;
	Tue, 13 Aug 2013 09:28:51 -0700 (PDT)
Message-ID: <520A5EAB.5050909@sandeen.net>
Date: Tue, 13 Aug 2013 11:28:27 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH v3 1/2] xfstests: add fssum tool
References: <1375949833-1104-1-git-send-email-list.xfs@jan-o-sch.net>
	<1375949833-1104-2-git-send-email-list.xfs@jan-o-sch.net>
	<5203D827.3050909@sandeen.net> <20130812011539.GM12779@dastard>
	<BB446B35-F3DA-462E-9E2C-9E4B780BC6B9@sandeen.net>
	<20130813152822.GG2150@localhost.localdomain>
In-Reply-To: <20130813152822.GG2150@localhost.localdomain>
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
To: Josef Bacik <jbacik@fusionio.com>
Cc: Jan Schmidt <list.xfs@jan-o-sch.net>, "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>, "sbehrens@giantdisaster.de" <sbehrens@giantdisaster.de>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On 8/13/13 10:28 AM, Josef Bacik wrote:
> On Sun, Aug 11, 2013 at 09:54:41PM -0500, Eric Sandeen wrote:
>> On Aug 11, 2013, at 8:15 PM, Dave Chinner <david@fromorbit.com> wrote:
>>
>>> On Thu, Aug 08, 2013 at 12:40:55PM -0500, Eric Sandeen wrote:
>>>> On 8/8/13 3:17 AM, Jan Schmidt wrote:
>>>>> SUBDIRS =
>>>>>
>>>>> LLDLIBS = $(LIBATTR) $(LIBHANDLE) $(LIBACL)
>>>>>
>>>>> +OPT_LDLIBS = -lssl -lcrypto
>>>>
>>>> Hm, new deps.  I guess it's not a huge problem, these should always
>>>> be available, right?
>>>
>>> Please, let's keep crypto out of xfstests if we can. That's just
>>> going to add a nightmare of US export compliance garbage to any
>>> distro that wants to package and ship this....
>>>
>> It's ssl that's (optionally) required for check summing I believe.  But it's optional if done properly...
>>
> 
> It doesn't build without -lcrypto for me, so either we have an external
> dependancy (which I'm fine with), or we add it to xfstests (which is what you
> wanted).  Does a config option alleviate your concerns?  And I it's just linking
> it in at build time, I don't think we have to work about export compliance as
> long as we aren't shipping actual crytpo stuff right?  Anybody who is going to
> be running this stuff is going to have libssl installed, which installs
> libcrypto (at least on my box) so I don't think it's a huge deal to have us
> linking it.  Thanks,

Yeah I think linking in a consumer is not at all the same as exporting the functionality.

Looks like my Makefile patch needs to add both -lssl & -lcrypto after all,
but again, yeah, just linking against it _if_ it's there.

Oh, and here's my m4/package_ssldev.m4, sorry about that:

AC_DEFUN([AC_PACKAGE_WANT_SSL],
  [ AC_CHECK_HEADERS(openssl/md5.h, [ have_ssl=true ], [ have_ssl=false ])
    AC_SUBST(have_ssl)
  ])


-Eric

> Josef
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
