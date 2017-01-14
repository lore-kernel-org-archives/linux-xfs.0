Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:35708 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751034AbdANO7C (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 14 Jan 2017 09:59:02 -0500
Subject: Re: [PATCH v3 4/5] xfs_db: sanitize geometry on load
References: <148419038856.32674.6479634718673149751.stgit@birch.djwong.org>
 <148419041340.32674.2646685552269275817.stgit@birch.djwong.org>
 <20170113003201.GC14038@birch.djwong.org>
 <20170113133542.GB22013@bfoster.bfoster>
 <b071967b-e67b-2280-156c-9a5aeaa5d40c@redhat.com>
 <20170114034449.GA29191@bfoster.bfoster>
 <d4731c23-e721-faad-9937-8256840012bb@redhat.com>
 <20170114125346.GA31018@bfoster.bfoster>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <91a33cde-6300-e84d-f74c-454c129e2669@sandeen.net>
Date: Sat, 14 Jan 2017 08:59:00 -0600
MIME-Version: 1.0
In-Reply-To: <20170114125346.GA31018@bfoster.bfoster>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>, Eric Sandeen <sandeen@redhat.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org

On 1/14/17 6:53 AM, Brian Foster wrote:
>> I do think that mere mortal invocations via xfs_admin need to be
>> handled in this "ignore agcount" case, though...
>>
> We're talking about invocations intended to modify things (i.e., version
> flags, fs uuid, etc.), right? If so, wouldn't we want those things to
> fail if the superblock is busted?

Yes - I'm saying that if xfs_db continues with only 1 ag, those tools
will not work as expected.  (they normally modify all superblocks).

setting exitcode to 1 in the corrupted agcount case would allow
xfs_admin to return failure as well, for example.

-Eric

> Brian
> 
