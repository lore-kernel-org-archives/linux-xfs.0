Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:49194 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753767AbdDFSim (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 6 Apr 2017 14:38:42 -0400
Subject: Re: [PATCH] xfs: actually report xattr extents via iomap
References: <20170406160356.GY4864@birch.djwong.org>
 <ec62ec40-ce03-6e42-a28f-b0ed9716f0ad@sandeen.net>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <27970b8d-5ad1-3ff1-1474-573a7352bfde@sandeen.net>
Date: Thu, 6 Apr 2017 13:38:41 -0500
MIME-Version: 1.0
In-Reply-To: <ec62ec40-ce03-6e42-a28f-b0ed9716f0ad@sandeen.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, xfs <linux-xfs@vger.kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, Eryu Guan <eguan@redhat.com>



On 4/6/17 1:37 PM, Eric Sandeen wrote:
> On 4/6/17 11:03 AM, Darrick J. Wong wrote:
>> Apparently FIEMAP for xattrs has been broken since we switched to
>> the iomap backend because of an incorrect check for xattr presence.
>>
>> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> nothing tests this?  eek.  Who wants to fix that? :)

Oh, you fixed that.  thanks :)

-Eric
