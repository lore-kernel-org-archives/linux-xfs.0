Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.stoffel.org ([104.236.43.127]:53738 "EHLO mail.stoffel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730734AbeLNUwp (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 14 Dec 2018 15:52:45 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <23572.5681.810087.381496@quad.stoffel.home>
Date: Fri, 14 Dec 2018 15:44:33 -0500
From: "John Stoffel" <john@stoffel.org>
Subject: Re: XFS and RAID10 with o2 layout
In-Reply-To: <5C13694A.8070303@youngman.org.uk>
References: <d9fc0327-eef3-63bd-82a3-98545251bfe5@4net.rs>
        <20181213220533.GH6311@dastard>
        <3e0e8def-2bb4-5e8a-56c1-d010ede059d4@4net.rs>
        <5C13694A.8070303@youngman.org.uk>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Wols Lists <antlists@youngman.org.uk>
Cc: Sinisa <sinisa@4net.rs>, linux-raid@vger.kernel.org, linux-xfs@vger.kernel.org

>>>>> "Wols" == Wols Lists <antlists@youngman.org.uk> writes:

Wols> On 14/12/18 07:03, Sinisa wrote:
>>> And another MD flush thread waiting on a MD sync barrier.
>>> 
>>> Basically, this looks and smells like a MD sync barrier race
>>> condition, not an XFs problem.
>>> 
>>> Cheers,
>>> 
>>> Dave.
>> 
>> But why don't we see the same issue with other filesystems?

Wols> Possibly because, iirc, xfs is aware of the underlying raid?

I don't think it's that in touch with the raid.  It can/does query for
settings so it can optimize stuff, but I don't think it actually uses
it other than as a block device.

Wols> I don't know, but I seem to remember that from earlier discussions about
Wols> "xfs over mdraid".

Have you tried doing this with the absolute latest kernel?  
