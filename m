Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:48574 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751430AbeDCQMp (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 3 Apr 2018 12:12:45 -0400
Subject: Re: FreeBSD and xfsprogs ?
References: <cem@freebsd.org>
 <CAG6CVpU3qe10UUY6B-N4fs9WTwwUerVcJh0CrP22D8hvB4Z14Q@mail.gmail.com>
 <201803261953.w2QJrYQm028227@slippy.cwsent.com>
 <CAG6CVpXi3rb-NfLUXQqzStipmwRviKJPMpgKeQA9DfBmOWJ5oQ@mail.gmail.com>
 <20180327160714.GB4818@magnolia>
 <8396fd92-3a64-a84f-b110-7edc6f0844b0@redhat.com>
 <20180327223201.GR18129@dastard> <20180328120212.GA1838@infradead.org>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <9f19f951-a328-5980-1b8e-3630dfacc3b1@sandeen.net>
Date: Tue, 3 Apr 2018 11:12:44 -0500
MIME-Version: 1.0
In-Reply-To: <20180328120212.GA1838@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>, Dave Chinner <david@fromorbit.com>
Cc: Eric Sandeen <sandeen@redhat.com>, Carlos Maiolino <cmaiolino@redhat.com>, Conrad Meyer <cem@freebsd.org>, "Darrick J. Wong" <darrick.wong@oracle.com>, xfs <linux-xfs@vger.kernel.org>, "Luis R. Rodriguez" <mcgrof@kernel.org>, "freebsd-arch@freebsd.org" <freebsd-arch@freebsd.org>



On 3/28/18 7:02 AM, Christoph Hellwig wrote:
> On Wed, Mar 28, 2018 at 09:32:01AM +1100, Dave Chinner wrote:
>> We don't support fuse-lkl XFS filesystems on Linux, so I'm not sure
>> that using it on some other platform compels us to maintain a
>> current userspace tool port to those platforms...
> 
> IFF we have someone signing up to maintain the FreeBSD port it seems
> like a whortwhile exercise.  But that is a big IFF.
> 
> For now I'd say give it a grace period of another release or two to
> see if someone is going to maintain it properly and if not drop it.

Just to keep it on this thread - I'm going to commit this to 4.16:

+#warning "FreeBSD support is deprecated and planned for removal in July 2018"
+#warning "Contact linux-xfs@vger.kernel.org if you'd like to maintain this port"
+#error   "Remove this line if you'd like to continue the build"

for to FreeBSD & the other platforms we're talking about deprecating.

That should get the attention of anyone who cares, I think.  If someone wants
to step up and maintain it, let us know on the list.

Thanks,
-Eric
