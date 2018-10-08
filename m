Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:54900 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726291AbeJIAVM (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 8 Oct 2018 20:21:12 -0400
Subject: Re: [PATCH 11/15] xfsprogs: include headers for extern variables
References: <1538712196-13625-1-git-send-email-sandeen@sandeen.net>
 <1538712196-13625-12-git-send-email-sandeen@sandeen.net>
 <20181006101400.GK28114@infradead.org>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <2612e09f-9532-6ae3-3722-1a8d49ff48be@sandeen.net>
Date: Mon, 8 Oct 2018 12:08:30 -0500
MIME-Version: 1.0
In-Reply-To: <20181006101400.GK28114@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org



On 10/6/18 5:14 AM, Christoph Hellwig wrote:
> On Thu, Oct 04, 2018 at 11:03:12PM -0500, Eric Sandeen wrote:
>> From: Eric Sandeen <sandeen@redhat.com>
>>
>> Include headers which export functions so that they don't appear to be
>> static to the sparse checker.
>>
>> Remove redundant extern declarations in c code which are no longer needed.
>>
>> Fixes sparse warnings about this.
> 
> I think this really wants to be split out into a few patches describing
> what gets moved/included for specific case.
> 

Ok - "include foo.h in foo.c" seems straightforward enough, but I will see if
it makes sense to split other stuff into similar groupings.

-Eric
