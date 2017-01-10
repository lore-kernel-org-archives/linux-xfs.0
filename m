Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:50796 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751395AbdAJVeH (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 10 Jan 2017 16:34:07 -0500
Subject: Re: [RFC PATCH] xfs_db: sanitize geometry on load
References: <20170110194249.GK14038@birch.djwong.org>
 <73a62730-59a9-cad4-ca33-f054e544459b@sandeen.net>
 <20170110212721.GL14038@birch.djwong.org>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <c4127369-3be4-bb80-daf5-1548fd07df48@sandeen.net>
Date: Tue, 10 Jan 2017 15:34:05 -0600
MIME-Version: 1.0
In-Reply-To: <20170110212721.GL14038@birch.djwong.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Eric Sandeen <sandeen@redhat.com>, Amir Goldstein <amir73il@gmail.com>, linux-xfs@vger.kernel.org, Eryu Guan <eguan@redhat.com>

On 1/10/17 3:27 PM, Darrick J. Wong wrote:
>> What about sanitizing only the agcount, and saying something like:
>>
>> xfs_db: device fsfile AG count is insane.  Initializing only first $X
>>
>> (where $X is based on your heuristics)
> I feel like "Initializing" could be misinterpreted as formatting the
> disk.  How about:
> 
> xfs_db: device fsfile AG count is insane.  Reading only the first $X AGs.

Sure.  (I'm not sure what the implications are - it's more than just
"Oh, we didn't read it" right?  It'll have implications for use if
more AGs really exist?)

-Eric

> ?
> 
> --D
> 
