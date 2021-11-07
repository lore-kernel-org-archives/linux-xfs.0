Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C991AC433F5
	for <linux-xfs@archiver.kernel.org>; Sun,  7 Nov 2021 22:25:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9BA1D6139E
	for <linux-xfs@archiver.kernel.org>; Sun,  7 Nov 2021 22:25:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234886AbhKGW2j (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 7 Nov 2021 17:28:39 -0500
Received: from mail107.syd.optusnet.com.au ([211.29.132.53]:43999 "EHLO
        mail107.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234236AbhKGW2i (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 7 Nov 2021 17:28:38 -0500
Received: from dread.disaster.area (pa49-195-103-97.pa.nsw.optusnet.com.au [49.195.103.97])
        by mail107.syd.optusnet.com.au (Postfix) with ESMTPS id 8AC99F2BA48;
        Mon,  8 Nov 2021 09:25:51 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1mjqbm-0067fL-JU; Mon, 08 Nov 2021 09:25:50 +1100
Date:   Mon, 8 Nov 2021 09:25:50 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Nikola Ciprich <nikola.ciprich@linuxbox.cz>
Cc:     Eric Sandeen <esandeen@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>, linux-xfs@vger.kernel.org
Subject: Re: XFS / xfs_repair - problem reading very large sparse files on
 very large filesystem
Message-ID: <20211107222550.GH449541@dread.disaster.area>
References: <20211104090915.GW32555@pcnci.linuxbox.cz>
 <39784566-4696-2391-a6f5-6891c2c7802b@sandeen.net>
 <20211105141343.GH32555@pcnci.linuxbox.cz>
 <20211105141719.GI32555@pcnci.linuxbox.cz>
 <6af37cfb-1136-6d07-45a0-c0494b64b0d7@redhat.com>
 <20211105155914.GJ32555@pcnci.linuxbox.cz>
 <48920430-e48b-0531-2627-0efee9845a1c@redhat.com>
 <20211105161947.GK32555@pcnci.linuxbox.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211105161947.GK32555@pcnci.linuxbox.cz>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=61885271
        a=fP9RlOTWD4uZJjPSFnn6Ew==:117 a=fP9RlOTWD4uZJjPSFnn6Ew==:17
        a=kj9zAlcOel0A:10 a=vIxV3rELxO4A:10 a=7-415B0cAAAA:8
        a=LlVvHddKB8pYotCdKcwA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Nov 05, 2021 at 05:19:47PM +0100, Nikola Ciprich wrote:
> > 
> > ok, thanks for the clarification.
> 
> no problem... in the meantime, xfs_bmap finished as well,
> resulting output has 1.5GB, showing total of 25354643 groups :-O

Yeah, that'll do it. If you are on spinning disks, at ~250 extents
per btree block you're talking about a hundred thousand IOs to read
in the extent list on first access to the file after mount.

> > Though I've never heard of streaming video writes that weren't sequential ...
> > have you actually observed that via strace or whatnot?
> those are streams from many cameras, somehow multiplexed by processing software.
> The guy I communicate with, whos responsible unfortunately does not know
> many details

The multiplexing is the problem here. Look at the allocation pattern
in the trace.

	680367: [872751104..872759863]: 870787280..870796039
	680368: [872759864..872760423]: 870799440..870799999
	680369: [872760424..872761527]: 870921888..870922991
	680370: [872761528..872762079]: 870959584..870960135
	680371: [872762080..872763631]: 871192144..871193695
	680372: [872763632..872763647]: 871183760..871183775
	680373: [872763648..872767487]: hole
	680374: [872767488..872768687]: 870796040..870797239
	680375: [872768688..872769887]: 870800000..870801199
	680376: [872769888..872772367]: 870922992..870925471
	680377: [872772368..872773559]: 870989000..870990191
	680378: [872773560..872775639]: 871193696..871195775
	680379: [872775640..872775679]: hole
	680380: [872775680..872776231]: 870797240..870797791
	680381: [872776232..872776775]: 870801200..870801743
	680382: [872776776..872777847]: 870870440..870871511
	680383: [872777848..872778383]: 870990192..870990727
	680384: [872778384..872779727]: 871195776..871197119
	680385: [872779728..872779791]: 871175064..871175127
	680386: [872779792..872783871]: hole
	680387: [872783872..872785519]: 870797792..870799439
	680388: [872785520..872786927]: 870801744..870803151
	680389: [872786928..872789671]: 870925472..870928215
	680390: [872789672..872791087]: 870990728..870992143
	680391: [872791088..872791991]: 871197120..871198023
	680392: [872791992..872792063]: hole

Lets lay that out into sequential blocks:

Stream 1:
	680367: [872751104..872759863]: 870787280..870796039
	680374: [872767488..872768687]: 870796040..870797239
	680380: [872775680..872776231]: 870797240..870797791
	680387: [872783872..872785519]: 870797792..870799439

Stream 2:
	680368: [872759864..872760423]: 870799440..870799999
	680375: [872768688..872769887]: 870800000..870801199
	680381: [872776232..872776775]: 870801200..870801743
	680388: [872785520..872786927]: 870801744..870803151

Stream 3:
	680369: [872760424..872761527]: 870921888..870922991
	680376: [872769888..872772367]: 870922992..870925471
	680382: [872776776..872777847]: 870870440..870871511 (discontig)
	680389: [872786928..872789671]: 870925472..870928215

Stream 4:
	680370: [872761528..872762079]: 870959584..870960135
	680377: [872772368..872773559]: 870989000..870990191
	680383: [872777848..872778383]: 870990192..870990727
	680390: [872789672..872791087]: 870990728..870992143

Stream 5:
	680371: [872762080..872763631]: 871192144..871193695
	680378: [872773560..872775639]: 871193696..871195775
	680384: [872778384..872779727]: 871195776..871197119
	680391: [872791088..872791991]: 871197120..871198023


Stream 6:
	680372: [872763632..872763647]: 871183760..871183775
	680373: [872763648..872767487]: hole	(contig with 680372)
	680379: [872775640..872775679]: hole
	680385: [872779728..872779791]: 871175064..871175127
	680386: [872779792..872783871]: hole	(contig with 680385)
	680392: [872791992..872792063]: hole

The reason I point this out, is that the way tha XFS allocator works
is that is peels off a chunk of the longest free extent on every
new physical allocation for non-contiguous file offsets.

Hence when we see this physical allocation pattern:

	680367: [872751104..872759863]: 870787280..870796039
	680374: [872767488..872768687]: 870796040..870797239
	680380: [872775680..872776231]: 870797240..870797791
	680387: [872783872..872785519]: 870797792..870799439

It indicates the order in which the writes are occurring. Hence it
would appear that the application is doing sparse writes for chunks
in the file, that it then goes back and partially files holes later
with another run of sparse writes. Eventually, all holes are filled,
but you end up with a fragmented file.

This is actually by design - the XFS allocator is optimised for
efficient write IO (i.e. sequentialises writes as much as possible)
rather than optimal read IO.

From the allocation pattern, I suspect there are 6 cameras in this
multiplexer setup, each sample time that it needs to store an image
has a frame from each camera, and a series of frames is written per
camera before writing the next set of frames from the next camera.
Hence the allocation pattern on disk is effectively sequential for
each camera stream as they are written, but when viewed as a
multiplexed file, it's extremely fragmented because the individual
camera streams are interleaved..

> > What might be happening is that if you are streaming multiple
> > files into a single directory at the same time, it competes for
> > the allocator, and they will interleave.
> > 
> > XFS has an allocator mode called "filestreams" which was
> > designed just for this (video ingest).

Won't do anything - that's for ensure "file per frame" video ingest
places all the files for a given video stream contiguously in an AG.
This looks like "multiple cameras and many frames per file" which
means the filestreams code will not trigger or do anything different
here.

> anyways I'll rather preallocate files fully for now, it takes a
> lot of time, but should be the safest way before we know what
> exactly is wrong..

That may well cause serious problems for camera data ingest, because
it forces the ingest write IO pattern to be non-contiguous rather
than sequential. Hence instead of larger, sequentialised writes per
incoming data set as the above pattern suggests, preallocation will
change to be many more smaller, sparse write IOs that cannot merge.

This will increase write IO latency and reduce the amount of data
that can be written to disk. The likely result of this is that it
will reduce the number of cameras that can be supported per spinning
disk.

I would suggest that the best solution is to rotate camera data
files at a much smaller size so that the extent list doesn't get too
large. e.g. max file size is 1TB, keep historic records in 500x1TB
files instead of one single 500TB file...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
