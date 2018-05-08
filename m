Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:45508 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755579AbeEHUja (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 8 May 2018 16:39:30 -0400
Subject: Re: [PATCH 20/21] xfsprogs: Add parent pointers during protofile
 creation
References: <1525754479-12177-1-git-send-email-allison.henderson@oracle.com>
 <1525754479-12177-21-git-send-email-allison.henderson@oracle.com>
 <20180508174305.GT11261@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <782721c1-f929-a5a6-ed45-b7f42b3a5c05@sandeen.net>
Date: Tue, 8 May 2018 15:39:29 -0500
MIME-Version: 1.0
In-Reply-To: <20180508174305.GT11261@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, Allison Henderson <allison.henderson@oracle.com>
Cc: linux-xfs@vger.kernel.org



On 5/8/18 12:43 PM, Darrick J. Wong wrote:
> On Mon, May 07, 2018 at 09:41:18PM -0700, Allison Henderson wrote:
>> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
>> ---
>>  mkfs/proto.c         | 59 ++++++++++++++++++++++++++++++++++------------------
>>  repair/attr_repair.c | 16 ++------------
>>  repair/phase6.c      | 47 +++++++++++++++++++++++++----------------

> Separate patches for separate utilities, please.

Or at least patch per functional change; it's not at all clear to me how protofile
creation has anything to do with xfs_repair, and there's nothing in the commit
log to help me figure it out.  :)

(I think it doesn't have anything to do w/ protofile creation, and the repair
patches are fixing up orphanage entry creation; the attr_repair changes seem
like some third thing that I don't grok yet, sorry - removing namecheck() for
some reason?).

-Eric
 
