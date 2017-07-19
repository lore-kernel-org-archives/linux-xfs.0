Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:40688 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754067AbdGSPVA (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 19 Jul 2017 11:21:00 -0400
Subject: Re: Collecting aged XFS profiles
References: <F180D8D4-633B-4CC5-8D70-5CAC36233513@cs.cmu.edu>
 <CAAxjCEzevLnmxyVRME1-kT867KjH2rtOdspv7nF6TOfLUDD+xA@mail.gmail.com>
 <20170717234814.GK17762@dastard>
 <CAAxjCEzP=bf5S12J8rTn7EyJK_MeM=t1JSa7pBzZyXK=9TrjQQ@mail.gmail.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <bcb651de-75bf-97a6-7ed8-c083d2a440e5@sandeen.net>
Date: Wed, 19 Jul 2017 10:20:59 -0500
MIME-Version: 1.0
In-Reply-To: <CAAxjCEzP=bf5S12J8rTn7EyJK_MeM=t1JSa7pBzZyXK=9TrjQQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Stefan Ring <stefanrin@gmail.com>, linux-xfs@vger.kernel.org

On 07/19/2017 02:59 AM, Stefan Ring wrote:
> On Tue, Jul 18, 2017 at 1:48 AM, Dave Chinner <david@fromorbit.com> wrote:
>> To analyse such things, maybe consider gathering obfuscated metadump
>> images rather asking people to run scripts that gather limited
>> information.  That way you can develop scripts to extract the
>> information your research requires from the filesystem images you
>> received, rather than try to draw tenuous conclusions from a limited
>> data set...
> 
> I have created a metadump that is 1GB in size, xz-compressed. However,
> by running strings on it I find that there are many identifiable
> remains inside, and I cannot legally pass this on. xfsprogs is
> xfsprogs-3.1.1-10.el6, which is obviously really old. I'm reluctant to
> just run a newer version on this production machine; after all I've
> once almost brought it down by running xfs_bmap on a heavily
> fragmented file.

newer metadump should correct that problem, and is a read-only tool,
so should be (tm) perfectly safe (tm).  You could run it out of a built
git repo, via the xfs_db commands.

> The question is: can I import this metadata image in a VM and recreate
> the metadata image from there, using modern xfsprogs? Will this
> preserve most of the relevant information?

yes, that would work too. (mdrestore followed by or piped through metadump)
If you find significant strings in that result please let me know :)

Thanks,
-Eric
