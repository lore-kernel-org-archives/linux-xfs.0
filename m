Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:37300 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755776AbeEAOTI (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 1 May 2018 10:19:08 -0400
Subject: Re: [PATCH 2/5] xfs: factor out secondary superblock updates
References: <eb592fc3-3165-5ec7-3896-b798fc7f6502@redhat.com>
 <aecfedfa-6216-80d8-bbac-3dfad639f9c8@sandeen.net>
 <20180501141752.GF4525@bfoster.bfoster>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <8fe74cf9-f6a5-a5d3-a70b-dba11dfd5b50@sandeen.net>
Date: Tue, 1 May 2018 09:19:07 -0500
MIME-Version: 1.0
In-Reply-To: <20180501141752.GF4525@bfoster.bfoster>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>



On 5/1/18 9:17 AM, Brian Foster wrote:
> On Mon, Apr 30, 2018 at 10:43:55AM -0500, Eric Sandeen wrote:
>> growfs rewrites all secondary supers, and relabel should do so as well;
>> factor out the code which does this for use by both operations.
>>
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>> ---
> 
> FYI I think Dave has some patches in progress to rework growfs. It might
> be useful to coordinate on the refactoring bits, at least..

Yup.  Growfs definitely needs a refactor and I know he's working on that,
but I haven't seen Dave's patches.  Dave?  :)

-Eric
