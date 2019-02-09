Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:56748 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726880AbfBIRxq (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 9 Feb 2019 12:53:46 -0500
Date: Sat, 9 Feb 2019 12:53:44 -0500
From: Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH v2 00/10] xfs: stable fixes for v4.19.y
Message-ID: <20190209175344.GA69686@sasha-vm>
References: <20190204165427.23607-1-mcgrof@kernel.org>
 <20190205220655.GF14116@dastard>
 <20190206040559.GA4119@sasha-vm>
 <20190206215454.GG14116@dastard>
 <20190208060620.GA31898@sasha-vm>
 <20190208212921.GO14116@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20190208212921.GO14116@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Luis Chamberlain <mcgrof@kernel.org>, linux-xfs@vger.kernel.org, gregkh@linuxfoundation.org, Alexander.Levin@microsoft.com, stable@vger.kernel.org, amir73il@gmail.com, hch@infradead.org

On Sat, Feb 09, 2019 at 08:29:21AM +1100, Dave Chinner wrote:
>On Fri, Feb 08, 2019 at 01:06:20AM -0500, Sasha Levin wrote:
>> On Thu, Feb 07, 2019 at 08:54:54AM +1100, Dave Chinner wrote:
>> >On Tue, Feb 05, 2019 at 11:05:59PM -0500, Sasha Levin wrote:
>> >>On Wed, Feb 06, 2019 at 09:06:55AM +1100, Dave Chinner wrote:
>> >>>On Mon, Feb 04, 2019 at 08:54:17AM -0800, Luis Chamberlain wrote:
>> >>>>Kernel stable team,
>> >>>>
>> >>>>here is a v2 respin of my XFS stable patches for v4.19.y. The only
>> >>>>change in this series is adding the upstream commit to the commit log,
>> >>>>and I've now also Cc'd stable@vger.kernel.org as well. No other issues
>> >>>>were spotted or raised with this series.
>> >>>>
>> >>>>Reviews, questions, or rants are greatly appreciated.
>> >>>
>> >>>Test results?
>> >>>
>> >>>The set of changes look fine themselves, but as always, the proof is
>> >>>in the testing...
>> >>
>> >>Luis noted on v1 that it passes through his oscheck test suite, and I
>> >>noted that I haven't seen any regression with the xfstests scripts I
>> >>have.
>> >>
>> >>What sort of data are you looking for beyond "we didn't see a
>> >>regression"?
>> >
>> >Nothing special, just a summary of what was tested so we have some
>> >visibility of whether the testing covered the proposed changes
>> >sufficiently.  i.e. something like:
>> >
>> >	Patchset was run through ltp and the fstests "auto" group
>> >	with the following configs:
>> >
>> >	- mkfs/mount defaults
>> >	- -m reflink=1,rmapbt=1
>> >	- -b size=1k
>> >	- -m crc=0
>> >	....
>> >
>> >	No new regressions were reported.
>> >
>> >
>> >Really, all I'm looking for is a bit more context for the review
>> >process - nobody remembers what configs other people test. However,
>> >it's important in reviewing a backport to know whether a backport to
>> >a fix, say, a bug in the rmap code actually got exercised by the
>> >tests on an rmap enabled filesystem...
>>
>> Sure! Below are the various configs this was run against. There were
>> multiple runs over 48+ hours and no regressions from a 4.14.17 baseline
>> were observed.
>
>Thanks, Sasha. As an ongoing thing, I reckon a "grep _OPTIONS
><config_files>" (catches both mkfs and mount options) would be
>sufficient as a summary of what was tested in the series
>decription...

Will do.

--
Thanks,
Sasha
