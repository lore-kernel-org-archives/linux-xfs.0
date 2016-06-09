Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 6216C7CAE
	for <xfs@oss.sgi.com>; Wed,  8 Jun 2016 21:53:07 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id EF4C1AC001
	for <xfs@oss.sgi.com>; Wed,  8 Jun 2016 19:53:06 -0700 (PDT)
Received: from mail-qk0-f179.google.com (mail-qk0-f179.google.com
	[209.85.220.179]) by cuda.sgi.com with ESMTP id
	NMYar432UBCtEtGf (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 08 Jun 2016 19:53:04 -0700 (PDT)
Received: by mail-qk0-f179.google.com with SMTP id u63so14461558qkh.0
	for <xfs@oss.sgi.com>; Wed, 08 Jun 2016 19:53:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160609022238.GY26977@dastard>
References: <CAAA5faG3Ls0Dh_bx=950db9BV01zoLfmubKbM0UYkWpS0y60BA@mail.gmail.com>
	<79c8e051-24a9-2e2b-553a-bcab17d03e83@sandeen.net>
	<20160607062717.GA30022@infradead.org>
	<c0b9776e-6917-13f2-1948-e7d51f72a909@monom.org>
	<CAAA5faEvt-vrvrkWC8-9Fys0WHN2TBQz7-Y-mtU8FaRHxUM6rw@mail.gmail.com>
	<48817b4c-26f4-5eb6-8a97-d8fa34fe7f6a@monom.org>
	<20160607134442.GA1803@infradead.org>
	<CAAA5faFWyPDienm2NbHkafZh-RvbjJp6f_zDq62z6rC1d1Vzyw@mail.gmail.com>
	<CAAA5faGXHJZPWkkxDM-kvHqh--hPhnD1Y8RuaaSmuzgiz=_LDg@mail.gmail.com>
	<CAAA5faEDdR_L6y9ShhUcermgvjtmzNCzwoYeENjx+8RUEMdwaA@mail.gmail.com>
	<20160609022238.GY26977@dastard>
From: Reinoud Koornstra <reinoudkoornstra@gmail.com>
Date: Wed, 8 Jun 2016 20:53:02 -0600
Message-ID: <CAAA5faGL_Nyu=jW2Vrgr_m7crhnB9BriWWzMAPODbiQATFhS=Q@mail.gmail.com>
Subject: Re: crash in xfs in current
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
Cc: Christoph Hellwig <hch@infradead.org>, Daniel Wagner <wagi@monom.org>, Eric Sandeen <sandeen@sandeen.net>, viro@zeniv.linux.org.uk, xfs@oss.sgi.com

On Wed, Jun 8, 2016 at 8:22 PM, Dave Chinner <david@fromorbit.com> wrote:
> On Tue, Jun 07, 2016 at 10:40:11PM -0600, Reinoud Koornstra wrote:
>> On Tue, Jun 7, 2016 at 10:16 PM, Reinoud Koornstra
>> <reinoudkoornstra@gmail.com> wrote:
>> > On Tue, Jun 7, 2016 at 5:40 PM, Reinoud Koornstra
>> > <reinoudkoornstra@gmail.com> wrote:
>> >> Hi Christoph,
>> >>
>> >> Now my git log show this:
>> >>
>> >> commit 555b67e4e729ca544bb4028ab12e532c68b70ddb
>> >> Merge: 544ad71 ad438c4
>> >> Author: Dave Chinner <david@fromorbit.com>
>> >> Date:   Fri May 20 10:34:00 2016 +1000
>> >>
>> >>    Merge branch 'xfs-4.7-inode-reclaim' into for-next
>> >>
>> >> commit 544ad71fc8e20fb3a6f50f00d487751492cd8409
>> >> Merge: 2a4ad58 e6b3bb7
>> >> Author: Dave Chinner <david@fromorbit.com>
>> >> Date:   Fri May 20 10:33:38 2016 +1000
>> >>
>> >>    Merge branch 'xfs-4.7-error-cfg' into for-next
>> >>
>> >> commit 2a4ad5894c819978dca5595396d54d51c3aca694
>> >> Merge: a7792aa 6e3e6d5
>> >> Author: Dave Chinner <david@fromorbit.com>
>> >> Date:   Fri May 20 10:33:17 2016 +1000
>> >>
>> >>    Merge branch 'xfs-4.7-misc-fixes' into for-next
>> >>
>> >> commit a7792aad644a259375002db8c9d9e03fd50bf509
>> >> Merge: 5b911354 3ab3ffc
>> >> Author: Dave Chinner <david@fromorbit.com>
>> >> Date:   Fri May 20 10:32:35 2016 +1000
>> >>
>> >> Is this correct?
>> >> If so, let me build and test.
>> >> Building it already as we speak, but it would be nice if you could
>> >> confirm I'm actually testing the right thing.
>> >> Though, wouldn't it be good to repro and get a core file as well?
>> >> Or would the test of this commit narrow down the possibilities as well?
>> >> Thanks,
>> >>
>> >> Reinoud.
>> >>
>> >
>> > Ouch, forgive me for not responding inline previously.
>> > For what it's worth, i've compiled the kernel and are running it as we speak.
>> > Will do testing and let you know.
>>
>> Ok, going back to commit 555b67e4e729ca544bb4028ab12e532c68b70ddb
>> brings the kernel back to 4.6-rc1.
>> With that kernel I crash all over the place, so that's something I cannot run.
>> Is there a way to get the 4.7-rc1 or rc2 without the commits for XFS?
>
> In your Linus git tree:
>
> $ git remote add xfsdev git://git.kernel.org/git/dgc/linux-xfs.git
> $ git remote update
> $ git checkout -b xfsdev-merge v4.6
> $ git merge xfsdev/xfs-for-linus-4.7-rc1

Tried to do this:

reinoud@router-dev:~/Downloads/kernel_current$  git remote add xfsdev
git://git.kernel.org/git/dgc/linux-xfs.git
reinoud@router-dev:~/Downloads/kernel_current$  git remote update
Fetching origin
Fetching xfsdev
fatal: remote error: access denied or repository not exported:
/git/dgc/linux-xfs.git
error: Could not fetch xfsdev

I don't think I have access to git.kernel.org in terms of pushing. :)
Or am I doing something else wrong.
Forgive the trivial question.

Btw, I started in the most current linus git tree.... or should I git
4.6.y and then do your suggestions?

Thanks,

Reinoud.

>
> And that should give you the XFS changes for 4.7-rc1 in a vanilla 4.6
> tree. This merge is one of the things I test (i.e. send to my test
> machiens for a round of xfstests and other stress) before sending a
> pull request to Linus, so it should work just fine.
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
